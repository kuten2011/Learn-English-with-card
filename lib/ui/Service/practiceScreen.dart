import 'package:flutter/material.dart';

class PracticeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cardterms;
  final int indexterm;

  PracticeScreen({
    required this.cardterms,
    required this.indexterm,
  });

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  int _currentIndex = 0;
  int _countWord = 0;
  String msg = '';
  Color msgColor = Colors.black;

  void _delayAndMoveToNextCard() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        msg = '';
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    Future.delayed(Duration.zero, () => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _handleNextCard() {
    _textEditingController.clear();
    if (_countWord ==
        widget.cardterms[widget.indexterm]['vietnamese'].length - 1) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _currentIndex = (_currentIndex + 1) %
            widget.cardterms[widget.indexterm]['vietnamese'].length as int;
        _countWord++;
      });
    }
  }

  void _checkAnswer() {
    String input = _textEditingController.text.trim().toLowerCase();
    if (input ==
        widget.cardterms[widget.indexterm]['english'][_currentIndex]
            .toLowerCase()) {
      setState(() {
        msg = 'Chính xác!';
        msgColor = Colors.green;
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        _handleNextCard();
      });
    } else {
      setState(() {
        msg = 'Sai rồi! Hãy thử lại.';
        msgColor = Colors.red;
      });
    }
    _textEditingController.clear();
    _delayAndMoveToNextCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        title: Text('Luyện tập'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: msgColor,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.cardterms[widget.indexterm]['vietnamese']
                      [_currentIndex],
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
                          decoration: const InputDecoration(
                            hintText: 'Nhập bằng tiếng Anh',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
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
