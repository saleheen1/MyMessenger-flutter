import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_messenger/views/auth/signIn.dart';
import 'package:my_messenger/views/others/constants.dart';
import 'package:my_messenger/views/services/auth.dart';
import 'package:my_messenger/views/services/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  TextEditingController searchUserEditingController = TextEditingController();

  Stream usersStream;
  onSearchButtonClick() async {
    setState(() {
      isSearching = true;
    });
    usersStream = await DatabaseMethods()
        .getUserByUserName(searchUserEditingController.text);
  }

  Widget searchUserList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Image.network(ds["imgUrl"]);
                },
              ),
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

  Widget chatRoomList() {
    return Container();
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
          child: Container(
            child: Row(
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
                              border: InputBorder.none, hintText: "username"),
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
                            child: Icon(Icons.search))
                      ],
                    ),
                  ),
                ),
                isSearching ? searchUserList() : chatRoomList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
