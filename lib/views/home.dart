import 'package:flutter/material.dart';
import 'package:my_messenger/views/auth/signIn.dart';
import 'package:my_messenger/views/services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              AuthMethod().signOut().then((value) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Text("Homepage"),
        ),
      ),
    );
  }
}
