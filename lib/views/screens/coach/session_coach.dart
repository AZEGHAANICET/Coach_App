import 'package:flutter/material.dart';
import 'package:flutter_coach_app/model/seance.dart';
import 'package:flutter_coach_app/service/session.dart';
import 'package:flutter_coach_app/views/screens/coach/create_seance.dart';
import 'package:intl/intl.dart';

class SessionScreenCoach extends StatefulWidget {
  const SessionScreenCoach({Key? key}) : super(key: key);

  @override
  State<SessionScreenCoach> createState() => _SessionScreenCoachState();
}

class _SessionScreenCoachState extends State<SessionScreenCoach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Session>>(
        stream: getSessionsByStatusStream("Yes"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            print("yooo");
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucune séance pour le moment'),
            );
          } else {
            List<Session> sessions = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(sessions.length, (index) {
                      final session = sessions[index];
                      final subject = session.name;
                      final date = session.day;
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(date);
                      final description = session.description;
                      final type = session.typ;

                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 15,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(
                              10), // Ajout de la marge extérieure
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        subject,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text('Le ${formattedDate}'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('De'),
                                    Text(
                                      '${session.startTime}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                    Text('à'),
                                    Text(
                                      '${session.endTime}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  description,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      type == 'Force'
                                          ? Icons.fitness_center
                                          : Icons.directions_run,
                                      color: type == 'Force'
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        print("dfdf" + session.id!);
                                        updateSessionStatus(session.id!, "No");
                                      },
                                      child: Text(
                                        'Annuler',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }
        },
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
