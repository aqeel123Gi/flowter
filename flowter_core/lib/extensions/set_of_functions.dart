part of 'extensions.dart';


extension SetOfFunctions on Set<VoidCallback>{

  void executeAll(){
    forEach((fun){
      fun();
    });
  }

}