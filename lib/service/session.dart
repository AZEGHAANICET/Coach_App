import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_coach_app/model/groupe.dart';
import 'package:flutter_coach_app/model/seance.dart';

Future<void> createSession(String groupName, Session session) async {
  try {
    CollectionReference sessions =
        FirebaseFirestore.instance.collection('Sessions');
    Map<String, dynamic> sessionData = session.toJson();

    DocumentReference sessionRef = await sessions.add(sessionData);
    String documentId = sessionRef.id;

    await sessionRef.update({'id': documentId});

    print('Session créée avec succès dans Firestore. ID: $documentId');

    DocumentSnapshot groupDoc = await getGroupDocument(groupName);

    if (groupDoc.exists) {
      List<dynamic> groupSessions = groupDoc['sessions'] ?? [];
      groupSessions.add(documentId);
      await groupDoc.reference.update({'sessions': groupSessions});

      print('Session ajoutée à la liste de séances du groupe.');
    } else {
      print(
          'Le document de groupe n\'existe pas. La session ne sera pas ajoutée à la liste de séances.');
    }
  } catch (e) {
    print('Erreur lors de la création et de l\'ajout de la session : $e');
    // Gérer l'erreur selon vos besoins
  }
}

Future<DocumentSnapshot> getGroupDocument(String groupName) async {
  try {
    // Référence de la collection 'groups'
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');

    // Requête pour obtenir le document avec le champ 'name' égal à groupName
    QuerySnapshot querySnapshot =
        await groups.where('name', isEqualTo: groupName).get();

    // Vérifier si le document existe
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      print('Aucun document trouvé pour le groupe avec le nom $groupName.');
      // Gérer le cas où le document n'est pas trouvé selon vos besoins
      return Future.error('Document non trouvé');
    }
  } catch (e, stackTrace) {
    print(
        'Erreur lors de la récupération du document de groupe : $e\n$stackTrace');
    // Gérer l'erreur selon vos besoins
    return Future.error('Erreur lors de la récupération du document de groupe');
  }
}

Future<List<Session>> getGroupSessions(String groupName) async {
  try {
    // Obtenez le document du groupe
    DocumentSnapshot groupDocument = await getGroupDocument(groupName);

    // Vérifiez si le document existe
    if (!groupDocument.exists) {
      print('Le document de groupe n\'existe pas.');
      // Gérer le cas où le document de groupe n'est pas trouvé selon vos besoins
      return Future.error('Document de groupe non trouvé');
    }

    // Obtenez les données du document du groupe
    Map<String, dynamic>? groupData =
        groupDocument.data() as Map<String, dynamic>?;

    // Vérifiez si le document du groupe a un champ 'sessions'
    if (groupData?.containsKey('sessions') != true) {
      print('Le groupe ne contient pas de champ "sessions".');
      // Gérer le cas où le champ 'sessions' n'est pas trouvé selon vos besoins
      return [];
    }

    // Obtenez les identifiants des sessions
    List<String> sessionIds = List<String>.from(groupData!['sessions']);

    // Récupérez les sessions à partir des identifiants
    List<Session> groupSessions = await getSessionsByIds(sessionIds);

    return groupSessions;
  } catch (e, stackTrace) {
    print(
        'Erreur lors de la récupération des sessions du groupe : $e\n$stackTrace');
    // Gérer l'erreur selon vos besoins
    return Future.error(
        'Erreur lors de la récupération des sessions du groupe');
  }
}

Future<List<Session>> getSessionsByIds(List<String> sessionIds) async {
  try {
    // Référence de la collection 'sessions'
    CollectionReference sessions =
        FirebaseFirestore.instance.collection('Sessions');

    // Récupérez les sessions à partir des identifiants
    List<Session> sessionsList =
        await Future.wait(sessionIds.map((sessionId) async {
      // Récupérez le document de la session
      DocumentSnapshot sessionDocument = await sessions.doc(sessionId).get();

      // Vérifiez si le document existe
      if (sessionDocument.exists) {
        // Utilisez la méthode fromSnapshot pour créer une Session à partir du snapshot
        return Session.fromSnapshot(sessionDocument);
      } else {
        throw FormatException('Invalid session ID');
      }
    }));

    return sessionsList;
  } catch (e, stackTrace) {
    print('Erreur lors de la récupération des sessions : $e\n$stackTrace');
    // Gérer l'erreur selon vos besoins
    return Future.error('Erreur lors de la récupération des sessions');
  }
}

Stream<List<Session>> getSessionsForCurrentUserStream(
    String userUid, String status) {
  try {
    // 1. Recherche des groupes auxquels l'utilisateur appartient
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');

    // 2. Écoute des changements dans les groupes
    return groups.where('users', arrayContains: userUid).snapshots().asyncMap(
      (userGroupsSnapshot) async {
        // 3. Liste pour stocker toutes les sessions des groupes
        List<Session> allSessions = [];

        // 4. Si l'utilisateur appartient à au moins un groupe
        if (userGroupsSnapshot.docs.isNotEmpty) {
          for (var groupDoc in userGroupsSnapshot.docs) {
            String groupName = groupDoc['name'];

            // 5. Utiliser la méthode getSessionsForGroup pour récupérer les sessions du groupe
            List<Session> sessionsList = await getGroupSessions(groupName);

            // 6. Filtrer les sessions par statut
            sessionsList = sessionsList
                .where((session) => session.status == status)
                .toList();

            // 7. Ajouter les sessions du groupe à la liste globale
            allSessions.addAll(sessionsList);
          }
        }

        // 8. Retourner la liste globale de sessions
        return allSessions;
      },
    );
  } catch (e, stackTrace) {
    print('Erreur lors de la récupération des sessions : $e\n$stackTrace');
    return Stream.error(
        'Erreur lors de la récupération des sessions de l\'utilisateur');
  }
}

Stream<List<Session>> getSessionsByStatusStream(String status) {
  try {
    CollectionReference sessions =
        FirebaseFirestore.instance.collection('Sessions');

    return sessions.where('status', isEqualTo: status).snapshots().map(
        (sessionsSnapshot) => sessionsSnapshot.docs
            .map((sessionDoc) =>
                Session.fromJson(sessionDoc.data() as Map<String, dynamic>))
            .toList());
  } catch (e, stackTrace) {
    print(
        'Erreur lors de la récupération des sessions par statut : $e\n$stackTrace');
    // Gérer l'erreur selon vos besoins
    return Stream.error([]);
  }
}

Future<void> updateSessionStatus(String sessionId, String newStatus) async {
  CollectionReference _sessionsCollection =
      FirebaseFirestore.instance.collection('Sessions');
  try {
    await _sessionsCollection.doc(sessionId).update({'status': newStatus});
    print('Le statut de la session a été mis à jour avec succès.');
  } catch (e) {
    print('Erreur lors de la mise à jour du statut de la session : $e');
    throw Exception('Erreur lors de la mise à jour du statut de la session');
  }
}
