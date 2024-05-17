import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      userfolders = folders
          .where((folder) => folder['userEmail'] == userEmail)
          .toList();
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
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermListScreen(),
                      ),
                    );
                  },
                  child: FolderCard(
                    folder: userfolders[index],
                    count: userfolders[index]['termIDs'] != null
                        ? userfolders[index]['termIDs'].length
                        : 0,
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
          color: Colors.white, // Màu nền trắng tinh
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
