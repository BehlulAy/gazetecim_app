// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gazetecim_app/pages/loginPage.dart';
import 'package:gazetecim_app/services/firebaseService.dart';
import 'package:gazetecim_app/services/screen_size_service.dart';
import 'package:gazetecim_app/styles/text_styles.dart';
import 'package:gazetecim_app/styles/widget_styles.dart';
import '../styles/colorsheet.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  FirebaseService firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSheet.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  width: screenWidth / 2.5,
                  height: screenWidth / 2.5,
                  child: Column(
                    children: [
                      Icon(
                        Icons.newspaper,
                        size: screenWidth / 6,
                        color: ColorSheet.primaryColor,
                      ),
                      Text(
                        'Gazetecim',
                        style: textStyles.logoTextStyle,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    buildTextFields(),
                  ],
                ),
                buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildButtons() {
    return Column(
      children: [
        WidgetStyles.primaryButton(
          context,
          'Login',
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
        WidgetStyles.secondaryButton(
          context,
          'Register',
          () {
            if (mailController.text.isEmpty ||
                passwordController.text.isEmpty ||
                usernameController.text.isEmpty) {
              Fluttertoast.showToast(
                msg: "These fields cannot be empty!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              firebaseService.createUserWithEmailAndPassword(
                  mailController.value.text,
                  usernameController.value.text,
                  passwordController.value.text,
                  context);

              mailController.text = '';
              passwordController.text = '';
              usernameController.text = '';
            }
          },
        ),
      ],
    );
  }

  buildTextFields() {
    return Column(
      children: [
        WidgetStyles.defaultTextFieldWithCounter(
            'Username', usernameController, textStyles.defaultTextStyle, 24),
        WidgetStyles.defaultTextField(
            'Mail', mailController, textStyles.defaultTextStyle, false),
        WidgetStyles.defaultTextField(
            'Password', passwordController, textStyles.defaultTextStyle, true),
      ],
    );
  }
}
