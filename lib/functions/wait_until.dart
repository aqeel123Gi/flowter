part of 'functions.dart';

Future<void> waitUntil({
  required bool Function() valueToBeTrue,
  required void Function() process,
  Duration sleepPeriods = const Duration(milliseconds: 500),
})async{
  while(true){
    if(valueToBeTrue()){
      process();
      return;
    }
    await Future.delayed(sleepPeriods);
  }
}