import 'package:air_quality_app/app/pages/add_city_screen.dart';
import 'package:flutter/material.dart';
import 'package:air_quality_app/app/pages/home_screen.dart';

class AqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Air Quality App",
      debugShowCheckedModeBanner: false,
      home: AddCityScreen(),
    );
  }
}
