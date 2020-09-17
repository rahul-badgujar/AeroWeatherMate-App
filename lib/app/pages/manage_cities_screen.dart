import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/services/database_helpers.dart' as dbhelper;
import 'package:air_quality_app/services/geolocation.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart' as ddsearch;
import 'package:location/location.dart';
import 'package:air_quality_app/resources/constants.dart' as constants;
import 'package:air_quality_app/resources/gradients_rsc.dart' as gradients;

class ManageCitiesScreen extends StatefulWidget {
  @override
  _ManageCitiesScreenState createState() => _ManageCitiesScreenState();
}

class _ManageCitiesScreenState extends State<ManageCitiesScreen> {
  List<dbhelper.City> citiesBeingShown = []; // List of Cities to be Shown
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Scaffold Key

  @override
  void initState() {
    loadCitiesToShow(); // load the Cities to be Shown
    //getTotalCitiesSavedLocally();
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
            decoration: AppDecorations.gradientBox(
                gradientTOFill: gradients.defaultGradient),
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
        // Floating Action Button with Label
        icon: IconTheme(
          // Add Icon
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
          // on Floating Action Button pressed
          showDialog(
            // show Dialog
            context: context,
            builder: (context) {
              return NewCityFormDialog(); // show New City Form
            },
          ).then((result) {
            // get the result returned by Dialog
            if (result is dbhelper.City) {
              insertCityLocally(result); // insert the City
            }
          });
        },
      ),
    );
  }

  // Custom App Bar
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

  // build Page Contents
  Widget _buildPageContents() {
    return Padding(
      padding: constants.Paddings.pageContentsPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              // ListView of Cities
              itemBuilder: (context, index) {
                return _buildCityLabelWidget(
                    index); //  build City Label for Each City
              },
              itemCount: citiesBeingShown.length,
            ),
          ),
        ],
      ),
    );
  }

  // build City Label Widget
  Widget _buildCityLabelWidget(int index) {
    dbhelper.City city = citiesBeingShown[index]; // get reference to City
    return Container(
      padding: constants.Paddings.paddingAll,
      margin: constants.Margins.bigListTileMargin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // Expanded Text for City Name
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
            // Delete Button
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

  // Back Button Callback
  void _onExitScreen() {
    Navigator.pop(context);
  }

  // method to Insert City into Database and update in UI
  Future<void> insertCityLocally(dbhelper.City city) async {
    dbhelper.DatabaseHelper helper =
        dbhelper.DatabaseHelper(); // Database Helper
    int row = await helper
        .insertCity(city); // wait till Insertion of City into Database
    if (row == dbhelper.DatabaseHelper.ERROR_CITY_ALREADY_PRESENT) {
      // if City Already Present
      _showSnackbar("City already Present");
    } else if (row == dbhelper.DatabaseHelper.ERROR_MAX_CITIES_LIMIT_REACHED) {
      // if Limit of Cities Exceeded
      _showSnackbar(
          "Max ${constants.Numbers.maxAllowedCities} Cities can be saved");
    }
    await loadCitiesToShow(); // wait till Updating UI for Updated Cities
  }

  // method to Update Cities in UI
  Future<void> loadCitiesToShow() async {
    dbhelper.DatabaseHelper helper =
        dbhelper.DatabaseHelper(); // Database Helper
    List<dbhelper.City> loadedCities = await helper.queryAllCities() ??
        []; // await and get List of All Cities from Database
    setState(() {
      // request update UI
      citiesBeingShown = loadedCities; // update citiesBeingShown
    });
  }

  // method to Delete City from Database
  Future<void> deleteCityLocally(dbhelper.City city) async {
    dbhelper.DatabaseHelper helper =
        dbhelper.DatabaseHelper(); // Database Helper
    int row =
        await helper.deleteCity(city); // wait and Delete City from Database
    print("City deleted from Row No. : $row");
    await loadCitiesToShow(); // update changed in Cities in UI
  }

  // method to get Count of Cities saved in Database
  Future<int> getTotalCitiesSavedLocally() async {
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    int count = await helper.countCities(); // Count Cities from Database
    print("Total Cities : $count");
    return count;
  }

  // method to show Snackbar
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
    _scaffoldKey.currentState
        .showSnackBar(snackbar); // show Snackbar for Current Scaffold
  }

  // method to Delete City for which Delete is cliked
  Future<void> _onDeleteButtonForCityLabelClicked(dbhelper.City city) async {
    await deleteCityLocally(city);
  }
}

// Class for New City Form
class NewCityFormDialog extends StatefulWidget {
  @override
  _NewCityFormStateDialog createState() => _NewCityFormStateDialog();
}

class _NewCityFormStateDialog extends State<NewCityFormDialog> {
  List<String> countriesList = <String>[]; // List of Countries for Dropdown
  List<String> statesList = <String>[]; // List of States for Dropdown
  List<String> citiesList = <String>[]; // List of Cities for Dropdown
  String countrySelected = ""; // Current Selected Country
  String stateSelected = ""; // Current Selected State
  String citySelected = ""; // Current Selected City
  bool isAddCityButtonActive =
      false; // wheather the Add City Button is Active or not

