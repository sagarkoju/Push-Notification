import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;
  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  // static final PushNotificationsManager _instance =
  //     PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  void fcmSubscribe(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  void fcmUnSubscribe(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestPermission();
      _firebaseMessaging.getInitialMessage();
      fcmSubscribe("notice");

      // For testing purposes print the Firebase Messaging token
      String? token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}
