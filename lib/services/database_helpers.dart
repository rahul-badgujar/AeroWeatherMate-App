import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:air_quality_app/resources/constants.dart' as consts;

// Column and Table Names
const String citiesTable = "CitiesTable"; // stores Cities user has Selected
const String userLoadedCitiesTable =
    "UserLoadedCitiesTable"; // stores the API Data for List of Cities
const String userLoadedStatesTable =
    "UserLoadedStatesTable"; // stores the API Data for List of States
const String userLoadedCountriesTable =
    "UserLoadedCountriesTable"; // stores the API Data for List of Countries
const String cityColumn = "City";
const String stateColumn = "State";
const String countryColumn = "Country";

/*
Datum Classes with helper methods like fromString, toString, fromMap, toMap
*/
class City {
  final String city;
  final String state;
  final String country;

  City({
    @required this.city,
    @required this.state,
    @required this.country,
  });

  factory City.fromString(String str) {
    List<String> details = str.split("&");
    City city = City(city: details[0], state: details[1], country: details[2]);
    return city;
  }

  factory City.fromMap(Map<String, dynamic> map) {
    City city = City(
      city: map[cityColumn],
      state: map[stateColumn],
      country: map[countryColumn],
    );
    return city;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      cityColumn: this.city,
      stateColumn: this.state,
      countryColumn: this.country,
    };

    return map;
  }

  @override
  String toString() {
    return "${this.city}&${this.state}&${this.country}";
  }

  // overriding == operator for City Type
  @override
  bool operator ==(other) {
    if (other is City) {
      return (this.city == other.city &&
          this.state == other.state &&
          this.country == other.country);
    }
    return false;
  }
}

class Country {
  final String country;
  Country({@required this.country});

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(country: map[countryColumn]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      countryColumn: this.country,
    };
  }

  @override
  String toString() {
    return this.country;
  }

  factory Country.fromString(String representation) {
    return Country(country: representation);
  }
}

class State {
  final String state;
  final String country;

  State({@required this.state, @required this.country});

  factory State.fromMap(Map<String, dynamic> map) {
    return State(state: map[stateColumn], country: map[countryColumn]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      stateColumn: this.state,
      countryColumn: this.country,
    };
  }

  @override
  String toString() {
    return "${this.state}&${this.country}";
  }

  factory State.fromString(String representation) {
    List<String> slices = representation.split("&");
    return State(state: slices[0], country: slices[1]);
  }
}

// Database Helper Class
class DatabaseHelper {
  static const String _databaseName = "ApiSavedData.db"; // Database Name
  static const int _databaseVersion = 1; // Database Version
  // ERROR CODES for Database Queries
  static const int ERROR_CITY_ALREADY_PRESENT = -23;
  static const int ERROR_MAX_CITIES_LIMIT_REACHED = -24;

  // making Class Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper _instace = DatabaseHelper._privateConstructor();
  factory DatabaseHelper() {
    return _instace;
  }

  // Single object of Database to maitain throughout App Lifetime
  static Database _database;
  // getter for Database Object
  Future<Database> get database async {
    if (_database == null) {
      // if Database not open,
      _database = await _initDatabase(); // open Databse
    }
    return _database;
  }

  // method to Open Database
  Future<Database> _initDatabase() async {
    Directory documentDirectory =
        await getApplicationDocumentsDirectory(); // get Application Documentary Directory
    String path =
        join(documentDirectory.path, _databaseName); // complete Database Path
    return await openDatabase(
      // request to Open Database
      path,
      version: _databaseVersion,
      onCreate: _onCreate, // called when Database is initialized First Time
    );
  }

  // Create Table Command for all Tables
  FutureOr<void> _onCreate(Database db, int version) async {
    db.execute('''
      CREATE TABLE $citiesTable (
        $cityColumn varchar(255) PRIMARY KEY,
        $stateColumn varchar(255) NOT NULL,
        $countryColumn varchar(255) NOT NULL
      )
      ''');
    db.execute('''
      CREATE TABLE $userLoadedCitiesTable (
        $cityColumn varchar(255) PRIMARY KEY,
        $stateColumn varchar(255) NOT NULL,
        $countryColumn varchar(255) NOT NULL
      )
      ''');
    db.execute('''
      CREATE TABLE $userLoadedStatesTable (
        $stateColumn varchar(255) PRIMARY KEY,
        $countryColumn varchar(255) NOT NULL
      )
      ''');
    db.execute('''
      CREATE TABLE $userLoadedCountriesTable (
        $countryColumn varchar(255) PRIMARY KEY
      )
      ''');
  }

