import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_messenger/views/helper/sharedPref_helper.dart';

class DatabaseMethods {
  //inserting data
  Future addUserInfoToDB(
      String userid, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userid)
        .set(userInfoMap);
  }

  //Query to find data from firebase
  Future getUserByUserName(String userName) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .where("username", isEqualTo: userName)
        .snapshots();
  }

  //adding chat messages to firebase
  Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        // .orderBy("ts", descending: true)
        .orderBy("ts")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String myUsername = await SharedPrefHelper().getUsername();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTS", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("username", isEqualTo: username)
        .get();
  }
}
