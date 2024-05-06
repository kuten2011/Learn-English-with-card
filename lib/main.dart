import 'package:flutter/material.dart';
import 'package:midtermm/ui/homepageScreen.dart';
import 'package:midtermm/ui/welcomeScreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: homepageScreen(),
    );
  }
}
