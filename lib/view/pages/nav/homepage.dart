import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readify/models/bookmodel.dart';
import 'package:readify/services/searchBooks.dart';
import 'package:readify/view/pages/nav/whoreading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../services/getBooks.dart';
import 'bookComments.dart';


class BookCard extends StatefulWidget {
  final String title;
  final String id;
  final String author;
  final String imageURL;

  BookCard(
      {required this.title,
      required this.id,
      required this.author,
      required this.imageURL});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  List favBooks = [];
  List readedBooks = [];
  List readingBooks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //burada bu kitabın kullanıcının favori ve okunmuş kitap olarak işaretlenip işaretlenmediğinin verisini çeken kod
    DocumentReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    reference.snapshots().listen((querySnapshot) {
      if (mounted) {
        setState(() {
          favBooks = querySnapshot.get("favBooks");
          readedBooks = querySnapshot.get("readedBooks");
          readingBooks = querySnapshot.get("readingBooks");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.30,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 125,
                  child: widget.imageURL.isEmpty
                      ? Icon(Icons.image)
                      : Image.network(
                          widget.imageURL,
                          fit: BoxFit.fill,
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        '${AppLocalizations.of(context)!.author}: ${widget.author}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: readingBooks.contains(widget.id) == true
                            ? Icon(
                                Icons.edit,
                                color: Colors.green,
                              )
                            : Icon(Icons.edit),
                        onPressed: () {
                          // okunmuş kitap butonuna basıldığında yapılacak işlemler
                          // okunmuş kitap ise  basıldığında okunmuş kitapdan kaldıracak değilse okunmuşa ekleyecek
                          if (readingBooks.contains(widget.id) == true) {
                            List newreadingBooks = readingBooks;

                            newreadingBooks.remove(widget.id);

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'readingBooks': newreadingBooks});
                          } else {
                            List newreadingBooks = readingBooks;

                            newreadingBooks.add(widget.id);

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'readingBooks': newreadingBooks});
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: readedBooks.contains(widget.id) == true
                            ? Icon(
                                Icons.bookmarks,
                                color: Colors.blue,
                              )
                            : Icon(Icons.bookmarks_outlined),
                        onPressed: () {
                          // Favori butonuna basıldığında yapılacak işlemler
                          // favori kitap ise  basıldığında favoriden kaldıracak değilse favoriye ekleyecek
                          if (readedBooks.contains(widget.id) == true) {
                            List newreadedBooks = readedBooks;

                            newreadedBooks.remove(widget.id);

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'readedBooks': newreadedBooks});
                          } else {
                            List newreadedBooks = readedBooks;

                            newreadedBooks.add(widget.id);

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'readedBooks': newreadedBooks});
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: favBooks.contains(widget.id) == true
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(Icons.favorite_border),
                        onPressed: () {
                          // okunmuş kitap butonuna basıldığında yapılacak işlemler
                          // okunmuş kitap ise  basıldığında okunmuş kitapdan kaldıracak değilse okunmuşa ekleyecek
                          if (favBooks.contains(widget.id) == true) {
                            List newBooks = favBooks;

                            newBooks.remove(widget.id);

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'favBooks': newBooks});
                          } else {
                            List newBooks = favBooks;

                            newBooks.add(widget.id);

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'favBooks': newBooks});
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          // Yorum yap butonuna basıldığında yapılacak işlemler
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookReviewPage(
                                      author: widget.author,
                                      id: widget.id,
                                      imageURL: widget.imageURL,
                                      title: widget.title)));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            if (readingBooks.contains(widget.id) == true)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WhoReading(
                              author: widget.author,
                              id: widget.id,
                              imageURL: widget.imageURL,
                              title: widget.title)));
                },
                child: CircleAvatar(
                  child: Icon(
                    Icons.group,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//kitap listeleme ekranı
class BookListingHomePage extends StatefulWidget {
  @override
  State<BookListingHomePage> createState() => _BookListingHomePageState();
}

class _BookListingHomePageState extends State<BookListingHomePage> {
  bool isSearching = false;
  Map<String, dynamic> data = {};
  bool firstLoad = true;
  bool errorNewsGet = false;
  bool loading = true;
  List card = [];
  //bu fonksion sayfa ilk açıldığında çalışır kitapları çeker verileri belirli değişkenlere tanır
  getValue() async {
    try {
      await getBooks().then((value) {
        print('bitti');
        if (mounted) {
          setState(() {
            data = value;
            for (var i = 0; i < data['items'].length; i++) {
              var author = data['items'][i]['volumeInfo']['authors'] == null
                  ? "Unkown"
                  : data['items'][i]['volumeInfo']['authors'][0].toString();
              var imageURL = data['items'][i]['volumeInfo']['imageLinks'] ==
                      null
                  ? ""
                  : data['items'][i]['volumeInfo']['imageLinks']['thumbnail']
                      .toString();

              card.add(BookCard(
                id: data['items'][i]['id'],
                title: data['items'][i]['volumeInfo']['title'],
                author: author.toString(),
                imageURL: imageURL,
              ));
            }

            firstLoad = true;
            loading = false;
          });
        }
      });
    } catch (e) {
      print('error: $e');
      if (mounted) {
        setState(() {
          firstLoad = false;
          errorNewsGet = true;
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getValue();
  }

  TextEditingController searchBook = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching == true
            ? TextField(
                controller: searchBook,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        setState(() {
                          card.clear();
                          data.clear();
                          firstLoad = false;
                          errorNewsGet = false;
                          loading = true;
                        });
                        try {
                          await searchBooks(searchWord: searchBook.text)
                              .then((value) {
                            print('bitti');
                            if (mounted) {
                              setState(() {
                                data = value;
                                for (var i = 0; i < data['items'].length; i++) {
                                  var author = data['items'][i]['volumeInfo']
                                              ['authors'] ==
                                          null
                                      ? "Unkown"
                                      : data['items'][i]['volumeInfo']
                                              ['authors'][0]
                                          .toString();
                                  var imageURL = data['items'][i]['volumeInfo']
                                              ['imageLinks'] ==
                                          null
                                      ? ""
                                      : data['items'][i]['volumeInfo']
                                              ['imageLinks']['thumbnail']
                                          .toString();

                                  card.add(BookCard(
                                    id: data['items'][i]['id'],
                                    title: data['items'][i]['volumeInfo']
                                        ['title'],
                                    author: author.toString(),
                                    imageURL: imageURL,
                                  ));
                                }

                                firstLoad = true;
                                loading = false;
                              });
                            }
                          });
                        } catch (e) {
                          print('error: $e');
                          if (mounted) {
                            setState(() {
                              firstLoad = false;
                              errorNewsGet = true;
                              loading = false;
                            });
                          }
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      )),
                  hintText: AppLocalizations.of(context)!.search_book,
                  border: InputBorder.none,
                ),
              )
            : Text(AppLocalizations.of(context)!.books),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (isSearching == true) {
                    print('1');
                    card.clear();
                    data.clear();
                    firstLoad = false;
                    errorNewsGet = false;
                    loading = true;
                    isSearching = false;
                    getValue();
                  } else {
                    print('2');

                    data.clear();
                    card.clear();
                    firstLoad = true;
                    errorNewsGet = false;
                    loading = true;

                    isSearching = true;
                  }
                });
              },
              icon: Icon(isSearching != true ? Icons.search : Icons.close))
        ],
      ),
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : errorNewsGet == true
              ? Center(
                  child: Text(AppLocalizations.of(context)!.haveaproblem),
                )
              : ListView(
                  children: [
                    Wrap(children: [
                      ...card,
                    ]),
                  ],
                ),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String imageUrl;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
  });
}
