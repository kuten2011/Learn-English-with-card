import 'dart:math';
import 'package:flutter/material.dart';
import 'package:midtermm/ui/Service/settingTestScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestCardScreen extends StatefulWidget {
  final Map<String, dynamic> cards;

  TestCardScreen({required this.cards});

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
  List<int> questionOrder = [];
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;
  int? _wrongAnswerIndex;
  bool _useVietnamese = false;
  bool _shuffleQuestions = false;

  @override
  void initState() {
    super.initState();
    _updateCard();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useVietnamese = prefs.getBool('useVietnamese') ?? false;
      _shuffleQuestions = prefs.getBool('shuffleQuestions') ?? false;
      _updateCard();  // Update card when preferences change
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateCard() {
    setState(() {
      card = widget.cards;
      if (_shuffleQuestions) {
        _shuffleQuestionOrder();
      } else {
        questionOrder = List<int>.generate(card['english'].length, (i) => i);
      }
      _generateRandomAnswers();
    });
  }

  void _shuffleQuestionOrder() {
    questionOrder = List<int>.generate(card['english'].length, (i) => i);
    questionOrder.shuffle();
  }

  void _checkAnswer(bool isCorrect, int index) {
    if (isCorrect) {
      setState(() {
        msg = _useVietnamese ? 'Chính xác!' : 'Correct!';
        _animationController.forward(from: 0.0);
        _colorTween = ColorTween(begin: Colors.white, end: Colors.green)
            .animate(_animationController);
        _wrongAnswerIndex = index;
      });
      _delayAndMoveToNextCard();
    } else {
      setState(() {
        msg = _useVietnamese ? 'Hãy thử lại lần nữa' : 'Try Again';
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
        if (_currentIndex == questionOrder.length - 1) {
          Navigator.of(context).pop();
        } else {
          _currentIndex = (_currentIndex + 1) % questionOrder.length;
          _generateRandomAnswers();
          msg = '';
        }
        _colorTween = ColorTween(
                begin: Colors.white,
                end: const Color.fromARGB(255, 255, 255, 255))
            .animate(_animationController);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentQuestionIndex = questionOrder[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(_useVietnamese ? 'Kiểm tra' : 'Test'),
        centerTitle: true,
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingTestScreen()),
              ).then((_) => _loadPreferences());
            },
          ),
        ],
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
                color: msg == (_useVietnamese ? 'Chính xác!' : 'Correct!')
                    ? Colors.green
                    : Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _useVietnamese
                  ? card['vietnamese'][currentQuestionIndex]
                  : card['english'][currentQuestionIndex],
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
    int currentQuestionIndex = questionOrder[_currentIndex];
    int answerCount = card['english'].length;
    int displayCount = min(answerCount, 4);

    correctAnswerIndex = Random().nextInt(displayCount);
    answers = List<String>.filled(displayCount, '', growable: false);

    Set<int> usedIndices = {currentQuestionIndex};

    answers[correctAnswerIndex] = _useVietnamese
        ? card['english'][currentQuestionIndex]
        : card['vietnamese'][currentQuestionIndex];

    for (int i = 0; i < answers.length; i++) {
      if (i == correctAnswerIndex) continue;

      int randomIndex;
      do {
        randomIndex = Random().nextInt(card['english'].length);
      } while (usedIndices.contains(randomIndex));

      answers[i] = _useVietnamese
          ? card['english'][randomIndex]
          : card['vietnamese'][randomIndex];
      usedIndices.add(randomIndex);
    }
  }
}
