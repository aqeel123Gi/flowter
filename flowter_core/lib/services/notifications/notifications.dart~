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

    await Firebase.initializeApp(options: options);
    final messaging = FirebaseMessaging.instance;

    if (Platform.isAndroid) {
      await _initializeAndroid(messaging);
    } else if (Platform.isIOS) {
      await _initializeIOS(messaging);
    }


    if(notificationSettings.onDataWithAppMessaging != null) FirebaseMessaging.onMessage.listen(notificationSettings.onDataWithAppMessaging!);
    if(notificationSettings.onDataWithAppOpened != null) FirebaseMessaging.onMessageOpenedApp.listen(notificationSettings.onDataWithAppOpened!);
    if(notificationSettings.onDataWithAppClosed != null) FirebaseMessaging.onBackgroundMessage(notificationSettings.onDataWithAppClosed!);


  }


// ----- Android Flow -----
  static Future<void> _initializeAndroid(FirebaseMessaging messaging) async {


    // التحقق من Google Play Services (لو مطبق عندك)
    if (!await areGooglePlayServicesAvailableForAndroid) {
      DebuggerConsole.setPinnedLine(
        "GOOGLE PLAY SERVICES NOT AVAILABLE",
        "GOOGLE PLAY SERVICES NOT AVAILABLE",
        color: Colors.cyanAccent,
      );
      return;
    }

    try {

      await loopExecution(
        function: () async {
          _firebaseMessagingAppToken = await messaging.getToken()
              .timeout(const Duration(seconds: 5), onTimeout: () => null);
        },
        stopOn: () => _firebaseMessagingAppToken != null,
        breakDuration: const Duration(seconds: 5),
      );

      messaging.onTokenRefresh.listen((newToken) {
        _firebaseMessagingAppToken = newToken;
        // هنا حدث التوكن عند السيرفر لو محتاج
      });
      debugPrint("Android FCM Token: $_firebaseMessagingAppToken");
    } catch (e) {
      debugPrint("Error getting Android FCM token: $e");
    }
  }


  // ----- iOS Flow -----
  static Future<void> _initializeIOS(FirebaseMessaging messaging) async {
    // طلب إذن الإشعارات
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      criticalAlert: false,
      carPlay: false,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint("Push permission denied on iOS.");
      return;
    }

    try {
      // اختياري: جلب APNs token للتأكد
      final apnsToken = await messaging.getAPNSToken();
      debugPrint("iOS APNS Token: $apnsToken");

      // جلب FCM token
      await loopExecution(
          function: ()async{
            _firebaseMessagingAppToken = await messaging.getToken()
                .timeout(const Duration(seconds: 5), onTimeout: () => null);
          },
          stopOn: () => _firebaseMessagingAppToken != null,
          breakDuration: const Duration(seconds: 5)
      );

      messaging.onTokenRefresh.listen((newToken) {
        _firebaseMessagingAppToken = newToken;
        // حدث التوكن عند السيرفر لو محتاج
      });

      debugPrint("iOS FCM Token: $_firebaseMessagingAppToken");

      // عرض الإشعارات أثناء foreground
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      debugPrint("Error getting iOS tokens: $e");
    }

  }



}