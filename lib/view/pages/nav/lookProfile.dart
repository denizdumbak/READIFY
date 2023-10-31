import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readify/view/pages/nav/chat.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../services/getBookInfo.dart';
import 'homepage.dart';


class LookProfile extends StatefulWidget {
  String profileID;
  LookProfile({super.key, required this.profileID});

  @override
  State<LookProfile> createState() => _LookProfileState();
}

class _LookProfileState extends State<LookProfile> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.profileID).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(AppLocalizations.of(context)!.haveaproblem));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(
                child: Text(AppLocalizations.of(context)!.haveaproblem));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                SizedBox(height: 10.0),
                Text(
                  data['name'],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  data['email'].toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.follower,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          data['followers'].length.toString(),
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.followed,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          data['followed'].length.toString(),
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          List myFollowed = [];
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get()
                              .then((value) {
                            print("sa");
                            setState(() {
                              myFollowed = value['followed'];
                            });
                          });

                          List followers = data['followers'];
                          if (followers.contains(
                                  FirebaseAuth.instance.currentUser!.uid) ==
                              true) {
                            List newFollowers = followers;

                            newFollowers
                                .remove(FirebaseAuth.instance.currentUser!.uid);
                            myFollowed.remove(widget.profileID);
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'followed': myFollowed});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.profileID)
                                .update({'followers': followers});
                            setState(() {});
                          } else {
                            List newFollowers = followers;

                            newFollowers
                                .add(FirebaseAuth.instance.currentUser!.uid);
                            myFollowed.add(widget.profileID);
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'followed': myFollowed});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.profileID)
                                .update({'followers': followers});
                            setState(() {});
                          }
                        },
                        child: Text(
                          data['followers'].contains(
                                      FirebaseAuth.instance.currentUser!.uid) ==
                                  true
                              ? AppLocalizations.of(context)!.unfollow
                              : AppLocalizations.of(context)!.follow,
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                          bool ishaveChat = false;
                          FirebaseFirestore.instance
                              .collection('chats')
                              .get()
                              .then((QuerySnapshot value) {
                            value.docs.forEach((element) {
                              if ((widget.profileID == element['user1'] ||
                                      widget.profileID == element['user2']) &&
                                  (FirebaseAuth.instance.currentUser!.uid ==
                                          element['user1'] ||
                                      FirebaseAuth.instance.currentUser!.uid ==
                                          element['user2'])) {
                                ishaveChat = true;
                                print('var');
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                            roomID: element.id,
                                            userName: data['name'])));
                              }
                            });

                            if (ishaveChat == false) {
                              FirebaseFirestore.instance
                                  .collection('chats')
                                  .add({
                                'user1': widget.profileID,
                                'user2': FirebaseAuth.instance.currentUser!.uid
                              }).then((value) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                            roomID: value.id,
                                            userName: data['name'])));
                              });
                            }
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!.message,
                        )),
                  ],
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: TabBar(tabs: [
                            Tab(
                              child: Text(
                                AppLocalizations.of(context)!.favorite_books +
                                    " (${data['favBooks'].length})",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                AppLocalizations.of(context)!.readed_books +
                                    " (${data['readedBooks'].length})",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                AppLocalizations.of(context)!.reading_books +
                                    " (${data['readingBooks'].length})",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            //Add this to give height
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    GetProfileFavBooks(
                                        favBooks: data['favBooks'])
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    GetProfileFavBooks(
                                        favBooks: data['readedBooks'])
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    GetProfileFavBooks(
                                        favBooks: data['readingBooks'])
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}


class GetProfileFavBooks extends StatefulWidget {
  List favBooks;
  GetProfileFavBooks({super.key, required this.favBooks});

  @override
  State<GetProfileFavBooks> createState() => _GetProfileFavBooksState();
}

class _GetProfileFavBooksState extends State<GetProfileFavBooks> {
  List card = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    card.clear();
    widget.favBooks.forEach((id) {
      try {
        getBookInfo(id: id).then((data) {
          print('bitti');
          if (mounted) {
            setState(() {
              var author = data['volumeInfo']['authors'] == null
                  ? "Unkown"
                  : data['volumeInfo']['authors'][0].toString();
              var imageURL = data['volumeInfo']['imageLinks'] == null
                  ? ""
                  : data['volumeInfo']['imageLinks']['thumbnail'].toString();

              card.add(BookCard(
                id: data['id'],
                title: data['volumeInfo']['title'],
                author: author.toString(),
                imageURL: imageURL,
              ));
            });
          }
        });
      } catch (e) {
        print('error: $e');
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [...card]);
  }
}
