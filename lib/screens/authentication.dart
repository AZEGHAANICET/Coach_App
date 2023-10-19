import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_coach_app/widgets/user_picker_image.dart';

final _firebase = FirebaseAuth.instance;
class AuthenticationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthenticationScreenState();
  }
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  var _isLogin = true;
  var _isAuthenticated = false;
  var _email_enter = '';
  var _password = '';
  var _isObscure = true;
  final _form = GlobalKey<FormState>();

  void _submit(){
    final isValidForm = _form.currentState!.validate();
    if (!isValidForm || !_isLogin) {
      return;
    }

    _form.currentState!.save();
      setState(() {
        _isAuthenticated = true;
      });
      if (_isLogin) {
        signIn(_email_enter,_password);
      } else {
        signUpWithEmail(_email_enter,_password);
      }
   

    setState(() {
      _isAuthenticated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent[100],
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
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
                        onPickedImage: (value) => print('Hello guy'),
                      ),
                    TextFormField(
                      validator: (value) {
                        if (!isValidEmail(value!)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email_enter = value!;
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          labelText: 'Entrer votre adresse mail'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (!isPasswordValid(value!)) {
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
                    SizedBox(
                      height: 20,
                    ),
                    if (_isAuthenticated) CircularProgressIndicator(),
                    if (!_isAuthenticated)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _submit(),
                          icon: const Icon(Icons.person),
                          label:
                              Text(_isLogin ? 'Se connecter' : 'S\'inscrire'),
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
    );
  }



Future<void> signUpWithEmail(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await sendEmailVerification(email);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Inscription réussie. Un e-mail de vérification a été envoyé.')),
    );
  } on FirebaseAuthException catch (error) {
    String errorMessage = 'Une erreur d\'inscription s\'est produite.';

    if (error.code == 'email-already-in-use') {
      errorMessage = 'Cette adresse e-mail est déjà utilisée.';
    }
    showSnackBar(content: Text(errorMessage));
  }
}

Future<void> sendEmailVerification(String email) async {
  User? user = FirebaseAuth.instance.currentUser;
  await user?.sendEmailVerification();
}
  
Future<void> signIn(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if(userCredential.user!=null && userCredential.user!.emailVerified){
      showSnackBar(content: Text('Connexion effectuée avec succès'));
    }
    else{
       showSnackBar(content: Text('Echec de connexion vous n\'avez pas vérifié votre email lors de votre inscription'));
    }
  } on FirebaseAuthException catch (error) {
    String errorMessage = 'Une erreur d\'authentification s\'est produite.';

    if (error.code == 'user-not-found') {
      errorMessage = 'Aucun utilisateur trouvé avec cette adresse e-mail.';
    } else if (error.code == 'wrong-password') {
      errorMessage = 'Le mot de passe est incorrect.Try again!!';
    }
    showSnackBar(content: Text(errorMessage));
  }
}


  
  bool isValidEmail(String email) {
    // Expression régulière pour valider une adresse e-mail
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }
    if (password.length < 8) {
      return false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    return true;
  }





  void showSnackBar({required Widget content}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
      duration: Duration(seconds: 3), 
    ),
  );
}
}
