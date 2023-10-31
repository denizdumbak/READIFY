import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readify/services/getBookInfo.dart';
import 'package:readify/view/pages/nav/lookProfile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookReviewPage extends StatefulWidget {
  String id;
  String imageURL;
  String title;
  String author;

  BookReviewPage(
      {required this.author,
      required this.id,
      required this.imageURL,
      required this.title});

  @override
  _BookReviewPageState createState() => _BookReviewPageState();
}

class _BookReviewPageState extends State<BookReviewPage> {
  TextEditingController comment = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.book_reviews),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.imageURL.isNotEmpty
                            ? Image.network(
                                widget.imageURL,
                                height: 100.0,
                              )
                            : Text(""),
                        SizedBox(height: 16.0),
                        Text(
                          widget.title,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          widget.author,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        GetBookComments(bookid: widget.id),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: comment,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.comment,
                    ),
                    onChanged: (value) {
                      // Yorumu almak için değeri güncelle
                    },
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Yorumu göndermek için işlemleri gerçekleştir

                      if (comment.text.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection("booksComments")
                            .doc(widget.id)
                            .collection('comments')
                            .add({
                          'likedUsers': [],
                          'senderComment': comment.text,
                          'senderName':
                              FirebaseAuth.instance.currentUser!.displayName,
                          'senderid': FirebaseAuth.instance.currentUser!.uid,
                          'time': DateTime.now()
                        }).then((value) {
                          setState(() {
                            comment.text = "";
                          });
                        });
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.send_comment),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//bu widget açılan kitabın yorumlarını çekip listeleyip ekrana yansıtıyor
class GetBookComments extends StatefulWidget {
  String bookid;
  GetBookComments({required this.bookid});
  @override
  _GetBookCommentsState createState() => _GetBookCommentsState();
}

class _GetBookCommentsState extends State<GetBookComments> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('booksComments')
        .doc(widget.bookid)
        .collection('comments')
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

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            Timestamp millis = data['time'];
            var dt = DateTime.fromMillisecondsSinceEpoch(
                millis.millisecondsSinceEpoch);
            var d24 =
                DateFormat('dd/MM/yyyy, HH:mm').format(dt); // 31/12/2000, 22:00
            return GestureDetector(
              onTap: () {
                if (FirebaseAuth.instance.currentUser!.uid !=
                    data['senderid']) {
                  print('profil');
                  print(data['senderid']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LookProfile(profileID: data['senderid'])));
                }
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['senderName'],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: FirebaseAuth.instance.currentUser!.uid ==
                                        data['senderid']
                                    ? Colors.green
                                    : Colors.black),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: data['likedUsers'].contains(FirebaseAuth
                                            .instance.currentUser!.uid) ==
                                        true
                                    ? Icon(
                                        Icons.thumb_up,
                                        color: Colors.blue,
                                      )
                                    : Icon(
                                        Icons.thumb_up_alt_outlined,
                                      ),
                                onPressed: () {
                                  print('book book : ${widget.bookid}');
                                  print('comment id : ${document.id}');
                                  List likedUsers = data['likedUsers'];
                                  if (likedUsers.contains(FirebaseAuth
                                          .instance.currentUser!.uid) ==
                                      true) {
                                    List newlikedUsers = likedUsers;

                                    newlikedUsers.remove(
                                        FirebaseAuth.instance.currentUser!.uid);

                                    FirebaseFirestore.instance
                                        .collection('booksComments')
                                        .doc(widget.bookid)
                                        .collection('comments')
                                        .doc(document.id)
                                        .update({'likedUsers': newlikedUsers});
                                  } else {
                                    List newlikedUsers = likedUsers;

                                    newlikedUsers.add(
                                        FirebaseAuth.instance.currentUser!.uid);
                                    FirebaseFirestore.instance
                                        .collection('booksComments')
                                        .doc(widget.bookid)
                                        .collection('comments')
                                        .doc(document.id)
                                        .update({'likedUsers': newlikedUsers});
                                  }
                                },
                              ),
                              Text(
                                data['likedUsers'].length.toString(),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        data['senderComment'],
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        d24,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
