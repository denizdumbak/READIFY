import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readify/view/pages/pageNavigationBottom.dart';
import '../widgets/loading.dart';
import '../widgets/snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


registerControl(context,
    {required String name,
    required String email,
    required String password}) async {
  loadingWidget(context);
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .set({
        'name': name,
        'email': email,
        'favBooks': [],
        'readedBooks': [],
        'readingBooks': [],
        'followed': [],
        'followers': [],
      }).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PageNavigationBottom()),
            (route) => false);
      });
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      Navigator.pop(context);
      showSnackBar(context,
          text: AppLocalizations.of(context)!.weekpassword, color: Colors.red);
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      Navigator.pop(context);
      showSnackBar(context,
          text: AppLocalizations.of(context)!.emailalready, color: Colors.red);
    } else {
      Navigator.pop(context);
      showSnackBar(context,
          text: AppLocalizations.of(context)!.haveaproblem, color: Colors.red);
    }
  }
}
