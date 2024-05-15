import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cartListScreen.dart';

class TermListScreen extends StatefulWidget {
  @override
  State<TermListScreen> createState() => _TermListScreenState();
}

class _TermListScreenState extends State<TermListScreen> {
  final List<Map<String, dynamic>> tterms = [
    {
      'english': ['everyone', 'hello'],
      'userEmail': 'an66528@gmail.com',
      'vietnamese': ['mọi người', 'xin chào'],
      'userName': 'an66528',
      'title': 'LearnVocab'
    },
    {
      'english': ['welcome', 'sad'],
      'userEmail': 'an66528@gmail.com',
      'vietnamese': ['chào mừng', 'buồn'],
      'userName': 'an66528',
      'title': 'Day1'
    }
  ];

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
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      userterms =
          terms.where((subject) => subject['userEmail'] == userEmail).toList();
      print('Filtered terms: $userterms'); // Debug output
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userterms.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => CardListScreen(indexterm: 0)),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CardListScreen()),
                    );
                  },
                  child: Term(
                    title: userterms[index]['title'] ?? 'No Title',
                    name: userterms[index]['userName'] ?? 'No Name',
                    count: userterms[index]['english'] != null
                        ? userterms[index]['english'].length
                        : 0,
                    //eng: userterms[index]['english'][0] ?? 'No Name',
                    //print('Eng1: $userterms[index]['english'][0] ?? 'No Name''),
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

class Term extends StatelessWidget {
  final String title;
  final int count;
  final String name;
  //final String eng;

  const Term({
    Key? key,
    required this.title,
    required this.count,
    //required this.eng,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
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
                  //'$eng',
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
