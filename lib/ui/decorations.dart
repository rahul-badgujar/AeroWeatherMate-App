import 'package:air_quality_app/resources/gradients_rsc.dart';
import 'package:flutter/material.dart';

class AppDecorations {
  static Decoration blurRoundBox() {
    return BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 200),
      borderRadius: BorderRadius.circular(16),
    );
  }

  static Decoration gradientBox(
      {Gradient gradientTOFill = AppGradients.defaultGradient}) {
    return BoxDecoration(
      gradient: gradientTOFill == null
          ? AppGradients.defaultGradient
          : gradientTOFill,
    );
  }
}
