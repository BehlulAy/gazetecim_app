// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../styles/colorsheet.dart';
import 'package:google_fonts/google_fonts.dart';

class textStyles {
  static var boldTitleStyle = GoogleFonts.roboto(
    fontSize: 24,
    color: ColorSheet.textColor,
    fontWeight: FontWeight.bold,
  );
  static var regularTitleStyle = GoogleFonts.roboto(
    fontSize: 24,
    color: ColorSheet.textColor,
  );
  static var defaultTextStyle = GoogleFonts.roboto(
    fontSize: 20,
    color: ColorSheet.textColor,
  );
  static var alternativeTextStyle = GoogleFonts.roboto(
    fontSize: 16,
    color: ColorSheet.secondaryColor,
  );
  static var logoTextStyle = GoogleFonts.dmSerifDisplay(
    fontSize: 28,
    color: ColorSheet.textColor,
  );
}
