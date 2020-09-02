import 'dart:core';

class ApiUrls {
  static const String airVisualApiKey = "5a817b55-b3d4-4367-b6bd-8c0c36066a71";
  static String nearestCityDataUrl(
      {double lattitude = 19.87758, double longitude = 73.97201}) {
    return "http://api.airvisual.com/v2/nearest_city?lat=${lattitude}&lon=${longitude}&key=${airVisualApiKey}";
  }
}
