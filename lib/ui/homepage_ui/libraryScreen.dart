import 'package:flutter/material.dart';
import 'package:midtermm/ui/folder_ui/addFolderScreen.dart';
import 'package:midtermm/ui/term_ui/addTermScreen.dart';
import 'package:midtermm/ui/term_ui/termListScreen.dart';
import 'package:midtermm/ui/folder_ui/folderOfLibrary.dart';

class libraryScreen extends StatefulWidget {
  final int initialTabIndex; // Thêm tham số này

  const libraryScreen({Key? key, this.initialTabIndex = 0})
      : super(key: key); // Sửa đổi constructor

  @override
  _libraryScreenState createState() => _libraryScreenState();
}

class _libraryScreenState extends State<libraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: widget.initialTabIndex); // Sử dụng initialTabIndex
    _tabController.addListener(() {
      setState(() {});
    });
  }

  // void _onAddButtonPressed() {
  //   if (_tabController.index == 0) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => AddTermScreen()),
  //     );
  //   } else if (_tabController.index == 1) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => AddFolderScreen()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Thư viện'),
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.add),
        //     onPressed: () {
        //       _onAddButtonPressed();
        //     },
        //   ),
        // ],
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          controller: _tabController,
          tabs: [
            Tab(text: 'Học phần'),
            Tab(text: 'Thư mục'),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TermListScreen(),
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
