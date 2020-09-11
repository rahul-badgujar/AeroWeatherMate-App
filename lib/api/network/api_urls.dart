import 'dart:core';

const String airVisualApiKey = "5a817b55-b3d4-4367-b6bd-8c0c36066a71";
String dataUsingCoordinatesUrl(
    {double latitude = 19.87758, double longitude = 73.97201}) {
  return "http://api.airvisual.com/v2/nearest_city?lat=$latitude&lon=$longitude&key=$airVisualApiKey";
}

String countriesListUrl() {
  return "http://api.airvisual.com/v2/countries?key=$airVisualApiKey";
}

String statesListInCountryUrl({String country = "India"}) {
  return "http://api.airvisual.com/v2/states?country=$country&key=$airVisualApiKey";
}

String citiesListInStateUrl(
    {String state = "Maharashtra", String country = "India"}) {
  return "http://api.airvisual.com/v2/cities?state=$state&country=$country&key=$airVisualApiKey";
}

String dataUsingCity(
    {String city = "Nashik",
    String state = "Maharashtra",
    String country = "India"}) {
  return "http://api.airvisual.com/v2/city?city=$city&state=$state&country=$country&key=$airVisualApiKey";
}
