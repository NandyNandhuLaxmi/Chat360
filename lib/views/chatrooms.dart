import 'dart:io';

import 'package:chatapp/constants.dart';
import 'package:chatapp/contactsync.dart';
import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/helper/loading.dart';
import 'package:chatapp/helper/theme.dart';
import 'package:chatapp/profile.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/search.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  AuthService authService = AuthService();
  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  getpermission() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.contacts, Permission.storage].request();
      print(statuses);
    }
  }

  @override
  void initState() {
    super.initState();
    getpermission();
    getUserInfogetChats();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Chat 360',
                style:
                    TextStyle(color: kBlackColor, fontWeight: FontWeight.bold),
              ),
              content: Text('Do you want close this app'),
              actions: [
                FlatButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: Text('Yes'.toUpperCase(),
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 15)),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'.toUpperCase(),
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 15)),
                ),
              ],
            );
          }),
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            elevation: 0.0,
            centerTitle: false,
            leading: InkWell(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: kTextColor,
                child: Text('',
                    style: TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.w800)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatSettings()),
                );
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Chat 360',
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text('Do you want close this app'),
                            actions: [
                              FlatButton(
                                onPressed: () async {
                                  AuthService().signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Authenticate()),
                                      (Route<dynamic> route) => false);
                                },
                                child: Text('Logout'.toUpperCase(),
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15)),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'.toUpperCase(),
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15)),
                              ),
                            ],
                          );
                        });
                  },
                  icon: Icon(EvaIcons.lockOutline))
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: size.width / 1.4,
                          child: Text(
                            "Chat with\nyour friends",
                            style: TextStyle(
                              fontSize: 26,
                              color: kTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => ChatSettings()),
                        //     );
                        //   },
                        //   child: Container(
                        //     alignment: Alignment.centerLeft,
                        //     margin: EdgeInsets.only(left: 10),
                        //     child: Icon(Icons.account_circle_outlined,
                        //         size: 40, color: Colors.white),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: kTextColor.withOpacity(0.15),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search()));
                          },
                          icon:
                              Icon(EvaIcons.searchOutline, color: kTextColor)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    height: size.height,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0))),
                    child: chatRoomsList(),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 8.0,
              child: Icon(
                EvaIcons.messageCircleOutline,
                size: 30,
              ),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactsPage()));
              })),
    );
  }

  //ChatRoomListView
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Loading();
        }
        if (snapshot.hasData) {
          return Center(
              child: Text(
            "No Friends Here \nclick a search button",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ));
        }
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print('dummy :: snapshot.data.documents.length');
              return ChatRoomsTile(
                userName: snapshot.data.documents[index].data['chatRoomId']
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
              );
            });
      },
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile({this.userName, @required this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
