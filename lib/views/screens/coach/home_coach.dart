import 'package:flutter/material.dart';
import 'package:flutter_coach_app/views/screens/coach/create_group_user.dart';

class HomeCoach extends StatefulWidget {
  const HomeCoach({super.key});

  @override
  State<HomeCoach> createState() => _HomeCoachState();
}

class _HomeCoachState extends State<HomeCoach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const AddGroup(),
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
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
