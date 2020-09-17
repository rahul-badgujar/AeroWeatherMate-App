import 'package:air_quality_app/app/pages/home_screen.dart';
import 'package:air_quality_app/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:air_quality_app/resources/constants.dart' show Strings;
import 'package:flutter/services.dart';

// App Stateless Widget
class AeroWeatherMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Restricting Device Orientation to Portrait Up only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Material App Instance
    return MaterialApp(
      title: Strings.appName, // Title of App
      debugShowCheckedModeBanner: false, // to remove Debug Banner from Device
      theme: getAppTheme(Theme.of(context)), // Application wide Theme
      home: HomeScreen(), // The start page of App
    );
  }
}

/// TODO
///
