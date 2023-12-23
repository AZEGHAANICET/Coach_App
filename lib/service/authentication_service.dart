import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_coach_app/model/user.dart';

class AuthService {
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

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    if (password.isEmpty) {
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

Future<UserModel> getUserByEmail(String email) async {
  try {
    QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      return UserModel.fromJson(userSnapshot.docs.first.data()!);
    } else {
      throw Exception('User not found'); // Throw an exception if user not found
    }
  } catch (e) {
    print('Error fetching user: $e');
    throw Exception(
        'Error fetching user'); // Throw an exception for other errors
  }
}
