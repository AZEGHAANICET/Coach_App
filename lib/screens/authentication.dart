import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_coach_app/widgets/user_picker_image.dart';
import 'package:flutter_coach_app/screens/authentication_service.dart';

final AuthService _authService = AuthService();
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
      _authService.signIn(_email_enter, _password);
      } else {
     _authService.signUpWithEmail(_email_enter, _password);
      }
    setState(() {
      _isAuthenticated = false;
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
                        if (!_authService.isValidEmail(value!)) {
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


}
