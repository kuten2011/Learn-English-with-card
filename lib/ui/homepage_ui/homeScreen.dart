import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Quizlet'),
        ),
        body: TabBarView(
          children: [
            CoursesPage(),
            VocabPage(),
            LibraryPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}

class CoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return CourseCard();
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.book),
        title: Text('C2 Transformations'),
        subtitle: Text('Testbuilder'),
        trailing: Text('2 months'),
      ),
    );
  }
}

class VocabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return VocabCard();
      },
    );
  }
}

class VocabCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.lightbulb),
        title: Text('Phrases CPE 2'),
        subtitle: Text('English'),
        trailing: Text('272'),
      ),
    );
  }
}

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return LibraryCard();
      },
    );
  }
}

class LibraryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.folder),
        title: Text('Learn vocab'),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile'),
    );
  }
}
