import 'package:flutter/material.dart';
import '../term_ui/addTermScreen.dart'; // Import file addTerm.dart
import '../folder_ui/addFolderScreen.dart'; // Import file addFolder.dart
import '../class_ui/addClassScreen.dart'; // Import file addClass.dart

class AddMenuPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.book_outlined, color: Color(0xFF4254FE)),
            title: Text('Học phần', style: TextStyle(color: Color(0xFF4254FE))),
            onTap: () {
              // Xử lý khi nhấn "Học phần"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTermScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.folder_outlined, color: Color(0xFF4254FE)),
            title: Text('Thư mục', style: TextStyle(color: Color(0xFF4254FE))),
            onTap: () {
              // Xử lý khi nhấn "Thư mục"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFolderScreen()),
              );
            },
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.group_outlined, color: Color(0xFF4254FE)),
          //   title: Text('Lớp', style: TextStyle(color: Colors.grey)),
          //   onTap: () {
          //     // Xử lý khi nhấn "Thư mục"
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => AddClassScreen()),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
