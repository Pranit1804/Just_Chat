import 'package:chat_app/Providers/user_details.dart';
import 'package:chat_app/Widgets/chats/messages.dart';
import 'package:chat_app/Widgets/chats/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {

  static const routeName = '/chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData =
        ModalRoute.of(context).settings.arguments as DocumentSnapshot;
    print('user: ${userData['username']}');
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.all(7),
              child: CircleAvatar(
                backgroundImage: NetworkImage(userData['userImageUrl']),
              ),
            ),
            Container(
              child: Text(
                userData['username'],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Messages(userData['userId'])),
            NewMessage(userData['userId']),
          ],
        ),
      ),
    );
  }
}
