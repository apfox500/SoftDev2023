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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(context),
        child: Center(),
      ),
      bottomNavigationBar: FooterButtons(
        global,
        page: "Profile",
      ),
    );
  }
}
