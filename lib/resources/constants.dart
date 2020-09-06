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
