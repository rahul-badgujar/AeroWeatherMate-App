import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/services/database_helpers.dart' as dbhelper;
import 'package:air_quality_app/services/geolocation.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart' as ddsearch;
import 'package:location/location.dart';
import 'package:air_quality_app/resources/constants.dart' as constants;

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
              padding: constants.Paddings.paddingAll,
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
        //backgroundColor: Colors.white,
        icon: IconTheme(
          data: Theme.of(context).iconTheme.copyWith(color: Colors.black),
          child: Icon(
            Icons.add,
          ),
        ),
        label: Text(
          "New City",
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: Colors.black),
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
            ),
            onPressed: () => _onExitScreen(),
          ),
          Expanded(
            child: Text(
              "Manage Cities",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContents() {
    return Padding(
      padding: constants.Paddings.pageContentsPadding,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityLabelWidget(int index) {
    dbhelper.City city = citiesBeingShown[index];
    return Container(
      padding: constants.Paddings.paddingAll,
      margin: constants.Margins.bigListTileMargin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              city.city ?? "",
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_rounded,
            ),
            onPressed: () => _onDeleteButtonForCityLabelClicked(city),
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
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Colors.black,
            ),
        textAlign: TextAlign.center,
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future<void> _onDeleteButtonForCityLabelClicked(dbhelper.City city) async {
    _showSnackbar("Hello");
    //await deleteCityLocally(city);
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCountriesSelectionDropdown(),
          _buildStateSelectionDropdown(),
          _buildCitySelectionDropdown(),
          _buildUserLocationRequestButton(),
          _buildAddCityDataButton(),
        ],
      ),
    );
  }

  Widget _buildUserLocationRequestButton() {
    return FlatButton.icon(
      onPressed: () {
        _onUserLocationRequestPermitted();
      },
      icon: Icon(
        Icons.location_searching_rounded,
      ),
      label: Text(
        "Use Current Location",
        style:
            Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),
      ),
    );
  }

  Widget _buildCountriesSelectionDropdown() {
    print("Country Selection Dropdown Rebuilded");
    return Padding(
      padding: constants.Paddings.formFieldPadding,
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
      padding: constants.Paddings.formFieldPadding,
      child: ddsearch.DropdownSearch(
        items: statesList ?? <String>[],
        mode: ddsearch.Mode.BOTTOM_SHEET,
        label: "Select State",
        showSearchBox: true,
        selectedItem: stateSelected ?? "",
        onChanged: (String value) => loadUserLoadedCities(value),
      ),
    );
  }

  Widget _buildCitySelectionDropdown() {
    print("City Selection Dropdown Rebuilded");
    return Padding(
      padding: constants.Paddings.formFieldPadding,
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
      padding: constants.Paddings.paddingAll,
      child: RaisedButton.icon(
        color: Colors.green,
        disabledColor: Colors.black38,
        icon: Icon(
          Icons.add_location,
          color: Theme.of(context).iconTheme.color,
        ),
        label: Padding(
          padding: constants.Paddings.paddingAll,
          child: Text(
            citySelected ?? "",
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w700,
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
    loadUserLoadedStates(countrySelected);
    loadUserLoadedCities(stateSelected);
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
    //print("Loaded Countries for Dropdown : $countriesList");
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
