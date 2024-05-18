import 'dart:math';
import 'package:flutter/material.dart';

class TestCardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cards;
  final int indexterm;

  TestCardScreen({required this.cards, required this.indexterm});

  @override
  _TestCardScreenState createState() => _TestCardScreenState();
}

class _TestCardScreenState extends State<TestCardScreen>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic> card;
  int _currentIndex = 0;
  int correctAnswerIndex = 0;
  String msg = '';
  List<String> answers = [];
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;
  int? _wrongAnswerIndex;

  @override
  void initState() {
    super.initState();
    _updateCard();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateCard() {
    setState(() {
      card = widget.cards[widget.indexterm];
      _generateRandomAnswers();
    });
  }

  void _checkAnswer(bool isCorrect, int index) {
    if (isCorrect) {
      setState(() {
        msg = 'Chính xác!';
        _animationController.forward(from: 0.0);
        _colorTween = ColorTween(begin: Colors.white, end: Colors.green)
            .animate(_animationController);
        _wrongAnswerIndex = index; // Đặt lại _wrongAnswerIndex
      });
      _delayAndMoveToNextCard();
    } else {
      setState(() {
        msg = 'Hãy thử lại lần nữa';
        _wrongAnswerIndex = index;
        _animationController.forward(from: 0.0);
        _colorTween = ColorTween(begin: Colors.white, end: Colors.red)
            .animate(_animationController);
        _colorTween = ColorTween(begin: Colors.red, end: Colors.white)
            .animate(_animationController);
      });
    }
  }

  void _delayAndMoveToNextCard() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (_currentIndex ==
            widget.cards[widget.indexterm]['english'].length - 1) {
          Navigator.of(context).pop();
        } else {
          _currentIndex = (_currentIndex + 1) %
              widget.cards[widget.indexterm]['english'].length as int;
          _generateRandomAnswers();
          msg = '';
        }
        // Đặt lại màu sau khi di chuyển đến thẻ tiếp theo
        _colorTween = ColorTween(
                begin: Colors.white,
                end: const Color.fromARGB(255, 255, 255, 255))
            .animate(_animationController);
      });
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
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
                color: msg == 'Chính xác!' ? Colors.green : Colors.red,
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
            for (int i = 0; i < answers.length; i++)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!, width: 2.0),
                      borderRadius: BorderRadius.circular(16.0),
                      color: _wrongAnswerIndex == i
                          ? _colorTween.value
                          : Colors.white,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 4,
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          answers[i],
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          bool isCorrect = i == correctAnswerIndex;
                          _checkAnswer(isCorrect, i);
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _generateRandomAnswers() {
    int answerCount = card['english'].length;
    int displayCount = min(answerCount, 4);

    correctAnswerIndex = Random().nextInt(displayCount);
    answers = List<String>.filled(displayCount, '', growable: false);

    Set<int> usedIndices = {_currentIndex};

    // Place the correct answer at the correctAnswerIndex
    answers[correctAnswerIndex] = card['english'][_currentIndex];

    // Fill other positions with random incorrect answers
    for (int i = 0; i < answers.length; i++) {
      if (i == correctAnswerIndex) continue;

      int randomIndex;
      do {
        randomIndex = Random().nextInt(card['english'].length);
      } while (usedIndices.contains(randomIndex));

      answers[i] = card['english'][randomIndex];
      usedIndices.add(randomIndex);
    }
  }
}
