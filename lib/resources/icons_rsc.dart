import 'package:air_quality_app/resources/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String weatherIconPathFromWeatherCode(String code) {
  print(code);
  if (code == "01d")
    return "assets/svg/clear_day.svg";
  else if (code == "01n")
    return "assets/svg/clear_night.svg";
  else if (code == "02d" || code == "02n")
    return "assets/svg/few_clouds.svg";
  else if (code == "03d" || code == "03n")
    return "assets/svg/scattered_clouds.svg";
  else if (code == "04d" || code == "04n")
    return "assets/svg/broken_clouds.svg";
  else if (code == "09d" || code == "09n")
    return "assets/svg/shower.svg";
  else if (code == "10d" || code == "10n")
    return "assets/svg/rain.svg";
  else
    return "assets/svg/rain.svg";
}

String pollutionIconPathFromAqi(int aqi) {
  if (0 <= aqi && aqi <= 50)
    return "assets/svg/aqi_0_50.svg";
  else if (51 <= aqi && aqi <= 100)
    return "assets/svg/aqi_51_100.svg";
  else if (101 <= aqi && aqi <= 150)
    return "assets/svg/aqi_101_150.svg";
  else if (151 <= aqi && aqi <= 200)
    return "assets/svg/aqi_151_200.svg";
  else if (201 <= aqi && aqi <= 300)
    return "assets/svg/aqi_201_300.svg";
  else
    return "assets/svg/aqi_300_plus.svg";
}
