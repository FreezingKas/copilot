import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';
import 'line_one.dart';
import 'line_two.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SpotifySdk.connectToSpotifyRemote(
      clientId: "6905a1a1c09a4acfb70bea867cc9c84c", redirectUrl: "copilot://callback");

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(MyApp());
  });

  //var tok = await SpotifySdk.getAuthenticationToken(clientId: "6905a1a1c09a4acfb70bea867cc9c84c", redirectUrl: "copilot://callback");
  //print(tok);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
        title: 'Copilot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: AnimatedSplashScreen(
            duration: 3000,

            splashIconSize: 300,
            splash: 'assets/Copilot.png',
            nextScreen: Scaffold(body: LineOne()),
            splashTransition: SplashTransition.slideTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Colors.white
        )
    );
  }
}