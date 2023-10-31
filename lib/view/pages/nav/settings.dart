import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../providers/locale_providers.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              if (AppLocalizations.of(context)!.language != 'English') {
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(Locale('en'));
              } else {
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(Locale('tr'));
              }
            },
            title: Text(AppLocalizations.of(context)!.lang),
            subtitle: Text(AppLocalizations.of(context)!.language),
          )
        ],
      ),
    );
  }
}
