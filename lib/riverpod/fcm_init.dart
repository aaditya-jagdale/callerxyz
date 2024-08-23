import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseFcmManager {
  Future<String> initFcmToken() async {
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    log('////#### token: $fcmToken');
    return fcmToken ?? "";
  }

  Future<void> removeFcmToken() async {
    await FirebaseMessaging.instance.deleteToken();
    log('////#### deleted token');
  }
}
