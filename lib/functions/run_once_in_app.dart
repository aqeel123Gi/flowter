part of 'functions.dart';


class RunOnce {

  static late Box box;
  static bool initialized = false;

  static Future<void> init({String fileName = '.run_once'})async{
    box = await Hive.openBox(fileName);
    initialized = true;
  }


  static Future<void> process({
    required String key,
    required DateTime endDate,
    required Function() process
  })async{

    if(!initialized){
      throw Exception('RunOnce must be initialized first.');
    }

    if(DateTime.now().isAfter(endDate)) return;

    bool hasProcessed = box.get(key, defaultValue: false);
    if (!hasProcessed) {
      await process();
      await box.put(key, true);
    }
  }

}