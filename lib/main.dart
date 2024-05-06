import 'package:flutter/material.dart';
import 'SettingsScreen.dart'; // Import file SettingsScreen.dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Trang Chủ'),
    Text('Lời Giải'),
    Text('Thêm'),
    Text('Thư Viện'),
    SettingsScreen(), // Thêm widget SettingsScreen vào danh sách widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Chụp ảnh'),
                onTap: () {
                  // Handle camera option
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Chọn ảnh từ thư viện'),
                onTap: () {
                  // Handle gallery option
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.note),
                title: Text('Tạo ghi chú'),
                onTap: () {
                  // Handle note creation option
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Demo'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF4254FE), // Màu nền của BottomNavigationBar
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Color(0xFF4254FE),
              label: 'Trang Chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              backgroundColor: Color(0xFF4254FE),
              label: 'Lời Giải',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              backgroundColor: Color(0xFF4254FE),
              label: 'Thêm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              backgroundColor: Color(0xFF4254FE),
              label: 'Thư Viện',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: Color(0xFF4254FE),
              label: 'Hồ Sơ',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor:
              Color.fromARGB(255, 255, 255, 255), // Màu khi được chọn
          unselectedItemColor: Colors.white, // Màu khi không được chọn
          onTap: (index) {
            if (index == 4) {
              // Nếu chọn "Hồ Sơ", chỉ cập nhật index mà không chuyển hướng ngay lập tức
              setState(() {
                _selectedIndex = index;
              });
            } else if (index == 2) {
              // Nếu chọn "Thêm", hiển thị pop-up với 3 sự lựa chọn
              _showAddOptions(context);
            } else {
              // Nếu chọn các mục khác, chuyển hướng ngay lập tức
              _onItemTapped(index);
            }
          },
        ),
      ),
    );
  }
}
