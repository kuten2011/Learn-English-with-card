import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddTermIntoFolder.dart';
import '../term_ui/cartListScreen.dart';

class FolderListScreen extends StatefulWidget {
  final String folderId;

  FolderListScreen({required this.folderId});

  @override
  _FolderListScreenState createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  List<Map<String, dynamic>> terms = [];
  String folderTitle = ''; // Biến để lưu trữ title của folder

  @override
  void initState() {
    super.initState();
    fetchTerms();
    fetchFolderTitle(); // Gọi hàm để lấy title từ Firestore khi widget được khởi tạo
  }

  Future<void> fetchTerms() async {
    final folderDoc = await FirebaseFirestore.instance
        .collection('folders')
        .doc(widget.folderId)
        .get();

    if (folderDoc.exists) {
      final List<dynamic> termIDs = folderDoc['termIDs'] ?? [];
      final List<Map<String, dynamic>> fetchedTerms = [];

      for (var termID in termIDs) {
        final termDoc = await FirebaseFirestore.instance
            .collection('terms')
            .doc(termID)
            .get();
        if (termDoc.exists) {
          fetchedTerms.add({
            'id': termDoc.id,
            'title': termDoc['title'] ?? 'No Title',
            'english': termDoc['english'] ?? [],
            'vietnamese': termDoc['vietnamese'] ?? [],
            'userName': termDoc['userName'] ?? 'No Name',
          });
        }
      }

      setState(() {
        terms = fetchedTerms;
      });
    }
  }

  Future<void> fetchFolderTitle() async {
    final folderDoc = await FirebaseFirestore.instance
        .collection('folders')
        .doc(widget.folderId)
        .get();

    if (folderDoc.exists) {
      setState(() {
        folderTitle = folderDoc['title'] ?? 'No Title';
      });
    }
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddTermIntoFolder(folderId: widget.folderId),
                    ),
                  );
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

  void _deleteTerm(String termId) async {
    try {
      await FirebaseFirestore.instance
          .collection('folders')
          .doc(widget.folderId)
          .update({
        'termIDs': FieldValue.arrayRemove([termId]),
      });
      setState(() {
        terms.removeWhere((term) => term['id'] == termId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Học phần đã được xóa')),
      );
    } catch (error) {
      print('Đã xảy ra lỗi khi xóa học phần: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa học phần không thành công')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderTitle), // Sử dụng title từ Firestore cho AppBar
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardListScreen(
                          cardterms: terms,
                          indexterm: index,
                        ),
                      ),
                    );
                  },
                  child: Dismissible(
                    key: Key(terms[index]['id']),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteTerm(terms[index]['id']);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: TermList(
                      title: terms[index]['title'] ?? 'No Title',
                      english: terms[index]['english'] ?? [],
                      vietnamese: terms[index]['vietnamese'] ?? [],
                      userName: terms[index]['userName'] ?? 'No Name',
                    ),
                  ),
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
  final List<dynamic> english;
  final List<dynamic> vietnamese;
  final String userName;

  const TermList({
    Key? key,
    required this.title,
    required this.english,
    required this.vietnamese,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước chiều rộng của màn hình
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth, // Sử dụng chiều rộng của màn hình cho mỗi mục term
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
                title,
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
                  '${english.length} thuật ngữ',
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),
              Text(userName),
            ],
          ),
        ),
      ),
    );
  }
}
