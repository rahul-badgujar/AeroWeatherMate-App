import 'dart:convert';

import 'package:air_quality_app/api/data/air_quality_data.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  HttpClient._privateConstructor();
  static final HttpClient _instance = HttpClient._privateConstructor();
  factory HttpClient() {
    return _instance;
  }
  Future<dynamic> fetchData(String url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      AirQualityData toReturn =
          AirQualityData.fromJson(json.decode(response.body));
      print("Success : " + toReturn.toString());
      return toReturn;
    } else {
      print("Error in Fetching Data : " + response.statusCode.toString());
    }
  }
}
