import 'package:flutter/material.dart';
import 'settingTermScreen.dart';

class AddTermScreen extends StatelessWidget {
  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _termController = TextEditingController();
  final TextEditingController _definitionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Học Phần'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings), // Icon cài đặt
            onPressed: () {
              // Xử lý khi nhấn "Cài Đặt"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingTermScreen()), // Màn hình cài đặt
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              // Xử lý khi nhấn "Xong"
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Tiêu đề',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _termController,
                decoration: InputDecoration(
                  labelText: 'Thuật ngữ',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Xử lý khi nhấn thêm "Thuật ngữ"
                    },
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _definitionController,
                decoration: InputDecoration(
                  labelText: 'Định nghĩa',
                ),
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt),
                  label: Text('Quét Tài Liệu'),
                  onPressed: () {
                    // Xử lý khi nhấn "Quét Tài Liệu"
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
