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
  Map<String, Set<City>> actionMap = {};

  @override
  void initState() {
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
          FlatButton(
            color: Colors.blue,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return NewCityFormDialog();
                },
              ).then((result) {
                if (result is City) {
                  _addCityForActionAdd(result);
                }
              });
            },
            child: Text(
              "Open Form",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCityForActionAdd(City city) {
    actionMap[HomeScreen.ADD_CITY_KEY].add(city);
    print("added City : $city");
    setState(() {});
  }

  void _successExitScreen() {
    Navigator.pop(context, actionMap);
  }

  void _intruptExitScreen() {
    Navigator.pop(context, actionMap);
  }
}

class NewCityFormDialog extends StatefulWidget {
  @override
  _NewCityFormStateDialog createState() => _NewCityFormStateDialog();
}

class _NewCityFormStateDialog extends State<NewCityFormDialog> {
  List<String> countriesList = <String>[];
  List<String> statesList = <String>[];
  List<String> citiesList = <String>[];
  String countrySelected = "";
  String stateSelected = "";
  String citySelected = "";
  bool isAddCityButtonActive = false;

  @override
  void initState() {
    HttpClient().fetchListOfCountries().then((fetchedCountries) {
      setState(() {
        countriesList = fetchedCountries ?? <String>[];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: _buildFormContents(),
    );
  }

  Widget _buildFormContents() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildUserLocationRequestButton(),
        _buildCountriesSelectionDropdown(),
        _buildStateSelectionDropdown(),
        _buildCitySelectionDropdown(),
        _buildAddCityDataButton(),
      ],
    );
  }

  Widget _buildUserLocationRequestButton() {
    return FlatButton.icon(
      onPressed: () {
        _onUserLocationRequestPermitted();
      },
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

  Widget _buildCountriesSelectionDropdown() {
    print("Country Selection Dropdown Rebuilded");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ddsearch.DropdownSearch(
        items: countriesList ?? <String>[],
        mode: ddsearch.Mode.BOTTOM_SHEET,
        selectedItem: countrySelected ?? "",
        label: "Select Country",
        showSearchBox: true,
        onChanged: (String value) {
          countrySelected = value;
          HttpClient()
              .fetchListOfStatesFromCountry(country: countrySelected)
              .then((fetchedStates) {
            setState(() {
              statesList = fetchedStates ?? <String>[];
              stateSelected = "";
              citiesList = <String>[];
              citySelected = "";
              isAddCityButtonActive = false;
            });
          });
        },
      ),
    );
  }

  Widget _buildStateSelectionDropdown() {
    print("State Selection Dropdown Rebuilded");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ddsearch.DropdownSearch(
        items: statesList ?? <String>[],
        mode: ddsearch.Mode.BOTTOM_SHEET,
        label: "Select State",
        showSearchBox: true,
        selectedItem: stateSelected ?? "",
        onChanged: (String value) {
          stateSelected = value;
          HttpClient()
              .fetchListOfCitiesInState(
                  state: stateSelected, country: countrySelected)
              .then((fetchedCities) {
            setState(() {
              citiesList = fetchedCities ?? <String>[];
              citySelected = "";
              isAddCityButtonActive = false;
            });
          });
        },
      ),
    );
  }

  Widget _buildCitySelectionDropdown() {
    print("City Selection Dropdown Rebuilded");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ddsearch.DropdownSearch(
        items: citiesList ?? <String>[],
        mode: ddsearch.Mode.BOTTOM_SHEET,
        label: "Select City",
        showSearchBox: true,
        selectedItem: citySelected ?? "",
        onChanged: (String value) {
          citySelected = value;
          setState(() {
            isAddCityButtonActive = true;
          });
        },
      ),
    );
  }

  Widget _buildAddCityDataButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton.icon(
        color: Colors.green,
        disabledColor: Colors.black38,
        icon: Icon(
          Icons.add_location,
          size: 30,
          color: Colors.white,
        ),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
          child: Text(
            citySelected ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: isAddCityButtonActive == false
            ? null
            : () {
                Navigator.pop(
                    context,
                    City(
                        city: citySelected,
                        state: stateSelected,
                        country: countrySelected));
              },
      ),
    );
  }

  Future<void> _onUserLocationRequestPermitted() async {
    LocationData locationData = await GeolocationService.getCurrentLocation();
    AirVisualData airVisualData = await HttpClient()
        .fetchcurrentAirVisualDataUsingCoordinates(locationData);
    countrySelected = airVisualData.data.country;
    stateSelected = airVisualData.data.state;
    citySelected = airVisualData.data.city;
    statesList = await HttpClient()
        .fetchListOfStatesFromCountry(country: countrySelected);
    citiesList = await HttpClient().fetchListOfCitiesInState(
      state: stateSelected,
      country: countrySelected,
    );
    setState(() {
      isAddCityButtonActive = true;
    });
  }
}