  // method to insert city in Saved Cities
  Future<int> insertCity(City city) async {
    Database db = await database;
    if (await queryCity(city) != null) {
      // check if that City is already present
      return DatabaseHelper.ERROR_CITY_ALREADY_PRESENT;
    }
    if (await countCities() >= consts.Numbers.maxAllowedCities) {
      // check for Cities Limit
      return DatabaseHelper.ERROR_MAX_CITIES_LIMIT_REACHED;
    }
    int id = await db.insert(
        citiesTable, city.toMap()); // otherwise Save the city in Database
    return id; // return the position of insertion of city
  }

  // method to save User Loaded Countries from API
  Future<void> saveUserLoadedCountries(List<Country> countries) async {
    Database db = await database;
    Batch batch = db.batch(); // batch for holding changes
    for (Country country in countries) {
      batch.insert(
          userLoadedCountriesTable, country.toMap()); // add all the cities
    }
    await batch.commit(
        noResult: true); // commit the batch without expecting result
    print("User Loaded Countries saved");
  }

  Future<void> saveUserLoadedStates(List<State> states) async {
    Database db = await database;
    Batch batch = db.batch();
    for (State state in states) {
      batch.insert(userLoadedStatesTable, state.toMap());
    }
    await batch.commit();
    print("User Loaded States saved");
  }

  Future<void> saveUserLoadedCities(List<City> cities) async {
    Database db = await database;
    Batch batch = db.batch();
    for (City city in cities) {
      batch.insert(userLoadedCitiesTable, city.toMap());
    }
    await batch.commit();
    print("User Loaded Cities saved");
  }

  // method to retrive User Loaded Countries
  Future<List<Country>> retrieveUserLoadedCountries() async {
    Database db = await database;
    List<Map> found = await db.query(userLoadedCountriesTable) ??
        <Map>[]; // retrive the list of Countries as Map
    if (found.length > 0) {
      // if the list is non-empty
      List<Country> countriesLoaded = found
          ?.map((e) => e == null ? null : Country.fromMap(e))
          ?.toList(); // convert maps list to List<Country>
      //print("User Loaded Countries Retrieved  : $countriesLoaded");
      return countriesLoaded;
    }
    //print("No User Loaded Countries Retrieved");
    return null;
  }

  Future<List<State>> retrieveUserLoadedStates(Country whereCountry) async {
    Database db = await database;
    List<Map> found = await db.query(
          userLoadedStatesTable,
          where: "$countryColumn=?",
          whereArgs: [whereCountry.country],
        ) ??
        <Map>[];
    if (found.length > 0) {
      List<State> statesLoaded =
          found?.map((e) => e == null ? null : State.fromMap(e))?.toList();
      //print("User Loaded States Retrieved  : $statesLoaded");
      return statesLoaded;
    }
    //print("No User Loaded States Retrieved");
    return null;
  }

  Future<List<City>> retrieveUserLoadedCities(State whereState) async {
    Database db = await database;
    List<Map> found = await db.query(
          userLoadedCitiesTable,
          where: "$stateColumn=? AND $countryColumn=?",
          whereArgs: [whereState.state, whereState.country],
        ) ??
        <Map>[];
    if (found.length > 0) {
      List<City> citiesLoaded =
          found?.map((e) => e == null ? null : City.fromMap(e))?.toList();
      //print("User Loaded Cities Retrieved  : $citiesLoaded");
      return citiesLoaded;
    }
    //print("No User Loaded Cities Retrieved");
    return null;
  }

  // method to Query about a City in UserSavedCities
  Future<City> queryCity(City city) async {
    Database db = await database;
    List<Map> found = await db.query(
      citiesTable,
      columns: [cityColumn, stateColumn, countryColumn],
      where: "$cityColumn=? AND $stateColumn=? AND $countryColumn=?",
      whereArgs: [city.city, city.state, city.country],
    ); // query Request
    if (found.length > 0) {
      // if got the response
      return City.fromMap(found.first); // return the first response
    }

    return null;
  }

  // method to get List of All Countries from UserSavedCities
  Future<List<City>> queryAllCities() async {
    Database db = await database;
    List<Map> found = await db.query(citiesTable); // get Map for all responses
    if (found.length > 0) {
      // if result is non-empty
      List<City> cities = found
          ?.map((e) => e == null ? null : City.fromMap(e))
          ?.toList(); // convert map to List<City>
      return cities;
    }
    return null;
  }

  // method to delete a City from UserSavedCities
  Future<int> deleteCity(City city) async {
    Database db = await database;
    return db.delete(
      citiesTable,
      where: "$cityColumn=? AND $stateColumn=? AND $countryColumn=?",
      whereArgs: [city.city, city.state, city.country],
    ); // delete request
  }

  // method to count the cities in UserSavedCities
  Future<int> countCities() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $citiesTable"));
  }

  // method to clear UserSavedCities Database
  Future<int> deleteAllCities() async {
    Database db = await database;
    return db.delete(citiesTable);
  }
}
