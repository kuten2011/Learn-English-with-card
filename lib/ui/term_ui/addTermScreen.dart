import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'settingTermScreen.dart';

class AddTermScreen extends StatefulWidget {
  @override
  State<AddTermScreen> createState() => _AddTermScreenState();
}

class _AddTermScreenState extends State<AddTermScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final List<TextEditingController> _englishTermController = [];
  final List<TextEditingController> _vietnameseDefinitionController = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      _englishTermController.add(TextEditingController());
      _vietnameseDefinitionController.add(TextEditingController());
    }
  }

  //AddTermScreen({required this.onTermAdded});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Học Phần'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingTermScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              final CollectionReference termsCollection =
                  FirebaseFirestore.instance.collection('terms');

              final User? currentUser = FirebaseAuth.instance.currentUser;

              List<Map<String, dynamic>> terms = [];

              for (int i = 0; i < 3; i++) {
                Map<String, dynamic> term = {
                  'title': _titleController.text,
                  'english': _englishTermController[i].text,
                  'vietnamese': _vietnameseDefinitionController[i].text,
                  'userEmail': currentUser?.email,
                  'userName': _userNameController.text,
                };
                terms.add(term);
              }

              await termsCollection.add(terms);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Term has been added successfully.'),
                ),
              );

              Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Tiêu đề',
                ),
              ),
              SizedBox(height: 8.0),
              ..._buildTermFields(),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt),
                  label: Text('Quét Tài Liệu'),
                  onPressed: () {
                    // Xử lý khi nhấn "Quét Tài Liệu"
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTermFields() {
    List<Widget> termFields = [];

    for (int i = 0; i < 3; i++) {
      termFields.addAll([
        SizedBox(height: 8.0),
        TextField(
          controller: _englishTermController[i],
          decoration: InputDecoration(
            labelText: 'Thuật ngữ',
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Xử lý khi nhấn thêm "Thuật ngữ"
              },
            ),
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _vietnameseDefinitionController[i],
          decoration: InputDecoration(
            labelText: 'Định nghĩa',
          ),
        ),
      ]);
    }

    return termFields;
  }
}
