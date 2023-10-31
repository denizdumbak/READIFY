import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readify/services/getBookInfo.dart';
import 'package:readify/view/pages/nav/lookProfile.dart';
import 'package:readify/view/pages/nav/searchFriends.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WhoReading extends StatefulWidget {
  String id;
  String imageURL;
  String title;
  String author;

  WhoReading(
      {required this.author,
      required this.id,
      required this.imageURL,
      required this.title});

  @override
  _WhoReadingState createState() => _WhoReadingState();
}

class _WhoReadingState extends State<WhoReading> {
  TextEditingController comment = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List followersData = [];
  List followedData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DocumentReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    reference.snapshots().listen((querySnapshot) {
      if (mounted) {
        setState(() {
          followersData = querySnapshot.get("followers");

          followedData = querySnapshot.get("followed");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.who_reading),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
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
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: TabBar(tabs: [
                              Tab(
                                child: Text(
                                  AppLocalizations.of(context)!.follower,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  AppLocalizations.of(context)!.followed,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            //Add this to give height
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(children: [
                              GetFollowers(
                                listData: followersData,
                                bookid: widget.id,
                              ),
                              GetFollowers(
                                listData: followedData,
                                bookid: widget.id,
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GetFollowers extends StatefulWidget {
  List listData;
  String bookid;
  GetFollowers({super.key, required this.listData, required this.bookid});

  @override
  State<GetFollowers> createState() => _GetFollowersState();
}

class _GetFollowersState extends State<GetFollowers> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
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
            String name = data['name'].toString();
            String email = data['email'].toString();
            List followers = data['followers'];
            if (FirebaseAuth.instance.currentUser!.uid != document.id) {
              if (widget.listData.contains(document.id) == true) {
                List readingBooks = data['readingBooks'];
                if (readingBooks.contains(widget.bookid) == true) {
                  return UserCard(
                    name: name,
                    email: email,
                    profileID: document.id,
                    followers: followers,
                    onPressed: () async {
                      List myFollowed = [];
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((value) {
                        setState(() {
                          myFollowed = value['followed'];
                        });
                      });
                      if (followers.contains(
                              FirebaseAuth.instance.currentUser!.uid) ==
                          true) {
                        List newFollowers = followers;

                        newFollowers
                            .remove(FirebaseAuth.instance.currentUser!.uid);
                        myFollowed.remove(document.id);
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'followed': myFollowed});
                        setState(() {});

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(document.id)
                            .update({'followers': followers});
                        setState(() {});
                        print('takipten cıkıldı');
                      } else {
                        List newFollowers = followers;

                        newFollowers
                            .add(FirebaseAuth.instance.currentUser!.uid);
                        myFollowed.add(document.id);
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'followed': myFollowed});
                        setState(() {});

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(document.id)
                            .update({'followers': followers});

                        setState(() {});
                        print('takip edildi');
                      }
                    },
                  );
                } else {
                  return SizedBox();
                }
              } else {
                return SizedBox();
              }
            } else {
              return SizedBox();
            }
          }).toList(),
        );
      },
    );
  }
}
