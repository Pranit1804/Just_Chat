import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class SendInvite extends StatelessWidget {
  final inviteId, hasFriends;

  SendInvite(this.inviteId, this.hasFriends);

  void share(BuildContext context, String inviteId){
    final RenderBox box = context.findRenderObject();
    Share.share(inviteId,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !hasFriends
              ? Text(
                  'You Have no Friends currently.',
                  textAlign: TextAlign.center,
                )
              : Center(),
          SizedBox(height: 15),
          Text(
            'Send your Invite ID to start chatting',
            style: TextStyle(
                fontSize: hasFriends ? 18 : 17, color: Colors.pink),
          ),
          SizedBox(height: 10),
          Text(
            inviteId,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.content_copy,
                  size: 15,
                ),
                label: Text(
                  'Copy to Clipboard',
                  style: TextStyle(fontSize: 10),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: inviteId));
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Copied to Clipboard',
                      textAlign: TextAlign.center,
                    ),
                  ));
                },
              ),
              FlatButton.icon(
                icon: Icon(
                  Icons.share,
                  size: 15,
                ),
                label: Text(
                  'Share',
                  style: TextStyle(fontSize: 10),
                ),
                onPressed: () {
                  share(context, 'Hey come and join me on Just Chatting app. My Invite Id is $inviteId');
                },
              ),

            ],
          ),

        ],
      ),
    );
  }
}
