import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_coach_app/model/groupe.dart';
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

Future<void> addSessionToGroup(String groupName, Session session) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('groups')
        .where('name', isEqualTo: groupName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> groupDoc =
          querySnapshot.docs.first;
      Group group = Group.fromFirestore(groupDoc);
      group.sessions.add(session);
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupDoc.id)
          .update({'sessions': group.sessions.map((s) => s.toJson()).toList()});
    } else {
      print('Aucun groupe trouvé avec le nom $groupName');
    }
  } catch (e) {
    print('Erreur lors de l\'ajout de la session au groupe : $e');
    // Gérer l'erreur selon vos besoins
  }
}

Stream<List<Session>> getSessionsStreamForCurrentUser(String userUid) {
  try {
    // 1. Recherche des groupes auxquels l'utilisateur appartient
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');

    // 2. Écoute des changements dans les groupes
    return groups
        .where('users', arrayContains: userUid)
        .snapshots()
        .asyncExpand(
      (userGroupsSnapshot) async* {
        // 3. Si l'utilisateur appartient à au moins un groupe
        if (userGroupsSnapshot.docs.isNotEmpty) {
          for (var groupDoc in userGroupsSnapshot.docs) {
            List<Session> sessionsList = (groupDoc['sessions'] as List<dynamic>)
                .map((sessionData) =>
                    Session.fromJson(sessionData as Map<String, dynamic>))
                .toList();

            yield sessionsList;
          }
        } else {
          // 4. Si l'utilisateur n'appartient à aucun groupe, retourne une liste vide
          yield [];
        }
      },
    );
  } catch (e, stackTrace) {
    print('Erreur lors de la récupération des sessions : $e\n$stackTrace');
    return Stream.error(
        'Erreur lors de la récupération des sessions de l\'utilisateur');
  }
}
