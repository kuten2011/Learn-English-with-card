import 'package:flutter/material.dart';

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
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Thư viện'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Xử lý khi nhấn "Xong"
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Học phần'),
            Tab(text: 'Lớp học'),
            Tab(text: 'Thư mục'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('Nội dung Học phần')),
          Center(child: Text('Nội dung Lớp học')),
          Center(child: Text('Nội dung Thư mục')),
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
