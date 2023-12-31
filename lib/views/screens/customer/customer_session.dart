import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/model/seance.dart';
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
    // Vérifier si l'utilisateur est connecté
    if (FirebaseAuth.instance.currentUser == null) {
      // Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
      // Vous pouvez ajouter votre propre logique de redirection
      return Center(
        child: Text(
            'Utilisateur non connecté. Rediriger vers la page de connexion.'),
      );
    }

    return Scaffold(
      body: StreamBuilder<List<Session>>(
        // Utiliser le flux pour récupérer les sessions de l'utilisateur actuel
        stream: getSessionsForCurrentUserStream(
            FirebaseAuth.instance.currentUser!.uid, "Yes"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Afficher un indicateur de chargement pendant le chargement des données
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            // Afficher un message d'erreur en cas d'erreur
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Afficher un message si aucune séance n'est disponible
            return const Center(
              child: Text('Aucune séance pour le moment'),
            );
          } else {
            // Afficher la liste des séances
            List<Session> sessions = snapshot.data!;
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final subject = session.name;
                final date = session.day.toLocal(); // Convertir en heure locale
                final description = session.description;
                final typ = session.typ;
                return ListTile(
                    onTap: () => print("On tap"),
                    contentPadding: EdgeInsets.all(5), // Espacement interne
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5), // Rayon de la bordure
                      side: BorderSide(color: Colors.black), // Bordure latérale
                    ),
                    leading: typ == 'Force'
                        ? Icon(
                            Icons.fitness_center,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.run_circle,
                            color: Colors.blue,
                          ),
                    title: Text(
                      "$subject",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cette séance se deroulera le ( $date )",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
