// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:gazetecim_app/services/screen_size_service.dart';
import 'package:gazetecim_app/styles/colorsheet.dart';

class textFieldStyles {
  static var loginTextFieldDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0.7, color: ColorSheet.secondaryColor),
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0.7, color: ColorSheet.secondaryColor),
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0.7, color: ColorSheet.secondaryColor),
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    filled: true,
    fillColor: ColorSheet.secondaryDarkColor,
    contentPadding:
        EdgeInsets.symmetric(horizontal: 16, vertical: screenWidth / 10),
  );

  static var commentTextFieldDecoration = InputDecoration(
    hoverColor: ColorSheet.primaryColor,
    suffixIcon: IconButton(
      icon: Icon(
        Icons.send,
        color: ColorSheet.secondaryColor,
      ),
      onPressed: () {},
    ),
  );
}
