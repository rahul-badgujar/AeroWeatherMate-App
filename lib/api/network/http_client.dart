import 'dart:convert';
import 'dart:io';
import 'package:air_quality_app/api/exceptions/api_exceptions.dart';
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

  Future<AirVisualData> fetchAirVisualDataUsingCoordinates(
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
          print(response.body);
          AirVisualData data =
              AirVisualData.fromJson(json.decode(response.body));
          print("Successful API Call : " + data.toString());
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

  Future<List<String>> fetchListOfCountries() async {
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
          List<String> countriesList = list.cast<String>().toList();
          print(countriesList);
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

  Future<List<String>> fetchListOfStatesFromCountry({String country}) async {
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
          List<String> statesList = list.cast<String>().toList();
          print(statesList);
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

  Future<List<String>> fetchListOfCitiesInState(
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
          List<String> citiesList = list.cast<String>().toList();
          print(citiesList);
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
