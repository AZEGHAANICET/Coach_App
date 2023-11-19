import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final String COLLECTION_NAME = "users";

  CollectionReference getUsersCollection() {
    return FirebaseFirestore.instance.collection(COLLECTION_NAME);
  }

  static Future<List<Map<String, dynamic>>> getUsersFromFireStore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();
      List<Map<String, dynamic>> usersList = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;

        usersList.add(userData);
      }
      print('test');
      return usersList;
    } catch (e) {
      print("Erreur de communication avec le serveur $e");
      return [];
    }
  }

  static Future<void> createUserInFirestore(
      String userId, String email, String displayName) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('Users');
      await usersCollection.doc(userId).set({
        'email': email,
        'displayName': displayName,
      });

      print('User created in Firestore successfully');
    } catch (e) {
      print('Error creating user in Firestore: $e');
    }
  }
}
