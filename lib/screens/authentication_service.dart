import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StreamController<UserModel?> _userStream =
      StreamController<UserModel>();
  Stream<UserModel?> get userStream => _userStream.stream;
  UserModel? _currentUser;
  late bool isAdmin;
  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _currentUser = null;
      } else {
        _currentUser = UserModel(
          uid: user.uid ?? '',
          email: user.email ?? '',
          isAdmin: isAdmin,
        );
      }
      print(_currentUser);
      _userStream.add(_currentUser);
    });
  }

  Future<void> signUpWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Inscription Effectué avec succès. Un email de vérification vous a été envoyé.'),
        ),
      );
      String uid = userCredential.user?.uid ?? '';
      bool isAdmin = await checkIfUserIsAdmin(uid);

      UserModel user = UserModel(
        uid: uid,
        email: userCredential.user!.email ?? '',
        isAdmin: isAdmin,
      );

      _userStream.add(
          user); //declenche la fonction de rappel celle appelé dans le constructeur
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Registration failed.';

      if (error.code == 'email-already-in-use') {
        errorMessage =
            'L\'adresse email que vous avez entré a déjà été utilisé.';
      }
      // ignore: use_build_context_synchronously
      showSnackBar(content: Text(errorMessage), context: context);
    }
  }

  Future<void> sendEmailVerification(String email) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        // ignore: use_build_context_synchronously
        showSnackBar(content: const Text('Login successful'), context: context);
        String uid = userCredential.user!.uid;
        bool isAdmin = await checkIfUserIsAdmin(uid);
        UserModel user = UserModel(
          uid: uid,
          email: userCredential.user!.email ?? '',
          isAdmin: isAdmin,
        );
        _userStream.add(user);
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(
            content:
                const Text('Echec de connexion. Vérifié votre adresse email.'),
            context: context);
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Authentication failed.';

      if (error.code == 'user-not-found') {
        errorMessage = 'No user found with this email address.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Try again!!';
      }
      // ignore: use_build_context_synchronously
      showSnackBar(content: Text(errorMessage), context: context);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _userStream.add(null);
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }
    if (password.length < 8) {
      return false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    return true;
  }

  void showSnackBar({required Widget content, required BuildContext context}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<bool> checkIfUserIsAdmin(String uid) async {
    return uid == 'S6aRKYdYXKhHizrib3KlcD882vs1';
  }
}
