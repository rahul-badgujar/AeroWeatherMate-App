import 'dart:async';

import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/services/geolocation.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:progress_indicators/progress_indicators.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  LocationData currentLiveLocation;
  Future<AirVisualData> airVisualData;
  bool isStateCountryVisible;
  @override
  void initState() {
    super.initState();
    isStateCountryVisible = false;
    GeolocationService.getCurrentLocation().then((location) {
      setState(() {
        currentLiveLocation = location;
        airVisualData = HttpClient().fetchAirVisualData(currentLiveLocation);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: AppDecorations.gradientBox(),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCustomAppBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () => _onRefreshButtonClicked(),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() {
                    isStateCountryVisible = !isStateCountryVisible;
                  }),
                  child: FutureBuilder<AirVisualData>(
                    future: airVisualData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          "${snapshot.data.data.city}",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return JumpingDotsProgressIndicator(
                          color: Colors.white,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        Visibility(
          visible: isStateCountryVisible,
          child: FutureBuilder<AirVisualData>(
            future: airVisualData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  "${snapshot.data.data.state}, ${snapshot.data.data.country}",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                );
              } else {
                return JumpingDotsProgressIndicator(
                  color: Colors.white,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  void _onRefreshButtonClicked() {
    GeolocationService.getCurrentLocation().then((location) {
      setState(() {
        currentLiveLocation = location;
        airVisualData = HttpClient().fetchAirVisualData(currentLiveLocation);
      });
    });
  }
}
