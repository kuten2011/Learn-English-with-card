import 'package:flutter/material.dart';

class StudyCardScreen extends StatelessWidget {
  final Map<String, dynamic> card;

  StudyCardScreen({required this.card});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Ghi nhớ'),
        centerTitle: true,
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: card['english'].length, // Adjusted itemCount
              itemBuilder: (context, index) {
                return CardItem(
                  title: card['english'][index] ?? 'No english',
                  content: card['vietnamese'][index] ?? 'No vietnamese',
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
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Colors.grey[400]!, width: 1),
                ),
                color: _isFrontVisible ? Color(0xFF4254FE) : Colors.green,
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
