import 'package:flutter/material.dart';
import 'package:my_messenger/views/others/constants.dart';
import 'package:my_messenger/views/helper/sharedPref_helper.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
  final String chatWithUsername, name;
  ChatScreen({this.chatWithUsername, this.name});
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = "";
  String myName, myProfilePic, myUserName, myEmail;

  getChatRoomIdByUsernames(String name1, String name2) {
    if (name1.substring(0, 1).codeUnitAt(0) >
        name2.substring(0, 1).codeUnitAt(0)) {
      return "$name2\_$name1";
    } else {
      return "$name1\_$name2";
    }
  }

  getMyLocalInfo() async {
    myName = await SharedPrefHelper().getDisplayName();
    myProfilePic = await SharedPrefHelper().getUserProfileUrl();
    myUserName = await SharedPrefHelper().getUsername();
    myEmail = await SharedPrefHelper().getUserEmail();

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername,
        myUserName); //chatwithusername is the other person name whom we searched
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kGrey, //change your color here
        ),
        title: Text(
          "${widget.name}",
          style: TextStyle(
              fontSize: 18, color: kGrey, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.3,
        actions: [],
      ),
    );
  }
}
