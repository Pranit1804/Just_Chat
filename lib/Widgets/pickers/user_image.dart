import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  final Function(File pickedImage) imagePick;

  UserImage(this.imagePick);
  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {

  File _image;


  void _pickImage() async{
    final imageFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50 );
    if(imageFile!=null){
      setState(() {
        _image = imageFile;
      });
      widget.imagePick(_image);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          backgroundImage: _image!=null ?  FileImage(_image) : null,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor ,
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
