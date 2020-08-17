import 'package:flutter/material.dart';

class UserData with ChangeNotifier{
  String _userId, _username, _userImage;

   String get userName{
     return _username;
   }
   String get userId{
     return _userId;
   }

   String get userImage{
     return _userImage;
   }

   void setData(String username, String password, String userId, String userImage){
     _userId = userId;
     _userImage = userImage;
     _username = username;
     notifyListeners();
   }

}

