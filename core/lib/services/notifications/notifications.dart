library notifications;

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../app_initializer/app_initializer.dart';
import '../../widgets/screen_debugger/screen_debugger.dart';
import '../../functions/functions.dart';

part 'notifications_settings.dart';

class Notifications{

  static String? _firebaseMessagingAppToken;

  static String? get firebaseMessagingAppToken => _firebaseMessagingAppToken;



  static Future<void> initialize({required NotificationSettingsEnvironment notificationSettings})async{


    final options = notificationSettings.notificationConnection.firebaseOptions;
    if (options == null) return;


    if (Platform.isIOS && kDebugMode) {
      if(kDebugMode){
        print("Cannot run Firebase Messaging in iOS with Debug mode.");
      }
      return;
    }


    if (Platform.isAndroid && !(await areGooglePlayServicesAvailableForAndroid)) {
      DebuggerConsole.setPinnedLine(
        "GOOGLE PLAY SERVICES NOT AVAILABLE",
        "GOOGLE PLAY SERVICES NOT AVAILABLE",
        color: Colors.cyanAccent,
      );
      return;
    }


    await Firebase.initializeApp(options: options);


    _firebaseMessagingAppToken = await FirebaseMessaging.instance.getToken();


    final messaging = FirebaseMessaging.instance;


    if (Platform.isIOS) {

      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        criticalAlert: false,
        carPlay: false,
      );

      // تحكّم بعرض الإشعار أثناء المقدمة
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // ضمَن APNs token (يمهّد الطريق لتوليد FCM token)
      try {
        await messaging.getAPNSToken();
      } catch (_) {
        // تجاهل، بعض الإصدارات قد ترجع null بدون استثناء
      }

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        if (kDebugMode) debugPrint('Push permission denied on iOS.');
      }
    }


    // الحصول على FCM token مع fallback
    try {
      _firebaseMessagingAppToken = await messaging.getToken();
      _firebaseMessagingAppToken ??= await messaging.onTokenRefresh.first;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting FCM token: $e');
      }
    }


    if(notificationSettings.onDataWithAppMessaging != null) FirebaseMessaging.onMessage.listen(notificationSettings.onDataWithAppMessaging!);
    if(notificationSettings.onDataWithAppOpened != null) FirebaseMessaging.onMessageOpenedApp.listen(notificationSettings.onDataWithAppOpened!);
    if(notificationSettings.onDataWithAppClosed != null) FirebaseMessaging.onBackgroundMessage(notificationSettings.onDataWithAppClosed!);


  }

}