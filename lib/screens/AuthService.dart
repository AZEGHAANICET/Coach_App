class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StreamController<User?> _userStream=  StreamController<User>();
  Stream<User?> get userStream=>_userStreamController.stream;
  
  AuthService(){
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        _currentUser = null;
      } else {
        _currentUser = User(email: user.email ?? "", motDepasse: "", image: "");
      }
      _userStreamController.add(_currentUser);
    });
  }
  
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Inscription Effectué avec succès. Un email de vérification vous a été envoyé.'),),
      );
      String uid = userCredential.user?.uid??'';
      bool isAdmin = await checkIfUserIsAdmin(uid);
      User user = User(uid:uid, email:userCredential.user?email??'', 
                       isAdmin: isAdmin,);
      _userStreamController.add(user);
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Registration failed.';

      if (error.code == 'email-already-in-use') {
        errorMessage = 'L\'adresse email que vous avez entré a déjà été utilisé.';
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
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null &&
          userCredential.user!.emailVerified) {
        showSnackBar(content: Text('Login successful'));
         User user = User(uid:uid, email:userCredential.user?email??'', 
                       isAdmin: isAdmin,);
          _userStreamController.add(user);
      } else {
        showSnackBar(
            content: Text(
                'Echec de connexion. Vérifié votre adresse email.'));
        
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Authentication failed.';

      if (error.code == 'user-not-found') {
        errorMessage = 'No user found with this email address.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Try again!!';
      }
      showSnackBar(content: Text(errorMessage));
    }
  }

Future<void> signOut() async {
    await _auth.signOut();
    _userStreamController.add(null);
  }

  
  bool isValidEmail(String email) {
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

Future<bool> checkIfUserIsAdmin(String uid) async {
    return uid == 'S6aRKYdYXKhHizrib3KlcD882vs1';
  }
}
