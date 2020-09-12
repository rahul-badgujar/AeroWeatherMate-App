import 'dart:async';
import 'package:air_quality_app/api/data_models/data.dart';
import 'package:air_quality_app/api/data_models/pollution.dart';
import 'package:air_quality_app/api/data_models/weather.dart';
import 'package:air_quality_app/app/pages/add_city_screen.dart';
import 'package:air_quality_app/services/database_helpers.dart';
import 'package:air_quality_app/widgets/main_page_widgets.dart'
    as mainpage_widgets;
import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/resources/constants.dart' as consts;
import 'package:air_quality_app/resources/icons_rsc.dart';
import 'package:air_quality_app/services/geolocation.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:air_quality_app/resources/gradients_rsc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationData currentLiveLocation;
  Future<AirVisualData> currentAirVisualData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<City> citiesToShow;
  final PageController _citiesPagesController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    citiesToShow = [];
    /* citiesToShow.add(new City("Nashik", "Maharashtra", "India"));
    citiesToShow.add(new City("Pimpri", "Maharashtra", "India")); */
    _loadCitiesToShow();
    super.initState();
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildCustomAppBar(),
                  Expanded(
                    child: _buildPageContent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Builder(
        builder: (context) {
          if (citiesToShow == null || citiesToShow.length == 0) {
            return _buildNoCityToShowScreen();
          } else {
            return PageView.builder(
              itemBuilder: (context, position) {
                return _buildDataShowUI(citiesToShow[position]);
              },
              itemCount: citiesToShow.length,
              controller: _citiesPagesController,
              onPageChanged: (int page) {
                currentPage = page;
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDataShowUI(City city) {
    currentAirVisualData =
        HttpClient().fetchcurrentAirVisualDataUsingAreaDetails(city);
    return FutureBuilder<AirVisualData>(
      future: currentAirVisualData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              _buildCityDetailTitle(snapshot),
              _buildCurrentDataWidget(snapshot),
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
      },
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
                  Icons.menu,
                ),
                color: Colors.white,
                onPressed: () => _addCity(),
              ),
              Expanded(
                child: Text(
                  consts.Strings.appName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () => _deleteCurrentCityLocally(),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 4),
            child: Builder(
              builder: (context) {
                if (citiesToShow == null || citiesToShow.length == 0) {
                  return Container(
                    height: 100,
                  );
                } else {
                  return SmoothPageIndicator(
                    controller: _citiesPagesController,
                    count: citiesToShow.length,
                    effect: WormEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white70,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityDetailTitle(AsyncSnapshot<AirVisualData> snapshot) {
    Data localAreaDetails = snapshot.data.data;

    return RichText(
      text: TextSpan(
        text: "${localAreaDetails.city}",
        style: TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: "   ${localAreaDetails.state}, ${localAreaDetails.country}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
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
    currentAirVisualData = HttpClient()
        .fetchcurrentAirVisualDataUsingCoordinates(currentLiveLocation);
  }

  Widget _buildCurrentDataWidget(AsyncSnapshot<AirVisualData> snapshot) {
    String weatherStatusCode =
        snapshot.data.data.current.weather.weatherStatusCode;
    int aqiUS = snapshot.data.data.current.pollution.aqiUS;
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildShortDetailWidgets(weatherStatusCode, aqiUS),
          _buildFullWeatherStatusWidget(snapshot),
          _buildFullPollutionStatusWidget(snapshot),
        ],
      ),
    );
  }

  Row _buildShortDetailWidgets(String weatherStatusCode, int aqiUS) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        mainpage_widgets.buildShortDetailWidget(
          consts.weatherStatusFromWeatherStatusCode(weatherStatusCode),
          weatherIconPathFromWeatherCode(weatherStatusCode),
        ),
        mainpage_widgets.buildShortDetailWidget(
          consts.airQualityFromAqi(aqiUS),
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
                    consts.windDirectionFromAngle(
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

  Widget _buildNoCityToShowScreen() {
    return Column(
      children: [
        GestureDetector(
          child: SvgPicture.asset(
            "assets/svg/add_location.svg",
            color: Colors.white,
            height: 60,
            width: 60,
          ),
          onTap: () => _addCity(),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "No Cities to Show, Add New City",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _addCity() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCityScreen()));
    if (result != null) {
      City city = City.fromString(result);
      setState(() {
        _insertCityLocally(city);
        _loadCitiesToShow();
      });
    }
  }

  void _insertCityLocally(City city) async {
    DatabaseHelper helper = DatabaseHelper();
    int row = await helper.insertCity(city);
    if (row == -1) {
      print("City already Present in Database");
    } else {
      print("city inserted at Row No. : $row");
    }
  }

  void _loadCitiesToShow() async {
    DatabaseHelper helper = DatabaseHelper();
    List<City> loadedCities = await helper.queryAllCities() ?? null;
    setState(() {
      citiesToShow = loadedCities;
      //currentPage = 0;
    });
  }

  void _deleteCurrentCityLocally() async {
    DatabaseHelper helper = DatabaseHelper();
    int row = await helper.deleteCity(citiesToShow[currentPage]);
    print("City deleted from Row No. : $row");
    _loadCitiesToShow();
  }
}
