import 'dart:async';
import 'package:air_quality_app/api/data_models/data.dart';
import 'package:air_quality_app/api/data_models/pollution.dart';
import 'package:air_quality_app/api/data_models/weather.dart';
import 'package:air_quality_app/app/pages/credits_screen.dart';
import 'package:air_quality_app/app/pages/manage_cities_screen.dart';
import 'package:air_quality_app/services/database_helpers.dart' as dbhelper;
import 'package:air_quality_app/widgets/main_page_widgets.dart'
    as mainpage_widgets;
import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/resources/constants.dart' as constants;
import 'package:air_quality_app/resources/icons_rsc.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // to store Scaffold Key for later reference
  List<dbhelper.City> citiesToShow = []; // list of Cities to show in PageViewer
  List<Future<AirVisualData>> _citiesFutureData =
      <Future<AirVisualData>>[]; // Future Data for Cities to Show
  final PageController _citiesPagesController = PageController(
      keepPage:
          true); // page Controller for Cities PageViewer, keepPage=True to save Pages in Memory to reduce Repeated Building overhead
  int currentPage =
      0; // keep track of Current Active Page of Cities PageViewer, used for Refresh Task

  @override
  void initState() {
    loadCitiesToShow(); // fetch and Load Future Data for Cities
    super.initState();
  }

  @override
  void dispose() {
    _citiesPagesController
        .dispose(); // dispose Cities PageViewer Controller when not needed
    dbhelper.DatabaseHelper()
        .database
        .then((db) => db.close()); // close the Database Connection
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold for Material Design benefits
      key: _scaffoldKey, // assign Scaffold Key to Scaffold
      body: Stack(
        // Stack to implement Gradient Background
        children: [
          Container(
            // Background of App
            decoration: AppDecorations.gradientBox(
                // Container with Gradient Decoration
                gradientTOFill: AppGradients.defaultGradient),
          ),
          SafeArea(
            // Safe Area to avoid cluttering of Content by Notch
            child: Padding(
              padding: constants.Paddings.paddingAll,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildCustomAppBar(), // Custom App Bar
                  Expanded(
                    // allow to fill entire remaining Screen
                    child: _buildPageContent(), // Page Contents
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // to Build Page Contents
  Widget _buildPageContent() {
    return Padding(
      padding:
          constants.Paddings.pageContentsPadding, // apply Page Contents Padding
      child: Builder(
        // using Builder so as to have Conditional Building
        builder: (context) {
          if (citiesToShow == null || citiesToShow.length == 0) {
            return _buildNoCityToShowScreen(); // if No Cities to show, then show No City Screen
          } else {
            return PageView.builder(
              // else build the PageView
              controller: _citiesPagesController, // attach PageController
              itemBuilder: (context, index) {
                if (index < _citiesFutureData.length) {
                  // if index is valid, then build Page
                  return _buildDataShowUI(_citiesFutureData[index]);
                } else {
                  // or Log the Error and show empty Container
                  print("The index is out of bound for page viewer caugth");
                  return Container();
                }
              },
              itemCount: // assign Items Count
                  _citiesFutureData == null ? 0 : _citiesFutureData.length,
              onPageChanged: (index) {
                // PageChanged Callback
                currentPage = index; // update Current Page
                print("Cities Page Changed to $currentPage");
              },
            );
          }
        },
      ),
    );
  }

  // to build The Info Widget provided FutureData
  Widget _buildDataShowUI(Future<AirVisualData> dataFuture) {
    return FutureBuilder<AirVisualData>(
      // Future Builder so as to decide what to show depending on Future status
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // if Future has Data ready
          return Column(
            children: [
              _buildCityDetailTitle(snapshot), // build City Title Widget
              _buildCurrentDataWidget(snapshot), // build Current Data Widget
            ],
          );
        } else {
          // till the Future Data is not ready
          return Center(
            child: Padding(
              padding: constants.Paddings.paddingAll,
              child: CircularProgressIndicator(
                // show a CircularProgressIndicator
                backgroundColor:
                    constants.Colours.circleProgressIndicatorBgColor,
              ),
            ),
          );
        }
      },
    );
  }

  // to build Custom App Bar
  Widget _buildCustomAppBar() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                // Refresh Icon Button
                icon: Icon(
                  Icons.refresh,
                ),
                onPressed: () => _doRefreshData(),
              ),
              Expanded(
                // Expanded Text Widget for App Title
                child: Text(
                  constants.Strings.appName,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildPopupMenuButtons(), // build Popup Menu
            ],
          ),
          Container(
            child: Builder(
              // builder for Conditional Build
              builder: (context) {
                if (citiesToShow == null || citiesToShow.length == 0) {
                  return Container(); // if no cities to show, show Empty Container
                } else {
                  // if Cities Available, display a SmoothPageIndicator
                  return SmoothPageIndicator(
                    controller:
                        _citiesPagesController, // Cities PageView Controller
                    count: citiesToShow.length, // count for Dots
                    effect: WormEffect(
                      // using WormEffect
                      activeDotColor: Colors.white,
                      dotColor: Colors.white70,
                      dotHeight: constants.Numbers.smoothControllerDot_dim,
                      dotWidth: constants.Numbers.smoothControllerDot_dim,
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

  // to build City Title
  Widget _buildCityDetailTitle(AsyncSnapshot<AirVisualData> snapshot) {
    Data localAreaDetails = snapshot.data.data; // get reference to Area Details
    return Container(
      margin: constants.Margins.rectMargin,
      child: RichText(
        // Rick Text for Varied Text Styles
        text: TextSpan(
          text: "${localAreaDetails.city}", // show City Name
          style: Theme.of(context).textTheme.headline6, // keep City Name bigger
          children: [
            TextSpan(
              text:
                  "   ${localAreaDetails.state}, ${localAreaDetails.country}", // show State and Country
              style: Theme.of(context)
                  .textTheme
                  .subtitle2, // keep State and Country Name small act City Name
            ),
          ],
        ),
      ),
    );
  }

  // function to Refresh Current City Page
  Future<void> _doRefreshData() async {
    Future<AirVisualData> refreshedData = HttpClient()
        .fetchcurrentAirVisualDataUsingAreaDetails(citiesToShow[
            currentPage]); // fetch Latest Data for Current Page City
    setState(() {
      _citiesFutureData[currentPage] =
          refreshedData; // and update Future Data for CurrentPage
    });
    print("Current Page Refreshed");
  }

  // builds total Data Representation
  Widget _buildCurrentDataWidget(AsyncSnapshot<AirVisualData> snapshot) {
    String weatherStatusCode = snapshot
        .data.data.current.weather.weatherStatusCode; // get WeatherStatusCode
    int aqiUS = snapshot.data.data.current.pollution.aqiUS; // get AqiUS
    return SingleChildScrollView(
      // SingleChildScrollView to scroll through

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // span the Entire Horizontal Screen
        children: [
          _buildShortDetailWidgets(
              weatherStatusCode, aqiUS), // build Short Details Widgets
          _buildFullWeatherStatusWidget(
              snapshot), // build Full Details Weather Widget
          _buildFullPollutionStatusWidget(
              snapshot), // build Full Details Pollution Widget
        ],
      ),
    );
  }

  // builds Short Details Widgets
  Row _buildShortDetailWidgets(String weatherStatusCode, int aqiUS) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        mainpage_widgets.buildShortDetailWidget(
          // build ShortDetailWidget for Weather
          context,
          constants.weatherStatusFromWeatherStatusCode(weatherStatusCode),
          weatherIconPathFromWeatherCode(weatherStatusCode),
        ),
        mainpage_widgets.buildShortDetailWidget(
          // build ShortDetailWidget for Pollution
          context,
          constants.airQualityFromAqi(aqiUS),
          pollutionIconPathFromAqi(aqiUS),
        ),
      ],
    );
  }

  // builds Full Details Pollution Widget
  Container _buildFullPollutionStatusWidget(
      AsyncSnapshot<AirVisualData> snapshot) {
    Pollution pollutionData =
        snapshot.data.data.current.pollution; // get reference to Pollution Data
    return Container(
      padding: constants.Paddings.paddingAll,
      margin: constants.Margins.rectMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          mainpage_widgets.buildTitleDataWidget(
              // build Title Data Widget
              context,
              snapshot.data.data.current.pollution.aqiUS,
              "aqi"),
          Padding(
            padding: constants.Paddings.paddingSym,
            child: Column(
              children: [
                // build Data-Value Pairs for Info
                mainpage_widgets.buildDataValueDetailWidget(
                    context, "US AQI", pollutionData.aqiUS, ""),
                mainpage_widgets.buildDataValueDetailWidget(
                    context, "US Pollutant", pollutionData.mainPollutantUS, ""),
                mainpage_widgets.buildDataValueDetailWidget(
                    context, "China AQI", pollutionData.aqiCN, ""),
                mainpage_widgets.buildDataValueDetailWidget(context,
                    "China Pollutant", pollutionData.mainPollutantCN, ""),
              ],
            ),
          ),
          mainpage_widgets.buildTimeStampWidget(
              // build Last Update TimeStamp
              context,
              snapshot.data.data.current.pollution.timeStamp),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  // build Full Details Weather Widget
  Container _buildFullWeatherStatusWidget(
      AsyncSnapshot<AirVisualData> snapshot) {
    Weather weatherData =
        snapshot.data.data.current.weather; // get reference to Weather Data
    return Container(
      padding: constants.Paddings.paddingAll,
      margin: constants.Margins.rectMargin,
      child: Column(
        children: [
          mainpage_widgets.buildTitleDataWidget(
              // build title Data Widget
              context,
              snapshot.data.data.current.weather.temprature,
              "°C"),
          Padding(
            padding: constants.Paddings.paddingSym,
            child: Column(
              children: [
                // build Data-Value pairs for Data
                mainpage_widgets.buildDataValueDetailWidget(
                    context, "Atm Pressure", weatherData.pressure, "hPa"),
                mainpage_widgets.buildDataValueDetailWidget(
                    context, "Humidity", weatherData.humidity, "%"),
                mainpage_widgets.buildDataValueDetailWidget(
                    context, "Wind Speed", weatherData.windSpeed, "m/s"),
                mainpage_widgets.buildDataValueDetailWidget(
                    context,
                    "Wind Direction",
                    constants.windDirectionFromAngle(
                      weatherData.windDirection,
                    ),
                    ""),
              ],
            ),
          ),
          mainpage_widgets.buildTimeStampWidget(
              // build Data Update Timestamp
              context,
              snapshot.data.data.current.weather.timeStamp),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  // builds NoCity Screen
  Widget _buildNoCityToShowScreen() {
    return Column(
      children: [
        GestureDetector(
          // to Detect Tap on NoCity Icon to trigger ManageCitiesScreen
          child: SvgPicture.asset(
            // Add Location Icon
            "assets/svg/add_location.svg",
            color: Theme.of(context).iconTheme.color,
            height: constants.Numbers.bigSvgIconDim,
            width: constants.Numbers.bigSvgIconDim,
          ),
          onTap: () => _requestManageCitiesRoute(),
        ),
        Padding(
          padding: constants.Paddings.paddingAll,
          child: Text(
            "No Cities to Show, Add New City",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ],
    );
  }

  // callback to request ManageCitiesRoute
  Future<void> _requestManageCitiesRoute() async {
    await Navigator.push(
        // push ManageCitiesScreen to Navigator Stack
        context,
        MaterialPageRoute(builder: (context) => ManageCitiesScreen()));
    dbhelper.DatabaseHelper helper =
        dbhelper.DatabaseHelper(); // get Database Helper
    List<dbhelper.City> loadedCities =
        await helper.queryAllCities() ?? []; // list out Updated Cities List
    setState(() {
      // remove out FutureData of Deleted Cities
      for (int i = 0; i < citiesToShow.length; i++) {
        if (loadedCities.contains(citiesToShow[i]) == false) {
          _citiesFutureData.removeAt(i);
        }
      }
      // add FutureData for Newly Added Cities
      for (dbhelper.City city in loadedCities) {
        if (citiesToShow.contains(city) == false) {
          Future<AirVisualData> fetchedData =
              HttpClient().fetchcurrentAirVisualDataUsingAreaDetails(city);
          _citiesFutureData.add(fetchedData);
        }
      }
      // update CitiesToShow list
      citiesToShow = loadedCities;
    });

    print("Updated Cities after Managing Cities  : $citiesToShow");
  }

  // Callback to request Credits Route
  Future<void> _requestCreditsRoute() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreditsScreen()));
  }

  // to initially Load Latest Data for CitiesToShow
  Future<void> loadCitiesToShow() async {
    dbhelper.DatabaseHelper helper =
        dbhelper.DatabaseHelper(); // get Database Helper Instance
    List<dbhelper.City> loadedCities =
        await helper.queryAllCities() ?? []; // list out All Cities to Show
    _citiesFutureData = []; // clear FutureData for Cities
    // add FutureData for all Cities
    for (dbhelper.City city in loadedCities) {
      Future<AirVisualData> fetchedData = HttpClient()
          .fetchcurrentAirVisualDataUsingAreaDetails(
              city); // fetch Data from API using CityDetails
      _citiesFutureData.add(fetchedData); // append FutureData to List
    }
    setState(() {
      citiesToShow = loadedCities; // update the CitiesToShow List
    });
    print("Loaded Cities : $citiesToShow");
  }

  // function to request Snackbar
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
    _scaffoldKey.currentState
        .showSnackBar(snackbar); // show Snackbar for top level Scaffold
  }

  // to build Popup Menu
  Widget _buildPopupMenuButtons() {
    return PopupMenuButton<constants.HomePagePopupMenuButtons>(
      icon: Icon(
        Icons.more_vert,
      ),
      itemBuilder: (context) {
        return <PopupMenuEntry<constants.HomePagePopupMenuButtons>>[
          PopupMenuItem(
            value: constants.HomePagePopupMenuButtons.manage_cities,
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
            value: constants.HomePagePopupMenuButtons.credits,
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
        // on selected Callback
        // chose action depending on Enum Values for Menu
        if (choice == constants.HomePagePopupMenuButtons.manage_cities) {
          _requestManageCitiesRoute();
        } else if (choice == constants.HomePagePopupMenuButtons.credits) {
          _requestCreditsRoute();
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
