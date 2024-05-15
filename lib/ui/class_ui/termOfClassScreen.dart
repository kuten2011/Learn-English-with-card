import 'package:flutter/material.dart';
import 'package:midtermm/ui/class_ui/memberOfClass.dart';
import 'package:midtermm/ui/class_ui/termOfClass.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title Class',
      home: TermListScreen(),
    );
  }
}

class TermListScreen extends StatefulWidget {
  @override
  _TermListScreenState createState() => _TermListScreenState();
}

class _TermListScreenState extends State<TermListScreen> {
  final List<Term> terms = [
    Term("Flutter", 20, "John Doe"),
    Term("Dart", 15, "Jane Smith"),
    Term("Widget", 25, "Alex Johnson"),
    // Add more terms as needed
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title Class - 5 học phần'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 8),
                      Text('Mời thành viên'),
                    ],
                  ),
                  value: 'inviteMembers',
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.plus_one_rounded),
                      SizedBox(width: 8),
                      Text('Thêm học phần'),
                    ],
                  ),
                  value: 'addTerm',
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.folder),
                      SizedBox(width: 8),
                      Text('Thêm thư mục'),
                    ],
                  ),
                  value: 'addFolder',
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'inviteMembers') {
                // Handle action when "Mời thành viên" is selected
              } else if (value == 'addTerm') {
                // Handle action when "Thêm học phần" is selected
              } else {
                // Handle action when "Thêm thư mục" is selected
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          TermList(),
          MemberScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Học phần',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Thành viên',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Term {
  final String title;
  final int count;
  final String name;

  Term(this.title, this.count, this.name);
}
