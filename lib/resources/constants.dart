import 'package:flutter/material.dart';

class Strings {
  static const String appName = "AeroWeatherMate";
  static const String defaultTempScale = "C";
  static const String defaultPlaceName = "Sinnar";
  static const String defaultCity = "Nashik";
  static const String defaultState = "Maharashtra";
  static const String defaultCountry = "India";
  static const String defaultWeatherCode = "10d";
  static const String defaultMainUSPollutant = "o3";
}

class Numbers {
  static const double boxRadius = 24.0;
  static const int maxAllowedCities = 5;
  static const double smoothControllerDot_dim = 6;
  static const double bigSvgIconDim = 56;
}

class Paddings {
  static const EdgeInsets paddingAll = const EdgeInsets.all(12);
  static const EdgeInsets pageContentsPadding =
      const EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets paddingSym =
      const EdgeInsets.symmetric(horizontal: 8, vertical: 16);
  static const EdgeInsets formFieldPadding =
      const EdgeInsets.symmetric(horizontal: 4, vertical: 8);
  static const EdgeInsets smallTextPadding =
      const EdgeInsets.symmetric(vertical: 4);
}

class Margins {
  static const EdgeInsets rectMargin =
      const EdgeInsets.symmetric(horizontal: 6, vertical: 6);
  static const EdgeInsets bigListTileMargin =
      const EdgeInsets.symmetric(vertical: 4);
}

class Colours {
  static const Color circleProgressIndicatorBgColor = Colors.white;
}

enum HomePagePopupMenuButtons { manage_cities, credits }

String airQualityFromAqi(int aqi) {
  if (0 <= aqi && aqi <= 50)
    return "Good Air";
  else if (51 <= aqi && aqi <= 100)
    return "Moderate Air";
  else if (101 <= aqi && aqi <= 150)
    return "Bad Air";
  else if (151 <= aqi && aqi <= 200)
    return "Unhealthy Air";
  else if (201 <= aqi && aqi <= 300)
    return "Very Unhealthy Air";
  else
    return "Hazardous Air";
}

String weatherStatusFromWeatherStatusCode(String code) {
  if (code == "01d" || code == "01n")
    return "Clear Sky";
  else if (code == "02d" || code == "02n")
    return "Few Clouds";
  else if (code == "03d" || code == "03n")
    return "Scattered Clouds";
  else if (code == "04d" || code == "04n")
    return "Broken Clouds";
  else if (code == "09d" || code == "09n")
    return "Shower Rain";
  else if (code == "10d" || code == "10n")
    return "Rain";
  else if (code == "11d" || code == "11n")
    return "Thunderstorm";
  else if (code == "13d" || code == "13n")
    return "Snow";
  else if (code == "50d" || code == "15n")
    return "Mist";
  else
    return "Clear Sky";
}

String windDirectionFromAngle(int angle) {
  if (315 < angle || angle < 45)
    return "NORTH";
  else if (135 < angle || angle < 225)
    return "SOUTH";
  else if (45 <= angle || angle <= 135)
    return "EAST";
  else if (225 <= angle || angle <= 315)
    return "WEST";
  else
    return "NORTH";
}

String pollutantFromCode(String code) {
  if (code == "p1")
    return "pm2.5";
  else if (code == "p2")
    return "pm10";
  else if (code == "n2")
    return "NO2";
  else if (code == "o3")
    return "O3";
  else if (code == "s2")
    return "SO2";
  else if (code == "co")
    return "CO";
  else
    return "SO2";
}

String updateStatusFromTimeStamp(String timeStamp) {
  final String year = timeStamp.substring(0, 4);
  final String month = timeStamp.substring(5, 7);
  final String day = timeStamp.substring(8, 10);
  final String hours = timeStamp.substring(11, 13);
  final String minutes = timeStamp.substring(14, 16);
  return "$hours:$minutes , $day-$month-$year";
}
