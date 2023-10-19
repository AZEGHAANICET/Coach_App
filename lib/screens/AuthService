class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                'Registration successful. A verification email has been sent.')),
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Registration failed.';

      if (error.code == 'email-already-in-use') {
        errorMessage = 'This email address is already in use.';
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
      } else {
        showSnackBar(
            content: Text(
                'Login failed. Please verify your email during registration.'));
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
}
