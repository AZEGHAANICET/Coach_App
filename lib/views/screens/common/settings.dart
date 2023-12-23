import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/model/user.dart';
import 'package:flutter_coach_app/service/authentication_service.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
    getUserModel();
  }

  String _username = "";
  String _image = "";
  String _email = ""; // Ajout du champ pour le nom d'utilisateur

  void getUserModel() async {
    try {
      UserModel customer = await getUserByEmail(
          FirebaseAuth.instance.currentUser!.email.toString());
      setState(() {
        _username = customer.username;
        _image = customer.image;
        _email = customer.email; // Set the userName
      });
    } catch (e) {
      print('Error fetching user: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                backgroundImage: NetworkImage(_image),
                backgroundColor: Colors.transparent,
              ),
              onTap: () {
                print('profile');
              },
              title: Text(_username),
              subtitle: Text(_email), // Affiche le nom d'utilisateur actuel
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editUsername(context);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Changer la langue de votre application'),
              subtitle:
                  Text('Tapez pour changer la langue de votre appliaction'),
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
        ),
      ),
    );
  }

  // Fonction pour modifier le nom d'utilisateur
  void _editUsername(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le nom d\'utilisateur'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _username = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Nouveau nom d\'utilisateur',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}
