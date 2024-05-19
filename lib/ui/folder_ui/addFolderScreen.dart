import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFolderScreen extends StatefulWidget {
  @override
  _AddFolderScreenState createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TextEditingController> termIDController = [TextEditingController()];

  User? user;
  String userEmail = 'No Email';
  String userName = 'No Name';

  @override
  void initState() {
    super.initState();
    getUser();
    getTermsFromFirestore();
  }

  void getUser() {
    user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email ?? 'No Email';
  }

  Future<void> getTermsFromFirestore() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    final QuerySnapshot querySnapshot = await usersCollection
        .where('userEmail', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot userDoc = querySnapshot.docs.first;
      setState(() {
        userName = userDoc['userName'] ?? 'No Username';
      });
    } else {
      setState(() {
        userName = 'No Username Found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop(); // Đóng màn hình khi nhấn nút "Hủy"
          },
        ),
        title: Text('Thư mục mới'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              final CollectionReference foldersCollection =
                  FirebaseFirestore.instance.collection('folders');

              List<String> termIDs = termIDController
                  .map((controller) => controller.text)
                  .where((text) => text.isNotEmpty)
                  .toList();

              Map<String, dynamic> data = {
                'title': _titleController.text,
                'userEmail': userEmail,
                'userName': userName,
                'description': _descriptionController.text.isNotEmpty
                    ? _descriptionController.text
                    : 'No Description',
                'termIDs': termIDs,
              };

              await foldersCollection.add(data);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Folder has been added successfully.'),
                ),
              );

              Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề (thư mục)',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả (tùy chọn)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
