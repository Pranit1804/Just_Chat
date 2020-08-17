import 'package:chat_app/Widgets/chats/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  final receiverID;

  const Messages(this.receiverID);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chats').document(futureSnapshot.data.uid)
                .collection(receiverID)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final chatDocs = chatSnapshot.data.documents;
                return ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, index) => MessageBubble(
                    chatDocs[index]['text'],
                    chatDocs[index]['userId'] == futureSnapshot.data.uid
                        ? true
                        : false,
                    chatDocs[index]['username'],
                    chatDocs[index]['userImage'],
                    key: ValueKey(chatDocs[index].documentID),
                  ),
                  itemCount: chatDocs.length,
                );
              }
            },
          );
        });
  }
}
