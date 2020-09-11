import 'package:air_quality_app/api/network/http_client.dart';
import 'package:air_quality_app/resources/gradients_rsc.dart';
import 'package:air_quality_app/ui/decorations.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart' as ddsearch;

class AddCityScreen extends StatefulWidget {
  @override
  _AddCityScreenState createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddCityScreen> {
  Future<List<String>> countriesListFuture;
  Future<List<String>> statesListFuture;
  Future<List<String>> citiesListFuture;
  String countrySelected;
  String stateSelected;
  String citySelected;

  @override
  void initState() {
    countrySelected = null;
    stateSelected = null;
    citySelected = null;
    statesListFuture = null;
    citiesListFuture = null;
    countriesListFuture = HttpClient().fetchListOfCountries();

    super.initState();

    print("Whole Screen Rebuilded!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _buildPageContents(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exitScreen() {
    Navigator.pop(context);
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
            onPressed: () => _exitScreen(),
          ),
          Text(
            "Choose City",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPageContents() {
    return Expanded(
      child: Column(
        children: [
          _buildCountriesSelectionDropdown(),
          _buildStateSelectionDropdown(),
          _buildCitySelectionDropdown(),
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
              mode: ddsearch.Mode.MENU,
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
              mode: ddsearch.Mode.MENU,
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
              mode: ddsearch.Mode.MENU,
              label: "Select City",
              showSearchBox: true,
              selectedItem: citySelected,
              onChanged: (String value) {
                print(value);
                citySelected = value;
                setState(() {});
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
