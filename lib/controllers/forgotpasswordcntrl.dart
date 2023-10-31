import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/loading.dart';
import '../widgets/snackbar.dart';



forgotPasswordControl(context, {required String email}) async {
  loadingWidget(context);
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar(context,
          text: AppLocalizations.of(context)!.forgotemailsend,
          color: Colors.green);
    });
  } catch (e) {
    Navigator.pop(context);
    showSnackBar(context,
        text: AppLocalizations.of(context)!.haveaproblem, color: Colors.red);
  }
}
