import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerSession extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerSessionState();
  }
}

class _CustomerSessionState extends State<CustomerSession> {
  List<Map<String, String>> sessions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: fetchUserSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final subject = session["subject"];
                final date = session["date"];
                final description = session["description"];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.fitness_center,
                      color: Colors.red,
                    ),
                    title: Text("$subject  $date"),
                    subtitle: Text("$description"),
                    trailing: const Icon(Icons.more_vert),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> fetchUserSession() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        QueryDocumentSnapshot first = userQuery.docs[0];
        String nameGroup = first["nameGroupe"];

        QuerySnapshot sessionQuery = await FirebaseFirestore.instance
            .collection('sessions')
            .where('name', isEqualTo: nameGroup)
            .get();

        setState(() {
          sessions = sessionQuery.docs
              .map<Map<String, String>>((QueryDocumentSnapshot doc) {
            return {
              "jour": doc["jour"] as String,
              "date": doc["date"] as String,
              "subject": doc["subject"] as String,
              "description": doc["description"] as String,
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }
}
