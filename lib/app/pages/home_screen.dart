import 'dart:async';
import 'package:air_quality_app/api/data_models/data.dart';
import 'package:air_quality_app/api/data_models/pollution.dart';
import 'package:air_quality_app/api/data_models/weather.dart';
import 'package:air_quality_app/app/pages/credits_screen.dart';
import 'package:air_quality_app/app/pages/manage_cities_screen.dart';
import 'package:air_quality_app/services/database_helpers.dart';
import 'package:air_quality_app/widgets/main_page_widgets.dart'
    as mainpage_widgets;
import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/resources/constants.dart' as consts;
import 'package:air_quality_app/resources/icons_rsc.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:air_quality_app/resources/gradients_rsc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  static const String ADD_CITY_KEY = "ADD CITY KEY";
  static const String DELETE_CITY_KEY = "DELETE CITY KEY";
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationData currentLiveLocation;
  Future<AirVisualData> currentAirVisualData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<City> citiesToShow = [];
  List<FutureBuilder<AirVisualData>> _citiesPages = [];
  final PageController _citiesPagesController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    loadCitiesToShow();
    super.initState();
  }

  @override
  void dispose() {
    _citiesPagesController.dispose();
    DatabaseHelper().database.then((db) => db.close());
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
              padding: const EdgeInsets.all(12),
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
            return PageView(
              children: _citiesPages,
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

  Widget _buildDataShowUI(Future<AirVisualData> dataFuture) {
    return FutureBuilder<AirVisualData>(
      future: dataFuture,
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
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () => _doRefreshData(),
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
              _buildPopupMenuButtons(),
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
                    count: _citiesPages.length,
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

  Future<void> _doRefreshData() async {
    Future<AirVisualData> refreshedData = HttpClient()
        .fetchcurrentAirVisualDataUsingAreaDetails(citiesToShow[currentPage]);
    setState(() {
      _citiesPages[currentPage] = _buildDataShowUI(refreshedData);
    });
    print("Current Page Refreshed");
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
          onTap: () => _requestManageCitiesRoute(),
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

  Future<void> _requestManageCitiesRoute() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ManageCitiesScreen()));
    await loadCitiesToShow();
  }

  Future<void> _requestCreditsRoute() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreditsScreen()));
  }

  Future<void> loadCitiesToShow() async {
    DatabaseHelper helper = DatabaseHelper();
    List<City> loadedCities = await helper.queryAllCities() ?? [];
    setState(() {
      citiesToShow = loadedCities;
      _citiesPages = [];
      for (City city in citiesToShow) {
        Future<AirVisualData> fetchedData =
            HttpClient().fetchcurrentAirVisualDataUsingAreaDetails(city);
        _citiesPages.add(_buildDataShowUI(fetchedData));
      }
    });
    print("Loaded Cities : $citiesToShow");
  }

  void _showSnackbar(String text) {
    final snackbar = SnackBar(
      backgroundColor: Colors.white,
      duration: Duration(seconds: 1),
      content: Text(
        text,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _buildPopupMenuButtons() {
    return PopupMenuButton<consts.HomePagePopupMenuButtons>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      itemBuilder: (context) {
        return <PopupMenuEntry<consts.HomePagePopupMenuButtons>>[
          PopupMenuItem(
            value: consts.HomePagePopupMenuButtons.manage_cities,
            child: Text(
              "Manage Cities",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          PopupMenuItem(
            value: consts.HomePagePopupMenuButtons.credits,
            child: Text(
              "Credits",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ];
      },
      onSelected: (choice) {
        if (choice == consts.HomePagePopupMenuButtons.manage_cities) {
          _requestManageCitiesRoute();
        } else if (choice == consts.HomePagePopupMenuButtons.credits) {
          _requestCreditsRoute();
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
