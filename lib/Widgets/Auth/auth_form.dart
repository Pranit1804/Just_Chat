import 'dart:io';

import 'package:chat_app/Widgets/pickers/user_image.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String userName,
      bool isLogin, BuildContext ctx, File userImage) submitFn;
  final isLoading;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userName='', _password='', _emailId='';
  var _isLogin = true;
  File _userImage;

  void _getImage(File image){
    _userImage = image;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState.validate();
    if(_userImage == null && !_isLogin){
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please Pick a Image'),
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_emailId.trim(), _password.trim(), _userName.trim(),
          _isLogin, context, _userImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if(!_isLogin) UserImage(_getImage),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains("@")) {
                        return 'Please Enter a valid Email Id';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _emailId = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('email'),
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please Enter a valid Username';
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password '),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 character';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  widget.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          child: Text(_isLogin ? 'Sign In' : 'Sign Up'),
                          onPressed: _submit,
                        ),
                  FlatButton(
                    textColor: Colors.pink,
                    child: Text(_isLogin
                        ? 'Create new Account'
                        : 'Already have an Account?'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
