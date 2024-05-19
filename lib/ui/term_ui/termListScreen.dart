import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cartListScreen.dart';
import 'addTermScreen.dart';

class TermListScreen extends StatefulWidget {
  @override
  State<TermListScreen> createState() => _TermListScreenState();
}

class _TermListScreenState extends State<TermListScreen> {
  User? user;
  String userEmail = 'No Email';
  List<Map<String, dynamic>> terms = [];
  List<Map<String, dynamic>> userterms = [];

  @override
  void initState() {
    super.initState();
    getUser().then((_) => getTermsFromFirestore());
  }

  Future<void> getUser() async {
    user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email ?? 'No Email';
    print('Current User Email: $userEmail');
  }

  Future<void> getTermsFromFirestore() async {
    final CollectionReference termsCollection = FirebaseFirestore.instance.collection('terms');
    final QuerySnapshot querySnapshot = await termsCollection.get();

    setState(() {
      terms = querySnapshot.docs.map((doc) => {
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      }).toList();

      userterms = terms.where((term) => term['userEmail'] == userEmail).toList();
      print('Filtered terms: $userterms');
    });
  }

  void removeTerm(int index) async {
    await FirebaseFirestore.instance.collection('terms').doc(userterms[index]['id']).delete();
    setState(() {
      userterms.removeAt(index);
    });
  }

  void toggleFavorite(int index) async {
    String termId = userterms[index]['id'];
    bool isFavorite = userterms[index]['favorite'] ?? false;
    await FirebaseFirestore.instance.collection('terms').doc(termId).update({'favorite': !isFavorite});
    setState(() {
      userterms[index]['favorite'] = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userterms.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    removeTerm(index);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardListScreen(
                            cardterms: userterms,
                            indexterm: index,
                            id: userterms[index]['id'],
                          ),
                        ),
                      );
                      getTermsFromFirestore();
                    },
                    child: Term(
                      title: userterms[index]['title'] ?? 'No Title',
                      name: userterms[index]['userName'] ?? 'No Name',
                      count: userterms[index]['english']?.length ?? 0,
                      width: screenWidth,
                      isFavorite: userterms[index]['favorite'] ?? false,
                      onFavoriteTap: () {
                        toggleFavorite(index);
                      },
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
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTermScreen()),
          );
          getTermsFromFirestore();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Term extends StatelessWidget {
  final String title;
  final int count;
  final String name;
  final double? width;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const Term({
    Key? key,
    required this.title,
    required this.count,
    required this.name,
    this.width,
    required this.isFavorite,
    this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(9),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: onFavoriteTap,
                  ),
                ],
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
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
