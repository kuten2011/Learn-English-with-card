import 'package:flutter/material.dart';
import 'termOfClassScreen.dart';

class Course {
  final String title;
  final String content;

  Course({required this.title, required this.content});
}

class CourseList extends StatelessWidget {
  final List<Course> courses = [
    Course(title: 'Toán cao cấp', content: '5 học phần'),
    Course(title: 'Vật lý đại cương', content: '4 học phần'),
    Course(title: 'Hóa học', content: '3 học phần'),
    // Thêm nhiều học phần khác nếu cần
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(course: courses[index]);
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard({required this.course});

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
          padding: const EdgeInsets.all(1.0),
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
                      Icon(Icons.people, size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          course.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: const Color.fromARGB(255, 199, 212, 252), // Màu nền trắng tinh
                    ),
                    child: Text(
                      course.content,
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
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
