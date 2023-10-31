import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readify/view/pages/pageNavigationBottom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/loading.dart';
import '../widgets/snackbar.dart';


loginControl(context, {required String email, required String password}) async {
  loadingWidget(context);
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PageNavigationBottom()),
          (route) => false);
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      Navigator.pop(context);
      showSnackBar(context,
          text: AppLocalizations.of(context)!.usernotfound, color: Colors.red);
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      Navigator.pop(context);
      showSnackBar(context,
          text: AppLocalizations.of(context)!.wrongpassword, color: Colors.red);
    } else {
      Navigator.pop(context);
      showSnackBar(context,
          text: AppLocalizations.of(context)!.haveaproblem, color: Colors.red);
    }
  }
}
