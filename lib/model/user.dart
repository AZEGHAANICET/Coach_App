import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  late String email;
  late String motDePasse;
  late bool isAdmin;
  late String uid;

  UserModel({
    required String email,
    required bool isAdmin,
    required String uid,
  }) {
    this.email = email;
    this.motDePasse = motDePasse;
    this.isAdmin = isAdmin;
    this.uid = uid;
  }

  static UserModel? fromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(
      email: user.email ?? '',
      isAdmin:
          false, // Ajoutez votre logique pour déterminer si l'utilisateur est administrateur
      uid: user.uid,
    );
  }

  void setisAdmin(bool admin) {
    this.isAdmin = admin;
  }
}
