import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'settingTermScreen.dart';

class EditTermScreen extends StatefulWidget {
  final Map<String, dynamic>? existingTerm;
  final String id;

  EditTermScreen({required this.existingTerm, required this.id});

  @override
  State<EditTermScreen> createState() => _EditTermScreen();
}

class _EditTermScreen extends State<EditTermScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _englishTermController = [];
  final List<TextEditingController> _vietnameseDefinitionController = [];
  String _visibility = 'Mọi người';

  User? user;
  String userEmail = 'No Email';
  String userName = 'No Name';

  @override
  void initState() {
    super.initState();
    getUser();
    getTermsFromFirestore();
    populateFields();
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

  void populateFields() {
    if (widget.existingTerm != null) {
      _titleController.text = widget.existingTerm!['title'] ?? '';
      _visibility = widget.existingTerm!['visibility'] ?? 'Mọi người';

      List<String> englishTerms =
          List<String>.from(widget.existingTerm!['english'] ?? []);
      List<String> vietnameseDefinitions =
          List<String>.from(widget.existingTerm!['vietnamese'] ?? []);

      for (int i = 0; i < englishTerms.length; i++) {
        _englishTermController
            .add(TextEditingController(text: englishTerms[i]));
        _vietnameseDefinitionController
            .add(TextEditingController(text: vietnameseDefinitions[i]));
      }
    } else {
      _englishTermController.add(TextEditingController());
      _vietnameseDefinitionController.add(TextEditingController());
    }
  }

  void _addNewField() {
    setState(() {
      _englishTermController.add(TextEditingController());
      _vietnameseDefinitionController.add(TextEditingController());
    });
  }

  void _removeField(int index) {
    setState(() {
      _englishTermController.removeAt(index);
      _vietnameseDefinitionController.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa Học Phần'),
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addNewField(); // Gọi phương thức để thêm một cặp trường mới
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingTermScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () async {
              final CollectionReference termsCollection =
                  FirebaseFirestore.instance.collection('terms');

              List<String> englishTerms = _englishTermController
                  .map((controller) => controller.text)
                  .toList();
              List<String> vietnameseDefinitions =
                  _vietnameseDefinitionController
                      .map((controller) => controller.text)
                      .toList();

              Map<String, dynamic> data = {
                'title': _titleController.text,
                'userEmail': userEmail,
                'userName': userName,
                'english': englishTerms.map((term) => term.trim()).toList(),
                'vietnamese': vietnameseDefinitions
                    .map((definition) => definition.trim())
                    .toList(),
                'visibility': _visibility,
              };

              if (widget.existingTerm != null) {
                // Nếu đây là một thuật ngữ đã tồn tại, sử dụng phương thức update để cập nhật dữ liệu
                await termsCollection.doc(widget.id).update(data);
              } else {
                // Nếu đây là một thuật ngữ mới, sử dụng phương thức add để thêm dữ liệu mới
                await termsCollection.add(data);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Term has been updated successfully.'),
                ),
              );

              Navigator.pop(context, true);
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Row(
                children: [
                  Text(
                    'Chế độ xem:', // Display the current visibility
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  DropdownButton2<String>(
                    value: _visibility,
                    onChanged: (String? newValue) {
                      setState(() {
                        _visibility = newValue!;
                      });
                    },
                    items: <String>['Mọi người', 'Chỉ mình tôi']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _englishTermController.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _englishTermController[index],
                            decoration: InputDecoration(
                              labelText: 'Thuật ngữ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removeField(index); // Xóa trường tại chỉ mục index
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _vietnameseDefinitionController[index],
                      decoration: InputDecoration(
                        labelText: 'Định nghĩa',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              },
            ),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Quét Tài Liệu'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF4254FE),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  // Xử lý khi nhấn "Quét Tài Liệu"
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
