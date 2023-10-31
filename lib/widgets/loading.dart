import 'package:flutter/material.dart';

loadingWidget(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      });
}
