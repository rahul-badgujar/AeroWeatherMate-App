import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String citiesTable = "CitiesTable";
const String idColumn = "ID";
const String cityColumn = "City";
const String stateColumn = "State";
const String countryColumn = "Country";

class City {
  int id;
  final String city;
  final String state;
  final String country;

  City(
      {this.id = null,
      this.city = null,
      this.state = null,
      this.country = null});

  factory City.fromString(String str) {
    List<String> details = str.split("&");
    City city = City(city: details[0], state: details[1], country: details[2]);
    return city;
  }

  factory City.fromMap(Map<String, dynamic> map) {
    City city = City(
      id: map[idColumn],
      city: map[cityColumn],
      state: map[stateColumn],
      country: map[countryColumn],
    );
    return city;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      cityColumn: city,
      stateColumn: state,
      countryColumn: country,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "$city&$state$country";
  }
}

class DatabaseHelper {
  static const String _databaseName = "CitiesSaved.db";
  static const int _databaseVersion = 1;

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
    return db.execute('''
      CREATE TABLE $citiesTable (
        $idColumn int PRIMARY KEY,
        $cityColumn varchar(255) NOT NULL,
        $stateColumn varchar(255) NOT NULL,
        $countryColumn varchar(255) NOT NULL
      )
      ''');
  }

  Future<int> insertCity(City city) async {
    Database db = await database;
    if (await queryCity(city) == null) {
      int id = await db.insert(citiesTable, city.toMap());
      return id;
    }
    return -1;
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
    ;
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

  Future<int> deleteAllCities() async {
    Database db = await database;
    return db.delete(citiesTable);
  }
}
