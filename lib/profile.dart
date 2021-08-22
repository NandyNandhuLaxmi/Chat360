import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChatSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Profile Update',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  bool isLoading = false;
  File _selectedFile;
  bool _inProcess = false;
  File image;
  String error = "";
  Color get primaryColor => null;

  @override
  void initState() {
    super.initState();
  }

  Widget MygetImageWidget() {
    return CircleAvatar(
      backgroundImage: _selectedFile == null
          ? AssetImage('assets/images/chat.png')
          : FileImage(_selectedFile),
      radius: 50,
    );
  }

  nowgetImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 50,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.blue[900],
            toolbarTitle: "Select Image",
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.white,
            backgroundColor: Colors.white,
          ));

      this.setState(() {
        _selectedFile = cropped;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.black38),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Stack(
                                alignment: const Alignment(1.3, 1.3),
                                children: [
                                  MygetImageWidget(),
                                  Container(
                                    child: IconButton(
                                      color: Colors.indigo,
                                      onPressed: () {
                                        nowgetImage(ImageSource.gallery);
                                      },
                                      iconSize: 25,
                                      icon: Icon(Icons.add_a_photo),
                                      disabledColor: Colors.deepOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              nowgetImage(ImageSource.gallery);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                children: <Widget>[
                  // Username
                  SizedBox(
                    height: size.height / 20,
                  ),
                  TextFormField(
                    controller: usernameEditingController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(EvaIcons.personOutline),
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (val) {
                      return val.isEmpty || val.length < 3
                          ? "Enter Username 3+ characters"
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailEditingController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(EvaIcons.emailOutline),
                      hintText: 'email',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                          ? "Enter correct email"
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(EvaIcons.lockOutline),
                      hintText: 'password',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (val) {
                      return val.length < 6
                          ? "Enter Password 6+ characters"
                          : null;
                    },
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              SizedBox(
                height: 15,
              ),

              // Button
              RaisedButton(
                color: kPrimaryColor,
                child: Container(
                    height: 52.0,
                    width: size.width / 1.12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: kPrimaryColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Update Account",
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                onPressed: () {},
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
      ],
    );
  }
}
