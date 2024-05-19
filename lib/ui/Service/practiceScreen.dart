import 'package:flutter/material.dart';
import 'package:midtermm/ui/Service/settingPracticeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticeScreen extends StatefulWidget {
  final Map<String, dynamic> cardterms;

  PracticeScreen({required this.cardterms});

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  int _currentIndex = 0;
  int _countWord = 0;
  String _msg = '';
  Color _msgColor = Colors.black;
  bool _shuffleQuestions = false;
  bool _useVietnamese = false;
  List<int> _questionOrder = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _loadPreferences();
    _initializeQuestions();
    Future.delayed(Duration.zero, () => _focusNode.requestFocus());
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _shuffleQuestions = prefs.getBool('shufflePracticeQuestions') ?? false;
      _useVietnamese = prefs.getBool('useVietnamesePractice') ?? false;
      _initializeQuestions();
    });
  }

  void _initializeQuestions() {
    setState(() {
      _questionOrder =
          List<int>.generate(widget.cardterms['vietnamese'].length, (i) => i);
      if (_shuffleQuestions) {
        _questionOrder.shuffle();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _handleNextCard() {
    _textEditingController.clear();
    if (_countWord == widget.cardterms['vietnamese'].length - 1) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.cardterms['vietnamese'].length as int;
        _countWord++;
      });
    }
  }

  void _checkAnswer() {
    String input = _textEditingController.text.trim().toLowerCase();
    String correctAnswer = widget.cardterms[_useVietnamese ? 'english' : 'vietnamese']
        [_questionOrder[_currentIndex]].toLowerCase();
    if (input == correctAnswer) {
      _setFeedback('Correct!', Colors.green);
      _delayAndMoveToNextCard();
    } else {
      _setFeedback('Incorrect! Try again.', Colors.red);
    }
  }

  void _setFeedback(String message, Color color) {
    setState(() {
      _msg = message;
      _msgColor = color;
    });
  }

  void _delayAndMoveToNextCard() {
    Future.delayed(Duration(seconds: 1), () {
      _setFeedback('', Colors.black);
      _handleNextCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentQuestionIndex = _questionOrder[_currentIndex];
    String currentQuestion = _useVietnamese
        ? widget.cardterms['vietnamese'][currentQuestionIndex]
        : widget.cardterms['english'][currentQuestionIndex];
    String hintText = _useVietnamese ? 'Enter in English' : 'Nhập tiếng Việt';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        title: Text('Practice'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPracticeScreen()),
              ).then((_) => _loadPreferences());
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _msg,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _msgColor,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  currentQuestion,
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: hintText,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: _handleNextCard,
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _checkAnswer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
