import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_coach_app/model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StreamController<UserModel?> _userStream =
      StreamController<UserModel>();
  Stream<UserModel?> get userStream => _userStream.stream;
  late bool isAdmin;

  Future<void> sendEmailVerification(String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else {
        print("L'utilisateur est déjà vérifié ou n'est pas connecté.");
      }
    } catch (e) {
      print(
          "Une erreur s'est produite lors de l'envoi de l'e-mail de vérification : $e");
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

  Future<bool> checkIfUserIsAdmin(String uid) async {
    return uid == 'S6aRKYdYXKhHizrib3KlcD882vs1';
  }
}
