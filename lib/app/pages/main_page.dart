import 'dart:async';

import 'package:air_quality_app/api/data/air_quality_data.dart';
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
  Gradient currentAppGradient;
  LocationData currentLiveLocation;
  Future<AirQualityData> airQualityData;
  WeatherEnums weatherEnum;
  Icon weatherStatusIcon;
  @override
  void initState() {
    super.initState();
    _refreshPage();
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
          _buildAppBackground(),
          _buildInfoScene(widget.appTitle),
        ],
      ),
    );
  }

  Widget _buildInfoScene(String cityName) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            _buildTopBar(),
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
            onPressed: () => _refreshPage(),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => _showAddressDialog(),
                child: _buildTopBarCityTitle(),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTempWidget(),
              _buildWeatherStatusIcon(),
            ],
          ),
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
            child: FutureBuilder<AirQualityData>(
              future: airQualityData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.temprature.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  );
                } else {
                  return JumpingDotsProgressIndicator(
                    color: Colors.white,
                    fontSize: 32,
                  );
                }
              },
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 4),
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
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: FutureBuilder<AirQualityData>(
        future: airQualityData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              Strings.weatherStatusFromWeatherEnum(
                  Strings.weatherEnumFromWeatherCode(
                      snapshot.data.weatherCode)),
              style: Theme.of(context).textTheme.headline6,
              maxLines: 2,
            );
          } else {
            return JumpingDotsProgressIndicator(
              color: Colors.white,
              fontSize: 32,
            );
          }
        },
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
              FutureBuilder<AirQualityData>(
                future: airQualityData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        "${snapshot.data.city}, ${snapshot.data.state}, ${snapshot.data.country}",
                        maxLines: 3);
                  } else {
                    return Text("Loading...");
                  }
                },
              ),
            ],
            contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            titlePadding: EdgeInsets.all(12),
          );
        });
  }

  void _refreshPage() {
    GeolocationService.getCurrentLocation().then((location) {
      setState(() {
        currentLiveLocation = location;
        _refreshAirQualityData();
      });
    });
  }

  void _refreshAirQualityData() {
    airQualityData = HttpClient().fetchAirQualityData(currentLiveLocation);
    airQualityData.then((data) {
      setState(() {
        weatherEnum = Strings.weatherEnumFromWeatherCode(data.weatherCode);
        currentAppGradient =
            WeatherGradients.gradientFromWeatherEnum(weatherEnum);
        weatherStatusIcon = AppIcons.iconFromWeatherEnum(weatherEnum);
      });
    });
  }

  Widget _buildTopBarCityTitle() {
    return FutureBuilder<AirQualityData>(
      future: airQualityData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data.city,
            style: Theme.of(context).textTheme.headline5,
          );
        } else {
          return JumpingDotsProgressIndicator(
            color: Colors.white,
            fontSize: 32,
          );
        }
      },
    );
  }

  Widget _buildWeatherStatusIcon() {
    return Container(
      child: weatherStatusIcon,
    );
  }
}
