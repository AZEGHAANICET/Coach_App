import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String email;
  final DocumentReference groupe;

  UserModel(this.email, this.groupe);

  toJson() {
    return {
      'email': this.email,
    };
  }
}
