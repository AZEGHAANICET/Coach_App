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
  bool _messageConfirmChoice = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordEnter = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: Form(
            key: _formKey,
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
                    padding: EdgeInsets.only(
                        left: 40, right: 40, top: 10, bottom: 10),
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
                          border: OutlineInputBorder()),
                      obscureText: _isObscure,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      controller: passwordEnter,
                    ),
                  ),
                ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.orange)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (enablePassword) {
                          try {
                            User user = FirebaseAuth.instance.currentUser!;
                            print(user);
                            print(passwordEnter.text);
                            if (!user.emailVerified) {
                              await user.sendEmailVerification();
                            }

                            await user.updatePassword(passwordEnter.text);
                            Text('Mot de passe mofidie avec success');
                          } catch (e) {
                            print(
                                "Erreur lors de la mise à jour réessayer plutard");
                          }
                          setState(() {
                            _messageConfirmChoice = true;
                          });
                        } else {
                          _messageConfirmChoice = true;
                        }
                      }
                    },
                    icon: Icon(Icons.update),
                    label: Text(enablePassword
                        ? 'Changer votre mot de passe'
                        : 'Conserver le mot de passe')),
                TextButton(
                  onPressed: () {
                    setState(() {
                      enablePassword = !enablePassword;
                    });
                  },
                  child: Text(enablePassword
                      ? 'Je desire conserver mon mot de passe'
                      : 'Je desire changer mon mot de passe'),
                ),
                if (_messageConfirmChoice)
                  Text(enablePassword
                      ? 'Merci d\' avoir changer votre mot de passe'
                      : 'Merci d\'avoir conserve votre mot de passe')
              ],
            )),
      )),
    );
  }
}
