import 'package:flutter/material.dart';

class TermListScreen extends StatefulWidget {
  @override
  _TermListScreenState createState() => _TermListScreenState();
}

class _TermListScreenState extends State<TermListScreen> {
  final List<Map<String, dynamic>> terms = [
    {'title': "Flutter", 'count': 20, 'name': "John Doe"},
    {'title': "Dart", 'count': 15, 'name': "Jane Smith"},
    {'title': "Widget", 'count': 25, 'name': "Alex Johnson"},
    // Add more terms as needed
  ];

  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_shared),
                title: const Text('Sửa thư mục'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle action for 'Sửa thư mục'
                },
              ),
              ListTile(
                leading: const Icon(Icons.plus_one_rounded),
                title: const Text('Thêm học phần'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle action for 'Thêm học phần'
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Hủy'),
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
        title: const Text('Title of Folder'),
        backgroundColor: const Color(0xFF4254FE),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showPopupMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Card(
              color: const Color(0xFF4254FE), // Card's background color
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
            child: ListView.builder(
              itemCount: terms.length,
              itemBuilder: (BuildContext context, int index) {
                return TermList(
                  title: terms[index]['title'] ?? 'No Title',
                  name: terms[index]['name'] ?? 'No Name',
                  count: terms[index]['count'] ?? 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TermList extends StatelessWidget {
  final String title;
  final int count;
  final String name;

  const TermList({
    Key? key,
    required this.title,
    required this.count,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 9, right: 9, top: 9),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[400]!, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.grey[400]!),
                  color: const Color.fromARGB(255, 199, 212, 252),
                ),
                child: Text(
                  '$count thuật ngữ',
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),
              Text('Name: $name'),
            ],
          ),
        ),
      ),
    );
  }
}
