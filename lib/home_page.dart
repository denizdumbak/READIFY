import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'message_page.dart';
import 'notification_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PostListWidget(),
    const NotificationPage(),
    const ProfilePage(),
    const MessagePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, color: Colors.black,),
            Text(
                'Readify',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
            color: Colors.black,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Page'),
    );
  }
}

class Post {
  final String username;
  final String text;
  int likes;
  int comments;
  int shares;

  Post({
    required this.username,
    required this.text,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });
}

class PostListWidget extends StatefulWidget {
  const PostListWidget({Key? key}) : super(key: key);

  @override
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  final List<Post> _posts = [
    Post(
      username: 'user1',
      text: 'Lorem ipsum dolor sit amet',
      likes: 10,
      comments: 2,
      shares: 1,
    ),
    Post(
      username: 'user2',
      text: 'consectetur adipiscing elit',
      likes: 5,
      comments: 3,
      shares: 0,
    ),
    Post(
      username: 'user3',
      text: 'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
      likes: 3,
      comments: 1,
      shares: 2,
    ),
  ];

  void _likePost(int index) {
    setState(() {
      _posts[index].likes++;
    });
  }

  void _commentOnPost(int index) {
    setState(() {
      _posts[index].comments++;
    });
  }

  void _sharePost(int index) {
    setState(() {
      _posts[index].shares++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (BuildContext context, int index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(post.text),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _likePost(index),
                          icon: const Icon(Icons.thumb_up),
                        ),
                        Text('${post.likes}'),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () => _commentOnPost(index),
                          icon: const Icon(Icons.comment),
                        ),
                        Text('${post.comments}'),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () => _sharePost(index),
                          icon: const Icon(Icons.share),
                        ),
                        Text('${post.shares}'),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

