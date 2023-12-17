import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/views/screens/coach/admin.dart';
import 'package:flutter_coach_app/views/screens/customer/customer_screen.dart';
import 'package:flutter_coach_app/views/screens/common/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter App",
      darkTheme: ThemeData.dark(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text('Une erreur s\'est produite!!');
          }
          if (snapshot.hasData) {
            bool isAdmin = snapshot.data!.uid == "tMyhBqHOUAbEBzvMG2XysEeAHJc2";
            return isAdmin ? const Admin() : const CustomerScreen();
          }
          return const AuthenticationScreen();
        },
      ),
    );
  }
}
