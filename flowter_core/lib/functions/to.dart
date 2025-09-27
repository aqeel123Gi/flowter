part of 'functions.dart';

T fromTo<T>(T from, Iterable<T> listFrom, T to){
  if(listFrom.contains(from)) return to;
  return from;
}