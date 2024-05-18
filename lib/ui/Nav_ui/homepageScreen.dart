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
  bool _showAppBar = true;
  int initialTabIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(
      onTabTapped: _onItemTapped,
    ),
    Text('Lời Giải'),
    Text('Thêm'),
    libraryScreen(initialTabIndex: initialTabIndex),
    settingScreen(),
  ];

  void _onItemTapped(int index, {int? initialTabIndex}) {
    if (index == 3 && initialTabIndex != null) {
      setState(() {
        _selectedIndex = index;
        _showAppBar = false;
        this.initialTabIndex = initialTabIndex;
        _widgetOptions[3] = libraryScreen(initialTabIndex: this.initialTabIndex);
      });
    } else {
      setState(() {
        _selectedIndex = index;
        _showAppBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF4254FE),
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
            selectedItemColor: Color.fromARGB(255, 255, 255, 255),
            unselectedItemColor: Colors.white,
            onTap: (index) {
              if (index == 2) {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => AddMenuPopup(),
                );
              } else {
                _onItemTapped(index);
              }
            },
          ),
        ),
      ),
    );
  }
}
