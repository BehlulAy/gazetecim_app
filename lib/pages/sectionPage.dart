// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazetecim_app/services/screen_size_service.dart';
import 'package:gazetecim_app/styles/colorsheet.dart';
import 'package:gazetecim_app/styles/widget_styles.dart';

class SectionPage extends StatefulWidget {
  final String articleId;

  const SectionPage({Key? key, required this.articleId}) : super(key: key);

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  late final String articleId;

  @override
  void initState() {
    super.initState();
    articleId = widget.articleId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSheet.backgroundColor,
      bottomNavigationBar: WidgetStyles.defaultBottomAppBar(context),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth / 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('articles')
                        .doc(articleId)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Article not found');
                      }

                      final articleData =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Column(
                        children: [
                          WidgetStyles.buildBannerPhoto(
                              articleData['bannerUrl']),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('articles')
                                .doc(articleId)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(); // Return an empty container while loading.
                              }

                              if (!snapshot.hasData) {
                                return const Text('Article not found');
                              }

                              final articleData =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              return FutureBuilder<Widget>(
                                future: WidgetStyles.buildSections(
                                  articleData['title'],
                                  articleData['article'],
                                  articleData['category'],
                                  articleData['writer'],
                                  articleId,
                                ),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Widget> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(); // Return an empty container while loading.
                                  }

                                  if (!snapshot.hasData) {
                                    return const Text('Error');
                                  }

                                  return snapshot.data!;
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
