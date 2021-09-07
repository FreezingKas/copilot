import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

/* 
  GET REQUEST FOR SPEED LIMIT
  http://www.overpass-api.de/api/interpreter?data=[out:json];way["maxspeed"](around:10,48.071615,7.338893);out;

*/

class Speed extends StatefulWidget {
  Speed({Key? key}) : super(key: key);

  @override
  _SpeedState createState() => _SpeedState();
}

class _SpeedState extends State<Speed> {
  double _value = 1;
  double _latitude = 0;
  double _longitude = 0;
  String _speedLimit = "";

  late StreamSubscription _positionSubscription;
  Location location = new Location();

  stream() {
    _positionSubscription = location.onLocationChanged.listen((event) {
      setState(() {
        _value = ((event.speed ?? 0) * 3.6);
        _latitude = event.latitude ?? 0;
        _longitude = event.longitude ?? 0;
      });
    });
  }

  periodicSpeedRetriever() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        getSpeedLimit();
      });
    });
  }

  Future<void> getSpeedLimit() async{
    final response = await http.get(Uri.parse('http://www.overpass-api.de/api/interpreter?data=[out:json];way["maxspeed"](around:20,$_latitude,$_longitude);out;'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var body = jsonDecode(response.body);
      try{
        if(body['elements'][0]['tags']['maxspeed'] != null) {
          print(body['elements'][0]['tags']['maxspeed']);
          setState(() {
            _speedLimit = body['elements'][0]['tags']['maxspeed'];
          });
        } else  {
          setState(() {
            _speedLimit = "";
          });
          print("Speed not found");
          return;
        }
      } on RangeError catch(e) {
        setState(() {
          _speedLimit = "";
        });
        print("Speed not found");
        return;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Speed not found");
      throw Exception('Failed to load Way');
    }
  }

  @override
  void initState() {
    location.changeSettings(accuracy: LocationAccuracy.high, interval: 10);
    periodicSpeedRetriever();
    stream();
    super.initState();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    super.dispose();
  }

  Widget _buildPanel() {
    if(_speedLimit != "") {
      return Container(
          padding: EdgeInsets.all(11.0),
          decoration :
          new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 7)
          ),
          child: Text(
              _speedLimit,
              style: TextStyle(fontSize: _speedLimit.length == 3 ? 35 : 40)
          )
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              _value.toStringAsFixed(0) + " Km/h",
              style: TextStyle(fontSize: 45, fontFamily: 'Nexa'),
            ),
            if(_speedLimit != "")
              _buildPanel()
          ],
        )
    );
  }
}


