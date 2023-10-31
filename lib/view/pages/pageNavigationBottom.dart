import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'nav/homepage.dart';

import 'nav/messages.dart';
import 'nav/profile.dart';
import 'nav/searchFriends.dart';
import 'nav/settings.dart';


class PageNavigationBottom extends StatefulWidget {
  const PageNavigationBottom({super.key});

  @override
  State<PageNavigationBottom> createState() => _PageNavigationBottomState();
}

class _PageNavigationBottomState extends State<PageNavigationBottom> {
  int pagenum = 0;
  List screen = [
    BookListingHomePage(),
    SearchScreen(),
    MessageScreen(),
    ProfileScreen(),
    SettingScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[pagenum],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pagenum,
        onTap: (i) {
          setState(() {
            pagenum = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context)!.home),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: AppLocalizations.of(context)!.new_friends),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: AppLocalizations.of(context)!.chat),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: AppLocalizations.of(context)!.profile),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings),
        ],
      ),
    );
  }
}
