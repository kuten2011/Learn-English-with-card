import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midtermm/ui/folder_ui/addFolderScreen.dart';
import 'termOfFolderScreen.dart';

class FolderList extends StatefulWidget {
  @override
  State<FolderList> createState() => _FolderListState();
}

class _FolderListState extends State<FolderList> {
  late User? user;
  String userEmail = 'No Email';

  @override
  void initState() {
    super.initState();
    getUser().then((_) {
      getFoldersFromFirestore();
    });
  }

  List<Map<String, dynamic>> folders = [];
  List<Map<String, dynamic>> userfolders = [];

  Future<void> getUser() async {
    user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email ?? 'No Email';
  }

  Future<void> getFoldersFromFirestore() async {
    final CollectionReference foldersCollection =
        FirebaseFirestore.instance.collection('folders');

    final QuerySnapshot querySnapshot = await foldersCollection.get();

    setState(() {
      folders = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id, // Thêm ID cho mỗi mục
              })
          .toList();

      userfolders = folders
          .where((folder) => folder['userEmail'] == userEmail)
          .toList();
    });
  }

  void removeFolder(int index) async {
    // Xóa thư mục khỏi Firestore
    await FirebaseFirestore.instance
        .collection('folders')
        .doc(userfolders[index]['id'])
        .delete();
    
    setState(() {
      // Xóa thư mục khỏi danh sách userfolders
      userfolders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userfolders.length,
              itemBuilder: (BuildContext context, int index) {
                final folder = userfolders[index];
                return Dismissible(
                  key: Key(folder['id']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    removeFolder(index);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FolderListScreen(folderId: folder['id']),
                        ),
                      );
                    },
                    child: FolderCard(
                      folder: folder,
                      count: folder['termIDs'] != null
                          ? folder['termIDs'].length
                          : 0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        onPressed: () async {
          // Chờ cho trang AddTermScreen được đóng và cập nhật danh sách thuật ngữ sau khi quay lại
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFolderScreen()),
          );
          setState(() {
            // Tải lại danh sách thuật ngữ
            getFoldersFromFirestore();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FolderCard extends StatelessWidget {
  final Map<String, dynamic> folder;
  final int count;

  FolderCard({required this.folder, required this.count});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: Colors.grey[400]!), // Viền đen
          ),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.folder, size: 30),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        folder["title"] ?? 'No Title',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: const Color.fromARGB(255, 199, 212, 252),
                      ),
                      child: Text(
                        '$count học phần',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      folder["userName"] ?? 'No Name',
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
