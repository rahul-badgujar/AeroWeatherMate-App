import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:air_quality_app/resources/constants.dart' as consts;

const String citiesTable = "CitiesTable";
const String userLoadedCitiesTable = "UserLoadedCitiesTable";
const String userLoadedStatesTable = "UserLoadedStatesTable";
const String userLoadedCountriesTable = "UserLoadedCountriesTable";
const String cityColumn = "City";
const String stateColumn = "State";
const String countryColumn = "Country";

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

class DatabaseHelper {
  static const String _databaseName = "ApiSavedData.db";
  static const int _databaseVersion = 1;
  static const int ERROR_CITY_ALREADY_PRESENT = -23;
  static const int ERROR_MAX_CITIES_LIMIT_REACHED = -24;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper _instace = DatabaseHelper._privateConstructor();
  factory DatabaseHelper() {
    return _instace;
  }

  static Database _database;
  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

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

  Future<int> insertCity(City city) async {
    Database db = await database;
    if (await queryCity(city) != null) {
      return DatabaseHelper.ERROR_CITY_ALREADY_PRESENT;
    }
    if (await countCities() >= consts.Numbers.maxAllowedCities) {
      return DatabaseHelper.ERROR_MAX_CITIES_LIMIT_REACHED;
    }
    int id = await db.insert(citiesTable, city.toMap());
    return id;
  }

  Future<void> saveUserLoadedCountries(List<Country> countries) async {
    Database db = await database;
    Batch batch = db.batch();
    for (Country country in countries) {
      batch.insert(userLoadedCountriesTable, country.toMap());
    }
    await batch.commit(noResult: true);
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
      batch.insert(userLoadedStatesTable, city.toMap());
    }
    await batch.commit();
    print("User Loaded Cities saved");
  }

  Future<List<Country>> retrieveUserLoadedCountries() async {
    Database db = await database;
    List<Map> found =
        await db.query(userLoadedCountriesTable) ?? <String, dynamic>{};
    if (found.length > 0) {
      List<Country> countriesLoaded =
          found?.map((e) => e == null ? null : Country.fromMap(e))?.toList();
      print("User Loaded Countries Retrieved  : $countriesLoaded");
      return countriesLoaded;
    }
    print("No User Loaded Countries Retrieved");
    return null;
  }

  Future<List<State>> retrieveUserLoadedStates(Country whereCountry) async {
    Database db = await database;
    List<Map> found = await db.query(
          userLoadedStatesTable,
          where: "$countryColumn=?",
          whereArgs: [whereCountry.country],
        ) ??
        <String, dynamic>{};
    if (found.length > 0) {
      List<State> statesLoaded =
          found?.map((e) => e == null ? null : State.fromMap(e))?.toList();
      print("User Loaded States Retrieved  : $statesLoaded");
      return statesLoaded;
    }
    print("No User Loaded States Retrieved");
    return null;
  }

  Future<List<City>> retrieveUserLoadedCities(State whereState) async {
    Database db = await database;
    List<Map> found = await db.query(
          userLoadedCitiesTable,
          where: "$stateColumn=? AND $countryColumn=?",
          whereArgs: [whereState.state, whereState.country],
        ) ??
        <String, dynamic>{};
    if (found.length > 0) {
      List<City> citiesLoaded =
          found?.map((e) => e == null ? null : City.fromMap(e))?.toList();
      print("User Loaded Cities Retrieved  : $citiesLoaded");
      return citiesLoaded;
    }
    print("No User Loaded Cities Retrieved");
    return null;
  }

  Future<City> queryCity(City city) async {
    Database db = await database;
    List<Map> found = await db.query(
      citiesTable,
      columns: [cityColumn, stateColumn, countryColumn],
      where: "$cityColumn=? AND $stateColumn=? AND $countryColumn=?",
      whereArgs: [city.city, city.state, city.country],
    );
    if (found.length > 0) {
      return City.fromMap(found.first);
    }

    return null;
  }

  Future<List<City>> queryAllCities() async {
    Database db = await database;
    List<Map> found = await db.query(citiesTable);
    if (found.length > 0) {
      List<City> cities =
          found?.map((e) => e == null ? null : City.fromMap(e))?.toList();
      return cities;
    }
    return null;
  }

  Future<int> deleteCity(City city) async {
    Database db = await database;
    return db.delete(
      citiesTable,
      where: "$cityColumn=? AND $stateColumn=? AND $countryColumn=?",
      whereArgs: [city.city, city.state, city.country],
    );
  }

  Future<int> countCities() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $citiesTable"));
  }

  Future<int> deleteAllCities() async {
    Database db = await database;
    return db.delete(citiesTable);
  }
}
