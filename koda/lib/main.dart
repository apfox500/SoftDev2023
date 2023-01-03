import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:koda/screens/flash/failed_load.dart';

import 'models/global.dart';
import 'providers/firebase_options.dart';
import 'providers/get_data_from_sheets.dart';
import 'screens/common/home.dart';
import 'screens/flash/loading_page.dart';

//When I have trouble with pods and the app not builiding, i've found the following to be effective:
//flutter clean; rm ios/Podfile ios/Podfile.lock pubspec.lock; rm -rf ios/Pods ios/Runner.xcworkspace; flutter run
//--or--
//flutter clean; rm macos/Podfile macos/Podfile.lock pubspec.lock; rm -rf macos/Pods macos/Runner.xcworkspace; flutter run
//need to have the flutter command working tho, so ryan you can't use it rn just text me

//rm -R build; rm .dart_tool; rm .packages; rm -Rf ios/Pods; rm -Rf ios/.symlinks; rm -Rf ios/Flutter/Flutter.framework; rm -Rf ios/Flutter/Flutter.podspec; pod cache clean --all; cd ios > pod deintegrate; pod setup; arch -x86_64 pod install cd ..; flutter clean -v; flutter pub get; flutter clean && flutter run

//Most important website ever:
//https://www.generatormix.com/random-dinosaurs?number=1
//TODO: create a page with a python editor/console on it so they can actually code in app
//TODO: use routes instead of .push for the main pages(i think idk if its actually supposed to happen)
//TODO: rn everything is like one class(intro and intermediate are combined), and they could
///techincally start anywhere, so we will need to figure out if there is intro/intermediate or how
///to unlock sections etc.
//TODO: use testing to check widgets, methods, maybe whole app
void main() async {
  bool timerDone = false;
  bool run = false;
  Timer(const Duration(seconds: 15), () {
    if (!run) {
      timerDone = true;
      runApp(
        const FailedLoadScreen(),
      );
    }
  });
  runApp(
    const LoadingScreen(),
  );
  //initialize firebase
  if (!timerDone) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  User? user = FirebaseAuth.instance.currentUser;
  //instantiate our global variable
  Global global = Global(user: user);

  //get lesson plans
  if (!timerDone) {
    await getDataFromGoogleSheet(global);
  }

  //profile stuff here for now
  //but why sync here when it syncs when you open the home page?
  //possibly remove
  if (user != null && !timerDone) {
    await global.userUpdate();
  }

  //open real app
  if (!timerDone) {
    run = true;
    runApp(MyApp(global));
  }
}

class MyApp extends StatelessWidget {
  const MyApp(this.global, {Key? key}) : super(key: key);
  final Global global;

  @override
  Widget build(BuildContext context) {
    //actually build the app
    return MaterialApp(
      /* theme: ThemeData(
        //light theme
        colorSchemeSeed: Global.bone,
        brightness: Brightness.light,
      ), */
      darkTheme: ThemeData(
        //dark theme
        colorSchemeSeed: Global.coolGrey,
        brightness: Brightness.dark,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/sign-in'
          : '/home', //this way, only signed in users can use the app
      debugShowCheckedModeBanner: false,
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: Global.providers,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/home');
              }),
            ],
          );
        },
        '/home': (context) {
          return HomePage(global);
        }
      },
      //debugShowMaterialGrid: true,
    );
  }
}
