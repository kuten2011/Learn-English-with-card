import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midtermm/ui/homepageScreen.dart';
import 'package:midtermm/ui/loginScreen.dart';
import 'package:midtermm/ui/welcomeScreen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return homepageScreen();
          }else {
            return welcomeScreen();
          }
        },
      )
    );
  }
}