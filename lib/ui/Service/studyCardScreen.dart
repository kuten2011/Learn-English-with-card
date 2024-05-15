import 'package:flutter/material.dart';

class StudyCardScreen extends StatelessWidget {
  final List<Map<String, String>> cards = [
    {'title': 'Card 1', 'content': 'This is the content of card 1'},
    {'title': 'Card 2', 'content': 'This is the content of card 2'},
    {'title': 'Card 3', 'content': 'This is the content of card 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50, // Đảm bảo nút quay lại cố định ở trên cùng
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text('Card Flip Example'),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return CardItem(
                  title: cards[index]['title']!,
                  content: cards[index]['content']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatefulWidget {
  final String title;
  final String content;

  CardItem({required this.title, required this.content});

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> with SingleTickerProviderStateMixin {
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

    _frontRotation = Tween<double>(begin: 0, end: 180).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0, 0.5, curve: Curves.easeInOut),
    ));

    _backRotation = Tween<double>(begin: -180, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        setState(() {
          _isFrontVisible = !_isFrontVisible;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFrontVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: _flipCard,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(
                    _isFrontVisible ? _frontRotation.value * (3.14 / 180) : _backRotation.value * (3.14 / 180)),
              alignment: Alignment.center,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: _isFrontVisible ? Colors.blue : Colors.green,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      _isFrontVisible ? widget.title : widget.content,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: _isFrontVisible ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
