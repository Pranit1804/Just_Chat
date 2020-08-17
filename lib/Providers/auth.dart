import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/Screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token, _userId;
  final auth = FirebaseAuth.instance;
  Map<String, String> _userData;

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  Map<String, String> get userData {
    fetchData();
    return _userData;
  }

  Future<Map<String, Object>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await json.decode(prefs.getString('chatAppUserData'))
        as Map<String, Object>;
    return data;
  }

  Future<String> get getData async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('chatAppUserData') != null) {
      return prefs.getString('chatAppUserData');
    } else {
      return null;
    }
  }

  Future<void> signUp(
      String userName, String email, String password, File image) async {
    AuthResult authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    int min = 100000;
    int max = 999999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(authResult.user.uid + '.jpg');
    await ref.putFile(image).onComplete;
    final url = await ref.getDownloadURL();
    print('Url: ' + url);
    print('UID: ' + authResult.user.uid);
    Firestore.instance
        .collection('users')
        .document(authResult.user.uid)
        .setData({
      'userId': authResult.user.uid,
      'username': userName,
      'email': email,
      'userImageUrl': url,
      'inviteId': rNum,
    });
  }

  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      AuthResult authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final dbData = await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .get();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userData = {
        'userId': authResult.user.uid,
        'email': email,
        'username': dbData['username'].toString(),
        'userImageUrl': dbData['userImageUrl'].toString(),
        'inviteId': dbData['inviteId'].toString()
      };

      if (prefs.containsKey('chatAppUserData')) {
        await prefs.clear();
        await prefs.setString('chatAppUserData', json.encode(userData));
      } else {
        await prefs.setString('chatAppUserData', json.encode(userData));
      }
      Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        title: 'Error Occurred',
        desc: 'Something wrong happened, Please try again',
        btnCancelOnPress: () {

        },
        btnOkOnPress: () {},
      )..show();
      print('error $e');
    }
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chatAppUserData');
  }
}
