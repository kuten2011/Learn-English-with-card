import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: TestScreen(),
//     );
//   }
// }

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late FocusNode _focusNode;
  int _currentIndex = 0; // Biến để theo dõi vị trí của từ hiện tại

  Map<String, dynamic> data = {
    'english': ['hi', 'plan'],
    'title': 'KhoaTerm',
    'userEmail': 'khoavo006@gmail.com',
    'userName': 'khoavo006',
    'vietnamese': ['xin chào', 'kế hoạch'],
  };

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Tự động focus vào ô nhập liệu khi màn hình được mở
    Future.delayed(Duration.zero, () => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lượt 2'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['english'][_currentIndex], // Hiển thị từ hiện tại
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 20), // Khoảng cách giữa Text và Row
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(16.0), // Đặt bo góc của container
                  border: Border.all(
                      color: Colors.grey), // Đặt viền xung quanh container
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Nhập bằng tiếng Anh', // Gợi ý nhập
                          border: InputBorder.none, // Ẩn viền của TextField
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  10.0), // Khoảng cách giữa nội dung và viền
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send), // Icon submit
                      onPressed: () {
                        setState(() {
                          // Tăng chỉ số để chuyển đến từ tiếp theo
                          _currentIndex = ((_currentIndex + 1) % data['english'].length).toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
