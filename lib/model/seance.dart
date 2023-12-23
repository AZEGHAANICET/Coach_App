import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  String id;
  DateTime day;
  String name;
  String description;
  String startTime;
  String typ;
  String status;
  String endTime;

  String group;

  Session(
      {required this.day,
      required this.name,
      required this.description,
      required this.typ,
      required this.group,
      required this.status,
      required this.startTime,
      required this.endTime,
      required this.id});

  // Méthode pour convertir la classe en Map (pour la sérialisation en JSON)
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'name': name,
      'description': description,
      'typ': typ,
      'group': group,
      'status': status,
      'id': this.id,
      'endTime': this.endTime,
      "startTime": this.startTime
    };
  }

  factory Session.fromSnapshot(DocumentSnapshot snapshot) {
    return Session(
      id: snapshot.id,
      day: (snapshot['day'] as Timestamp).toDate(),
      name: snapshot['name'],
      description: snapshot['description'],
      typ: snapshot['typ'],
      group: snapshot['group'],
      status: snapshot['status'],
      endTime: snapshot['endTime'],
      startTime: snapshot['startTime'],
    );
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      day: (json['day'] as Timestamp).toDate(),
      name: json['name'],
      description: json['description'],
      typ: json['typ'],
      group: json['group'],
      status: json['status'],
      endTime: json['endTime'],
      startTime: json['startTime'],
    );
  }
}
