import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionRepository {
  static Future<List<Map<String, dynamic>>> getSessionFromUser(
      String userId) async {
    final String COLLECTION_NAME = "Users";
    final String COLLECTION_GROUP_NAME = "Groups";
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentReference userRef = FirebaseFirestore.instance
            .collection(COLLECTION_NAME)
            .doc(currentUser.uid);
        DocumentSnapshot userDoc = await userRef.get();
        String userGroup = userDoc['Group'];

        QuerySnapshot sessioSnapshot = await FirebaseFirestore.instance
            .collection(COLLECTION_GROUP_NAME)
            .doc(userGroup)
            .collection('Seances')
            .where('membres', arrayContains: userId)
            .get();
        List<Map<String, dynamic>> sessionJSList =
            sessioSnapshot.docs.map((sessionDoc) {
          Map<String, dynamic> sessionData =
              sessionDoc.data() as Map<String, dynamic>;
          return sessionData;
        }).toList();
        return sessionJSList;
      } else {
        throw new Exception('Une erreur s \' est produite');
      }
    } catch (e) {
      print("Erreur de communication avec le serveur $e");
      return [];
    }
  }

  static Future<void> saveSession(String userId, String sessionName) async {
    final String COLLECTION_NAME = "Users";
    final String COLLECTION_GROUP_NAME = "Groups";
    final String SESSION_COLLECTION_NAME = "Session";
    DateTime currentTime = new DateTime.now();
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentReference userRef = FirebaseFirestore.instance
            .collection(COLLECTION_NAME)
            .doc(currentUser.uid);
        DocumentSnapshot userDoc = await userRef.get();
        String userGroup = userDoc['idGroup'];
        DocumentReference sessionRef = FirebaseFirestore.instance
            .collection(COLLECTION_GROUP_NAME)
            .doc(userGroup)
            .collection(SESSION_COLLECTION_NAME)
            .doc();
        Map<String, dynamic> sessionData = {
          'sessionName': sessionName,
          'membres': [userId],
          'dateSession': currentTime,
        };
        await sessionRef.set(sessionData);

        print("Session sauvegardée avec succès");
      } else {
        throw new Exception("Une erreur s'est produite");
      }
    } catch (e) {
      print("Erreur de communication avec le serveur $e");
    }
  }

  static Future<void> createsession(
      String userId,
      String sessionName,
      String groupName,
      String description,
      String typeSession,
      DateTime date) async {
    final String COLLECTION_NAME = "Users";
    final String COLLECTION_GROUP_NAME = "Groups";
    final String SESSION_COLLECTION_NAME = "Sessions";
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentReference userRef = FirebaseFirestore.instance
            .collection(COLLECTION_NAME)
            .doc(currentUser.uid);
        print(userRef.toString());
        DocumentSnapshot userDoc = await userRef.get();
        String userGroup = userDoc['Groupes'];
        DocumentReference sessionRef = FirebaseFirestore.instance
            .collection(COLLECTION_GROUP_NAME)
            .doc(userGroup)
            .collection(SESSION_COLLECTION_NAME)
            .doc();
        print("test");
        Map<String, dynamic> sessionData = {
          'sessionName': sessionName,
          'membres': [userId],
          'dateSession': date,
          'typeDeSession': typeSession,
          'description': description,
          'groupName': groupName,
        };
        await sessionRef.set(sessionData);

        print("Session sauvegardée avec succès");
      } else {
        throw new Exception("Une erreur s'est produite");
      }
    } catch (e) {
      print("Erreur de communication avec le serveur $e");
    }
  }
}
