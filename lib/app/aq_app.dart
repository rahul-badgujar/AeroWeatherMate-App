import 'package:flutter/material.dart';
import 'package:air_quality_app/app/pages/main_page.dart';

class AqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Air Quality App",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
