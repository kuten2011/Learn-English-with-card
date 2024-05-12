import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';
  String tt = 'Học phần, Sách giáo khoa, Học phần, ...';

  List<Map<String, dynamic>> subjects = [
    {'name': 'Toán cao cấp A1', 'terms': 10, 'teacher': 'Nguyễn Văn A'},
    {'name': 'Lập trình di động', 'terms': 8, 'teacher': 'Trần Thị B'},
    {'name': 'Vật lý đại cương', 'terms': 12, 'teacher': 'Lê Minh C'},
    {'name': 'Tiếng Anh 1', 'terms': 6, 'teacher': 'Phạm Thị D'},
    // Thêm các học phần khác vào đây
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 8.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: tt,
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 82, 82, 82)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 82, 82, 82)),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            prefixIcon: Icon(Icons.search,
                                color: const Color.fromARGB(255, 82, 82, 82)),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear,
                                  color: const Color.fromARGB(255, 82, 82, 82)),
                              onPressed: () {
                                setState(() {
                                  searchText = '';
                                  tt = '';
                                });
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.8),
                            isDense: true,
                          ),
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Các học phần',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Xem tất cả" button tap
                    },
                    child: Text('Xem tất cả'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return EducationCard(
                    title: subject['name'],
                    termsCount: subject['terms'],
                    teacherName: subject['teacher'],
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tương tự học phần của ${subjects[0]['teacher']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return EducationCard(
                    title: subject['name'],
                    termsCount: subject['terms'],
                    teacherName: subject['teacher'],
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thư mục',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Xem tất cả" button tap
                    },
                    child: Text('Xem tất cả'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final String title;
  final int termsCount;
  final String teacherName;

  const EducationCard({
    Key? key,
    required this.title,
    required this.termsCount,
    required this.teacherName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey[300]!), // Màu xám cho viền
        ),
        child: Container(
          color: Colors.white, // Màu nền trắng cho nội dung
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.grey[400]!), // Viền màu xám
                  color: Color.fromARGB(
                      255, 199, 212, 252), // Màu nền xám cho số thuật ngữ
                ),
                child: Text(
                  '$termsCount thuật ngữ',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    '$teacherName   ',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      border:
                          Border.all(color: Colors.grey[400]!), // Viền màu xám
                      color: Color.fromARGB(
                          255, 210, 211, 212), // Màu nền xám cho số thuật ngữ
                    ),
                    child: Text(
                      'Giáo viên',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
