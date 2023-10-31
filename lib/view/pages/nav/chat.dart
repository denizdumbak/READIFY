import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:readify/widgets/snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isSender;

  MessageBubble(
      {required this.message, required this.time, required this.isSender});

  @override
  Widget build(BuildContext context) {
    final bubbleAlignment =
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isSender ? Colors.blue : Colors.grey.shade200;
    final textColor = isSender ? Colors.white : Colors.black;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: bubbleAlignment,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 16.0, color: textColor),
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  time,
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
        ],
      ),
    );
  }
}

//burası chat ekranı burada yazışmalar ekrana yansıtılır ve mesaj gönderilir

class ChatScreen extends StatefulWidget {
  String userName;
  String roomID;
  ChatScreen({super.key, required this.roomID, required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GetChats(
                roomID: widget.roomID,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: message,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.message,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    //bu kod mesaj alanı boş değil ise gönder butouna basıldığında çalışır kullanıcının mesajını gönderir
                    if (message.text.isNotEmpty) {
                      DateTime time = await NTP.now();

                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(widget.roomID)
                          .collection('chat')
                          .add({
                        'senderID': FirebaseAuth.instance.currentUser!.uid,
                        'senderMsg': message.text,
                        'time': time
                      });
                      setState(() {
                        message.text = '';
                      });
                    }
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//burası mesajların çekilip ekrana sohbet baloncuklarının oluşturulduğu yer
class GetChats extends StatefulWidget {
  String roomID;
  GetChats({required this.roomID});
  @override
  _GetChatsState createState() => _GetChatsState();
}

class _GetChatsState extends State<GetChats> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.roomID)
        .collection("chat")
        .orderBy('time', descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(AppLocalizations.of(context)!.haveaproblem);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          reverse: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            Timestamp millis = data['time'];
            var dt = DateTime.fromMillisecondsSinceEpoch(
                millis.millisecondsSinceEpoch);

// 24 Hour format:
            var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt);
            return FirebaseAuth.instance.currentUser!.uid == data['senderID']
                ? MessageBubble(
                    message: data['senderMsg'], time: d24, isSender: true)
                : MessageBubble(
                    message: data['senderMsg'], time: d24, isSender: false);
          }).toList(),
        );
      },
    );
  }
}
