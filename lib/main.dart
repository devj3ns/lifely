import 'package:Lifely/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';
import 'data/dataHelper.dart';
import 'tabBar.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => new DataHelper(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Lifely',
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Nunito",
      ),
      home: FutureBuilder(
        future: Provider.of<DataHelper>(context, listen: false).loadData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? snapshot.data == "" ? Welcome() : MyTabBar()
              : Scaffold(
                  backgroundColor: Colors.white,
                  /* würde man eh nur paar Millisekunden sehen
                  body: Center(
                    child: SpinKitRipple(
                      color: Color(0xff382350).withOpacity(0.5),
                      size: 90.0,
                    ),
                  ),*/
                );
        },
      ),
    );
  }
}
