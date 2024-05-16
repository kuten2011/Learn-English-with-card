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
  final List<TextEditingController> _englishTermController = [TextEditingController()];
  final List<TextEditingController> _vietnameseDefinitionController = [TextEditingController()];
  late User? user;
  late String userEmail = 'No Email';

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> usercurrent = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeData() async {
    await getUser();
    getUsersFromFirestore();
  }

  Future<void> getUser() async {
    user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email ?? 'No Email';
    print('Current User Email: $userEmail'); // Debug output
  }

  Future<void> getUsersFromFirestore() async {
    final CollectionReference termsCollection =
        FirebaseFirestore.instance.collection('users');

    final QuerySnapshot querySnapshot = await termsCollection.get();

    setState(() {
      users = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      usercurrent = users
          .where((subject) => subject['userEmail'] == userEmail)
          .toList();
      print('Filtered terms: $usercurrent'); // Debug output
    });
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
        title: const Text('Thêm Học Phần'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
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

              final User? currentUser = FirebaseAuth.instance.currentUser;

              List<Map<String, dynamic>> terms = [];

              for (int i = 0; i < _englishTermController.length; i++) {
                Map<String, dynamic> term = {
                  'title': _titleController.text,
                  'english': _englishTermController[i].text,
                  'vietnamese': _vietnameseDefinitionController[i].text,
                  'userEmail': currentUser?.email,
                  'userName': usercurrent['userName'],
                };
                terms.add(term);
              }

              await termsCollection.add({'terms': terms});

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Term has been added successfully.'),
                ),
              );

              Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                    Dismissible(
                      key: Key('$index'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _removeField(index);
                      },
                      child: Column(
                        children: [
                          TextField(
                            controller: _englishTermController[index],
                            decoration: InputDecoration(
                              labelText: 'Thuật ngữ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: _addNewField,
                              ),
                            ),
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
                      ),
                    ),
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
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
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
