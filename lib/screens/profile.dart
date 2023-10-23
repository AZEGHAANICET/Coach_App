import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool enablePassword = false;
  bool _isObscure = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 30,
            ),
            Text(FirebaseAuth.instance.currentUser!.email!),
            SizedBox(
              height: 10,
            ),
            if (enablePassword)
              Padding(
                padding:
                    EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                    prefixIcon: Icon(Icons.fingerprint),
                    labelText: 'Entrer votre mot de passe',
                    hintStyle: TextStyle(color: Color(0xFF3498db)),
                  ),
                  obscureText: _isObscure,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                ),
              ),
            ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                onPressed: () {
                  setState(() {
                    enablePassword = !enablePassword;
                  });
                },
                icon: Icon(Icons.update),
                label: Text(
                    !enablePassword ? 'Changer votre mot de passe' : 'Valider'))
          ],
        )),
      )),
    );
  }
}
