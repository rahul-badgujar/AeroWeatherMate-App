import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient defaultGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    //stops: [0.1, 0.72],
    colors: [
      Color.fromRGBO(246, 112, 98, 1),
      Color.fromRGBO(252, 82, 150, 1),
    ],
  );
}
