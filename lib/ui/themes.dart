import 'package:flutter/material.dart';

// TextTheme of App
TextTheme getAppTextTheme(TextTheme base, {Color textColor = Colors.white}) {
  return base.copyWith(
    headline1: base.headline1.copyWith(),
    headline2: base.headline2.copyWith(
      color: textColor,
      fontSize: 56,
    ),
    headline3: base.headline3.copyWith(
      color: textColor,
      fontSize: 30,
    ),
    headline4: base.headline4.copyWith(
      color: textColor,
      fontSize: 27,
    ),
    headline5: base.headline5.copyWith(
      color: textColor,
      fontSize: 24,
    ),
    headline6: base.headline6.copyWith(
      color: textColor,
      fontSize: 21,
    ),
    subtitle1: base.subtitle1.copyWith(
      color: textColor,
      fontSize: 18,
    ),
    subtitle2: base.subtitle2.copyWith(
      color: textColor,
      fontSize: 15,
    ),
    bodyText2: base.bodyText2.copyWith(
      color: textColor,
      fontSize: 12,
    ),
  );
}

// Icon Theme for App
IconThemeData getAppIconTheme(IconThemeData base,
    {Color iconColor = Colors.white}) {
  return base.copyWith(
    color: iconColor,
    size: 28,
  );
}

// Floating Action Button Theme for App
FloatingActionButtonThemeData getAppFloatingActionsButtonTheme(
    FloatingActionButtonThemeData base,
    {Color backgroundColor = Colors.white}) {
  return base.copyWith(
    backgroundColor: backgroundColor,
  );
}

// App wide Theme
ThemeData getAppTheme(ThemeData base) {
  return base.copyWith(
    textTheme: getAppTextTheme(
      base.textTheme,
      textColor: Colors.white,
    ),
    iconTheme: getAppIconTheme(
      base.iconTheme,
      iconColor: Colors.white,
    ),
    floatingActionButtonTheme: getAppFloatingActionsButtonTheme(
      base.floatingActionButtonTheme,
      backgroundColor: Colors.white,
    ),
  );
}

ThemeData getAppThemeLight(ThemeData base) {
  return base.copyWith(
    textTheme: getAppTextTheme(
      base.textTheme,
      textColor: Colors.black,
    ),
    iconTheme: getAppIconTheme(
      base.iconTheme,
      iconColor: Colors.black,
    ),
    floatingActionButtonTheme: getAppFloatingActionsButtonTheme(
      base.floatingActionButtonTheme,
      backgroundColor: Colors.black,
    ),
  );
}
