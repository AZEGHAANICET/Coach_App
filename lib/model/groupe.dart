import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String nom;
  final List<DocumentReference> users;
  final List<DocumentReference> seance;
  Group(this.nom, this.users, this.seance);
}
