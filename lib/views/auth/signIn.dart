import 'package:flutter/material.dart';
import 'package:my_messenger/views/others/constants.dart';
import 'package:my_messenger/views/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: InkWell(
            onTap: () {
              AuthMethod().signInWithGoogle(context);
            },
            child: Container(
              color: Colors.redAccent,
              padding: EdgeInsets.all(20),
              child: Text(
                "Sign in with google",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
