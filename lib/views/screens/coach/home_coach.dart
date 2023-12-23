import 'package:flutter/material.dart';
import 'package:flutter_coach_app/service/group.dart';
import 'package:flutter_coach_app/views/screens/coach/create_group_user.dart';

class HomeCoach extends StatefulWidget {
  const HomeCoach({super.key});

  @override
  _HomeCoachState createState() => _HomeCoachState();
}

class _HomeCoachState extends State<HomeCoach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Afficher la liste des groupes des utilisateurs
          Expanded(
            child: GroupListWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGroup()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class GroupListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: getAllGroups(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur : ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('Aucun groupe trouvé pour les utilisateurs.'),
          );
        }

        List<Map<String, dynamic>> userGroups = snapshot.data!;

        return ListView.builder(
          itemCount: userGroups.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> userGroup = userGroups[index];
            String groupName = userGroup['name'];
            String description = userGroup['description'];

            return ListTile(
              contentPadding: EdgeInsets.all(5), // Espacement interne
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // Rayon de la bordure
                side: BorderSide(
                  color: Color.fromARGB(31, 223, 219, 219),
                ), // Bordure latérale
              ),
              leading: Icon(Icons.group),
              title: Text(
                groupName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(description),
            );
          },
        );
      },
    );
  }
}
