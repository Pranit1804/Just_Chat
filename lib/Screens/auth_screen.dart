import 'dart:io';

import 'file:///D:/FlutterTraining/MyApplications/chat_app/lib/Widgets/Auth/auth_form.dart';
import 'package:chat_app/Providers/auth.dart';
import 'package:chat_app/Providers/user_details.dart';
import 'package:chat_app/Screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  var _isLoading = false;
  var userData;

  Future<void> saveUserId(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userID);
    prefs.commit();
  }

  void _submitAuthForm(String email, String password, String userName,
      bool isLogin, BuildContext ctx, File image) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        await Provider.of<Auth>(context, listen: false).signIn(email, password, context);
        setState(() {
          _isLoading = false;
        });
      } else {
        Provider.of<Auth>(context, listen: false).signUp(userName, email, password, image);
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      }
    } on PlatformException catch (error) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured, please check your credentials!';

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
      ));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<UserData>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}
