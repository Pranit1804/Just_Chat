import 'package:chat_app/Providers/auth.dart';
import 'package:chat_app/Widgets/main_screen/send_invite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendInviteScreen extends StatelessWidget {

  static const routeName = '/send-invite-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Invite'),
      ),
      body: FutureBuilder(
        future: Provider.of<Auth>(context).fetchData(),
        builder: (ctx, snapShot) {
          return SendInvite(
            snapShot.data['inviteId'],
            true,
          );
        },
      ),
    );
  }
}
