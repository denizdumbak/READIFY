import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
    ),
    body: Column(
    children: [
    Container(
    color: Colors.white,
    child: Column(
    children: [
    const SizedBox(height: 20.0),
      const CircleAvatar(
        radius: 60.0,
        backgroundImage: NetworkImage(
          'https://picsum.photos/200',
        ),
      ),

      const SizedBox(height: 10.0),
    const Text(
    'Emre Bekmezci',
    style: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    ),
    const SizedBox(height: 5.0),
    Text(
    '@bekmezcix',
    style: TextStyle(
    fontSize: 16.0,
    color: Colors.grey[500],
    ),
    ),
    const SizedBox(height: 10.0),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Column(
    children: [
    const Text(
    '123',
    style: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    const SizedBox(height: 5.0),
    Text(
    'Followers',
    style: TextStyle(
    fontSize: 16.0,
    color: Colors.grey[500],
    ),
    ),
    ],
    ),
    Column(
    children: [
    const Text(
    '456',
    style: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    const SizedBox(height: 5.0),
    Text(
    'Following',
    style: TextStyle(
    fontSize: 16.0,
    color: Colors.grey[500],
    ),
    ),
    ],
    ),
    ],
    ),
    const SizedBox(height: 20.0),
    ],
    ),
    ),
    Expanded(
    child: ListView.builder(
    itemCount: 10,
    itemBuilder: (BuildContext context, int index) {
    return Container(
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
    border: Border(
    bottom: BorderSide(
    color: Colors.grey[300]!,
    ),
    ),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    const Icon(
    Icons.account_circle,
    size: 50.0,
    color: Colors.grey,
    ),
    const SizedBox(width: 10.0),
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
    Text(
    'Emre Bekmezci',
    style: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    ),
    ),
    SizedBox(height: 5.0),
    Text(
    '@bekmezcix',
    style: TextStyle(
    fontSize: 14.0,
    color: Colors.grey,
    ),
    ),
    ],
    ),
    ],
    ),
    const SizedBox(height: 10.0),
    Row(
    children: [
    Expanded(
    child: Text(
    'Comment ${index + 1}',
    style: const TextStyle(
    fontSize: 18.0,
    color: Colors.black,
    ),
    ),
    ),
    const Icon(
    Icons.expand_more,
    color: Colors.black,
    ),
    ],
    ),
      const SizedBox(height: 10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(
                Icons.chat_bubble_outline,
                size: 18.0,
                color: Colors.grey,
              ),
              SizedBox(width: 5.0),
              Text(
                '10',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(
                Icons.favorite_border,
                size: 18.0,
                color: Colors.grey,
              ),
              SizedBox(width: 5.0),
              Text(
                '30',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(
                Icons.share,
                size: 18.0,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    ],
    ),
    );
    },
    ),
    ),
    ],
    ),
    );
  }
}
