part of 'functions.dart';

executeOneByOne<T>(List<T> list,Duration delayForNext,void Function(T) process)async{
  for(var e in list){
    process(e);
    await Future.delayed(delayForNext);
  }
}