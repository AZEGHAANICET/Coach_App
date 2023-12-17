import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coach_app/views/screens/coach/availability_coach.dart';
import 'package:flutter_coach_app/views/screens/coach/create_group_user.dart';
import 'package:flutter_coach_app/views/screens/common/settings.dart';
import 'package:flutter_coach_app/views/screens/customer/customer_session.dart';
import 'package:flutter_coach_app/views/screens/common/profile.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  int _currentIndex = 0;
  setCurrentPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          title: [
            Text('Accueil'),
            Text('Planing'),
            Text('Profile')
          ][_currentIndex],
          backgroundColor: Colors.orange,
          actions: [
            // IconButton(
            //   onPressed: () {
            //     FirebaseAuth.instance.signOut();
            //   },
            //   icon: Icon(Icons.exit_to_app),
            // ),

            PopupMenuButton<String>(
              color: Color.fromARGB(255, 20, 214, 43),
              icon: Icon(Icons.more_vert),
              offset: Offset(22, 50),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'Paramètres',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Paramètres'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const Setting(),
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
                  ),
                  PopupMenuItem<String>(
                    value: 'Deconnexion',
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Deconnexion'),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'Infos',
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text('Infos'),
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                performAction(value);
              },
            ),
          ]),
      body: [CustomerSession(), AvailabilityCoach(), Profile()][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setCurrentPage(value),
        selectedItemColor: Colors.red,
        iconSize: 28,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: "Disponibilité",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    ));
  }

  void performAction(String action) {
    print('Performing action: $action');
    // Add logic to perform the selected action
  }
}
