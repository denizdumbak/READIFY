import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const NotificationList(),
    );
  }
}
class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        NotificationItem(
          avatarUrl: 'https://picsum.photos/50',
          title: 'Gökberk Ömer Çoban',
          subtitle: 'liked your post',
          time: '2m',
        ),
        NotificationItem(
          avatarUrl: 'https://picsum.photos/53',
          title: 'Emre Bekmezci',
          subtitle: 'liked your comment',
          time: '5m',
        ),
        NotificationItem(
          avatarUrl: 'https://picsum.photos/52',
          title: 'Deniz Dumbak',
          subtitle: 'sent you a follow request',
          time: '10m',
        ),
      ],
    );
  }
}
class NotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String title;
  final String subtitle;
  final String time;

  const NotificationItem({
    Key? key,
    required this.avatarUrl,
    required this.title,
    required this.subtitle,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
