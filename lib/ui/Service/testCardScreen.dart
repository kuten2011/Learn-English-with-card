import 'dart:math';
import 'package:flutter/material.dart';

class TestCardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cards;
  final int indexterm;

  TestCardScreen({required this.cards, required this.indexterm});

  @override
  _TestCardScreenState createState() => _TestCardScreenState();
}

class _TestCardScreenState extends State<TestCardScreen> {
  late Map<String, dynamic> card;
  int _currentIndex = 0; // Initialize index variable
  int _randomIndexCards = 0; // Initialize random index variable
  int _randomIndexCardofCards = 0; // Initialize random index variable
  int body = 0;
  String msg = '';

  @override
  void initState() {
    super.initState();
    _updateCard(); // Initialize card
  }

  void _updateCard() {
    setState(() {
      card = widget.cards[widget.indexterm];
      _generateRandomIndexCards();
      _generateRandomIndexCardofCards();
      _generateRandomBody();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lượt 2'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              card['vietnamese'][_currentIndex] ?? 'No Vietnamese',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    body == 0
                        ? card['english'][_currentIndex] ?? 'No English'
                        : widget.cards[_randomIndexCards]['english']
                                    [_randomIndexCardofCards] ==
                                card['english'][_currentIndex]
                            ? 'apologize'
                            : widget.cards[_randomIndexCards]['english']
                                    [_randomIndexCardofCards] ??
                                'No English',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    //do {
                      if ((body == 0
                              ? card['english'][_currentIndex] ?? 'No English'
                              : widget.cards[_randomIndexCards]['english']
                                          [_randomIndexCardofCards] ==
                                      card['english'][_currentIndex]
                                  ? 'apologize'
                                  : widget.cards[_randomIndexCards]['english']
                                          [_randomIndexCardofCards] ??
                                      'No English') ==
                          card['english'][_currentIndex])
                        setState(() {
                          // Increment index when button is pressed
                          _currentIndex =
                              (_currentIndex + 1) % (card['english'].length)
                                  as int; // Generate new random index
                          _generateRandomIndexCards(); // Generate new random card index
                          _generateRandomIndexCardofCards(); // Generate new random card index
                          _generateRandomBody();
                          msg = '';
                        });
                      else {
                        setState(() {
                          msg = 'Hãy thử lại lần nữa';
                        });
                      }
                    /* } while (_currentIndex < card['english'].length - 1);
                    Navigator.of(context).pop(); */
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    body == 1
                        ? card['english'][_currentIndex] ?? 'No English'
                        : widget.cards[_randomIndexCards]['english']
                                    [_randomIndexCardofCards] ==
                                card['english'][_currentIndex]
                            ? 'apologize'
                            : widget.cards[_randomIndexCards]['english']
                                    [_randomIndexCardofCards] ??
                                'No English',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    //do {
                      if ((body == 1
                              ? card['english'][_currentIndex] ?? 'No English'
                              : widget.cards[_randomIndexCards]['english']
                                          [_randomIndexCardofCards] ==
                                      card['english'][_currentIndex]
                                  ? 'apologize'
                                  : widget.cards[_randomIndexCards]['english']
                                          [_randomIndexCardofCards] ??
                                      'No English') ==
                          card['english'][_currentIndex])
                        setState(() {
                          // Increment index when button is pressed
                          _currentIndex =
                              (_currentIndex + 1) % (card['english'].length)
                                  as int; // Generate new random index
                          _generateRandomIndexCards(); // Generate new random card index
                          _generateRandomIndexCardofCards(); // Generate new random card index
                          _generateRandomBody();
                          msg = '';
                        });
                      else {
                        setState(() {
                          msg = 'Hãy thử lại lần nữa';
                        });
                      }
                    /* } while (_currentIndex < card['english'].length -1);
                    Navigator.of(context).pop(); */
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    body == 1
                        ? card['english'][_currentIndex] ?? 'No English'
                        : widget.cards[_randomIndexCards]['english']
                                    [_randomIndexCardofCards] ==
                                card['english'][_currentIndex]
                            ? 'apologize'
                            : widget.cards[_randomIndexCards]['english']
                                    [_randomIndexCardofCards] ??
                                'No English',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    //do {
                      if ((body == 1
                              ? card['english'][_currentIndex] ?? 'No English'
                              : widget.cards[_randomIndexCards]['english']
                                          [_randomIndexCardofCards] ==
                                      card['english'][_currentIndex]
                                  ? 'apologize'
                                  : widget.cards[_randomIndexCards]['english']
                                          [_randomIndexCardofCards] ??
                                      'No English') ==
                          card['english'][_currentIndex])
                        setState(() {
                          // Increment index when button is pressed
                          _currentIndex =
                              (_currentIndex + 1) % (card['english'].length)
                                  as int; // Generate new random index
                          _generateRandomIndexCards(); // Generate new random card index
                          _generateRandomIndexCardofCards(); // Generate new random card index
                          _generateRandomBody();
                          msg = '';
                        });
                      else {
                        setState(() {
                          msg = 'Hãy thử lại lần nữa';
                        });
                      }
                    /* } while (_currentIndex < card['english'].length -1);
                    Navigator.of(context).pop(); */
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    body == 1
                        ? card['english'][_currentIndex] ?? 'No English'
                        : widget.cards[_randomIndexCards]['english']
                                    [_randomIndexCardofCards] ==
                                card['english'][_currentIndex]
                            ? 'apologize'
                            : widget.cards[_randomIndexCards]['english']
                                    [_randomIndexCardofCards] ??
                                'No English',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    //do {
                      if ((body == 1
                              ? card['english'][_currentIndex] ?? 'No English'
                              : widget.cards[_randomIndexCards]['english']
                                          [_randomIndexCardofCards] ==
                                      card['english'][_currentIndex]
                                  ? 'apologize'
                                  : widget.cards[_randomIndexCards]['english']
                                          [_randomIndexCardofCards] ??
                                      'No English') ==
                          card['english'][_currentIndex])
                        setState(() {
                          // Increment index when button is pressed
                          _currentIndex =
                              (_currentIndex + 1) % (card['english'].length)
                                  as int; // Generate new random index
                          _generateRandomIndexCards(); // Generate new random card index
                          _generateRandomIndexCardofCards(); // Generate new random card index
                          _generateRandomBody();
                          msg = '';
                        });
                      else {
                        setState(() {
                          msg = 'Hãy thử lại lần nữa';
                        });
                      }
                    /* } while (_currentIndex < card['english'].length -1);
                    Navigator.of(context).pop(); */
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateRandomIndexCards() {
    _randomIndexCards = Random().nextInt(widget.cards.length);
  }

  void _generateRandomIndexCardofCards() {
    _randomIndexCardofCards =
        Random().nextInt(widget.cards[_randomIndexCards]['english'].length);
  }

  void _generateRandomBody() {
    // Generate random index for the selected random card
    body = Random().nextInt(2);
  }
}
