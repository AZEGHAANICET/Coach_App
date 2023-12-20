import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/model/seance.dart';
import 'package:flutter_coach_app/repository/seance_repository.dart';
import 'package:flutter_coach_app/service/session.dart';

class CustomerSession extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerSessionState();
  }
}

class _CustomerSessionState extends State<CustomerSession> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Session>>(
        stream: getAllSessionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucune séance pour le moment'),
            );
          } else {
            List<Session> sessions = snapshot.data!;
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final subject = session.name;
                final date = session.day;
                final description = session.description;
                return ListTile(
                  leading: Icon(
                    Icons.fitness_center,
                    color: Colors.red,
                  ),
                  title: Text("$subject  $date"),
                  subtitle: Text("$description"),
                );
              },
            );
          }
        },
      ),
    );
  }
}
