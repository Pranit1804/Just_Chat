import 'dart:math';

import 'package:chat_app/Providers/auth.dart';
import 'package:chat_app/Screens/add_new_friend.dart';
import 'package:chat_app/Screens/auth_screen.dart';
import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Widgets/chats/send_invite_screen.dart';
import 'package:chat_app/Widgets/main_screen/list.dart';
import 'package:chat_app/Widgets/main_screen/send_invite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {
              Navigator.of(context).pushNamed(SendInviteScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Provider.of<Auth>(context, listen: false).signOut();
              Navigator.of(context).pushNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Auth>(context).fetchData(),
        builder: (ctx, user) => user.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('friends')
                      .document(user.data['userId'])
                      .collection(user.data['userId'])
                      .snapshots(),
                  builder: (ctx, snapShot) => snapShot.connectionState ==
                          ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : snapShot.data.documents.length != 0
                          ? ListView.builder(
                              itemCount: snapShot.data.documents.length,
                              itemBuilder: (ctx, index) => GestureDetector(
                                child: MainScreenList(
                                    user.data['userId'],
                                    snapShot.data.documents[index]['userId'],
                                    snapShot.data.documents[index]['username'],
                                    snapShot.data.documents[index]
                                        ['userImageUrl']),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ChatScreen.routeName,
                                      arguments:
                                          snapShot.data.documents[index]);
                                },
                              ),
                            )
                          : SendInvite(
                              user.data['inviteId'],
                              false,
                            ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddNewFriend.routeName);
        },
      )),
    );
  }
}
