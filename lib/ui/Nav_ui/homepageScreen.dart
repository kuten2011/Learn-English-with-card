import 'package:flutter/material.dart';
import 'package:midtermm/ui/homepage_ui/homeScreen.dart';
import 'package:midtermm/ui/homepage_ui/libraryScreen.dart';
import 'package:midtermm/ui/homepage_ui/popUp.dart';
import 'package:midtermm/ui/homepage_ui/settingScreen.dart';

class homepageScreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<homepageScreen> {
  int _selectedIndex = 0;
  bool _showAppBar = true; // Biến để kiểm tra hiển thị AppBar

  late final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(
      onTabTapped: _onItemTapped,
    ),
    Text('Lời Giải'),
    Text('Thêm'),
    libraryScreen(),
    settingScreen(), // Thêm widget SettingsScreen vào danh sách widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showAppBar = true; // Hiển thị AppBar khi chuyển đổi các tab khác
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _showAppBar
      //     ? AppBar(
      //       automaticallyImplyLeading: false,
      //       title: const Text('Quizlet'))
      //     : null, // Kiểm tra và hiển thị AppBar
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0), // Bo tròn góc trên bên trái
          topRight: Radius.circular(25.0), // Bo tròn góc trên bên phải
        ),
        child: Container(
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
              if (index == 2) {
                // Index 2 tương ứng với mục "Thêm"
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) =>
                      AddMenuPopup(), // Gọi pop-up từ AddMenuPopup
                );
              } else if (index == 0) {
                // Nếu chọn "Hồ Sơ", chỉ cập nhật index mà không chuyển hướng ngay lập tức
                setState(() {
                  _selectedIndex = index;
                  _showAppBar = false; // Ẩn AppBar khi chọn "Hồ Sơ"
                });
              } else if (index == 1) {
                // Nếu chọn "Hồ Sơ", chỉ cập nhật index mà không chuyển hướng ngay lập tức
                setState(() {
                  _selectedIndex = index;
                  _showAppBar = false; // Ẩn AppBar khi chọn "Hồ Sơ"
                });
              } else if (index == 3) {
                // Nếu chọn "Hồ Sơ", chỉ cập nhật index mà không chuyển hướng ngay lập tức
                setState(() {
                  _selectedIndex = index;
                  _showAppBar = false; // Ẩn AppBar khi chọn "Hồ Sơ"
                });
              } else if (index == 4) {
                // Nếu chọn "Hồ Sơ", chỉ cập nhật index mà không chuyển hướng ngay lập tức
                setState(() {
                  _selectedIndex = index;
                  _showAppBar = false; // Ẩn AppBar khi chọn "Hồ Sơ"
                });
              } else {
                // Nếu chọn các mục khác, chuyển hướng ngay lập tức
                _onItemTapped(index);
                _showAppBar =
                    true; // Hiển thị AppBar khi chuyển đổi các tab khác
              }
            },
          ),
        ),
      ),
    );
  }
}
