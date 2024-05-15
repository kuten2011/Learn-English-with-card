import 'package:flutter/material.dart';

class MemberScreen extends StatelessWidget {
  MemberScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> items = [
    {'name': 'John Doe', 'image': 'lib/assets/images/test.jpg'},
    {'name': 'Jane Smith', 'image': 'lib/assets/images/test.jpg'},
    {'name': 'Michael Johnson', 'image': 'lib/assets/images/test.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return CardItem(key: Key(index.toString()), name: items[index]['name']!, image: items[index]['image']!);
      },
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({Key? key, required this.name, required this.image}) : super(key: key);

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Set the background color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Set border radius to 8.0
        side: BorderSide(color: Colors.black, width: 1.0), // Set border side color and width
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(image),
        ),
        title: Text(name),
        onTap: () {
          // Add onTap functionality here
        },
      ),
    );
  }
}