enum WeatherEnums {
  ClearSkyDay,
  ClearSkyNight,
  FewCloudsDay,
  FewCloudsNight,
  ScatteredClouds,
  BrokenClouds,
  ShowerRain,
  RainDay,
  RainNight
}

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

class Strings {
  static const String appName = "Air Quality App";
  static const String defaultTempScale = "C";
  static const String defaultPlaceName = "Sinnar";
  static const String defaultCity = "Nashik";
  static const String defaultState = "Maharashtra";
  static const String defaultCountry = "India";
  static const String defaultWeatherCode = "10d";
  static const String defaultMainUSPollutant = "o3";

  static WeatherEnums weatherEnumFromWeatherCode(String code) {
    if (code == "01d")
      return WeatherEnums.ClearSkyDay;
    else if (code == "01n")
      return WeatherEnums.ClearSkyNight;
    else if (code == "02d")
      return WeatherEnums.FewCloudsDay;
    else if (code == "02n")
      return WeatherEnums.FewCloudsNight;
    else if (code == "03d")
      return WeatherEnums.ScatteredClouds;
    else if (code == "04d")
      return WeatherEnums.BrokenClouds;
    else if (code == "09d")
      return WeatherEnums.ShowerRain;
    else if (code == "10d")
      return WeatherEnums.RainDay;
    else if (code == "10n")
      return WeatherEnums.RainNight;
    else
      return WeatherEnums.ClearSkyDay;
  }

  static String weatherStatusFromWeatherEnum(WeatherEnums enm) {
    if (enm == WeatherEnums.ClearSkyDay || enm == WeatherEnums.ClearSkyNight)
      return "Clear Sky";
    else if (enm == WeatherEnums.FewCloudsDay ||
        enm == WeatherEnums.FewCloudsNight)
      return "Few Clouds";
    else if (enm == WeatherEnums.ScatteredClouds)
      return "Scattered Clouds";
    else if (enm == WeatherEnums.BrokenClouds)
      return "Broken Clouds";
    else if (enm == WeatherEnums.ShowerRain)
      return "Shower Rain";
    else if (enm == WeatherEnums.RainDay || enm == WeatherEnums.RainNight)
      return "Raining Here";
    else
      return "Clear Sky";
  }
}

class Numbers {
  static const int defaultTemprature = 35;
  static const int defaultAtmPressure = 994;
  static const double defaultHumidity = 87;
  static const double defaultWindSpeed = 2;
  static const int defaultWindDirection = 239;
  static const int defaultAqiUS = 7;
  static const double defaultPollutantConcentration = 20;
  static const int defaultPollutionAqi = 18;
  static const double defaultWeatherIconSize = 30;
}
