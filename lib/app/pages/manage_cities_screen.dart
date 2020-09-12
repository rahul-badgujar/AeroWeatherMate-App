import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/app/pages/home_screen.dart';
import 'package:air_quality_app/services/database_helpers.dart';
import 'package:air_quality_app/services/geolocation.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart' as ddsearch;
import 'package:location/location.dart';

class ManageCitiesScreen extends StatefulWidget {
  @override
  _ManageCitiesScreenState createState() => _ManageCitiesScreenState();
}

class _ManageCitiesScreenState extends State<ManageCitiesScreen> {
  Future<List<String>> countriesListFuture;
  Future<List<String>> statesListFuture;
  Future<List<String>> citiesListFuture;
  String countrySelected = null;
  String stateSelected = null;
  String citySelected = null;
  Map<String, Set<City>> actionMap = {};

  @override
  void initState() {
    countriesListFuture = HttpClient().fetchListOfCountries();
    actionMap[HomeScreen.ADD_CITY_KEY] = Set();
    actionMap[HomeScreen.DELETE_CITY_KEY] = Set();
    print("Whole Screen Rebuilded!");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCustomAppBar(),
              _buildPageContents(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => _intruptExitScreen(),
          ),
          Expanded(
            child: Text(
              "Manage Cities",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () => _intruptExitScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContents() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserLocationRequestButton(),
          _buildCountriesSelectionDropdown(),
          _buildStateSelectionDropdown(),
          _buildCitySelectionDropdown(),
          _buildAddCityDataButton(),
        ],
      ),
    );
  }

  Widget _buildCountriesSelectionDropdown() {
    print("Country Selection Dropdown Rebuilded");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: countriesListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && countriesListFuture != null) {
            return ddsearch.DropdownSearch(
              items: snapshot.data,
              mode: ddsearch.Mode.BOTTOM_SHEET,
              label: "Select Country",
              showSearchBox: true,
              selectedItem: countrySelected,
              onChanged: (String value) {
                print(value);
                countrySelected = value;
                setState(() {
                  stateSelected = null;
                  citySelected = null;
                  statesListFuture = HttpClient()
                      .fetchListOfStatesFromCountry(country: countrySelected);
                  citiesListFuture = null;
                });
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildStateSelectionDropdown() {
    print("State Selection Dropdown Rebuilded");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: statesListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && statesListFuture != null) {
            return ddsearch.DropdownSearch(
              items: snapshot.data,
              mode: ddsearch.Mode.BOTTOM_SHEET,
              label: "Select State",
              showSearchBox: true,
              selectedItem: stateSelected,
              onChanged: (String value) {
                print(value);
                stateSelected = value;
                setState(() {
                  citySelected = null;

                  citiesListFuture = HttpClient().fetchListOfCitiesInState(
                      state: stateSelected, country: countrySelected);
                });
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildCitySelectionDropdown() {
    print("City Selection Dropdown Rebuilded");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: citiesListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && citiesListFuture != null) {
            return ddsearch.DropdownSearch(
              items: snapshot.data,
              mode: ddsearch.Mode.BOTTOM_SHEET,
              label: "Select City",
              showSearchBox: true,
              selectedItem: citySelected,
              onChanged: (String value) {
                print(value);
                setState(() {
                  citySelected = value;
                });
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildAddCityDataButton() {
    return Visibility(
      visible: (citySelected != "" && citySelected != null),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton.icon(
          color: Colors.green,
          icon: Icon(
            Icons.add_location,
            size: 30,
            color: Colors.white,
          ),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
            child: Text(
              citySelected == null ? "" : citySelected,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: () {
            if (citySelected != null &&
                stateSelected != null &&
                countrySelected != null) {
              City city = City.fromString(
                  "$citySelected&$stateSelected&$countrySelected");
              _addCityForActionAdd(city);
            }
          },
        ),
      ),
    );
  }

  void _addCityForActionAdd(City city) {
    actionMap[HomeScreen.ADD_CITY_KEY].add(city);
    setState(() {
      citySelected = null;
      stateSelected = null;
      countrySelected = null;
    });
  }

  void _successExitScreen() {
    Navigator.pop(context, actionMap);
  }

  void _intruptExitScreen() {
    Navigator.pop(context, actionMap);
  }

  Widget _buildUserLocationRequestButton() {
    return FlatButton.icon(
      onPressed: () => _onUserLocationRequestPermitted(),
      icon: Icon(
        Icons.location_searching_rounded,
        size: 24,
      ),
      label: Text(
        "Use Current Location",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Future<void> _onUserLocationRequestPermitted() async {
    LocationData locationData = await GeolocationService.getCurrentLocation();
    AirVisualData airVisualData = await HttpClient()
        .fetchcurrentAirVisualDataUsingCoordinates(locationData);
    setState(() {
      countrySelected = airVisualData.data.country;
      stateSelected = airVisualData.data.state;
      citySelected = airVisualData.data.city;
      statesListFuture =
          HttpClient().fetchListOfStatesFromCountry(country: countrySelected);
      citiesListFuture = HttpClient().fetchListOfCitiesInState(
          state: stateSelected, country: countrySelected);
    });
  }
}
