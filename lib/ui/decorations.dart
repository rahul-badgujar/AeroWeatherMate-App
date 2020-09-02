import 'package:flutter/material.dart';

class AppDecorations {
  static Decoration blurRoundBox() {
    return BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 180),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
