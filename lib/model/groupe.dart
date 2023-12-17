import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_coach_app/model/seance.dart';

class Group {
  final String name;
  final List<User> users;
  final List<Session> seance;
  Group(this.name, this.users, this.seance);

  toJson() {
    return {'name': this.name, 'users': this.users, 'seance': this.seance};
  }
}
