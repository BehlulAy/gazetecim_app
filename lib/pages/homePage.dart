// ignore_for_file: camel_case_types, file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazetecim_app/services/screen_size_service.dart';

import '../styles/colorsheet.dart';
import '../styles/widget_styles.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int selectedCategory = 1;
  WidgetStyles widgetStyles = WidgetStyles();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetStyles.defaultAppBar('Home Page', context),
      bottomNavigationBar: WidgetStyles.defaultBottomAppBar(context),
      backgroundColor: ColorSheet.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: screenHeight / 1.4,
              child: ListView(
                shrinkWrap: true,
                children: [
                  widgetStyles.buildNewsStream(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
