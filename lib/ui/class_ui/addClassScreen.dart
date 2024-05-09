import 'package:flutter/material.dart';

class AddClassScreen extends StatefulWidget {
  @override
  _AddClassScreen createState() => _AddClassScreen();
}

class _AddClassScreen extends State<AddClassScreen> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  bool _allowMembersToAdd = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lớp mới'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Xử lý khi nhấn "Lưu"
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _classNameController,
              decoration: InputDecoration(
                labelText: 'Tên lớp',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _additionalInfoController,
              decoration: InputDecoration(
                labelText: 'Thông tin bổ sung (không bắt buộc)',
              ),
            ),
            SwitchListTile(
              title:
                  Text('Cho phép thành viên thêm học phần và thành viên mới'),
              value: _allowMembersToAdd,
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF4254FE),
              inactiveTrackColor: Color.fromARGB(255, 178, 178, 178),
              inactiveThumbColor: Color.fromARGB(255, 255, 255, 255),
              onChanged: (bool value) {
                setState(() {
                  _allowMembersToAdd = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
