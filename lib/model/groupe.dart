import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  dynamic pName;
  dynamic? id;
  String description;
  final List<dynamic> users;
  List<dynamic> sessions;
  String get name {
    return this.pName;
  }

  void set name(dynamic name) {
    pName = name;
  }

  Group(
      {required this.pName,
      this.id,
      required this.users,
      required this.sessions,
      required this.description});

  toJson() {
    return {
      'name': this.pName,
      'users': this.users,
      'id': this.id,
      'description': this.description
    };
  }

  factory Group.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Group(
      description: data['description'],
      id: doc.id,
      pName: data['name'],
      users: doc['users'],
      sessions: doc['sessions'],
      // Ajoutez d'autres propriétés du groupe au besoin
    );
  }
}
