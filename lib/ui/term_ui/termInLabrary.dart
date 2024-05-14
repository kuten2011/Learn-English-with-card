import 'package:flutter/material.dart';
import 'cardScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Term List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TermListScreen(),
    );
  }
}

class TermListScreen extends StatelessWidget {
  final List<Term> terms = [
    Term("Flutter", 20, "John Doe"),
    Term("Dart", 15, "Jane Smith"),
    Term("Widget", 25, "Alex Johnson"),
    // Add more terms as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Term List'),
      ),
      body: ListView.builder(
        itemCount: terms.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                //MaterialPageRoute(builder: (context) => CardListScreen(term: terms[index])),
                MaterialPageRoute(builder: (context) => CardListScreen()),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      terms[index].title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.grey[400]!),
                        color: const Color.fromARGB(255, 199, 212, 252),
                      ),
                      child: Text(
                        '${terms[index].count} thuật ngữ',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: const AssetImage('lib/assets/images/test.jpg'),
                        ),
                        const SizedBox(width: 8),
                        Text('Name: ${terms[index].name}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Term {
  final String title;
  final int count;
  final String name;

  Term(this.title, this.count, this.name);
}