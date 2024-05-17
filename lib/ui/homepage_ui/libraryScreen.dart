import 'package:flutter/material.dart';
import 'package:midtermm/ui/class_ui/addClassScreen.dart';
import 'package:midtermm/ui/folder_ui/addFolderScreen.dart';
import 'package:midtermm/ui/term_ui/addTermScreen.dart';
import 'package:midtermm/ui/term_ui/termListScreen.dart';
import 'package:midtermm/ui/class_ui/classOfLibrary.dart';
import 'package:midtermm/ui/folder_ui/folderOfLibrary.dart';

class libraryScreen extends StatefulWidget {
  const libraryScreen({Key? key}) : super(key: key);

  @override
  _libraryScreenState createState() => _libraryScreenState();
}

class _libraryScreenState extends State<libraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  void _onAddButtonPressed() {
    if (_tabController.index == 0) {
      // Check if the current tab is 'Học phần'
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddTermScreen()),
      );
    // } else if (_tabController.index == 1) {
    //   // Check if the current tab is 'Lớp học'
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => AddClassScreen()),
    //   );
    }else {
      // Check if the current tab is 'Thư mục'
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddFolderScreen()),
      );
    }
    // Add more conditions here if needed for other tabs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Thư viện'),
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _onAddButtonPressed();
            },
          ),
        ],
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          controller: _tabController,
          tabs: [
            Tab(text: 'Học phần'),
            //Tab(text: 'Lớp học'),
            Tab(text: 'Thư mục'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TermListScreen(),
          //CourseList(),
          FolderList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
