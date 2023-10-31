import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readify/view/pages/nav/lookProfile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  String userPicker = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.new_friends),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  userPicker = value;
                });
              },
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.username} & ${AppLocalizations.of(context)!.email}',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text(AppLocalizations.of(context)!.haveaproblem);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Container(
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        String name = data['name'].toString();
                        String email = data['email'].toString();
                        List followers = data['followers'];

                        if (userPicker.isEmpty) {
                          if (FirebaseAuth.instance.currentUser!.uid !=
                              document.id) {
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
                                  print("sa");
                                  setState(() {
                                    myFollowed = value['followed'];
                                  });
                                });
                                if (followers.contains(FirebaseAuth
                                        .instance.currentUser!.uid) ==
                                    true) {
                                  List newFollowers = followers;

                                  newFollowers.remove(
                                      FirebaseAuth.instance.currentUser!.uid);
                                  myFollowed.remove(document.id);
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
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

                                  newFollowers.add(
                                      FirebaseAuth.instance.currentUser!.uid);
                                  myFollowed.add(document.id);
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
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
                          }
                        }

                        if (name.contains(userPicker.toString()) ||
                            email.contains(userPicker.toString())) {
                          if (FirebaseAuth.instance.currentUser!.uid !=
                              document.id) {
                            return UserCard(
                              profileID: document.id,
                              name: name,
                              email: email,
                              followers: followers,
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
                                if (followers.contains(FirebaseAuth
                                        .instance.currentUser!.uid) ==
                                    true) {
                                  List newFollowers = followers;

                                  newFollowers.remove(
                                      FirebaseAuth.instance.currentUser!.uid);
                                  myFollowed.remove(document.id);
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
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

                                  newFollowers.add(
                                      FirebaseAuth.instance.currentUser!.uid);
                                  myFollowed.add(document.id);
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
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
                          }
                        }

                        return SizedBox(
                          height: 0,
                        );
                      }).toList(),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String profileID;
  final List followers;
  final VoidCallback onPressed;

  UserCard({
    required this.name,
    required this.profileID,
    required this.email,
    required this.onPressed,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LookProfile(profileID: profileID)));
      },
      child: Card(
        child: ListTile(
          title: Text(
            name,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            email,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          trailing: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
            ),
            child: Text(
              followers.contains(FirebaseAuth.instance.currentUser!.uid) == true
                  ? AppLocalizations.of(context)!.unfollow
                  : AppLocalizations.of(context)!.follow,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
