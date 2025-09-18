// import 'package:flutter_clarity/flutter_clarity.dart';

enum AnalyticsService{
  clarity
}

class Analytics{

  static late AnalyticsService service;
  // static late FlutterClarityPlugin flutterClarityPlugin;

  static initialize(AnalyticsService service, String projectID)async{
    Analytics.service = service;
    switch(service){
      case AnalyticsService.clarity:
        // flutterClarityPlugin = FlutterClarityPlugin();
        // await flutterClarityPlugin.initialize(projectId:projectID);
        break;
    }
  }

  static setUser(String userID){
    switch(service){
      case AnalyticsService.clarity:
        // flutterClarityPlugin.setCustomUserId(userID);
        break;
    }
  }


}