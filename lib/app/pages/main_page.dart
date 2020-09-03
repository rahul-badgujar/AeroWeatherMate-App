import 'dart:convert';

import 'package:air_quality_app/api/data/air_quality_data.dart';
import 'package:air_quality_app/api/network/api_urls.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/resources/gradients_rsc.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:air_quality_app/resources/strings_rsc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  MainPage({Key key, @required this.appTitle}) : super(key: key);
  final String appTitle;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Gradient currentAppGradient;
  Position currentLocation;
  AirQualityData airQualityData;
  @override
  void initState() {
    super.initState();
    currentAppGradient = WeatherGradients.defaultGradient;
    currentLocation = null;
    airQualityData = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAppBackground(),
          _buildInfoScene(widget.appTitle),
        ],
      ),
    );
  }

  Widget _buildInfoScene(String cityName) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildTopBar(),
            _updateDataWidget(),
            _buildShortWeatherDetailWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () => _refreshDataForCurrentLocation(),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => _showAddressDialog(),
                child: Text(
                  Strings.defaultCity,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert_sharp,
              color: Colors.white,
            ),
            onPressed: null,
          ),
        ],
      ),
      decoration: BoxDecoration(),
    );
  }

  Widget _buildShortWeatherDetailWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTempWidget(),
          _buildWeatherStatusWidget(),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  Widget _buildTempWidget() {
    return Container(
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              Strings.defaultTemp,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "°" + Strings.defaultTempScale,
              style: Theme.of(context).textTheme.headline6,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeatherStatusWidget() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      child: Text(
        Strings.defaultWeatherStatus,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  /*  Widget _buildAiqWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: AppDecorations.blurRoundBox(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AppIcons.aqiLeaf),
          Text(
            "AIQ " + Strings.defaultAqi,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  } */

  Widget _buildAppBackground() {
    return Container(
      decoration:
          AppDecorations.gradientBox(gradientTOFill: currentAppGradient),
    );
  }

  Future<void> _showAddressDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              "Current Location",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            children: [
              Text(
                "City : ${airQualityData.city}, \n State: ${airQualityData.state}",
                maxLines: 5,
              ),
            ],
            contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            titlePadding: EdgeInsets.all(12),
          );
        });
  }

  Widget _updateDataWidget() {
    return SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 4,
      ),
    );
  }

  void _refreshDataForCurrentLocation() {
    Future<Position> position = getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
    position.then((location) {
      setState(() {
        currentLocation = location;
        Future<AirQualityData> response =
            HttpClient().fetchAirQualityData(currentLocation);
        response.then((data) {
          airQualityData = data;
          print(airQualityData.toString());
        });
      });
    });
  }
}
