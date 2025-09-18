part of 'functions.dart';

T? tryGet<T>(T Function() condition,[T? onError]){
  try{
    return condition();
  }catch(_){
    return onError;
  }
}


Future<T?> tryGetAsync<T>(Future<T> Function() condition,[T? onError])async{
  try{
    return await condition();
  }catch(_){
    return onError;
  }
}

void tryF(void Function() function){
  try{
    function();
  }catch(e){null;}
}

T? tryGetWhatever<T>(List<T Function()> functions,{bool Function()? condition, T? onError}){
  for (var function in functions) {
    try{
      T value = function();
      return value;
    }catch(_){}
  }
  return onError;
}
