import 'package:flutter/material.dart';

class Disponibilite extends StatefulWidget {
  const Disponibilite({super.key});

  @override
  State<Disponibilite> createState() => _DisponibiliteState();
}

class _DisponibiliteState extends State<Disponibilite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("hello");
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
