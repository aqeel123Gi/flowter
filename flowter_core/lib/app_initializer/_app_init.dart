part of 'app_initializer.dart';


Future<void> appInit(AppCustomization environment)async{


  WidgetsFlutterBinding.ensureInitialized();

  AppLifecycleObserver.initialize();

  await Hive.initFlutter(environment.filesDir);


  await DevStageController.initialize();


  // Database Init
  if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await logsInitialize();



  // Notifications Settings
  if(environment.notificationSettings != null && !Platform.isWindows) {
    Notifications.initialize(notificationSettings: environment.notificationSettings!);
  }



  // Windows Platform Settings
  if(environment.windowsPlatformSettings!=null && Platform.isWindows){

    await windowManager.ensureInitialized();
    if(environment.windowsPlatformSettings!.windowTitle!=null){
      await windowManager.setTitle(environment.windowsPlatformSettings!.windowTitle!);
    }

  }


  // Error Widget Builder
  Widget Function(FlutterErrorDetails details) errorWidgetBuilder = ErrorWidget.builder;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if(environment.onErrorThrown!=null && details.stack!=null){
      environment.onErrorThrown!(details.exception,details.stack!);
    }
    if(kDebugMode || kProfileMode || (kDebugMode && environment.errorWidgetBuilder==null)){
      return errorWidgetBuilder(details);
    }
    return environment.errorWidgetBuilder!(details);
  };




  if(environment.arabicIndicAndPersianNumbersToEnglishNumbers){
    AdvancedTextFieldController.setGlobalCharConversion({
      '٠': '0', // Arabic-Indic digits
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      '۰': '0', // Persian digits
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    });
  }


}