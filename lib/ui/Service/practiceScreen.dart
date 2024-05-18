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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        title: Text('Luyện tập'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: () {
                          if (_countWord ==
                              widget.cardterms[widget.indexterm]['vietnamese']
                                      .length -
                                  1) {
                            Navigator.of(context).pop();
                          } else {
                            _textEditingController.clear();
                            setState(() {
                              _currentIndex = ((_currentIndex + 1) %
                                      widget
                                          .cardterms[widget.indexterm]
                                              ['vietnamese']
                                          .length)
                                  .toInt();
                              _countWord++;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          String input =
                              _textEditingController.text.trim().toLowerCase();
                          if (input ==
                              widget.cardterms[widget.indexterm]['english']
                                      [_currentIndex]
                                  .toLowerCase()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Chính xác!'),
                                duration: Duration(milliseconds: 800),
                              ),
                            );
                            _textEditingController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Không chính xác. Thử lại!'),
                                duration: Duration(milliseconds: 800),
                              ),
                            );
                            _textEditingController.clear();
                            return;
                          }

                          Future.delayed(
                            Duration(milliseconds: 1000),
                            () {
                              setState(() {
                                if (_countWord ==
                                    widget
                                            .cardterms[widget.indexterm]
                                                ['english']
                                            .length -
                                        1) {
                                  Navigator.of(context).pop();
                                } else {
                                  _currentIndex = ((_currentIndex + 1) %
                                          widget
                                              .cardterms[widget.indexterm]
                                                  ['english']
                                              .length)
                                      .toInt();
                                  _countWord++;
                                }
                              });
                            },
                          );
                        },
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
