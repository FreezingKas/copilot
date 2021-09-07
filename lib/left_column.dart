import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'speedometer.dart';
import 'package:spotify_sdk/spotify_sdk.dart';


// SPEED AND HOUR/NOTIFICATIONS
class LeftColumn extends StatefulWidget {
  LeftColumn({Key? key}) : super(key: key);

  @override
  _LeftColumnState createState() => _LeftColumnState();
}

class _LeftColumnState extends State<LeftColumn> {


  Future<void> connect() async {
    print("BEGIN");
    try {
      await SpotifySdk.connectToSpotifyRemote(
          clientId: "6905a1a1c09a4acfb70bea867cc9c84c", redirectUrl: "copilot://callback");

      var isActive = await SpotifySdk.isSpotifyAppActive;
      String snackBar = isActive
          ? 'Spotify app connection is active (currently playing)'
          : 'Spotify app connection is not active (currently not playing)';

      print(snackBar);

    } on PlatformException catch (e) {
      print("PE");
    } on MissingPluginException {
      print("MPE");
    } on Exception {
      print('what');
    }
  }

  Future<void> disconnect() async {
    try {
      var result = await SpotifySdk.disconnect();
      print("Disconnected");
    } on PlatformException catch (e) {
      print("plat");
    } on MissingPluginException {
      print("sd");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 90,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(child: Speed()),
            ),
          ),
          Spacer(flex: 10),
          Flexible(
            flex: 90,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                  child:
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton.extended(onPressed: connect, label: Text("CONNEXION"), ),
                        FloatingActionButton.extended(onPressed: disconnect, label: Text("DECONNEXION"))
                      ]
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
