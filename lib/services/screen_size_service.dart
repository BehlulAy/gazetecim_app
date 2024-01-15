// ignore_for_file: camel_case_types

import 'package:flutter/widgets.dart';

double screenHeight = 0.0;
double screenWidth = 0.0;

class screenSizeService {
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}
