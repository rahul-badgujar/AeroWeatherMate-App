import 'dart:async';

import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/resources/gradients_rsc.dart';
import 'package:air_quality_app/resources/icons_rsc.dart';
import 'package:air_quality_app/services/geolocation.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:air_quality_app/resources/constants.dart';
import 'package:location/location.dart';
import 'package:progress_indicators/progress_indicators.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, @required this.appTitle}) : super(key: key);
  final String appTitle;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  LocationData currentLiveLocation;
  Future<AirVisualData> airVisualData;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [],
      ),
    );
  }
}
