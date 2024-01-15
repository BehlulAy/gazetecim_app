// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:gazetecim_app/styles/colorsheet.dart';

class buttonStyles {
  static var primaryButtonStyle = BoxDecoration(
    color: ColorSheet.primaryColor,
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  );

  static var secondaryButtonStyle = BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    border: Border.all(color: Colors.white, width: 3),
  );
}
