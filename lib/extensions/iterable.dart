part of 'extensions.dart';

extension IterableFunctions<T> on Iterable<T>{

  Map<K,V> toMap<K,V>({required K Function(int index, T element) keyFrom, required V Function(int index, T element) valueFrom, bool Function(T)? where}){
    Map<K,V> map = {};
    var index = 0;
    for (var element in this) {
      if (where == null || where(element)) {
        map[keyFrom(index, element)] = valueFrom(index, element);
      }
      index++;
    }
    return map;
  }




  List<Widget> build(Widget Function(int index,T element) widgetBuilder){
    List<Widget> widgets = [];

    int i=0;
    for(var element in this){
      widgets.add(widgetBuilder(i++,element));
    }
    return widgets;
  }

  T? tryFirstWhere(bool Function(T) where){
    try{
      T e = firstWhere((element) => where(element));
      return e;
    }catch(_){
      return null;
    }
  }



}