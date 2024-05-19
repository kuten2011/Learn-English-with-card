import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:midtermm/ui/Service/studyCardScreen.dart';
import 'package:midtermm/ui/Service/testCardScreen.dart';
import 'package:midtermm/ui/Service/practiceScreen.dart';
import 'package:midtermm/ui/term_ui/editTermScreen.dart';

class CardListScreen extends StatefulWidget {
  List<Map<String, dynamic>> cardterms;
  final int indexterm;
  final String id;

  CardListScreen({
    required this.cardterms,
    required this.indexterm,
    required this.id,
  });

  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  int currentPage = 0;
  final FlutterTts flutterTts = FlutterTts();

  Map<String, dynamic> term = {"title": "", "english": [], "vietnamese": []};

  Future<void> speakWord(String? word) async {
    if (word != null) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(word);
    }
  }

  @override
  void initState() {
    super.initState();
    getTermById();
  }

  void getTermById() async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('terms')
          .doc(widget.id)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          term = documentSnapshot.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print("Error fetching term from Firestore: $e");
    }
  }

  void onReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyCardScreen(
            card: term),
      ),
    );
  }

  void onStudy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Material(
          child: PracticeScreen(
            cardterms: term,
          ),
        ),
      ),
    );
  }

  void onTest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestCardScreen(
            cards: term),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.indexterm < 0 || widget.indexterm >= widget.cardterms.length) {
      return Scaffold(
        body: Center(
          child: Text('Index out of bounds'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(term["title"] ?? 'No Title'),
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTermScreen(
                    existingTerm: term,
                    id: widget.cardterms[widget.indexterm]['id'],
                  ),
                ),
              );
              if (result != null && result) {
                getTermById();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: PageView.builder(
                itemCount: term["english"].length,
                controller: PageController(
                  initialPage: currentPage,
                  viewportFraction: 0.8,
                ),
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: FlipCard(
                      frontChild: CardItem(term["english"][index] ?? 'No English'),
                      backChild: CardItem(term["vietnamese"][index] ?? 'No Vietnamese'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${currentPage + 1} of ${term["english"].length}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Test',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print('Download button pressed');
                    },
                    child: Icon(
                      Icons.download,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            buildCustomCard('Ghi nhớ', Icons.bookmark_add, onReview),
            SizedBox(height: 5),
            buildCustomCard('Luyện tập', Icons.fitness_center, onStudy),
            SizedBox(height: 5),
            buildCustomCard('Kiểm tra nhanh', Icons.flash_on, onTest),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thuật ngữ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      print('Sort button pressed');
                    },
                    label: Text(
                      'Thứ tự gốc',
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: Icon(Icons.sort, color: Colors.black),
                  ),
                ],
              ),
            ),
            for (int index = 0; index < term['english'].length; index++)
              Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    String deletedEnglishWord = term["english"][index];
                    String deletedVietnameseWord = term["vietnamese"][index];
                    term["english"].removeAt(index);
                    term["vietnamese"].removeAt(index);
                    FirebaseFirestore.instance
                        .collection('terms')
                        .doc(widget.id)
                        .update({
                          "english": FieldValue.arrayRemove([deletedEnglishWord]),
                          "vietnamese": FieldValue.arrayRemove([deletedVietnameseWord])
                        })
                        .then((_) => print("Deleted successfully!"))
                        .catchError((error) => print("Error deleting word: $error"));
                  });
                },
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  child: Icon(Icons.delete),
                ),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[400]!, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  term["english"][index] ?? 'No English',
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  term["vietnamese"][index] ?? 'No Vietnamese',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () {
                            speakWord(term["english"][index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomCard(String text, IconData icon, VoidCallback onPressed) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey[400]!, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onPressed,
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                SizedBox(width: 10.0),
                Text(
                  text,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String text;

  CardItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF4254FE),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  final Widget frontChild;
  final Widget backChild;

  const FlipCard({Key? key, required this.frontChild, required this.backChild})
      : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;

  bool _isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _frontRotation = Tween<double>(
      begin: 0,
      end: 180,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.linear),
      ),
    );
    _backRotation = Tween<double>(
      begin: -180,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isFrontVisible) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        _isFrontVisible = !_isFrontVisible;
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_isFrontVisible
                  ? _frontRotation.value * 3.1415927 / 180
                  : _backRotation.value * 3.1415927 / 180),
            alignment: Alignment.center,
            child: _isFrontVisible ? widget.frontChild : widget.backChild,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
