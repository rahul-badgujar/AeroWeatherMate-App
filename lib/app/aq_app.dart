import 'package:flutter/material.dart';
import 'package:air_quality_app/app/pages/main_page.dart';
import 'package:air_quality_app/resources/constants.dart';

class AqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Air Quality App",
      theme: ThemeData(
        backgroundColor: Colors.white,
        primaryColor: Colors.white,
        accentColor: Colors.grey,
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontSize: 150,
          ),
          headline4: TextStyle(
            color: Colors.white,
          ),
          headline2: TextStyle(
            color: Colors.white,
          ),
          headline3: TextStyle(
            color: Colors.white,
          ),
          headline5: TextStyle(
            color: Colors.white,
          ),
          headline6: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: MainPage(appTitle: Strings.appName),
    );
  }
}
