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

  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.folder_shared),
                title: Text('Sửa thư mục'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle action for 'Sửa thư mục'
                },
              ),
              ListTile(
                leading: Icon(Icons.plus_one_rounded),
                title: Text('Thêm học phần'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle action for 'Thêm học phần'
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Hủy'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle action for 'Hủy'
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title Class - 5 học phần'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showPopupMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              CircleAvatar(
                backgroundImage: AssetImage('lib/assets/images/test.jpg'),
              ),
              const SizedBox(width: 10),
              Text(
                'khoavone',
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Card(
              color: Colors.blue, // Card's background color
              child: ListTile(
                title: const Text(
                  'Học thư mục này',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  // Handle action when card is pressed
                },
              ),
            ),
          ),
          Expanded(
            child: TermList(),
          ),
        ],
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
