import 'dart:convert';
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
    final http.Response response = await http.get(apiRequestUrl);
    if (response.statusCode == 200) {
      return AirQualityData.fromJson(json.decode(response.body));
    } else {
      print("Error in Fetching Data : " + response.statusCode.toString());
    }
  }
}
