import 'package:air_quality_app/resources/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherGradients {
  static const LinearGradient defaultGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(95, 114, 190, 1),
      Color.fromRGBO(153, 33, 232, 1),
    ],
  );
  static const LinearGradient clearSkyDay = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(95, 114, 190, 1),
      Color.fromRGBO(153, 33, 232, 1),
    ],
  );
  static const LinearGradient clearSkyNight = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(25, 23, 20, 1),
      Color.fromRGBO(34, 52, 174, 1),
    ],
  );
  static const LinearGradient fewCloudsDay = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(8, 126, 225, 1),
      Color.fromRGBO(5, 232, 186, 1),
    ],
  );
  static const LinearGradient fewCloudsNight = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(0, 159, 194, 1),
      Color.fromRGBO(13, 10, 11, 1),
    ],
  );
  static const LinearGradient rainDay = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(11, 171, 100, 1),
      Color.fromRGBO(59, 183, 143, 1),
    ],
  );
  static const LinearGradient rainNight = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(0, 0, 0, 1),
      Color.fromRGBO(22, 109, 59, 1),
    ],
  );
  static const LinearGradient scatteredClouds = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(215, 129, 106, 1),
      Color.fromRGBO(189, 79, 108, 1),
    ],
  );
  static const LinearGradient brokenClouds = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(246, 112, 98, 1),
      Color.fromRGBO(252, 82, 150, 1),
    ],
  );
  static const LinearGradient showerRain = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(134, 75, 162, 1),
      Color.fromRGBO(191, 58, 48, 1),
    ],
  );

  static LinearGradient gradientFromWeatherEnum(WeatherEnums enm) {
    if (enm == WeatherEnums.ClearSkyDay)
      return WeatherGradients.clearSkyDay;
    else if (enm == WeatherEnums.ClearSkyNight)
      return WeatherGradients.clearSkyNight;
    else if (enm == WeatherEnums.FewCloudsDay)
      return WeatherGradients.fewCloudsDay;
    else if (enm == WeatherEnums.FewCloudsNight)
      return WeatherGradients.fewCloudsNight;
    else if (enm == WeatherEnums.ScatteredClouds)
      return WeatherGradients.scatteredClouds;
    else if (enm == WeatherEnums.BrokenClouds)
      return WeatherGradients.brokenClouds;
    else if (enm == WeatherEnums.ShowerRain)
      return WeatherGradients.showerRain;
    else if (enm == WeatherEnums.RainDay)
      return WeatherGradients.rainDay;
    else if (enm == WeatherEnums.RainNight)
      return WeatherGradients.rainNight;
    else
      return WeatherGradients.clearSkyDay;
  }
}
