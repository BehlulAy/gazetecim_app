import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazetecim_app/pages/createNewPage.dart';
import 'package:gazetecim_app/pages/profilePage.dart';
import 'package:gazetecim_app/pages/sectionPage.dart';
import 'package:gazetecim_app/services/firebaseService.dart';
import 'package:gazetecim_app/styles/colorsheet.dart';
import '../pages/homePage.dart';
import 'textfield_styles.dart';
import 'text_styles.dart';
import 'button_styles.dart';
import '../services/screen_size_service.dart';

class WidgetStyles {
  static Widget defaultTextField(String hintText,
      TextEditingController controller, TextStyle style, bool obscureText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        style: style,
        decoration: textFieldStyles.loginTextFieldDecoration.copyWith(
          hintText: hintText,
          hintStyle: textStyles.defaultTextStyle,
        ),
      ),
    );
  }

  static Widget commentTextField(
      String hintText, TextEditingController controller, TextStyle style) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        style: style,
        decoration: textFieldStyles.commentTextFieldDecoration.copyWith(
          hintText: hintText,
          hintStyle: textStyles.defaultTextStyle,
        ),
      ),
    );
  }

  static Widget defaultTextFieldWithCounter(String hintText,
      TextEditingController controller, TextStyle style, int maxChars) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        style: style,
        maxLength: maxChars,
        decoration: textFieldStyles.loginTextFieldDecoration.copyWith(
          hintText: hintText,
          hintStyle: textStyles.defaultTextStyle,
        ),
      ),
    );
  }

  static Widget newsTextField(
      String hintText, TextEditingController controller, TextStyle style) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: screenWidth,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenHeight / 2.2,
        ),
        child: TextField(
          controller: controller,
          style: style,
          maxLength: 500,
          decoration: textFieldStyles.loginTextFieldDecoration.copyWith(
            hintText: hintText,
            hintStyle: textStyles.defaultTextStyle,
          ),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 13,
        ),
      ),
    );
  }

  static Widget primaryButton(
      BuildContext context, String text, Function onTap) {
    screenSizeService.init(context);

    return Center(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: screenWidth / 2,
          height: screenHeight / 16,
          decoration: buttonStyles.primaryButtonStyle,
          margin: EdgeInsets.all(screenWidth / 110),
          child: Center(
            child: Text(text, style: textStyles.defaultTextStyle),
          ),
        ),
      ),
    );
  }

  static Widget secondaryButton(
      BuildContext context, String text, Function onTap) {
    screenSizeService.init(context);

    return Center(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: screenWidth / 2,
          height: screenHeight / 16,
          decoration: buttonStyles.secondaryButtonStyle,
          margin: EdgeInsets.all(screenWidth / 110),
          child: Center(
            child: Text(text, style: textStyles.defaultTextStyle),
          ),
        ),
      ),
    );
  }

  static Widget addProfilePhoto() {
    FirebaseService firebaseService = FirebaseService();

    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              firebaseService.pickCompressAndUploadImage(userId);
            },
            child: Container(
              margin: EdgeInsets.all(screenWidth / 24),
              child: Stack(
                children: [
                  FutureBuilder<String>(
                    future: firebaseService.getProfilePhoto(userId),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(); // or some other widget while waiting
                      } else {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircleAvatar(
                            radius: screenWidth / 11,
                            backgroundImage:
                                NetworkImage(snapshot.data!.toString()),
                          ); // Widget to display when the image URL is available
                        }
                      }
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorSheet.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: screenWidth / 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<String>(
            future: firebaseService.getUsername(
                userId), // userId is the id of the user you want to fetch
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(snapshot.data ?? 'No username',
                    style: textStyles.boldTitleStyle);
              }
            },
          )
        ],
      ),
    );
  }

  static Widget buildBannerPhoto(String bannerUrl) {
    return Container(
      width: screenWidth,
      height: screenHeight / 4,
      decoration: BoxDecoration(
        color: ColorSheet.secondaryColor,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(bannerUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  static Future<Widget> buildSections(String title, String section,
      String category, String writer, String articleId) async {
    FirebaseService firebaseService = FirebaseService();
    String userId = FirebaseAuth.instance.currentUser!.uid;

    int netLikes = 0;
    await firebaseService
        .getNetLikes(articleId)
        .then((value) => netLikes = value);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth / 1.4,
              height: screenHeight / 12,
              child: Text(title, style: textStyles.boldTitleStyle),
            ),
            Text(category, style: textStyles.defaultTextStyle),
          ],
        ),
        Text(
          section,
          style: textStyles.defaultTextStyle,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(writer, style: textStyles.boldTitleStyle),
            FutureBuilder(
              future: firebaseService.getUserArticleLike(userId, articleId),
              builder: (context, snapshot) => Builder(
                builder: (context) => Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        firebaseService.updateLikes(userId, articleId, 'like');
                      },
                      icon: Icon(
                        (snapshot.data == 'like')
                            ? Icons.thumb_up_alt
                            : Icons.thumb_up_alt_outlined,
                        color: ColorSheet.textColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        firebaseService.updateLikes(
                            userId, articleId, 'dislike');
                      },
                      icon: Icon(
                        (snapshot.data == 'dislike')
                            ? Icons.thumb_down_alt
                            : Icons.thumb_down_alt_outlined,
                        color: ColorSheet.textColor,
                      ),
                    ),
                    Text(netLikes.toString(),
                        style: textStyles.defaultTextStyle)
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  static Widget profileDetails(BuildContext context) {
    FirebaseService firebaseService = FirebaseService();

    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Container(
      decoration: BoxDecoration(
        color: ColorSheet.secondaryDarkColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      width: screenWidth,
      height: screenHeight / 1.5,
      padding: EdgeInsets.all(screenWidth / 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // buildProfileStat('Account Type', 'Admin'),
              FutureBuilder<Map<String, dynamic>>(
                future: firebaseService.getUserStats(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: [
                        buildProfileStat('Account Type',
                            snapshot.data!['admin'] ? 'Admin' : 'User'),
                        buildProfileStat(
                            'Articles', snapshot.data!['articles'].toString()),
                        // buildProfileStat(
                        //     'Comments', snapshot.data!['comments'].toString()),
                      ],
                    );
                  }
                },
              )
            ],
          ),
          buildAccountManagementButtons(context),
        ],
      ),
    );
  }

  static Widget buildAccountManagementButtons(BuildContext context) {
    FirebaseService firebaseService = FirebaseService();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => firebaseService.signOut(context),
          child: Container(
            margin: EdgeInsets.all(screenWidth / 40),
            padding: EdgeInsets.symmetric(
                vertical: screenWidth / 60, horizontal: screenWidth / 45),
            decoration: buttonStyles.primaryButtonStyle,
            child: Text('Sign Out', style: textStyles.defaultTextStyle),
          ),
        ),
      ],
    );
  }

  static Widget buildProfileStat(String statTitle, String statCount) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: screenWidth / 40),
              child: Text(
                '$statTitle: $statCount',
                style: textStyles.defaultTextStyle,
              ),
            ),
          ],
        ),
        Container(
          height: 1,
          width: screenWidth,
          color: ColorSheet.secondaryColor,
        )
      ],
    );
  }

  static Widget topNewBannerPhoto(
      BuildContext context, String title, String bannerUrl, String articleId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SectionPage(articleId: articleId),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight / 5,
              decoration: BoxDecoration(
                color: ColorSheet.secondaryColor,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(bannerUrl),
                  fit: BoxFit.cover,
                ),
              ),
              margin: EdgeInsets.symmetric(vertical: screenWidth / 40),
            ),
            Positioned(
              left: screenWidth / 50,
              bottom: screenHeight / 50,
              child: SizedBox(
                width: screenWidth / 1.7,
                child: Text(
                  title,
                  style:
                      textStyles.boldTitleStyle.copyWith(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //FGtFm7lowGOu6tlJxtvZX71mhE63

  StreamBuilder<QuerySnapshot> buildNewsStream(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('articles')
          .orderBy('createdTime', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        // Get all articles
        final articles = snapshot.data!.docs;

        return ListView(
          shrinkWrap: true,
          children: articles.map((article) {
            return topNewBannerPhoto(
                context, article['title'], article['bannerUrl'], article.id);
          }).toList(),
        );
      },
    );
  }

  static Widget buildCategory(String title) {
    return Container(
      height: screenHeight / 16,
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth / 80, vertical: screenWidth / 40),
      padding: EdgeInsets.symmetric(horizontal: screenWidth / 40),
      decoration: buttonStyles.secondaryButtonStyle,
      child: Center(child: Text(title, style: textStyles.defaultTextStyle)),
    );
  }

  static Widget buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }

          // Convert the documents to a list and sort them alphabetically.
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          docs.sort((a, b) {
            Map<String, dynamic> dataA = a.data() as Map<String, dynamic>;
            Map<String, dynamic> dataB = b.data() as Map<String, dynamic>;
            return dataA['title'].compareTo(dataB['title']);
          });

          return Row(
            children: docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return buildCategory(data['title']);
            }).toList(),
          );
        },
      ),
    );
  }

  static Widget buildDropDownButton(List<String> items) {
    String dropdownValue = items.first;
    ValueNotifier<String> dropdownValueNotifier = ValueNotifier(dropdownValue);
    return ValueListenableBuilder<String>(
      valueListenable: dropdownValueNotifier,
      builder: (context, value, child) {
        return Container(
          width: screenWidth,
          margin: EdgeInsets.symmetric(horizontal: screenWidth / 25),
          padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
          decoration: BoxDecoration(
            color: ColorSheet.secondaryDarkColor,
            borderRadius: BorderRadius.circular(screenWidth / 60),
          ),
          child: DropdownButton<String>(
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                dropdownValueNotifier.value = newValue;
              } else {
                dropdownValueNotifier.value = items.first;
              }
            },
            value: value, // Değer buradan alınıyor
            style: textStyles.defaultTextStyle,
            dropdownColor: ColorSheet.secondaryDarkColor,
            underline: Container(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: ColorSheet.secondaryColor,
            ),
            isExpanded: true,
            elevation: 0,
          ),
        );
      },
    );
  }

  static PreferredSizeWidget defaultAppBar(String title, BuildContext context) {
    FirebaseService firebaseService = FirebaseService();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return AppBar(
      backgroundColor: ColorSheet.primaryColor,
      leading: const SizedBox(),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<String>(
            future: firebaseService.getProfilePhoto(userId),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(); // or some other widget while waiting
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!.toString()),
                  ); // Widget to display when the image URL is available
                }
              }
            },
          ),
        ),
      ],
      centerTitle: true,
      title: Text(
        title,
        style: textStyles.regularTitleStyle,
      ),
    );
  }

  static Widget defaultBottomAppBar(BuildContext context) {
    FirebaseService firebaseService = FirebaseService();

    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder<bool>(
        future: firebaseService.isAdmin(userId),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else {
            var isAdmin = snapshot.data ?? false;
            return BottomAppBar(
              height: screenHeight / 12,
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
              color: ColorSheet.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      if (ModalRoute.of(context)?.settings.name !=
                          '/homePage') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const homePage(),
                            settings: const RouteSettings(name: '/homePage'),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.home,
                      color: ColorSheet.textColor,
                      size: screenWidth / 12,
                    ),
                  ),
                  if (isAdmin) // If the user is an admin, show the commented out IconButton
                    IconButton(
                      onPressed: () {
                        if (ModalRoute.of(context)?.settings.name !=
                            '/createNewPage') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const createNewPage(),
                              settings:
                                  const RouteSettings(name: '/createNewPage'),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.newspaper_rounded,
                        color: ColorSheet.textColor,
                        size: screenWidth / 12,
                      ),
                    ),
                  IconButton(
                    onPressed: () {
                      if (ModalRoute.of(context)?.settings.name !=
                          '/profilePage') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                            settings: const RouteSettings(name: '/profilePage'),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.person,
                      color: ColorSheet.textColor,
                      size: screenWidth / 12,
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
