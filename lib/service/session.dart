import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_coach_app/model/seance.dart';

Future<void> createSession(Session session) async {
  try {
    CollectionReference sessions =
        FirebaseFirestore.instance.collection('Sessions');
    Map<String, dynamic> sessionData = session.toJson();
    await sessions.add(sessionData);

    print('Session créée avec succès dans Firestore.');
  } catch (e) {
    print('Erreur lors de la création de la session dans Firestore : $e');
  }
}

Stream<List<Session>> getAllSessionsStream() {
  try {
    CollectionReference sessions =
        FirebaseFirestore.instance.collection('Sessions');

    return sessions.snapshots().map((QuerySnapshot querySnapshot) {
      List<Session> sessionList = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> sessionData =
            document.data() as Map<String, dynamic>;
        Session session = Session.fromJson(sessionData);
        sessionList.add(session);
      }

      return sessionList;
    });
  } catch (e) {
    print('Erreur lors de la récupération des sessions depuis Firestore : $e');
    return Stream.value([]); // Retourne un Stream vide en cas d'erreur
  }
}
