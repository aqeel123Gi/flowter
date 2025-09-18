part of 'extensions.dart';

extension GenericFunctions<T> on T {

  bool isOneOf(Iterable<T> list){
    return list.contains(this);
  }

  bool isNotOneOf(Iterable<T> list){
    return !list.contains(this);
  }

  V execute<V>(V Function(T) function){
    return function(this);
  }

}