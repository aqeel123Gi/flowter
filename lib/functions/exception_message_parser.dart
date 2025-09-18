import 'package:framework/classes/exceptions.dart';

String parseErrorMessage (Object exception){

  if(exception.runtimeType == NoConnectionException){
    return "لا يوجد اتصال بالشبكة.";
  }

  if(exception.runtimeType == NetworkException){
    return "لا يوجد اتصال بالإنترنت أو جودة الاتصال ضعيفة.";
  }

  if(exception.runtimeType == ServerErrorException){
    return "حدث خطأ استجابة:${(exception as ServerErrorException).responseCode}.";
  }

  return "حدث خطأ.";

}