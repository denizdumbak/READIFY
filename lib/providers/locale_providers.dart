import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale("en");

  Locale get locale => _locale;
  void setLocale(Locale locale) async {
    await Future.delayed(Duration(milliseconds: 1));
    _locale = locale;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 1));
  }

  void clearcLocale() async {
    await Future.delayed(Duration(milliseconds: 1));
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 1));
  }
}
