import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coach_app/screens/admin.dart';
import 'package:flutter_coach_app/screens/customer.dart';
import 'package:flutter_coach_app/screens/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter App",
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
           if (snapshot.hasError) {
              return Text('Une erreur s\'est produite!!');
            }
            if(snapshot.hasData){
               bool isAdmin = snapshot.data?.isAdmin??false;
               return isAdmin?Admin():Customer();
             }
            return AuthenticationScreen();
          }),
    );
  }
}
