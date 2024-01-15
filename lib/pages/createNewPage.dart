// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:gazetecim_app/styles/text_styles.dart';
import 'package:gazetecim_app/styles/widget_styles.dart';

import '../styles/colorsheet.dart';

class createNewPage extends StatefulWidget {
  const createNewPage({super.key});

  @override
  State<createNewPage> createState() => _createNewPageState();
}

class _createNewPageState extends State<createNewPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController newsTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: WidgetStyles.defaultAppBar('Create New Page', context),
      bottomNavigationBar: WidgetStyles.defaultBottomAppBar(context),
      backgroundColor: ColorSheet.backgroundColor,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                WidgetStyles.defaultTextFieldWithCounter(
                    'Title', titleController, textStyles.defaultTextStyle, 45),
                WidgetStyles.buildDropDownButton(
                    ['Eğlence', 'Yaşam', 'Category 3']),
                const SizedBox(height: 8),
                WidgetStyles.secondaryButton(context, 'Upload Picture', () {}),
                const SizedBox(height: 8),
                WidgetStyles.newsTextField('hintText', newsTextFieldController,
                    textStyles.defaultTextStyle),
                WidgetStyles.primaryButton(context, 'Submit', () {})
              ],
            ),
          ],
        ),
      ),
    );
  }
}// popup, canın projesi
