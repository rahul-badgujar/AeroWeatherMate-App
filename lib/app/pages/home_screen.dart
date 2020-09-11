import 'dart:async';
import 'package:air_quality_app/api/data_models/data.dart';
import 'package:air_quality_app/api/data_models/forecast.dart';
import 'package:air_quality_app/api/data_models/pollution.dart';
import 'package:air_quality_app/api/data_models/weather.dart';
import 'package:air_quality_app/app/pages/add_city_screen.dart';
import 'package:air_quality_app/widgets/main_page_widgets.dart'
    as mainpage_widgets;
import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/resources/constants.dart';
import 'package:air_quality_app/resources/icons_rsc.dart';
import 'package:air_quality_app/services/geolocation.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:air_quality_app/resources/gradients_rsc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        airVisualData = HttpClient()
            .fetchAirVisualDataUsingCoordinates(currentLiveLocation);
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildPageContent() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _onRefreshRequested,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildCurrentDataWidget(),
              _buildSourceCreditWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceCreditWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
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
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.add,
                ),
                color: Colors.white,
                onPressed: () => _addCity(),
                tooltip: "Add City",
              ),
              FutureBuilder<AirVisualData>(
                future: airVisualData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Data localAreaDetails = snapshot.data.data;
                    return RichText(
                      text: TextSpan(
                          text: "${localAreaDetails.city}",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text:
                                  "   ${localAreaDetails.state}, ${localAreaDetails.country}",
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
    airVisualData =
        HttpClient().fetchAirVisualDataUsingCoordinates(currentLiveLocation);
  }

  Widget _buildCurrentDataWidget() {
    return FutureBuilder<AirVisualData>(
        future: airVisualData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String weatherStatusCode =
                snapshot.data.data.current.weather.weatherStatusCode;
            int aqiUS = snapshot.data.data.current.pollution.aqiUS;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildShortDetailWidgets(weatherStatusCode, aqiUS),
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

  Row _buildShortDetailWidgets(String weatherStatusCode, int aqiUS) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        mainpage_widgets.buildShortDetailWidget(
          weatherStatusFromWeatherStatusCode(weatherStatusCode),
          weatherIconPathFromWeatherCode(weatherStatusCode),
        ),
        mainpage_widgets.buildShortDetailWidget(
          airQualityFromAqi(aqiUS),
          pollutionIconPathFromAqi(aqiUS),
        ),
      ],
    );
  }

  Container _buildFullPollutionStatusWidget(
      AsyncSnapshot<AirVisualData> snapshot) {
    Pollution pollutionData = snapshot.data.data.current.pollution;
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          mainpage_widgets.buildTitleDataWidget(
              snapshot.data.data.current.pollution.aqiUS, "aqi"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                mainpage_widgets.buildDataValueDetailWidget(
                    "US AQI", pollutionData.aqiUS, ""),
                mainpage_widgets.buildDataValueDetailWidget(
                    "US Pollutant", pollutionData.mainPollutantUS, ""),
                mainpage_widgets.buildDataValueDetailWidget(
                    "China AQI", pollutionData.aqiCN, ""),
                mainpage_widgets.buildDataValueDetailWidget(
                    "China Pollutant", pollutionData.mainPollutantCN, ""),
              ],
            ),
          ),
          mainpage_widgets.buildTimeStampWidget(
              snapshot.data.data.current.pollution.timeStamp),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  Container _buildFullWeatherStatusWidget(
      AsyncSnapshot<AirVisualData> snapshot) {
    Weather weatherData = snapshot.data.data.current.weather;
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          mainpage_widgets.buildTitleDataWidget(
              snapshot.data.data.current.weather.temprature, "°C"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                mainpage_widgets.buildDataValueDetailWidget(
                    "Atm Pressure", weatherData.pressure, "hPa"),
                mainpage_widgets.buildDataValueDetailWidget(
                    "Humidity", weatherData.humidity, "%"),
                mainpage_widgets.buildDataValueDetailWidget(
                    "Wind Speed", weatherData.windSpeed, "m/s"),
                mainpage_widgets.buildDataValueDetailWidget(
                    "Wind Direction",
                    windDirectionFromAngle(
                      weatherData.windDirection,
                    ),
                    ""),
              ],
            ),
          ),
          mainpage_widgets.buildTimeStampWidget(
              snapshot.data.data.current.weather.timeStamp),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  void _addCity() async {
    final String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCityScreen()));
    _scaffoldKey.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(result)));
  }
}
