import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_coach_app/model/groupe.dart';
import 'package:flutter_coach_app/model/seance.dart';

Stream<List<Map<String, dynamic>>> getAllUsers() async* {
  try {
    // Utilisation de la méthode snapshots() pour obtenir un Stream de QuerySnapshot
    Stream<QuerySnapshot> snapshots =
        FirebaseFirestore.instance.collection('users').snapshots();

    await for (QuerySnapshot querySnapshot in snapshots) {
      List<Map<String, dynamic>> usersList = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
        usersList.add(userData);
      }

      yield usersList;
    }
  } catch (e) {
    print('Erreur lors de la récupération des utilisateurs : $e');
    yield [];
  }
}

Future<void> createGroup(Group group) async {
  try {
    DocumentReference groupRef =
        await FirebaseFirestore.instance.collection('groups').add({
      'id': group.id,
      'name': group.name,
      'users': group.users,
      'sessions': group.sessions,
      'description': group.description
    });
    String groupId = groupRef.id;
    group.id = groupId;
    await groupRef.update({'id': groupId});
    print(groupRef);

    for (String userId in group.users) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'groups': FieldValue.arrayUnion([groupRef.id]),
      });
    }

    print('Groupe créé avec succès.');
  } catch (e) {
    print('Erreur lors de la création du groupe : $e');
  }
}

Future<void> addUserToGroup(String userId, String groupId) async {
  try {
    // Mettre à jour la liste des groupes pour l'utilisateur
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'group': FieldValue.arrayUnion([groupId]),
    });

    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'users': FieldValue.arrayUnion([userId]),
    });

    print('Utilisateur ajouté au groupe avec succès.');
  } catch (e) {
    print("Erreur lors de l'ajout de l'utilisateur au groupe : $e");
  }
}

Stream<List<Map<String, dynamic>>> getAllGroups() {
  try {
    return FirebaseFirestore.instance.collection('groups').snapshots().map(
      (QuerySnapshot querySnapshot) {
        List<Map<String, dynamic>> groupsList = [];
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> groupData =
              document.data() as Map<String, dynamic>;
          groupsList.add(groupData);
        }
        return groupsList;
      },
    );
  } catch (e) {
    print('Erreur lors de la récupération des groupes : $e');
    return Stream.value([]); // Retourne un Stream vide en cas d'erreur
  }
}

Future<List<Group>> getAllGroup() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('groups').get();

    List<Group> groupsList =
        querySnapshot.docs.map((doc) => Group.fromFirestore(doc)).toList();
    print(groupsList.toString());
    return groupsList;
  } catch (e) {
    print('Erreur lors de la récupération des groupes : $e');
    return []; // Retourne une liste vide en cas d'erreur
  }
}

Future<bool> isGroupNameExists(String groupName) async {
  try {
    // Référence à la collection 'groups'
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');

    // Récupération des documents dans la collection
    QuerySnapshot querySnapshot = await groups.get();

    // Vérification de l'existence du nom dans les documents
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      if (doc['name'] == groupName) {
        // Le nom existe déjà
        return true;
      }
    }

    // Le nom n'existe pas
    return false;
  } catch (e, stackTrace) {
    print(
        'Erreur lors de la vérification de l\'existence du nom : $e\n$stackTrace');
    throw Exception('Erreur lors de la vérification de l\'existence du nom');
  }
}
