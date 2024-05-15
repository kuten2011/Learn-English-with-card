import 'package:flutter/material.dart';
import 'package:midtermm/ui/Service/studyCardScreen.dart';

class CardListScreen extends StatefulWidget {
  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  final List<CardModel> cards = [
    CardModel("Flutter",
        "A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase."),
    CardModel("Dart",
        "A programming language optimized for building mobile, web, and server-side applications."),
    CardModel("Widget", "A description of part of a user interface."),
    CardModel("Animation",
        "A visual effect that makes an element appear or disappear, change size or position, or otherwise change its appearance and behavior."),
  ];

  int currentPage = 0;

  void onReview() {
    print('Ghi nhớ button pressed');
  }

  void onStudy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudyCardScreen()),
    );
  }

  void onTest() {
    print('Kiểm tra nhanh button pressed');
  }

  void onMerge() {
    print('Ghép từ button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horizontal Card Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: PageView.builder(
                itemCount: cards.length,
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
                      frontChild: CardItem(cards[index].keyword),
                      backChild: CardItem(cards[index].definition),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${currentPage + 1} of ${cards.length}',
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
                      // Handle "Xem tất cả" button tap
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
            buildCustomCard('Ghép từ', Icons.merge_type, onMerge),
            SizedBox(height: 10),
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
                      // Handle "Xem tất cả" button tap
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
            for (int index = 0; index < cards.length; index++)
              Card(
                elevation: 5, // Độ nổi bật của thẻ
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 1), // Viền đen
                  borderRadius: BorderRadius.circular(10), // Bo góc
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Nền trắng
                    borderRadius: BorderRadius.circular(10), // Bo góc
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.2), // Màu đen với độ trong suốt để tạo hiệu ứng nổi bật
                        spreadRadius: 3, // Bán kính lan trải của shadow
                        blurRadius: 5, // Độ mờ của shadow
                        offset: Offset(0, 3), // Vị trí của shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(cards[index].keyword,
                            style: TextStyle(color: Colors.black)), // Chữ đen
                        subtitle: Text(cards[index].definition,
                            style: TextStyle(color: Colors.black)), // Chữ đen
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey),
      ),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.only(left: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.transparent),
            ),
          ),
          icon: Icon(icon, color: Colors.black),
          label: Align(
            alignment: Alignment.centerLeft,
            child: Text(text),
          ),
          onPressed: onPressed,
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
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
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

class CardModel {
  String keyword;
  String definition;

  CardModel(this.keyword, this.definition);
}
