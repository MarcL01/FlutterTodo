import 'package:flutter/material.dart';

class ColorChoice {
  ColorChoice({@required this.primary, @required this.gradient});

  final Color primary;
  final List<Color> gradient;
}

class ColorChoices {
  static List<ColorChoice> choices = [
    ColorChoice(
      primary: Color(0xFFF77B67),
      gradient: [
        Color.fromRGBO(245, 68, 113, 1.0),
        Color.fromRGBO(245, 161, 81, 1.0),
      ],
    ),
    ColorChoice(
      primary: Color(0xFF5A89E6),
      gradient: [
        Color.fromRGBO(77, 85, 225, 1.0),
        Color.fromRGBO(93, 167, 231, 1.0),
      ],
    ),
    ColorChoice(
      primary: Color(0xFF4EC5AC),
      gradient: [
        Color.fromRGBO(61, 188, 156, 1.0),
        Color.fromRGBO(61, 212, 132, 1.0),
      ],
    ),
  ];
}
