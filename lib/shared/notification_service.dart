import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_badger/flutter_app_badger.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '9999', // id
  'your channel name', // title
  // 'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  _updateBagder(message.data);
  print('A bg message just showed up :  ${message.messageId}');
}

final storage = new FlutterSecureStorage();

_updateBagder(message) async {
  final storage = new FlutterSecureStorage();
  dynamic valueStorage = await storage.read(key: 'dataUserLoginDDPM');
  dynamic _token = await storage.read(key: 'tokenD');
  dynamic dataValue =
      valueStorage == null ? {'email': ''} : json.decode(valueStorage);
  var _email = dataValue['email'].toString() ?? "";
}

class NotificationService {
  /// We want singelton object of ``NotificationService`` so create private constructor
  /// Use NotificationService as ``NotificationService.instance``
  final storage = new FlutterSecureStorage();

  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();
  bool _started = false;
  void start(BuildContext context) {
    if (!_started) {
      _integrateNotification(context);
      _refreshToken();
      _started = true;
    }
  }

  Future<void> _refreshToken() async {
    FirebaseMessaging.instance.getToken().then((token) async {
      print('token: $token');

      storage.write(key: 'tokenD', value: token);
    }, onError: _tokenRefreshFailure);
  }

  void _tokenRefresh(String newToken) async {
    // print('New Token : $newToken');

    storage.write(key: 'tokenD', value: newToken);
  }

  void _tokenRefreshFailure(error) {
    print("FCM token refresh failed with error $error");
  }

  void _integrateNotification(BuildContext context) {
    _initializeLocalNotification();
    _registerNotification(context);
  }

  Future<void> _initializeLocalNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance.subscribeToTopic('all');
  }

  void _registerNotification(BuildContext context) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _updateBagder(message.data);

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('1'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('2')],
                  ),
                ),
              );
            });
      }
       else {
        switch (message.data['page']) {
          case 'NEWS':
            {
             print('----123----Test');
            }
            break;
        }
       }
    });

    FirebaseMessaging.instance.onTokenRefresh
        .listen(_tokenRefresh, onError: _tokenRefreshFailure);
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing ",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                // color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }
}
