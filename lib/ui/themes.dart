import 'package:flutter/material.dart';

// TextTheme of App
TextTheme getAppTextTheme(TextTheme base) {
  return base.copyWith(
    headline1: base.headline1.copyWith(),
    headline2: base.headline2.copyWith(
      color: Colors.white,
      fontSize: 56,
    ),
    headline3: base.headline3.copyWith(),
    headline4: base.headline4.copyWith(),
    headline5: base.headline5.copyWith(
      color: Colors.white,
      fontSize: 24,
    ),
    headline6: base.headline6.copyWith(
      color: Colors.white,
      fontSize: 21,
    ),
    subtitle1: base.subtitle1.copyWith(
      color: Colors.white,
      fontSize: 18,
    ),
    subtitle2: base.subtitle2.copyWith(
      color: Colors.white,
      fontSize: 15,
    ),
    bodyText2: base.bodyText2.copyWith(
      color: Colors.white,
      fontSize: 12,
    ),
  );
}

// Icon Theme for App
IconThemeData getAppIconTheme(IconThemeData base) {
  return base.copyWith(
    color: Colors.white,
    size: 28,
  );
}

// Floating Action Button Theme for App
FloatingActionButtonThemeData getAppFloatingActionsButtonTheme(
    FloatingActionButtonThemeData base) {
  return base.copyWith(
    backgroundColor: Colors.white,
  );
}

// App wide Theme
ThemeData getAppTheme(ThemeData base) {
  return base.copyWith(
    textTheme: getAppTextTheme(base.textTheme),
    iconTheme: getAppIconTheme(base.iconTheme),
    floatingActionButtonTheme:
        getAppFloatingActionsButtonTheme(base.floatingActionButtonTheme),
  );
}
