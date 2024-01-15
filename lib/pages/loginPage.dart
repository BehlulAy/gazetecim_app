// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:gazetecim_app/pages/registerPage.dart';
import 'package:gazetecim_app/services/firebaseService.dart';
import 'package:gazetecim_app/services/screen_size_service.dart';
import 'package:gazetecim_app/styles/widget_styles.dart';
import 'package:gazetecim_app/styles/text_styles.dart';
import '../styles/colorsheet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseService firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSheet.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildLogo(),
            buildTextFields(),
            buildButtons(),
          ],
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
            navigateToHome();
          },
        ),
        WidgetStyles.secondaryButton(
          context,
          'Register',
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const registerPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  buildLogo() {
    return Container(
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
    );
  }

  navigateToHome() {
    if (mailController.text.isEmpty && passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Error on login'),
            content: Text('Please fill all the blank fields'),
          );
        },
      );
    } else {
      firebaseService.signInWithEmailAndPassword(
          mailController.text, passwordController.text, context);

      mailController.text = '';
      passwordController.text = '';
    }
  }

  buildTextFields() {
    return Column(
      children: [
        WidgetStyles.defaultTextField(
            'Mail', mailController, textStyles.defaultTextStyle, false),
        WidgetStyles.defaultTextField(
            'Password', passwordController, textStyles.defaultTextStyle, true),
      ],
    );
  }
}
