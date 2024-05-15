import 'package:flutter/material.dart';
import 'termOfFolderScreen.dart';

class FolderList extends StatelessWidget {
  final List<Map<String, dynamic>> folders = [
    {
      'title': 'Toán cao cấp',
      'content': '5',
      'name': 'khoavo006',
      'image': 'lib/assets/images/test.jpg'
    },
    {
      'title': 'Vật lý đại cương',
      'content': '4',
      'name': 'khoavone',
      'image': 'lib/assets/images/test.jpg'
    },
    {
      'title': 'Hóa học',
      'content': '3',
      'name': 'an3013',
      'image': 'lib/assets/images/test.jpg'
    },
    // Thêm nhiều học phần khác nếu cần
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return FolderCard(folder: folders[index]);
        },
      ),
    );
  }
}

class FolderCard extends StatelessWidget {
  final Map<String, dynamic> folder;

  FolderCard({required this.folder});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TermListScreen()),
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.black), // Viền đen
            ),
            color: Colors.white, // Màu nền trắng tinh
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.folder, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          folder["title"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: const Color.fromARGB(255, 199, 212, 252),
                        ),
                        child: Text(
                          '${folder["content"]} học phần',
                          style: const TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        backgroundImage: AssetImage(folder["image"]),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        folder["name"],
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
