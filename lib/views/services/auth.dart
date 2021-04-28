import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_messenger/views/helper/sharedPref_helper.dart';
import 'package:my_messenger/views/home.dart';
import 'package:my_messenger/views/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  } //give me the current user who is already logged in

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }

  signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);
    User userDetails = result.user;

    if (result != null) {
      SharedPrefHelper().saveUserEmail(userDetails.email);
      SharedPrefHelper().saveUserId(userDetails.uid);
      SharedPrefHelper().saveDisplayName(userDetails.displayName);
      SharedPrefHelper().saveUserProfilePicUrl(userDetails.photoURL);
    }

    Map<String, dynamic> userInfoMap = {
      "email": userDetails.email,
      "username": userDetails.email.replaceAll("@gmail.com", ""),
      "name": userDetails.displayName,
      "imgUrl": userDetails.photoURL,
      "userId": userDetails.uid
    };
    DatabaseMethods()
        .addUserInfoToDB(userDetails.uid, userInfoMap)
        .then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }
}
