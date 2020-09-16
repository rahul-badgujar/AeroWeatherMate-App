import 'package:air_quality_app/resources/gradients_rsc.dart' as gradients;
import 'package:flutter/material.dart';
import 'package:air_quality_app/resources/constants.dart' as constants;

class AppDecorations {
  static Decoration blurRoundBox() {
    return BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 210),
      borderRadius: BorderRadius.circular(constants.Numbers.boxRadius),
    );
  }

  static Decoration gradientBox(
      {Gradient gradientTOFill = gradients.AppGradients.defaultGradient}) {
    return BoxDecoration(
      gradient: gradientTOFill == null
          ? gradients.AppGradients.defaultGradient
          : gradientTOFill,
    );
  }
}
