import 'package:flutter/material.dart';

import 'background.dart';
import 'bottom_buttons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(context),
        child: Center(
          child: Column(
            children: [
              Text("profile", style: Theme.of(context).textTheme.headline5),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FooterButtons(
        page: "profile",
      ),
    );
  }
}
