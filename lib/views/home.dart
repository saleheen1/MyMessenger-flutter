import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_messenger/views/auth/signIn.dart';
import 'package:my_messenger/views/chatScreen.dart';
import 'package:my_messenger/views/others/constants.dart';
import 'package:my_messenger/views/services/auth.dart';
import 'package:my_messenger/views/services/database.dart';

import 'helper/sharedPref_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  TextEditingController searchUserEditingController = TextEditingController();

  Stream usersStream, chatRoomsStream;
  onSearchButtonClick() async {
    setState(() {
      isSearching = true;
    });
    usersStream = await DatabaseMethods()
        .getUserByUserName(searchUserEditingController.text);
  }

  getChatRoomIdByUsernames(String name1, String name2) {
    //name1 is the persone we search and name2 is my name
    if (name1.substring(0, 1).codeUnitAt(0) >
        name2.substring(0, 1).codeUnitAt(0)) {
      return "$name2\_$name1";
    } else {
      return "$name1\_$name2";
    }
  }

  String myName, myProfilePic, myUserName, myEmail;
  getMyLocalInfo() async {
    myName = await SharedPrefHelper().getDisplayName();
    myProfilePic = await SharedPrefHelper().getUserProfileUrl();
    myUserName = await SharedPrefHelper().getUsername();
    myEmail = await SharedPrefHelper().getUserEmail();
  }

  Widget searchUserList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return InkWell(
                  onTap: () {
                    var chatRoomId =
                        getChatRoomIdByUsernames(myUserName, ds["username"]);
                    Map<String, dynamic> chatRoomInfoMap = {
                      "users": [myUserName, ds["username"]]
                    };
                    DatabaseMethods()
                        .createChatRoom(chatRoomId, chatRoomInfoMap);
                    Get.to(ChatScreen(
                      chatWithUsername: ds["username"],
                      name: ds["name"],
                    ));
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          ds["imgUrl"],
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${ds["name"]}",
                            style: TextStyle(
                                fontSize: 17,
                                color: kGrey,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${ds["email"]}",
                            style: TextStyle(fontSize: 15, color: kGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  // return Text(
                  //     ds.id.replaceAll(myUserName, "").replaceAll("_", ""));
                  return ChatRoomListTile(ds["lastMessage"], ds.id, myUserName);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getMyChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoad() async {
    await getMyLocalInfo();
    getMyChatRooms();
  }

  @override
  void initState() {
    onScreenLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.3,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: InkWell(
              onTap: () {
                AuthMethod().signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.exit_to_app,
                  color: kGrey,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              Row(
                children: [
                  isSearching == true
                      ? GestureDetector(
                          onTap: () {
                            isSearching = false;
                            searchUserEditingController.text = "";
                            setState(() {});
                          },
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 15, 20, 15),
                              child: Icon(Icons.arrow_back)),
                        )
                      : Container(
                          height: 10,
                        ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: kSecondaryGrey,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: searchUserEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "username",
                              focusColor: kGrey,
                              hoverColor: kGrey,
                            ),
                          )),
                          GestureDetector(
                              onTap: () {
                                if (searchUserEditingController.text != "") {
                                  onSearchButtonClick();
                                }

                                // if (searchUsernameEditingController.text != "") {
                                //   onSearchBtnClick();
                                // }
                              },
                              child: Icon(
                                Icons.search,
                                color: kGrey,
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              isSearching ? searchUserList() : chatRoomsList()
            ],
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    print("the docs data here ${querySnapshot.docs[0]["imgUrl"]}}");
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      chatWithUsername: username,
                      name: name,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            profilePicUrl != ""
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      profilePicUrl,
                      height: 40,
                      width: 40,
                    ),
                  )
                : Container(
                    height: 40,
                    width: 40,
                  ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3),
                Text(widget.lastMessage)
              ],
            )
          ],
        ),
      ),
    );
  }
}
