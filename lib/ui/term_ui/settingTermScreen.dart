import 'package:flutter/material.dart';

class SettingTermScreen extends StatelessWidget {
  String _selectedLanguage = 'Tiếng Việt';
  bool _privacyEveryone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Ngôn ngữ'),
            subtitle: Text(_selectedLanguage),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Xử lý khi chọn ngôn ngữ
            },
          ),
          ListTile(
            title: Text('Định nghĩa'),
            subtitle: Text('Mọi người'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Xử lý khi chọn dinh nghĩa
            },
          ),
          SwitchListTile(
            title: Text('Quyền riêng tư'),
            subtitle: Text('Mọi người'),
            activeColor: Colors.white,
            activeTrackColor: Color(0xFF4254FE),
            inactiveTrackColor: Color.fromARGB(255, 178, 178, 178),
            inactiveThumbColor: Color.fromARGB(255, 255, 255, 255),
            value: _privacyEveryone,
            onChanged: (bool value) {
              /*setState(() {
                _privacyEveryone = value;
              });*/
            },
          ),
          ListTile(
            title: Text('Ai có thể xem'),
            subtitle: Text('Mọi người'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Xử lý khi chọn ai có thể xem
            },
          ),
          ListTile(
            title: Text('Ai có thể sửa'),
            subtitle: Text('Chỉ tôi'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Xử lý khi chọn ai có thể sửa
            },
          ),
        ],
      ),
    );
  }
}
