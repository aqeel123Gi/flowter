part of 'app_initializer.dart';

/// App Customization, it prepared with the basic args needed for the common apps to be initialized which will be taken and excused in [AppFramework.appInitializer] function.
class AppCustomization{

  AppCustomization({
    this.googleAPIKey,
    this.appStoreId,
    this.filesDir,
    this.analyticsService,
    this.analyticsProjectID,


    this.windowsPlatformSettings,
    this.notificationSettings,


    this.onErrorThrown,
    this.errorWidgetBuilder,


    this.defaultFontFamily,

    required this.templateCustomization,

    required this.lightTheme,
    required this.darkTheme,

    this.appScale,

    this.arabicIndicAndPersianNumbersToEnglishNumbers = true,


    this.noScrollbar = true,



  });

  // Google Maps and Routes Api Key:
  final String? googleAPIKey;


  /// For app review, this can be found in App Store Connect under General > App Information > Apple ID.
  final String? appStoreId;

  /// Where Files Stored on the device (In Windows, it stored in [Documents] folder).
  final String? filesDir;

  // Analytics
  final AnalyticsService? analyticsService;
  final String? analyticsProjectID;

  // Windows Settings
  final WindowsPlatformSettings? windowsPlatformSettings;


  /// Notifications Settings for Firebase.
  /// TODO: it will include Huawei services, etc services to share same handlers over all.
  final NotificationSettingsEnvironment? notificationSettings;

  final bool arabicIndicAndPersianNumbersToEnglishNumbers;


  /// Errors Handler
  final void Function(Object exception, StackTrace stacktrace)? onErrorThrown;
  final Widget Function(FlutterErrorDetails details)? errorWidgetBuilder;


  final String? defaultFontFamily;

  final TemplateCustomization templateCustomization;

  final ThemeData lightTheme;
  final ThemeData darkTheme;

  final double Function()? appScale;

  final bool noScrollbar;


}


class WindowsPlatformSettings {

  const WindowsPlatformSettings({
    this.windowTitle,
    this.executableFileName,
    this.onlyOneTask = true,
  });


  final bool onlyOneTask;
  final String? executableFileName;
  final String? windowTitle;

}





class NotificationSettingsEnvironment {

  const NotificationSettingsEnvironment({
    required this.notificationConnection,
    this.onDataWithAppMessaging,
    this.onDataWithAppOpened,
    this.onDataWithAppClosed
  });

  // Notifications
  final NotificationConnection notificationConnection;
  final void Function(RemoteMessage)? onDataWithAppMessaging;
  final void Function(RemoteMessage)? onDataWithAppOpened;
  final Future<void> Function(RemoteMessage)? onDataWithAppClosed;

}