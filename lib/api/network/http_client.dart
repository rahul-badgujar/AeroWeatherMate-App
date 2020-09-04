import 'dart:convert';
import 'dart:io';
import 'package:air_quality_app/api/exceptions/api_exceptions.dart';
import 'package:geolocator/geolocator.dart';

import 'api_urls.dart';
import 'package:air_quality_app/api/data/air_quality_data.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient._privateConstructor();
  static final HttpClient _instance = HttpClient._privateConstructor();
  factory HttpClient() {
    return _instance;
  }

  Future<AirQualityData> fetchAirQualityData(Position location) async {
    String apiRequestUrl = ApiUrls.nearestCityDataUrl(
        latitude: location.latitude, longitude: location.longitude);
    try {
      final http.Response response = await http.get(apiRequestUrl);
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        if (response.body.isEmpty)
          throw EmptyApiResultException();
        else {
          AirQualityData data =
              AirQualityData.fromJson(json.decode(response.body));
          print("Successful API Call : " + data.toString());
          return data;
        }
      } else {
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
    } on Exception catch (exception) {
      if (exception is SocketException)
        print(ConnectionException().toString());
      else if (exception is ApiException) print(exception.toString());
      return AirQualityData();
    }
  }
}
