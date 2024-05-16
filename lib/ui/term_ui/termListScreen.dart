import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cartListScreen.dart';
import 'addTermScreen.dart'; // Import AddTermScreen

class TermListScreen extends StatefulWidget {
  @override
  State<TermListScreen> createState() => _TermListScreenState();
}

class _TermListScreenState extends State<TermListScreen> {
  late User? user;
  String userEmail = 'No Email';

  @override
  void initState() {
    super.initState();
    getUser().then((_) {
      getTermsFromFirestore();
    });
  }

  List<Map<String, dynamic>> terms = [];
  List<Map<String, dynamic>> userterms = [];

  Future<void> getUser() async {
    user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email ?? 'No Email';
    print('Current User Email: $userEmail'); // Debug output
  }

  Future<void> getTermsFromFirestore() async {
    final CollectionReference termsCollection =
        FirebaseFirestore.instance.collection('terms');

    final QuerySnapshot querySnapshot = await termsCollection.get();

    setState(() {
      terms = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id, // Thêm ID cho mỗi mục
              })
          .toList();

      userterms =
          terms.where((subject) => subject['userEmail'] == userEmail).toList();
      print('Filtered terms: $userterms'); // Debug output
    });
  }

  void removeTerm(int index) async {
    // Xử lý khi mục bị xóa
    await FirebaseFirestore.instance
        .collection('terms')
        .doc(userterms[index]['id'])
        .delete();
    setState(() {
      // Xóa mục khỏi danh sách userterms
      userterms.removeAt(index);
    });
  }

  void _addNewTerm() async {
    // Chờ cho trang AddTermScreen được đóng và cập nhật danh sách thuật ngữ sau khi quay lại
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTermScreen()),
    );
    setState(() {
      // Tải lại danh sách thuật ngữ
      getTermsFromFirestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước chiều rộng của màn hình
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userterms.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key:
                      UniqueKey(), // Đảm bảo tính duy nhất của mỗi mục trong danh sách
                  direction: DismissDirection
                      .endToStart, // Lướt từ phải sang trái để xóa
                  onDismissed: (direction) {
                    removeTerm(index);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red, // Màu nền khi lướt để xóa
                    child: Icon(Icons.delete, color: Colors.white), // Icon xóa
                  ),
                  child: InkWell(
                    onTap: _addNewTerm, // Gọi hàm _addNewTerm khi nhấn vào một mục thuật ngữ
                    child: Term(
                      title: userterms[index]['title'] ?? 'No Title',
                      name: userterms[index]['userName'] ?? 'No Name',
                      count: userterms[index]['english'] != null
                          ? userterms[index]['english'].length
                          : 0,
                      // Gán chiều rộng của thẻ bằng kích thước chiều rộng của màn hình
                      width: screenWidth,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTerm, // Gọi hàm _addNewTerm khi nhấn vào nút floating action button
        child: Icon(Icons.add),
      ),
    );
  }
}

class Term extends StatelessWidget {
  final String title;
  final int count;
  final String name;
  final double? width; // Thêm thuộc tính width

  const Term({
    Key? key,
    required this.title,
    required this.count,
    required this.name,
    this.width, // Cập nhật constructor để chấp nhận width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Sử dụng width được cung cấp
      margin: const EdgeInsets.only(left: 9, right: 9, top: 9),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              Text('$name'),
            ],
          ),
        ),
      ),
    );
  }
}
