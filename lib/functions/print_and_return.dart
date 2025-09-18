part of 'functions.dart';

T par<T>(T value,[String? title]){

    if(title!=null){
      title += ": ";
    }
    if (kDebugMode) {
      print('${title??''}$value');
    }

  return value;
}