import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'bottom_buttons.dart';
import 'global.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(this.global, {Key? key}) : super(key: key);
  final Global global;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Global global = widget.global;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      //if they are signed out, then we gotta go to the sign in page
      //print('User is currently signed out!');
      Navigator.pushReplacementNamed(context, '/sign-in');
    }
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: ProfileScreen(
            //TODO: improve profile page ui
            //We need some way of contiuing the amazing background as well as having settings
            providers: global.providers,
            actions: [
              SignedOutAction((context) {
                global.signout();
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterButtons(
        global,
        page: "Profile",
      ),
    );
  }
}
