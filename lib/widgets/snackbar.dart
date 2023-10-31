import 'package:flutter/material.dart';


showSnackBar(context, {required String text, required Color color}) {
  var snackBar = SnackBar(
    content: Text(text),
    backgroundColor: color,
  );

  ScaffoldMessenger.of(context).showSnackBar(
    snackBar,
  );
}
