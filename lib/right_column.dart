import 'dart:typed_data';
import 'dart:ui';

import 'package:copilot/speedometer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/player_state.dart';



// SPOTIFY INTERFACE
class RightColumn extends StatefulWidget {
  RightColumn({Key? key}) : super(key: key);

  @override
  _RightColumnState createState() => _RightColumnState();
}

class _RightColumnState extends State<RightColumn> {
  bool _connected = true;

  Future<void> skipNext() async {
    print("Next song...");

    try {
      await SpotifySdk.skipNext();
      print("Next song ✓");
    } on PlatformException catch (e) {
      print("PlatformException" + e.code);
    } on MissingPluginException {
      print("MissingPluginException");
    }
  }

  Future<void> skipPrevious() async {
    print("Previous song...");

    try {
      await SpotifySdk.skipPrevious();
      print("Previous song ✓");
    } on PlatformException catch (e) {
      print("PlatformException" + e.code);
    } on MissingPluginException {
      print("MissingPluginException");
    }
  }

  Future<void> pause() async {
    print("Pausing song...");

    try {
      await SpotifySdk.pause();
      print("Song paused ✓");
    } on PlatformException catch (e) {
      print("PlatformException" + e.code);
    } on MissingPluginException {
      print("MissingPluginException");
    }
  }

  Future<void> like(sUri) async {
    print("Like song...");

    try {
      await SpotifySdk.addToLibrary(spotifyUri: sUri);
      print("Song liked ✓");
      Fluttertoast.showToast(
          msg: "Ajoutée à Titres Likés ♥",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 40.0
      );
    } on PlatformException catch (e) {
      print("PlatformException" + e.code);
    } on MissingPluginException {
      print("MissingPluginException");
    }

  }

  Future<void> resume() async {
    print("Resuming song...");

    try {
      await SpotifySdk.resume();
      print("Song resumed ✓");
    } on PlatformException catch (e) {
      print("PlatformException" + e.code);
    } on MissingPluginException {
      print("MissingPluginException");
    }
  }

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


  Widget _buildSpotifyWidget(var track, var playerState) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: ImageUri('${track.imageUri.raw}'),
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return new Container(
                decoration: new BoxDecoration(
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
                    image: new DecorationImage(
                      image: MemoryImage(snapshot.data!),
                      fit: BoxFit.cover,
                    )
                ),
                child:
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                    BackdropFilter(
                        filter: ImageFilter.blur(sigmaX:10, sigmaY:10),
                        child:
                        GestureDetector(
                            onDoubleTap: () => like('${track.uri}'),
                            child:
                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Text(
                                            '${track.name}',
                                            style: TextStyle(fontSize: 40, fontFamily: 'Nexa', fontWeight: FontWeight.bold, color: Colors.white ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )
                                      ),
                                      Center(
                                          child: Text(
                                            '${track.artist.name}',
                                            style: TextStyle(fontSize: 20, fontFamily: 'Nexa', color: Colors.white),
                                          )
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Flexible(flex: 1, child: FloatingActionButton(onPressed: skipPrevious, child: Icon(Icons.skip_previous))),
                                            Flexible(flex: 1, child:FloatingActionButton(onPressed: playerState.isPaused ? resume : pause, child: playerState.isPaused ? Icon(Icons.play_arrow) : Icon(Icons.pause))),
                                            Flexible(flex: 1, child:FloatingActionButton(onPressed: skipNext, child: Icon(Icons.skip_next)))
                                          ]
                                      )
                                  )
                                ]
                            )
                        )
                    )
                )
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        }
    );
  }

  Widget _buildConnectedWidget() {
    return StreamBuilder(
        stream: SpotifySdk.subscribePlayerState(),
        builder: (BuildContext ctx, AsyncSnapshot<PlayerState> snapshot) {
          var track = snapshot.data?.track;
          var playerState = snapshot.data;

          if (playerState == null || track == null) {
            return Center(
              child: Container(),
            );
          }

          return Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                    flex: 1,
                    child: _buildSpotifyWidget(track, playerState)
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildDisconnectedWidget() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 1,
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
              child:
              Center(child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/Disconnect.png', height: 128, width: 128),
                    Container(child: Text("Spotify Déconnecté",
                        style: TextStyle(fontSize: 30, fontFamily: 'Nexa'),
                        textAlign: TextAlign.center),
                        padding: EdgeInsets.all(30.0)),
                    FloatingActionButton.extended(onPressed: connect, label: Text("CONNEXION"))
                  ]
              )

              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = true;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return _connected ? _buildConnectedWidget() : _buildDisconnectedWidget();
        }
    );
  }
}
