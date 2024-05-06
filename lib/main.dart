import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('an_nguyen5010'),
            accountEmail: Text('an66528@gmail.com'),
          ),
          ListTile(
            title: Text('Tạo mật khẩu'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Navigate to password creation screen
            },
          ),
          ListTile(
            title: Text('Lưu học phần để học ngoại tuyến'),
            subtitle: Text('8 học phần mới học gần đây nhất của bạn sẽ được tự động tải xuống'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Navigate to offline learning screen
            },
          ),
          ListTile(
            title: Text('Quản lý dung lượng lưu trữ'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Navigate to storage management screen
            },
          ),
          SwitchListTile(
            title: Text('Thông báo đẩy'),
            value: false,
            onChanged: (bool value) {
              // Handle push notification toggle
            },
          ),
          SwitchListTile(
            title: Text('Hiệu ứng âm thanh'),
            value: true,
            onChanged: (bool value) {
              // Handle sound effects toggle
            },
          ),
        ],
      ),
    );
  }
}
