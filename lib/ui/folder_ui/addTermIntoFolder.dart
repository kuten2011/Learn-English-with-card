import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTermIntoFolder extends StatefulWidget {
  final String folderId;

  AddTermIntoFolder({required this.folderId});
  @override
  _AddTermIntoFolderState createState() => _AddTermIntoFolderState();
}

class _AddTermIntoFolderState extends State<AddTermIntoFolder> {
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
  List<Map<String, dynamic>> userTerms = [];
  List<String> selectedTermIds = [];

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
                'id': doc.id, // Add ID to each item
              })
          .toList();

      userTerms =
          terms.where((term) => term['userEmail'] == userEmail).toList();
      print('Filtered terms: $userTerms'); // Debug output
    });
  }

  void removeTerm(int index) async {
    // Handle item deletion
    await FirebaseFirestore.instance
        .collection('terms')
        .doc(userTerms[index]['id'])
        .delete();
    setState(() {
      // Remove item from userTerms list
      userTerms.removeAt(index);
    });
  }

  Future<void> updateFolderWithTerms() async {
    final folderDocument =
        FirebaseFirestore.instance.collection('folders').doc(widget.folderId);

    await folderDocument.update({
      'termIDs': FieldValue.arrayUnion(selectedTermIds),
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4254FE),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Handle done button press
              await updateFolderWithTerms();
              Navigator.pop(
                  context); // Example: simply go back to the previous screen
            },
            child: Row(
              children: [
                Icon(Icons.done, color: Colors.white),
                SizedBox(width: 5),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userTerms.length,
              itemBuilder: (BuildContext context, int index) {
                final term = userTerms[index];
                return Dismissible(
                  key: Key(term['id']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    removeTerm(index);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: Term(
                    title: term['title'] ?? 'No Title',
                    count: term['english']?.length ?? 0, // Fix count property
                    name: term['userName'] ?? 'No Name', // Fix name property
                    width: screenWidth,
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          selectedTermIds.add(term['id']);
                        } else {
                          selectedTermIds.remove(term['id']);
                        }
                      });
                    },
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

class Term extends StatefulWidget {
  final String title;
  final int count;
  final String name;
  final double? width; // Add width property
  final ValueChanged<bool> onSelected; // Add callback for selection

  const Term({
    Key? key,
    required this.title,
    required this.count,
    required this.name,
    this.width, // Update constructor to accept width
    required this.onSelected, // Update constructor to accept callback
  }) : super(key: key);

  @override
  _TermState createState() => _TermState();
}

class _TermState extends State<Term> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onSelected(_isSelected);
      },
      child: Container(
        width: widget.width, // Use provided width
        margin: const EdgeInsets.only(left: 9, right: 9, top: 9),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: _isSelected ? Colors.blue : Colors.grey[400]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          color: _isSelected ? Colors.blue[50] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.title} ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
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
                    '${widget.count} thuật ngữ',
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                Text('${widget.name}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
