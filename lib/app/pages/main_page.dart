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
import 'package:air_quality_app/resources/gradients_rsc.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  LocationData currentLiveLocation;
  Future<AirVisualData> airVisualData;
  Drawer appDrawer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
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
      key: _scaffoldKey,
      drawer: _buildAppDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: AppDecorations.gradientBox(
                gradientTOFill: AppGradients.defaultGradient),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCustomAppBar(),
                  _buildPageContent(),
                  _buildSourceCreditWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildAppDrawer() {
    appDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(""),
            decoration: AppDecorations.gradientBox(
                gradientTOFill: AppGradients.defaultGradient),
          )
        ],
      ),
    );
    return appDrawer;
  }

  Expanded _buildPageContent() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _onRefreshRequested,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            child: _buildCurrentDataWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceCreditWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(
          "source ",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          "AirVisual",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
              FutureBuilder<AirVisualData>(
                future: airVisualData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RichText(
                      text: TextSpan(
                          text: snapshot.data.data.city,
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text:
                                  "   ${snapshot.data.data.state}, ${snapshot.data.data.country}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ]),
                    );
                  } else {
                    return Text(
                      "Loading...",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onRefreshRequested() async {
    print("Refresh Requested");
    setState(() {
      _doRefreshData();
    });
  }

  void _doRefreshData() async {
    currentLiveLocation = await GeolocationService.getCurrentLocation();
    airVisualData = HttpClient().fetchAirVisualData(currentLiveLocation);
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
                _buildFullWeatherStatusWidget(snapshot),
                _buildFullPollutionStatusWidget(snapshot),
              ],
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            );
          }
        });
  }

  Container _buildFullPollutionStatusWidget(
      AsyncSnapshot<AirVisualData> snapshot) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${snapshot.data.data.current.pollution.aqiUS}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "aqi",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "US AQI:\n" +
                      "US Pollutant:\n" +
                      "CN AQI:\n" +
                      "CN Pollutant:",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  "${snapshot.data.data.current.pollution.aqiUS}\n" +
                      "${pollutantFromCode(snapshot.data.data.current.pollution.mainPollutantUS)}\n" +
                      "${snapshot.data.data.current.pollution.aqiCN}\n" +
                      "${pollutantFromCode(snapshot.data.data.current.pollution.mainPollutantCN)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          _buildTimeStampWidget(snapshot.data.data.current.pollution.timeStamp),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  Container _buildFullWeatherStatusWidget(
      AsyncSnapshot<AirVisualData> snapshot) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${snapshot.data.data.current.weather.temprature}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "°C",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Atm Pressure:\n" +
                      "Humidity:\n" +
                      "Wind Speed:\n" +
                      "Wind Direction:",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  "${snapshot.data.data.current.weather.pressure} hPa\n" +
                      "${snapshot.data.data.current.weather.humidity} %\n" +
                      "${snapshot.data.data.current.weather.windSpeed} m/s\n" +
                      "${windDirectionFromAngle(snapshot.data.data.current.weather.windDirection)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          _buildTimeStampWidget(snapshot.data.data.current.weather.timeStamp),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
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
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  pollutionIconPathFromAqi(
                      snapshot.data.data.current.pollution.aqiUS),
                  color: Colors.white,
                  width: 56,
                  height: 56,
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
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  weatherIconPathFromWeatherCode(
                      snapshot.data.data.current.weather.weatherStatusCode),
                  color: Colors.white,
                  width: 60,
                  height: 60,
                ),
              ),
            ],
          ),
        ),
        decoration: AppDecorations.blurRoundBox(),
      ),
    );
  }

  Widget _buildTimeStampWidget(String timeStamp) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Text(
        "Last Updated : " + updateStatusFromTimeStamp(timeStamp),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
