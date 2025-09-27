part of 'functions.dart';

executeIfSucceed(dynamic Function() process,void Function(dynamic data) onSucceed){
  try{
    onSucceed(process());
  }catch(_){}
}