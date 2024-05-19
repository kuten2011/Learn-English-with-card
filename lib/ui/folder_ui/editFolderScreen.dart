import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditFolderScreen extends StatefulWidget {
  final String folderIdEdit;

  EditFolderScreen({required this.folderIdEdit});

  @override
  _EditFolderScreenState createState() => _EditFolderScreenState();
}

class _EditFolderScreenState extends State<EditFolderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  User? user;
  String userEmail = 'No Email';
  String userName = 'No Name';

  @override
  void initState() {
    super.initState();
    getUser();
    fetchFolderData();
  }

  void getUser() {
    user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email ?? 'No Email';
  }

  Future<void> fetchFolderData() async {
    final folderDoc = await FirebaseFirestore.instance
        .collection('folders')
        .doc(widget.folderIdEdit)
        .get();

    if (folderDoc.exists) {
      setState(() {
        _titleController.text = folderDoc['title'] ?? '';
        _descriptionController.text = folderDoc['description'] ?? '';
      });
    }
  }

  void _saveChanges() async {
    final CollectionReference foldersCollection =
        FirebaseFirestore.instance.collection('folders');

    Map<String, dynamic> data = {
      'title': _titleController.text,
      'description': _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : 'No Description',
    };

    await foldersCollection.doc(widget.folderIdEdit).update(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thư mục đã được cập nhật thành công.'),
      ),
    );

    // Trả về kết quả cập nhật thông tin
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
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
            Navigator.of(context).pop();
          },
        ),
        title: Text('Sửa thư mục'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveChanges,
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
