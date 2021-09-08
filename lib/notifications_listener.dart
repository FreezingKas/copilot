import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';

class NotificationsLts extends StatefulWidget {
  NotificationsLts({Key? key}) : super(key: key);



  @override
  _NotificationsLtsState createState() => _NotificationsLtsState();
}

class _NotificationsLtsState extends State<NotificationsLts> {

  Notifications? _notifications;
  StreamSubscription<NotificationEvent>? _subscription;
  List<NotificationEvent> _log = [];
  bool started = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void onData(NotificationEvent event) {
    setState(() {
      _log.add(event);
    });
    print(event.toString());
  }

  void example() {
    Notifications().notificationStream!.listen((event) => print(event));
  }

  void startListening() {
    _notifications = Notifications();
    try {
      _subscription = _notifications!.notificationStream!.listen(onData);
      setState(() => started = true);
    } on NotificationException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription?.cancel();
    setState(() => started = false);
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new ListView.builder(
            itemCount: _log.length,
            reverse: true,
            itemBuilder: (BuildContext context, int idx) {
              final entry = _log[idx];
              return ListTile(
                  leading:
                  Text(entry.timeStamp.toString().substring(0, 19)),
                  trailing:
                  Text(entry.packageName.toString().split('.').last));
            }
        )
    );

  }
}