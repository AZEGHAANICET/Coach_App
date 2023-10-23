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
  late Stream<List<Map<String, String>>> sessionsStream;

  @override
  void initState() {
    super.initState();
    sessionsStream = createSessionsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, String>>>(
        stream: sessionsStream,
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
            print(snapshot.data);
            return const Center(
              child: Text('Aucune séance pour le moment'),
            );
          } else {
            List<Map<String, String>> sessions = snapshot.data!;
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final subject = session["subject"];
                final jour = session["jour"];
                final date = session["date"];
                final description = session["description"];
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

  Stream<List<Map<String, String>>> createSessionsStream() async* {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    print(user!.email);
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: user!.email)
          .limit(1)
          .get();
      print(userQuery.docs.isNotEmpty);
      if (userQuery.docs.isNotEmpty) {
        // QueryDocumentSnapshot first = userQuery.docs[0];
        //String nameGroup = first["nameGroup"];

        // Create a query that listens for changes to the 'Session' collection
        Stream<QuerySnapshot> sessionQueryStream =
            FirebaseFirestore.instance.collection('Session').snapshots();

        await for (QuerySnapshot sessionQuery in sessionQueryStream) {
          print("Values ${sessionQuery.docs.isNotEmpty}");
          // Emit the updated list of sessions
          yield sessionQuery.docs
              .map<Map<String, String>>((QueryDocumentSnapshot doc) {
            return {
              "jour": doc["jour"] as String,
              "date": doc["date"] as String,
              "subject": doc["subject"] as String,
              "description": doc["description"] as String,
            };
          }).toList();
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }
}
