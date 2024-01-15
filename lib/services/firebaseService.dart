// ignore_for_file: file_names, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gazetecim_app/pages/homePage.dart';
import 'package:gazetecim_app/pages/loginPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final ImagePicker _picker = ImagePicker();

  Future<void> createUserWithEmailAndPassword(String email, String username,
      String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      try {
        await _usersCollection.doc(user?.uid).set({
          'userId': user?.uid,
          'username': username,
          'email': email,
          'profilePhotoUrl': '',
          'admin': false,
          'articles': 0,
          'comments': 0,
          // Diğer kullanıcı bilgileri burada saklanacak
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const homePage(),
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
      // Kullanıcı bilgileri Firestore'a kaydedildi
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      // Kullanıcı giriş yaptı
      // ignore: unnecessary_null_comparison
      if (userCredential != null) {
        // Save the user's email and password to SharedPreferences

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const homePage(),
          ),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<String> getProfilePhoto(String userId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String url = '';

    if (docSnapshot.exists) {
      final userData = docSnapshot.data() as Map<String, dynamic>;
      final profilePhotoUrl = userData['profilePhotoUrl'];

      if (profilePhotoUrl != null && profilePhotoUrl.isNotEmpty) {
        return profilePhotoUrl;
      }
    }

    // If profilePhotoUrl is null or empty, return the default profile picture URL
    final ref = FirebaseStorage.instance
        .ref()
        .child('profilePictures/gazetecimProfilePicture.png');
    try {
      url = (await ref.getDownloadURL()).toString();
    } catch (error) {
      url = '';
    }
    return url;
  }

  Future<bool> isAdmin(String userId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (docSnapshot.exists) {
      final userData = docSnapshot.data() as Map<String, dynamic>;
      final admin = userData['admin'];

      if (admin != null) {
        return admin;
      }
    }

    // If 'admin' field is null or doesn't exist, return false
    return false;
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future<String> getUserId() async {
    final User? user = _auth.currentUser;
    return user!.uid;
  }

  Future<String> getUserArticleLike(String userId, String articleId) async {
    final DocumentSnapshot likesSnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('likes')
        .doc(userId)
        .get();

    final DocumentSnapshot dislikesSnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('dislikes')
        .doc(userId)
        .get();

    if (likesSnapshot.exists) {
      return 'like';
    } else if (dislikesSnapshot.exists) {
      return 'dislike';
    } else {
      return '';
    }
  }

  Future<int> getNetLikes(String articleId) async {
    final likesSnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('likes')
        .get();
    final dislikesSnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('dislikes')
        .get();

    final likesCount = likesSnapshot.docs.length;
    final dislikesCount = dislikesSnapshot.docs.length;
    final netLikes = likesCount - dislikesCount;

    return netLikes;
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      return {
        'admin': userDoc['admin'],
        'articles': userDoc['articles'],
        'comments': userDoc['comments'],
      };
    } else {
      throw Exception('User does not exist');
    }
  }

  Future<void> updateLikes(String userId, String articleId, String like) async {
    final likeDocRef = FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection(like == 'like' ? 'likes' : 'dislikes')
        .doc(userId);

    final oppositeCollectionRef = FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection(like == 'like' ? 'dislikes' : 'likes');

    if (like == 'like' || like == 'dislike') {
      // Like veya dislike yapıldığında, karşı koleksiyondaki belgeyi sil
      await oppositeCollectionRef.doc(userId).delete();

      // Bu koleksiyona yeni belge ekle
      await likeDocRef.set({'userId': userId});
    } else {
      // Eğer like veya dislike değilse, her ikisini de sil
      await likeDocRef.delete();
      await oppositeCollectionRef.doc(userId).delete();
    }
  }

  Future<void> pickCompressAndUploadImage(String userId) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Compress the image
      final result = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        Path.join(Path.dirname(pickedFile.path), 'compressed.jpg'),
        minWidth: 500,
        minHeight: 500,
        quality: 88,
      );

      if (result != null) {
        // Upload the compressed image to Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(result.path)}');
        await ref.putFile(File(result.path));

        // Get the download URL
        final url = await ref.getDownloadURL();

        // Update the user document
        FirebaseFirestore.instance.collection('users').doc(userId).update({
          'profilePhotoUrl': url,
        });
      }
    }
  }

  Future<String> getUsername(String userId) {
    return _usersCollection.doc(userId).get().then((doc) => doc['username']);
  }
}
