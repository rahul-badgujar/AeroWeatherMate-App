import 'dart:convert';
import 'dart:io';
import 'package:air_quality_app/api/exceptions/api_exceptions.dart';
import 'package:air_quality_app/services/database_helpers.dart';
import 'package:location/location.dart';
import 'package:air_quality_app/api/network/api_urls.dart' as url;
import 'package:air_quality_app/api/data_models/air_visual_data.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient._privateConstructor();
  static final HttpClient _instance = HttpClient._privateConstructor();
  factory HttpClient() {
    return _instance;
  }

  Future<AirVisualData> fetchcurrentAirVisualDataUsingCoordinates(
      LocationData location) async {
    String apiRequestUrl = url.dataUsingCoordinatesUrl(
        latitude: location.latitude, longitude: location.longitude);
    try {
      final http.Response response = await http.get(apiRequestUrl);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        if (response.body.isEmpty)
          throw EmptyApiResultException();
        else {
          //print(response.body);
          AirVisualData data =
              AirVisualData.fromJson(json.decode(response.body));
          return data;
        }
      } else {
        _handleExceptions(statusCode);
      }
    } on Exception catch (exception) {
      if (exception is SocketException)
        print(ConnectionException().toString());
      else if (exception is ApiException) print(exception.toString());
    }
    return null;
  }

  Future<AirVisualData> fetchcurrentAirVisualDataUsingAreaDetails(
      City cityDetails) async {
    String apiRequestUrl = url.dataUsingCity(
        city: cityDetails.city,
        state: cityDetails.state,
        country: cityDetails.country);
    try {
      final http.Response response = await http.get(apiRequestUrl);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        if (response.body.isEmpty)
          throw EmptyApiResultException();
        else {
          //print(response.body);
          AirVisualData data =
              AirVisualData.fromJson(json.decode(response.body));

          return data;
        }
      } else {
        _handleExceptions(statusCode);
      }
    } on Exception catch (exception) {
      if (exception is SocketException)
        print(ConnectionException().toString());
      else if (exception is ApiException) print(exception.toString());
    }
    return null;
  }

  Future<List<Country>> fetchListOfCountries() async {
    String apiRequestUrl = url.countriesListUrl();
    try {
      final http.Response response = await http.get(apiRequestUrl);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        if (response.body.isEmpty)
          throw EmptyApiResultException();
        else {
          //print(response.body);
          Map<String, dynamic> jsonData = json.decode(response.body);
          List<dynamic> list = (jsonData["data"] as List)
              ?.map((e) => e == null ? null : e["country"])
              ?.toList();
          List<String> countriesStringList = list.cast<String>().toList();
          List<Country> countriesList = countriesStringList
              ?.map((e) => e == null ? null : Country.fromString(e));
          return countriesList;
        }
      } else {
        _handleExceptions(statusCode);
      }
    } on Exception catch (exception) {
      if (exception is SocketException)
        print(ConnectionException().toString());
      else if (exception is ApiException) print(exception.toString());
    }
    return null;
  }

  Future<List<State>> fetchListOfStatesFromCountry({String country}) async {
    String apiRequestUrl = url.statesListInCountryUrl(country: country);
    try {
      final http.Response response = await http.get(apiRequestUrl);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        if (response.body.isEmpty)
          throw EmptyApiResultException();
        else {
          //print(response.body);
          Map<String, dynamic> jsonData = json.decode(response.body);
          List<dynamic> list = (jsonData["data"] as List)
              ?.map((e) => e == null ? null : e["state"])
              ?.toList();
          List<String> statesStringList = list.cast<String>().toList();
          List<State> statesList = statesStringList
              ?.map((e) => e == null ? null : State.fromString("$e&$country"));
          return statesList;
        }
      } else {
        _handleExceptions(statusCode);
      }
    } on Exception catch (exception) {
      if (exception is SocketException)
        print(ConnectionException().toString());
      else if (exception is ApiException) print(exception.toString());
    }
    return null;
  }

  Future<List<City>> fetchListOfCitiesInState(
      {String state, String country}) async {
    String apiRequestUrl =
        url.citiesListInStateUrl(state: state, country: country);
    try {
      final http.Response response = await http.get(apiRequestUrl);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        if (response.body.isEmpty)
          throw EmptyApiResultException();
        else {
          //print(response.body);
          Map<String, dynamic> jsonData = json.decode(response.body);
          List<dynamic> list = (jsonData["data"] as List)
              ?.map((e) => e == null ? null : e["city"])
              ?.toList();
          List<String> citiesStringList = list.cast<String>().toList();
          List<City> citiesList = citiesStringList?.map(
              (e) => e == null ? null : City.fromString("$e&$state&$country"));
          return citiesList;
        }
      } else {
        _handleExceptions(statusCode);
      }
    } on Exception catch (exception) {
      if (exception is SocketException)
        print(ConnectionException().toString());
      else if (exception is ApiException) print(exception.toString());
    }
    return null;
  }

  void _handleExceptions(int statusCode) {
    print("Error in Fetching Data : " + statusCode.toString());
    final int errorType = statusCode % 100;
    if (errorType == 3)
      throw RedirectionalApiException();
    else if (errorType == 4)
      throw ClientSideErrorApiException();
    else if (errorType == 5)
      throw ServerSideApiException();
    else
      throw UnknownApiException();
  }
}
