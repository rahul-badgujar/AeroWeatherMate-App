import 'package:flutter/material.dart';

TextTheme getAppTextTheme(TextTheme base) {
  return base.copyWith(
    headline1: base.headline1.copyWith(),
    headline2: base.headline2.copyWith(),
    headline3: base.headline3.copyWith(),
    headline4: base.headline4.copyWith(),
    headline5: base.headline5.copyWith(),
    headline6: base.headline6.copyWith(),
    subtitle1: base.subtitle1.copyWith(),
    subtitle2: base.subtitle2.copyWith(),
  );
}

IconThemeData getAppIconTheme(IconThemeData base) {
  return base.copyWith();
}

ThemeData getAppTheme(ThemeData base) {
  return base.copyWith(
    textTheme: getAppTextTheme(base.textTheme),
    iconTheme: getAppIconTheme(base.iconTheme),
  );
}
