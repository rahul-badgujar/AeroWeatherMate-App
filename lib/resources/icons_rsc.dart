import 'package:air_quality_app/resources/constants.dart';
import 'package:air_quality_app/resources/weather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIcons {
  static Icon aqiLeafIcon({Color color = Colors.white, double size = 10.0}) {
    return Icon(
      Icons.eco,
      color: color,
      size: size,
    );
  }

  static Icon downKeyIcon({Color color = Colors.white, double size = 10.0}) {
    return Icon(
      Icons.keyboard_arrow_down,
      color: color,
      size: size,
    );
  }

  static Icon clearSkyDayIcon(
      {Color color = Colors.white,
      double size = Numbers.defaultWeatherIconSize}) {
    return Icon(
      Weather.sun_inv,
      color: color,
      size: size,
    );
  }

  static Icon clearSkyNightIcon(
      {Color color = Colors.white,
      double size = Numbers.defaultWeatherIconSize}) {
    return Icon(
      Weather.moon_inv,
      color: color,
      size: size,
    );
  }

  static Icon fewCloudsDayIcon(
      {Color color = Colors.white,
      double size = Numbers.defaultWeatherIconSize}) {
    return Icon(
      Weather.cloud_sun_inv,
      color: color,
      size: size,
    );
  }

  static Icon fewCloudsNightIcon(
      {Color color = Colors.white,
      double size = Numbers.defaultWeatherIconSize}) {
    return Icon(
      Weather.cloud_moon_inv,
      color: color,
      size: size,
    );
  }

  static Icon scatteredCloudsIcon(
      {Color color = Colors.white,
      double size = Numbers.defaultWeatherIconSize}) {
    return Icon(
      Weather.clouds_flash_inv,
      color: color,
      size: size,
    );
  }

  static Icon brokenCloudsIcon(
      {Color color = Colors.white,
      double size = Numbers.defaultWeatherIconSize}) {
    return Icon(
      Weather.cloud_inv,
      color: color,
      size: size,
    );
  }

  static Icon showerRainIcon(
      {Color color = Colors.white,
      double size = Numbers.defaultWeatherIconSize}) {
    return Icon(
      Weather.rain_inv,
      color: color,
      size: size,
    );
  }

  static Icon rainIcon(
      {Color color = Colors.white,
      double size = Numbers.defaultWeatherIconSize}) {
    return Icon(
      Weather.hail_inv,
      color: color,
      size: size,
    );
  }

  static Icon iconFromWeatherEnum(WeatherEnums enm) {
    if (enm == WeatherEnums.ClearSkyDay)
      return AppIcons.clearSkyDayIcon();
    else if (enm == WeatherEnums.ClearSkyNight)
      return AppIcons.clearSkyNightIcon();
    else if (enm == WeatherEnums.FewCloudsDay)
      return AppIcons.fewCloudsDayIcon();
    else if (enm == WeatherEnums.FewCloudsNight)
      return AppIcons.fewCloudsNightIcon();
    else if (enm == WeatherEnums.ScatteredClouds)
      return AppIcons.scatteredCloudsIcon();
    else if (enm == WeatherEnums.BrokenClouds)
      return AppIcons.brokenCloudsIcon();
    else if (enm == WeatherEnums.ShowerRain)
      return AppIcons.showerRainIcon();
    else if (enm == WeatherEnums.RainDay || enm == WeatherEnums.RainNight)
      return AppIcons.rainIcon();
    else
      return AppIcons.clearSkyDayIcon();
  }
}
