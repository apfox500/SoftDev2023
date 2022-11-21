import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'background.dart';
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(context),
        child: Center(
          child: SafeArea(
            child: ProfileScreen(
              //TODO: improve profile page ui
              providers: global.providers,
              actions: [
                SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, '/sign-in');
                }),
              ],
            ),
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
