import 'package:flutter/material.dart';

class ResponsiveScreenshot {
  static late double screen_width;
  static late double screen_height;

  static void init(context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
  }
}
