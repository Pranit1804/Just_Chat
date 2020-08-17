import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String username;
  final String userImage;

  MessageBubble(this.message, this.isMe, this.username, this.userImage,
      {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Row(
            mainAxisAlignment:
                !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 140,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isMe ? Colors.teal : Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white
                        ),
                        textAlign: isMe ? TextAlign.start : TextAlign.end,
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ],
    );
  }
}
