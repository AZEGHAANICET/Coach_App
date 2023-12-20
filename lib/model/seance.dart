import 'package:flutter/physics.dart';

class Session {
  String day;
  String name;
  String description;
  String startDate;
  String typ;

  String group;

  Session(
      {required this.day,
      required this.name,
      required this.description,
      required this.startDate,
      required this.typ,
      required this.group});

  // Méthode pour convertir la classe en Map (pour la sérialisation en JSON)
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'name': name,
      'description': description,
      'startDate': startDate,
      'typ': typ,
      'group': group
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      day: json['day'],
      name: json['name'],
      description: json['description'],
      startDate: json['startDate'],
      typ: json['typ'],
      group: json['group'],
    );
  }
}
