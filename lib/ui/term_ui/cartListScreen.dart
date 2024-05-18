import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:midtermm/ui/Service/studyCardScreen.dart';
import 'package:midtermm/ui/Service/testCardScreen.dart';
import 'package:midtermm/ui/Service/testScreen.dart';

class CardListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cardterms;
  final int indexterm;

  CardListScreen({
    required this.cardterms,
    required this.indexterm,
  });

  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  int currentPage = 0;
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speakWord(String? word) async {
    if (word != null) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(word);
    }
  }

  void onReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyCardScreen(
            cards: widget.cardterms, indexterm: widget.indexterm),
      ),
    );
  }

  void onStudy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestScreen(),
      ),
    );
  }

  void onTest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestCardScreen(
            cards: widget.cardterms, indexterm: widget.indexterm),
      ),
    );
  }

  void onMerge() {
    print('Ghép từ button pressed');
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cardterms = widget.cardterms;

    // Check if indexterm is within bounds
    if (widget.indexterm < 0 || widget.indexterm >= cardterms.length) {
      return Scaffold(
        body: Center(
          child: Text('Index out of bounds'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(cardterms[widget.indexterm]["title"] ?? 'No Title'),
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: PageView.builder(
                itemCount: cardterms[widget.indexterm]["english"].length,
                controller: PageController(
                  initialPage: currentPage,
                  viewportFraction: 0.8,
                ),
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, indexterm) {
                  int englishCount =
                      cardterms[widget.indexterm]["english"].length;
                  return PageView.builder(
                    itemCount: englishCount,
                    controller: PageController(
                      initialPage: 0,
                      viewportFraction: 0.8,
                    ),
                    onPageChanged: (int page) {
                      setState(() {
                        currentPage = page;
                      });
                    },
                    itemBuilder: (context, arrayindex) {
                      return Center(
                        child: FlipCard(
                          frontChild: CardItem(cardterms[widget.indexterm]
                                  ["english"][arrayindex] ??
                              'No English'),
                          backChild: CardItem(cardterms[widget.indexterm]
                                  ["vietnamese"][arrayindex] ??
                              'No Vietnamese'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${currentPage + 1} of ${cardterms[widget.indexterm]["english"].length}',
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
                      print('Xem tất cả button pressed');
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
            // buildCustomCard('Ghép từ', Icons.merge_type, onMerge),
            // SizedBox(height: 10),
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
                      print('Xem tất cả button pressed');
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
            for (int index = 0;
                index < cardterms[widget.indexterm]['english'].length;
                index++)
              Card(
                elevation: 5,
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
                    mainAxisAlignment: MainAxisAlignment
                        .end, // Đưa biểu tượng loa về phía bên phải
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                cardterms[widget.indexterm]["english"][index] ??
                                    'No English',
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                cardterms[widget.indexterm]["vietnamese"]
                                        [index] ??
                                    'No Vietnamese',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up), //
                        onPressed: () {
                          // Gọi hàm để đọc từ tiếng Anh khi người dùng nhấn vào nút nghe
                          speakWord(
                              cardterms[widget.indexterm]["english"][index]);
                        },
                      ),
                    ],
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
      elevation: 5,
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
            height: 60, // Đặt chiều cao tùy ý
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  _FlipCardtermstate createState() => _FlipCardtermstate();
}

class _FlipCardtermstate extends State<FlipCard>
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
