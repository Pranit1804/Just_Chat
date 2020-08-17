import 'package:chat_app/Providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewFriend extends StatefulWidget {
  static const routeName = '/add-new-friend';

  @override
  _AddNewFriendState createState() => _AddNewFriendState();
}

class _AddNewFriendState extends State<AddNewFriend> {
  final _controller = new TextEditingController();
  var inviteUser;
  var _isLoading = false,
      _inviteIdRec = false,
      _friendAdded = false,
      _sentLoading = false,
      _alreadyFriend = false,
      _isMe = false;



  Future<void> checkInviteId(String inviteId) async {
    final userData =
    await Provider.of<Auth>(context, listen: false).fetchData();

    setState(() {
      inviteUser = null;
      _isLoading = true;
      _inviteIdRec = true;
    });

    if (inviteId == userData['inviteId']) {
      setState(() {
        _isMe = true;
        _isLoading = false;
      });
      return;
    }

    final data1 = await Firestore.instance
        .collection('friends')
        .document(userData['userId'])
        .collection(userData['userId'])
        .getDocuments();

    for (int i = 0; i < data1.documents.length; i++) {
      if (data1.documents[i]['inviteId'].toString() == inviteId) {
        print('Friend found!');
        setState(() {
          _isLoading = false;
          _alreadyFriend = true;
          inviteUser = data1.documents[i];
        });
        break;
      }
    }

    if (!_alreadyFriend) {
      final data = await Firestore.instance.collection('users').getDocuments();
      for (int i = 0; i < data.documents.length; i++) {
        print('inviteId 2: ${data.documents[i]['inviteId']}');
        if (data.documents[i]['inviteId'].toString() == inviteId) {
          setState(() {
            inviteUser = data.documents[i];
            _controller.clear();
            _isLoading = false;
          });
          break;
        }
      }
    }

    if (inviteUser == null) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendInvite() async {
    setState(() {
      _sentLoading = true;
    });
    final userData =
    await Provider.of<Auth>(context, listen: false).fetchData();
    await Firestore.instance
        .collection('friends')
        .document(inviteUser['userId'])
        .collection(inviteUser['userId'])
        .add({
      'userId': userData['userId'],
      'username': userData['username'],
      'userImageUrl': userData['userImageUrl'],
      'inviteId': userData['inviteId']
    });

    await Firestore.instance
        .collection('friends')
        .document(userData['userId'])
        .collection(userData['userId'])
        .add({
      'userId': inviteUser['userId'],
      'username': inviteUser['username'],
      'userImageUrl': inviteUser['userImageUrl'],
      'inviteId': inviteUser['inviteId']
    });

    setState(() {
      _sentLoading = false;
      _friendAdded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Friend'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Enter Invite Code'),
                onChanged: (value) {
                  if (value.length == 6) {
                    checkInviteId(value);
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              _inviteIdRec
                  ? !_isLoading
                  ? Card(
                child: _inviteIdRec && inviteUser != null
                    ? Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          inviteUser['userImageUrl'],
                        ),
                      ),
                      title: Text(inviteUser['username'],
                        style: TextStyle(fontSize: 18),),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: 10, bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: !_sentLoading
                            ? RaisedButton.icon(
                          padding: EdgeInsets.all(10),
                          icon: Icon(_alreadyFriend ||
                              _friendAdded
                              ? Icons.done
                              : Icons.message, size: 18,),
                          label: !_alreadyFriend
                              ? Text(
                            !_friendAdded
                                ? 'Add Friend'
                                : 'Friend Added',
                          )
                              : Text(
                              'Already Friend', style: TextStyle(fontSize: 11)),
                          color: _friendAdded ||
                              _alreadyFriend
                              ? Colors.green
                              : Theme
                              .of(context)
                              .primaryColorDark,
                          onPressed: _friendAdded ||
                              _alreadyFriend
                              ? () {}
                              : _sendInvite,
                        )
                            : CircularProgressIndicator(),
                      ),
                    )
                  ],
                )
                    : Container(
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: Text(!_isMe ? 'No user found' : 'Its your invite Id my friend', style: TextStyle(color: Colors.blue),),
                  ),
                ),
              )
                  : Center(
                child: CircularProgressIndicator(),
              )
                  : Center(),
            ],
          ),
        ),
      ),
    );
  }
}
