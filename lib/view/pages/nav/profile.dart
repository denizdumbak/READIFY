import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readify/services/getBookInfo.dart';
import 'package:readify/view/auth/login.dart';
import 'package:readify/view/pages/nav/homepage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var followers = "-";
  var followed = "-";
  List favBooks = [];
  List readedBooks = [];
  List readingBooks = [];
  List<Widget> card = [];
  List<Widget> readedcard = [];
  List<Widget> readingcard = [];
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
          List followersData = querySnapshot.get("followers");
          followers = followersData.length.toString();
          List followedData = querySnapshot.get("followed");
          favBooks = querySnapshot.get("favBooks");
          readedBooks = querySnapshot.get("readBooks");
          readingBooks = querySnapshot.get("readingBooks");
          followed = followedData.length.toString();
          card.clear();
          readedcard.clear();
          readingcard.clear();
          favBooks.forEach((id) {
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
                        : data['volumeInfo']['imageLinks']['thumbnail']
                            .toString();

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

          readedBooks.forEach((id) {
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
                        : data['volumeInfo']['imageLinks']['thumbnail']
                            .toString();

                    readedcard.add(BookCard(
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
          readingBooks.forEach((id) {
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
                        : data['volumeInfo']['imageLinks']['thumbnail']
                            .toString();

                    readingcard.add(BookCard(
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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.0),
          SizedBox(height: 10.0),
          Text(
            FirebaseAuth.instance.currentUser!.displayName.toString(),
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.  grey,
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
                    followers,
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
                    followed,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
                              " (${favBooks.length})",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppLocalizations.of(context)!.readed_books +
                              " (${readedBooks.length})",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppLocalizations.of(context)!.reading_books +
                              " (${readingBooks.length})",
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
                              Wrap(children: [...card]),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Wrap(children: [...readedcard]),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Wrap(children: [...readingcard]),
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
      ),
    );
  }
}
