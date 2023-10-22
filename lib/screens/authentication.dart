import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_coach_app/widgets/user_picker_image.dart';
import 'package:flutter_coach_app/screens/authentication_service.dart';

final AuthService _authService = AuthService();
final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthenticationScreenState();
  }
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  var _isLogin = true;
  var _isAuthenticated = false;
  var _emailEnter = '';
  var _password = '';
  var _isObscure = true;
  var _enteredUsername = '';
  File? _selectedImage;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final _form = GlobalKey<FormState>();

  Future<void> _submit() async {
    final isValidForm = _form.currentState!.validate();
    if (!isValidForm || !_isLogin && _selectedImage == null) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isAuthenticated = true;
    });

    if (!_isLogin) {
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailEnter,
          password: _password,
        );
        final storageUser = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');
        storageUser.putFile(_selectedImage!);
        final imageUrl = await storageUser.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _emailEnter,
          'image_url': imageUrl,
          'nomgroupe': ''
        });
        await sendEmailVerification(_emailEnter);

        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text(
                'Inscription Effectué avec succès. Un email de vérification vous a été envoyé.'),
          ),
        );
      } on FirebaseAuthException catch (error) {
        String errorMessage = 'Registration failed.';

        if (error.code == 'email-already-in-use') {
          errorMessage =
              'L\'adresse email que vous avez entré a déjà été utilisé.';
        }
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
            ),
          ),
        );
      }
    } else {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailEnter,
          password: _password,
        );

        if (userCredential.user != null && userCredential.user!.emailVerified) {
          _scaffoldMessengerKey.currentState
              ?.showSnackBar(const SnackBar(content: Text('Login successful')));
        } else {
          _scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
              content:
                  Text('Echec de connexion. Vérifié votre adresse email.')));
        }
      } on FirebaseAuthException catch (error) {
        String errorMessage = 'Authentication failed.';

        if (error.code == 'user-not-found') {
          errorMessage = 'No user found with this email address.';
        } else if (error.code == 'wrong-password') {
          errorMessage = 'Incorrect password. Try again!!';
        }
        _scaffoldMessengerKey.currentState
            ?.showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
    // Authentification réussie, mise à jour de _isAuthenticated si nécessaire

    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: _scaffoldMessengerKey,
        home: Scaffold(
          backgroundColor: Colors.deepOrangeAccent[100],
          body: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.login,
                size: 80,
              ),
              Card(
                margin: const EdgeInsets.only(right: 30, left: 30, top: 20),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 30, left: 30, bottom: 20, top: 20),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!_isLogin)
                          UserImagePicker(
                            onPickImage: (pickedImage) => setState(() {
                              _selectedImage = pickedImage;
                            }),
                          ),
                        TextFormField(
                          validator: (value) {
                            if (!_authService.isValidEmail(value!)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _emailEnter = value!;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              labelText: 'Entrer votre adresse mail'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (!_isLogin)
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 4) {
                                return 'Please enter at least 4 caracters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                        TextFormField(
                          validator: (value) {
                            if (!_authService.isPasswordValid(value!)) {
                              return 'Please enter a valide password';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value!,
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
                              labelText: 'Entrer votre mot de passe'),
                          obscureText: _isObscure,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (_isAuthenticated) const CircularProgressIndicator(),
                        if (!_isAuthenticated)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _submit(),
                              icon: const Icon(Icons.person),
                              label: Text(
                                  _isLogin ? 'Se connecter' : 'S\'inscrire'),
                            ),
                          ),
                        if (!_isAuthenticated)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Je ne dispose pas encore de compte'
                                : 'J\' ai déjà un compte'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ));
  }

  Future<void> sendEmailVerification(String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else {
        _showAlertDialog(context, "Erreur",
            "L'utilisateur est déjà vérifié ou n'est pas connecté");
      }
    } catch (e) {
      _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(
              "Une erreur s'est produite lors de l'envoi de l'e-mail de vérification : $e")));
    }
  }
}

void _showAlertDialog(BuildContext context, String title, String error) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer l'AlertDialog
            },
            child: const Text('Fermer'),
          ),
        ],
      );
    },
  );
}
