import 'package:air_quality_app/resources/constants.dart';
import 'package:air_quality_app/resources/weather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIcons {
  static const Icon aqiLeaf = Icon(
    Icons.eco,
    color: Colors.white,
  );
  static const Icon downKey = Icon(
    Icons.keyboard_arrow_down,
    color: Colors.white,
  );
  static const Icon clearSkyDay = Icon(
    Weather.sun_inv,
    color: Colors.white,
  );
  static const Icon clearSkyNight = Icon(
    Weather.moon_inv,
    color: Colors.white,
  );
  static const fewCloudsDay = Icon(
    Weather.cloud_sun_inv,
    color: Colors.white,
  );
  static const fewCloudNight = Icon(
    Weather.cloud_moon_inv,
    color: Colors.white,
  );
  static const scatteredClouds = Icon(
    Weather.clouds_flash_inv,
    color: Colors.white,
  );
  static const brokenClouds = Icon(
    Weather.cloud_inv,
    color: Colors.white,
  );
  static const showerRain = Icon(
    Weather.rain_inv,
    color: Colors.white,
  );

  static const rain = Icon(
    Weather.hail_inv,
    color: Colors.white,
  );

  static Icon iconFromWeatherEnum(WeatherEnums enm) {
    if (enm == WeatherEnums.ClearSkyDay)
      return AppIcons.clearSkyDay;
    else if (enm == WeatherEnums.ClearSkyNight)
      return AppIcons.clearSkyNight;
    else if (enm == WeatherEnums.FewCloudsDay)
      return AppIcons.fewCloudsDay;
    else if (enm == WeatherEnums.FewCloudsNight)
      return AppIcons.fewCloudNight;
    else if (enm == WeatherEnums.ScatteredClouds)
      return AppIcons.scatteredClouds;
    else if (enm == WeatherEnums.BrokenClouds)
      return AppIcons.brokenClouds;
    else if (enm == WeatherEnums.ShowerRain)
      return AppIcons.showerRain;
    else if (enm == WeatherEnums.RainDay || enm == WeatherEnums.RainNight)
      return AppIcons.rain;
    else
      return AppIcons.clearSkyDay;
  }
}
