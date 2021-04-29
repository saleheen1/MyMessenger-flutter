import 'package:flutter/material.dart';
import 'package:my_messenger/views/others/constants.dart';
import 'package:my_messenger/views/helper/sharedPref_helper.dart';
import 'package:my_messenger/views/services/database.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
  final String chatWithUsername, name;
  ChatScreen({this.chatWithUsername, this.name});
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = "";
  String myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextEditingController = TextEditingController();

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

  addMessage(bool sendClicked) {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;
      var lastMessageTS = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTS,
        "imgUrl": myProfilePic
      };

      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
        DatabaseMethods()
            .addMessage(
              chatRoomId,
              messageId,
              messageInfoMap,
            )
            .then((value) {});
      }
    }
  }

  getAndSetMessages() async {}

  doThisOnLaunch() async {
    await getMyLocalInfo();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
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
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Container(
          child: Stack(
            children: [
              Container(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xffF4F4F4),
                          ),
                          child: TextField(
                            controller: messageTextEditingController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "type a message",
                                hintStyle: TextStyle(color: kGrey)),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.send,
                        color: kGrey,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
