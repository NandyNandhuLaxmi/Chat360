import 'dart:io';
import 'package:chatapp/constants.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    sendByMe: Constants.myName ==
                        snapshot.data.documents[index].data["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTextColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kTextColor,
        title: Text(widget.chatRoomId, style: TextStyle(color: kBlackColor)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(EvaIcons.arrowIosBackOutline, color: kBlackColor)),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.all(14),
                color: kGrayColor,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageEditingController,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              _media(context);
                            },
                            icon: Icon(EvaIcons.attachOutline)),
                        hintText: 'Search here friends name here ....',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      radius: 25.0,
                      backgroundColor: kPrimaryColor,
                      child: IconButton(
                          onPressed: () {
                            addMessage();
                          },
                          icon: Icon(EvaIcons.paperPlane, color: kTextColor)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _media(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                height: 30.0,
                width: double.infinity,
                color: Colors.black54,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                    color: kTextColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 35.0,
                          backgroundColor: kPrimaryColor,
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(EvaIcons.camera, color: kTextColor)),
                        ),
                        CircleAvatar(
                          radius: 35.0,
                          backgroundColor: kPrimaryColor,
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(EvaIcons.video, color: kTextColor)),
                        ),
                        CircleAvatar(
                          radius: 35.0,
                          backgroundColor: kPrimaryColor,
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(EvaIcons.file, color: kTextColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [kPrimaryColor, kPrimaryColor]
                  : [kSecondaryColor, kSecondaryColor],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
