import 'dart:async';

import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/views/chatrooms.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool aulog;
  _getshare() async {
    await HelperFunctions.getUserLogInSharedPreference().then((value) {
      if (aulog != null) {
        Timer(
            (Duration(seconds: 2)),
            () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ChatRoom())));
      } else {
        Timer(
            (Duration(seconds: 2)),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Authenticate())));
      }
    });
  }

  @override
  void initState() {
    _getshare();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/Chat 360 Logo.png',
        ),
      ),
    );
  }
}
