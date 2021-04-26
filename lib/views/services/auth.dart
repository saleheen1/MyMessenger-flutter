import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_messenger/views/helper/sharedPref_helper.dart';

class AuthMethod {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() {
    return auth.currentUser;
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
  }
}
