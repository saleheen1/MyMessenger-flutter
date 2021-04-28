import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String userid, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userid)
        .set(userInfoMap);
  }
}
