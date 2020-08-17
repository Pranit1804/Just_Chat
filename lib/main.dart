import 'package:chat_app/Providers/auth.dart';
import 'package:chat_app/Providers/user_details.dart';
import 'package:chat_app/Screens/add_new_friend.dart';
import 'package:chat_app/Screens/auth_screen.dart';
import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Screens/main_screen.dart';
import 'package:chat_app/Widgets/chats/send_invite_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UserData(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Just Talk',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            backgroundColor: Colors.blueAccent,
            accentColor: Colors.red,
            accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.green,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          home:FutureBuilder(
            future: auth.getData,
            builder: (ctx, snapShot){
              if(snapShot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(snapShot.data == null){
                return AuthScreen();
              }
              else{
                return MainScreen();
              }
            }
          ),
          routes: {
            ChatScreen.routeName: (ctx) => ChatScreen(),
            MainScreen.routeName: (ctx) => MainScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            AddNewFriend.routeName: (ctx) => AddNewFriend(),
            SendInviteScreen.routeName: (ctx) => SendInviteScreen(),
          },
        ),
      ),
    );
  }
}
