import 'dart:async';

import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/resources/constants.dart';
import 'package:air_quality_app/resources/icons_rsc.dart';
import 'package:air_quality_app/services/geolocation.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                  _buildCurrentDataWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
      ),
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

  Widget _buildCurrentDataWidget() {
    return FutureBuilder<AirVisualData>(
        future: airVisualData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShortWeatherStatusWidget(snapshot),
                    _buildShortPollutionStatusWidget(snapshot),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.data.data.current.weather.temprature}",
                            style: TextStyle(color: Colors.white, fontSize: 56),
                          ),
                          Text(
                            "°C",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                  decoration: AppDecorations.blurRoundBox(),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(top: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.data.data.current.pollution.aqiUS}",
                            style: TextStyle(color: Colors.white, fontSize: 56),
                          ),
                          Text(
                            "aqi",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                  decoration: AppDecorations.blurRoundBox(),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator(
              backgroundColor: Colors.white,
            );
          }
        });
  }

  Expanded _buildShortPollutionStatusWidget(
      AsyncSnapshot<AirVisualData> snapshot) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                "${airQualityFromAqi(snapshot.data.data.current.pollution.aqiUS)}",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  pollutionIconPathFromAqi(
                      snapshot.data.data.current.pollution.aqiUS),
                  color: Colors.white,
                  width: 45,
                  height: 45,
                ),
              ),
            ],
          ),
        ),
        decoration: AppDecorations.blurRoundBox(),
      ),
    );
  }

  Expanded _buildShortWeatherStatusWidget(
      AsyncSnapshot<AirVisualData> snapshot) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                "Clear Sky",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  weatherIconPathFromWeatherCode(
                      snapshot.data.data.current.weather.weatherStatusCode),
                  color: Colors.white,
                  width: 48,
                  height: 48,
                ),
              ),
            ],
          ),
        ),
        decoration: AppDecorations.blurRoundBox(),
      ),
    );
  }
}
