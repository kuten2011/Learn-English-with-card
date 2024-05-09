import 'package:flutter/material.dart';
import 'package:midtermm/auth/firebase_auth.dart';
import 'package:midtermm/ui/homepageScreen.dart';
import 'package:midtermm/ui/loginScreen.dart';
import 'package:midtermm/ui/signupScreen.dart';
import 'package:midtermm/ui/welcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizlet App',
      debugShowCheckedModeBanner: false,
      //home: homepageScreen(),
      routes: {
        '/': (context) => AuthPage(),
      }
    );
  }
}
