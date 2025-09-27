part of 'functions.dart';

Future<bool> get areGooglePlayServicesAvailableForAndroid async{


  if(Platform.isAndroid){
    GooglePlayServicesAvailability availability =
    await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
    return availability == GooglePlayServicesAvailability.success;
  }

  throw Exception("Not Android");


}