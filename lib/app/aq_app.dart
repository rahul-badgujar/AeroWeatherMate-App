import 'package:air_quality_app/app/pages/home_screen.dart';
import 'package:air_quality_app/ui/themes.dart';
import 'package:flutter/material.dart';

class AqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Air Quality App",
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: HomeScreen(),
    );
  }
}
