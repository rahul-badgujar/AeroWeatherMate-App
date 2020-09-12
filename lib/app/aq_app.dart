import 'package:air_quality_app/app/pages/home_screen.dart';
import 'package:air_quality_app/app/pages/manage_cities_screen.dart';
import 'package:air_quality_app/ui/themes.dart';
import 'package:flutter/material.dart';

class AqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Air Quality App",
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: ManageCitiesScreen(),
    );
  }
}

/// TODO
/// 1. Add Cities Show to Manage Cities Page
/// 2. Add Location Service in Manage Cities Page
/// 3. Add City Labels in Manage Cities Page
///
