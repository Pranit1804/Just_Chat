import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreenList extends StatelessWidget {
  final myUserId;
  final String userId;
  final String username;
  final String imageUrl;
  final Key key;

  MainScreenList(this.myUserId, this.userId, this.username, this.imageUrl,
      {this.key});

  @override
  Widget build(BuildContext context) {
    print('MyUserId: $myUserId oppUserId: $userId');
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('chats')
                    .document(myUserId)
                    .collection(userId)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (ctx, snapShot) =>
                    snapShot.connectionState != ConnectionState.waiting
                        ? Container(
                            margin: EdgeInsets.only(top: 5),
                            child: snapShot.data.documents.length != 0
                                ? Text(
                                     snapShot.data.documents[0]['text'],
                                    style: TextStyle(fontSize: 12),
                                  )
                                : null,
                          )
                        : Center(
                            child: Text('Loading.... '),
                          ),
              )
            ],
          ),
          Divider(
            color: Colors.blue,
            height: 2,
          ),
        ],
      ),
    );
  }
}
