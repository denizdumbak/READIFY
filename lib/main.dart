import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readify/providers/locale_providers.dart';
import 'package:readify/view/auth/login.dart';
import 'package:readify/view/pages/pageNavigationBottom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart';
import 'package:devicelocale/devicelocale.dart';

bool isOpenApp = false;
String currentLocale = "";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await localeGet();
  runApp(MyApp());
}

localeGet() async {
  await Devicelocale.currentLocale.then((value) async {
    print(value);
    currentLocale = value![0] + value[1];

    debugPrint("locale is got: " + currentLocale);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localeGet();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          var provider = Provider.of<LocaleProvider>(
            context,
          );

          if (isOpenApp == false) {
            if (L10n.all.contains(Locale(currentLocale)) == true) {
              provider.setLocale(Locale(currentLocale));

              isOpenApp = true;
            } else {
              provider.setLocale(Locale("en"));

              isOpenApp = true;
            }
          }

          return MaterialApp(
            supportedLocales: L10n.all,
            locale: provider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            title: "Readify",
            //burada daha önce girilmiş hesap var mı yokmu kontrolunu yapıyor
            home: FirebaseAuth.instance.currentUser == null
                ? LoginPage()
                : PageNavigationBottom(),
          );
        });
  }
}
