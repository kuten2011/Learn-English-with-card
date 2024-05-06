import 'package:flutter/material.dart';

class settingScreen extends StatelessWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text(
              'Kuten',
              style: TextStyle(color: Colors.black), // Đặt màu chữ là màu đen
            ),
            accountEmail: Text(
              'khoavo006@gmail.com',
              style: TextStyle(color: Colors.black), // Đặt màu chữ là màu đen
            ),
            decoration: BoxDecoration(
              color:
                  Color.fromARGB(255, 255, 255, 255), // Đặt màu nền là màu xanh
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: ListTile(
              title: Text('Lưu học phần để học ngoại tuyến'),
              subtitle: Text(
                  '8 học phần mới học gần đây nhất của bạn sẽ được tự động tải xuống'),
              trailing: Icon(Icons.download_rounded),
              onTap: () {
                // Navigate to offline learning screen
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(0),
            child: ListTile(
              title: Text('Quản lý dung lượng lưu trữ'),
              trailing: Icon(Icons.storage),
              onTap: () {
                // Navigate to storage management screen
              },
            ),
          ),
          Divider(),
          SwitchListTile(
            title: Text('Thông báo đẩy'),
            value: false,
            activeColor: Colors.white,
            activeTrackColor: Color(0xFF4254FE),
            inactiveTrackColor: Color.fromARGB(255, 178, 178, 178),
            inactiveThumbColor: Color.fromARGB(255, 255, 255,
                255), // Màu của nút khi không được bật là màu trắng
            onChanged: (bool value) {
              // Handle push notification toggle
            },
          ),
          SwitchListTile(
            title: Text('Hiệu ứng âm thanh'),
            value: true,
            activeColor: Colors.white,
            activeTrackColor: Color(0xFF4254FE),
            inactiveTrackColor: Color.fromARGB(255, 178, 178, 178),
            inactiveThumbColor: Color.fromARGB(255, 255, 255,
                255), // Màu của nút khi không được bật là màu trắng
            onChanged: (bool value) {
              // Handle push notification toggle
            },
          ),
        ],
      ),
    );
  }
}