  @override
  void initState() {
    loadUserLoadedCountries(); // Load the List of Countries and Update for Dropdown
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // return an Alert Box
      title: Text(
        // Title for Alert Box
        "City Details",
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
      content: _buildFormContents(), // build Form Contents
    );
  }

  // builds Form Contents
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

  // User Location Button Callback
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

  // build Countries Dropdown
  Widget _buildCountriesSelectionDropdown() {
    print("Country Selection Dropdown Rebuilded");
    return Padding(
      padding: constants.Paddings.formFieldPadding,
      child: ddsearch.DropdownSearch(
        // using DropDownSearch Package
        items: countriesList ?? <String>[], // list of Contries
        mode: ddsearch.Mode.BOTTOM_SHEET, // open as Bottom Sheet
        selectedItem: countrySelected ?? "",
        label: "Select Country",
        showSearchBox: true,
        onChanged: (String value) => loadUserLoadedStates(value),
      ),
    );
  }

  // build States Dropdown
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

  // build Cities Dropdown
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

  // Add City Button
  Widget _buildAddCityDataButton() {
    return Padding(
      padding: constants.Paddings.paddingAll,
      child: RaisedButton.icon(
        // Raised Button with Icon
        color: Colors.green,
        disabledColor: Colors.black38,
        icon: Icon(
          Icons.add_location, // Add Location Icon
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
        // if onPressed=null, Button is considered Disabled, else Active
        onPressed: isAddCityButtonActive == false
            ? null // if Button is not Active, assign NULL to deactivate Button
            : () {
                // Active Button Callback
                Navigator.pop(
                    // exit the Form and Return City Result
                    context,
                    dbhelper.City(
                        city: citySelected,
                        state: stateSelected,
                        country: countrySelected));
              },
      ),
    );
  }

  // method to Access User Location and Fill in Data in UI accordingly
  Future<void> _onUserLocationRequestPermitted() async {
    LocationData locationData =
        await GeolocationService.getCurrentLocation(); // get User Location
    AirVisualData airVisualData = await HttpClient()
        .fetchcurrentAirVisualDataUsingCoordinates(
            locationData); // fetch Data using Location
    // Fill in the Data in UI
    countrySelected = airVisualData.data.country;
    stateSelected = airVisualData.data.state;
    citySelected = airVisualData.data.city;
    loadUserLoadedStates(
        countrySelected); // Load States List for Live Location Country
    loadUserLoadedCities(
        stateSelected); // Load Cities List for Live Location State
    setState(() {
      isAddCityButtonActive = true; // activate the Add City Button
    });
  }

  // Load User Loaded Countries List
  Future<void> loadUserLoadedCountries() async {
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    List<dbhelper.Country> fetchedCountries =
        await helper.retrieveUserLoadedCountries(); // Fetch Contries List
    if (fetchedCountries == null) {
      // if nothing found
      fetchedCountries = await HttpClient()
          .fetchListOfCountries(); // wait and fetch list from API
      await helper.saveUserLoadedCountries(
          fetchedCountries); // save the fetched Countries in Database
    }
    setState(() {
      // request Update in UI
      countriesList = fetchedCountries
          ?.map((e) => e == null ? null : e.country)
          .toList(); // update countriesList
    });
    //print("Loaded Countries for Dropdown : $countriesList");
  }

  // method to Load User Saved States for Country
  Future<void> loadUserLoadedStates(String value) async {
    countrySelected = value;
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    List<dbhelper.State> fetchedStatesList =
        await helper.retrieveUserLoadedStates(dbhelper.Country(
            country: countrySelected)); // get the List of States for Country
    if (fetchedStatesList == null) {
      // if nothing found
      fetchedStatesList = await HttpClient().fetchListOfStatesFromCountry(
          country: countrySelected); // wait and fetch List from API
      await helper.saveUserLoadedStates(
          fetchedStatesList); // save the List Locally in Database
    }
    setState(() {
      // request Update UI
      statesList = fetchedStatesList
          ?.map((e) => e == null ? null : e.state)
          ?.toList(); // update statesList
    });
  }

  // method to load User Saved Cities
  Future<void> loadUserLoadedCities(String value) async {
    stateSelected = value;
    dbhelper.DatabaseHelper helper = dbhelper.DatabaseHelper();
    List<dbhelper.City> fetchedCitiesList =
        await helper.retrieveUserLoadedCities(dbhelper.State(
            state: stateSelected,
            country:
                countrySelected)); // wait and load List of Cities for Country and State
    if (fetchedCitiesList == null) {
      // if nothing found
      fetchedCitiesList = await HttpClient().fetchListOfCitiesInState(
          state: stateSelected,
          country: countrySelected); // wait and fetch List from API
      await helper.saveUserLoadedCities(
          fetchedCitiesList); // save List locally in Database
    }
    setState(() {
      // request Update UI
      citiesList = fetchedCitiesList
          ?.map((e) => e == null ? null : e.city)
          ?.toList(); // update citiesList
    });
  }
}
