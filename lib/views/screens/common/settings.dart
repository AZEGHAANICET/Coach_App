import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('Settings'),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.orange,
            ),
            onTap: () {
              print('profile');
            },
            title: Text('Username'),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Changer la langue de votre application'),
            subtitle: Text('Tapez pour changer la langue de votre appliaction'),
            onTap: () {
              print('Langue');
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Aide'),
            subtitle: Text('Tapez si vous avez besoin d\' aide'),
            onTap: () {
              print('Aide');
            },
          )
        ],
      )),
    );
  }
}
