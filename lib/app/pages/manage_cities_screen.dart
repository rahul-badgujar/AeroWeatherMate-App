import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/services/database_helpers.dart' as dbhelper;
import 'package:air_quality_app/services/geolocation.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart' as ddsearch;
import 'package:location/location.dart';

class ManageCitiesScreen extends StatefulWidget {
  @override
  _ManageCitiesScreenState createState() => _ManageCitiesScreenState();
}

class _ManageCitiesScreenState extends State<ManageCitiesScreen> {
  List<dbhelper.City> citiesBeingShown = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    loadCitiesToShow();
    getTotalCitiesSavedLocally();
    print("Whole Screen Rebuilded!");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            decoration: AppDecorations.gradientBox(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCustomAppBar(),
                  Expanded(
                    child: _buildPageContents(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        icon: Icon(
          Icons.add,
          color: Colors.black,
          size: 35,
        ),
        label: Text(
          "New City",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return NewCityFormDialog();
            },
          ).then((result) {
            if (result is dbhelper.City) {
              insertCityLocally(result);
            }
          });
        },
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
              color: Colors.white,
            ),
            onPressed: () => _onExitScreen(),
          ),
          Expanded(
            child: Text(
              "Manage Cities",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContents() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _buildCityLabelWidget(index);
              },
              itemCount: citiesBeingShown.length,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityLabelWidget(int index) {
    dbhelper.City city = citiesBeingShown[index];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              city.city ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => _onDeleteButtonForCityLabelClicked(city),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
      decoration: AppDecorations.blurRoundBox(),
    );
  }

  void _onExitScreen() {
    Navigator.pop(context);
  }

  Future<void> insertCityLocally(dbhelper.City city) async {
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    int row = await helper.insertCity(city);
    if (row == dbhelper.DatabaseHelper.ERROR_CITY_ALREADY_PRESENT) {
      _showSnackbar("City already Present");
    } else if (row == dbhelper.DatabaseHelper.ERROR_MAX_CITIES_LIMIT_REACHED) {
      _showSnackbar("Max 5 Cities can be saved");
    }
    await loadCitiesToShow();
  }

  Future<void> loadCitiesToShow() async {
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    List<dbhelper.City> loadedCities = await helper.queryAllCities() ?? [];
    setState(() {
      citiesBeingShown = loadedCities;
    });
  }

  Future<void> deleteCityLocally(dbhelper.City city) async {
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    int row = await helper.deleteCity(city);
    print("City deleted from Row No. : $row");
    await loadCitiesToShow();
  }

  Future<int> getTotalCitiesSavedLocally() async {
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    int count = await helper.countCities();
    print("Total Cities : $count");
    return count;
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

  Future<void> _onDeleteButtonForCityLabelClicked(dbhelper.City city) async {
    await deleteCityLocally(city);
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
    loadUserLoadedCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "City Details",
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
      content: _buildFormContents(),
    );
  }

  Widget _buildFormContents() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildCountriesSelectionDropdown(),
        _buildStateSelectionDropdown(),
        _buildCitySelectionDropdown(),
        _buildUserLocationRequestButton(),
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
        onChanged: (String value) => loadUserLoadedStates(value),
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
                    dbhelper.City(
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
    /* statesList = await HttpClient()
                .fetchListOfStatesFromCountry(country: countrySelected);
            citiesList = await HttpClient().fetchListOfCitiesInState(
              state: stateSelected,
              country: countrySelected,
            ); */
    setState(() {
      isAddCityButtonActive = true;
    });
  }

  Future<void> loadUserLoadedCountries() async {
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    List<dbhelper.Country> fetchedCountries =
        await helper.retrieveUserLoadedCountries();
    if (fetchedCountries == null) {
      fetchedCountries = await HttpClient().fetchListOfCountries();
      await helper.saveUserLoadedCountries(fetchedCountries);
    }
    setState(() {
      countriesList =
          fetchedCountries?.map((e) => e == null ? null : e.country).toList();
    });
    print("Loaded Countries for Dropdown : $countriesList");
  }

  Future<void> loadUserLoadedStates(String value) async {
    countrySelected = value;
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    List<dbhelper.State> fetchedStatesList = await helper
        .retrieveUserLoadedStates(dbhelper.Country(country: countrySelected));
    if (fetchedStatesList == null) {
      fetchedStatesList = await HttpClient()
          .fetchListOfStatesFromCountry(country: countrySelected);
      await helper.saveUserLoadedStates(fetchedStatesList);
    }
    setState(() {
      statesList =
          fetchedStatesList?.map((e) => e == null ? null : e.state)?.toList();
    });
  }

  Future<void> loadUserLoadedCities(String value) async {
    stateSelected = value;
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    List<dbhelper.City> fetchedCitiesList =
        await helper.retrieveUserLoadedCities(
            dbhelper.State(state: stateSelected, country: countrySelected));
    if (fetchedCitiesList == null) {
      fetchedCitiesList = await HttpClient().fetchListOfCitiesInState(
          state: stateSelected, country: countrySelected);
      await helper.saveUserLoadedCities(fetchedCitiesList);
    }
    setState(() {
      citiesList =
          fetchedCitiesList?.map((e) => e == null ? null : e.city)?.toList();
    });
  }
}
