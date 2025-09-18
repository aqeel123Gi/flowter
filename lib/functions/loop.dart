part of 'functions.dart';

stop()async{
  await Future.delayed(const Duration(hours: 9999));
}

dynamic loopUntilSuccess(Function() function,bool Function()? stopRepeatingWhen)async{
  try{
    return await function();
  }catch(e,s){

    if (kDebugMode) {
      print(e);
      print(s);
    }

    if(stopRepeatingWhen==null || !stopRepeatingWhen()){
      return await loopUntilSuccess(function,stopRepeatingWhen);
    }
  }
}

Future<void> loopExecution({required Function() function,required  bool Function() stopOn,required Duration breakDuration})async{
  while(!stopOn()){
    await function();
    await Future.delayed(breakDuration);
  }
}

dynamic loopOnDebug(Function() function)async{
  if(kDebugMode){
    return await loopUntilSuccess(function,()=>false);
  }else{
    return await function();
  }
}