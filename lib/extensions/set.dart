part of 'extensions.dart';

extension SetFunctions<T> on Set<T> {
  void addInNotNull(T? value){
    if(value!=null){
      add(value);
    }
  }

  bool addOrRemove(T value){
    if(contains(value)){
      remove(value);
      return false;
    }else{
      add(value);
      return true;
    }
  }
}