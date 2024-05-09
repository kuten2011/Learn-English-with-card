import 'package:flutter/material.dart';
import 'package:midtermm/ui/auth_ui/loginScreen.dart';
import 'package:midtermm/ui/auth_ui/signupScreen.dart';

class welcomeScreen extends StatelessWidget {
  const welcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFF4254FE),
          Color(0xFF691FDC),
        ])),
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 200.0),
            child: Text(
              'Quizlet',
              style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          const Text(
            'Welcome To Quizlet',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => loginScreen()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => signupScreen()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
