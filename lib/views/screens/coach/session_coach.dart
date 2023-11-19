import 'package:flutter/material.dart';
import 'package:flutter_coach_app/views/screens/coach/create_seance.dart';

class SessionScreenCoach extends StatefulWidget {
  const SessionScreenCoach({Key? key}) : super(key: key);

  @override
  State<SessionScreenCoach> createState() => _SessionScreenCoachState();
}

class _SessionScreenCoachState extends State<SessionScreenCoach> {
  List<Map<String, String>> sessions = [
    {
      "subject": "Sujet 1",
      "jour": "Lundi",
      "date": "2023-10-23",
      "description": "Description de la session 1 comment  ",
      "type": "Force",
    },
    {
      "subject": "Sujet 2",
      "jour": "Mardi",
      "date": "2023-10-24",
      "description": "Description de la session 2",
      "type": "Cardio",
    },
    {
      "subject": "Sujet 3",
      "jour": "Mardi",
      "date": "2023-10-24",
      "description": "Description de la session 2",
      "type": "Cardio",
    },
    {
      "subject": "Sujet 4",
      "jour": "Mardi",
      "date": "2023-10-24",
      "description": "Description de la session 2",
      "type": "Cardio",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final subject = session["subject"];
                final date = session["date"];
                final description = session["description"];
                final type = session["type"];
                return ListTile(
                  trailing: OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(color: Colors.red),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        sessions.removeAt(index);
                      });
                    },
                    child: Text('Annuler'),
                  ),
                  leading: type == 'Force'
                      ? Icon(
                          Icons.fitness_center,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.run_circle,
                          color: Colors.blue,
                        ),
                  title: Text("$subject  $date"),
                  subtitle: Text("$description"),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const AddSession(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
