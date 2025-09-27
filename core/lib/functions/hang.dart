part of 'functions.dart';

bool _run = false;
Future<void> hang(Function onPress)async{
  if(!_run){
    _run = true;
    await Future.delayed(const Duration(milliseconds: 300));
    onPress();
    _run = false;
  }
}