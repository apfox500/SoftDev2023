import 'package:flutter/material.dart';

import '../../models/global.dart';

class FailedLoadScreen extends StatelessWidget {
  const FailedLoadScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        //dark theme
        colorSchemeSeed: Global.coolGrey,
        brightness: Brightness.dark,
      ),
      home: Container(
        height: double.infinity,
        width: double.infinity,
        color: Global.davysGrey,
        child: Center(
          child: Text(
            "App Failed to Load\nPlease Try Again Later",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5!.copyWith(color: Global.bone),
          ),
        ),
      ),
    );
  }
}
