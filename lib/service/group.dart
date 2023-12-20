import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
    yield []; // Utilisation de yield pour émettre une liste vide en cas d'erreur
  }
}

Future<void> createGroup(String groupName, List<String> initialUsers) async {
  try {
    DocumentReference groupRef =
        await FirebaseFirestore.instance.collection('groups').add({
      'name': groupName,
      'users': initialUsers,
    });
    for (String userId in initialUsers) {
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
