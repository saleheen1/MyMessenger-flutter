import 'package:cloud_firestore/cloud_firestore.dart';

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
}
