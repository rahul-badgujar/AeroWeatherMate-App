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
  static const LinearGradient hot = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(134, 75, 162, 1),
      Color.fromRGBO(191, 58, 48, 1),
    ],
  );
  static const LinearGradient clear = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(131, 234, 241, 1),
      Color.fromRGBO(99, 164, 255, 1),
    ],
  );
  static const LinearGradient storm = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(158, 118, 143, 1),
      Color.fromRGBO(159, 164, 196, 1),
    ],
  );
  static const LinearGradient cloudy = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(180, 144, 200, 1),
      Color.fromRGBO(142, 207, 205, 1),
    ],
  );
  static const LinearGradient fog = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(247, 154, 211, 1),
      Color.fromRGBO(200, 111, 201, 1),
    ],
  );
  static const LinearGradient sleet = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(139, 147, 154, 1),
      Color.fromRGBO(91, 100, 103, 1),
    ],
  );
  static const LinearGradient sandstorm = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(198, 146, 13, 1),
      Color.fromRGBO(208, 157, 31, 80),
    ],
  );
  static const LinearGradient tornado = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.2, 0.72],
    colors: [
      Color.fromRGBO(67, 48, 46, 1),
      Color.fromRGBO(173, 111, 105, 25),
    ],
  );
}
