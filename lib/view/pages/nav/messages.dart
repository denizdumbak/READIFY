import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readify/view/pages/nav/chat.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.chat),
        ),
        body: GetChatsInfos());
  }
}

class Message {
  final String senderName;
  final String senderImageUrl;
  final String text;

  Message(
      {required this.senderName,
      required this.senderImageUrl,
      required this.text});
}


class GetChatsInfos extends StatefulWidget {
  @override
  _GetChatsInfosState createState() => _GetChatsInfosState();
}

class _GetChatsInfosState extends State<GetChatsInfos> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('chats').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            AppLocalizations.of(context)!.haveaproblem,
            style: TextStyle(color: Colors.white),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            if (FirebaseAuth.instance.currentUser!.uid == data['user1'] ||
                FirebaseAuth.instance.currentUser!.uid == data['user2']) {
              var userID;
              if (FirebaseAuth.instance.currentUser!.uid != data['user1']) {
                userID = data['user1'];
              }
              if (FirebaseAuth.instance.currentUser!.uid != data['user2']) {
                userID = data['user2'];
              }

              return UserCard(
                roomid: document.id,
                userID: userID,
              );
            } else {
              return SizedBox();
            }
          }).toList(),
        );
      },
    );
  }
}

class UserCard extends StatefulWidget {
  String roomid;

  String userID;
  UserCard({
    super.key,
    required this.roomid,
    required this.userID,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  var userName;
  var lastMessage = '';
  var time = '';
  bool load = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CollectionReference<Map<String, dynamic>> reference = FirebaseFirestore
        .instance
        .collection('chats')
        .doc(widget.roomid)
        .collection("chat");
    reference
        .orderBy("time", descending: false)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot != null) {
        if (mounted) {
          setState(() {
            Timestamp millis = querySnapshot.docs.last['time'];
            var dt = DateTime.fromMillisecondsSinceEpoch(
                millis.millisecondsSinceEpoch);

            var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt);

            time = d24;
            if (FirebaseAuth.instance.currentUser!.uid ==
                querySnapshot.docs.last['senderID']) {
              lastMessage = 'You: ${querySnapshot.docs.last['senderMsg']}';
            } else {
              lastMessage = querySnapshot.docs.last['senderMsg'];
            }
          });
        }
      }
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userID)
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          userName = value['name'];
          load = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return load == true
        ? Text("")
        : ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          roomID: widget.roomid, userName: userName)));
            },
            title: Text(userName),
            trailing: Text(time),
            subtitle: Text(lastMessage.toString()),
          );
  }
}
