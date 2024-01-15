// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gazetecim_app/styles/widget_styles.dart';
import 'package:gazetecim_app/styles/colorsheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSheet.backgroundColor,
      appBar: WidgetStyles.defaultAppBar('Profile Page', context),
      bottomNavigationBar: WidgetStyles.defaultBottomAppBar(context),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetStyles.addProfilePhoto(),
              WidgetStyles.profileDetails(context),
            ],
          ),
        ],
      ),
    );
  }
}
