import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static String userIdkey = "USERNAME";
  static String userNameKey = "USERNAMEKEY";
  static String displaNamekey = "USERDISPLAYNAME";
  static String userEmailkey = "USEREMAILKEY";
  static String userProfilePicUrl = "USERPROFILEPICKEY";

  Future saveUsername(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(
        userNameKey, getUserName); //if successful return true else return false
  }

  Future saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailkey,
        getUserEmail); //if successful return true else return false
  }

  Future saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(
        userIdkey, getUserId); //if successful return true else return false
  }

  Future saveDisplayName(String getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displaNamekey,
        getDisplayName); //if successful return true else return false
  }

  Future saveUserProfilePicUrl(String getUserProfilePicUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilePicUrl,
        getUserProfilePicUrl); //if successful return true else return false
  }

  //Getting the datas
  Future getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString(userNameKey); //if successful return true else return false
  }

  Future getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString(userEmailkey); //if successful return true else return false
  }

  Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString(userIdkey); //if successful return true else return false
  }

  Future getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString(displaNamekey); //if successful return true else return false
  }

  Future getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
        userProfilePicUrl); //if successful return true else return false
  }
}
