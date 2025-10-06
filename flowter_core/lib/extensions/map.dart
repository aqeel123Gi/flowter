part of 'extensions.dart';

extension MapFunctions<K, V> on Map<K, V> {


  void addKeyWithValueIfKeyNotExists(K key, V value){
    if(!containsKey(key)){
      this[key] = value;
    }
  }

  Map<K, V> sortByKey() {
    var sortedKeys = keys.toList()..sort();
    Map<K, V> sortedMap = {};
    for (var key in sortedKeys) {
      sortedMap[key] = this[key] as V;
    }
    return sortedMap;
  }

  Map<K, V> withSortedMap(dynamic Function(K key,V value) function, [bool reversed = false]) {

    var entriesList = entries.toList();

    entriesList.sortBy((e) => function(e.key, e.value));

    if(reversed){
      entriesList = entriesList.reversed.toList();
    }

    return Map.fromEntries(entriesList);

  }

  // Map<K, V> sortWithinValues(dynamic Function(V element) function) {
  //   var sortedValues = values.toList();
  //   sortedValues.sortBy((e) => function(e));
  //   Map<K, V> sortedMap = {};
  //   for (var value in sortedValues) {
  //     for (var key in keys) {
  //       if (this[key] == value) {
  //         sortedMap[key] = value;
  //         break;
  //       }
  //     }
  //   }
  //   return sortedMap;
  // }





  Map<K, V> withRemovedNulls() {
    Map<K, V> map = {};
    for (var key in keys) {
      if(this[key]!=null){
        map[key] = this[key] as V;
      }
    }
    return map;
  }




  Map<K2, V2> modify<K2,V2>(
      {required K2 Function(K key, V value) keyFrom,
        required V2 Function(K key, V value) valueFrom}){
    Map<K2, V2> map = {};
    for (var key in keys) {
      map[keyFrom(key, this[key] as V)] = valueFrom(key, this[key] as V);
    }
    return map;
  }




  V get valueOfFirstKey{
    try{
      return (this as Map).values.first;
    }catch(_){
      throw Exception("dynamic has no key");
    }
  }




  V getFromOneOfTheKeys(List<K> keys){
    for (var key in keys) {
      if(containsKey(key)){
        return this[key]!;
      }
    }
    throw Exception("No key found");
  }




  Map<K, V> whereKeys(bool Function(K key) condition){
    Map<K, V> map = {};
    for (var key in keys) {
      if(condition(key)){
        map[key] = this[key] as V;
      }
    }
    return map;
  }




  Map<K, V> whereValues(bool Function(V value) condition){
    Map<K, V> map = {};
    for (var key in keys) {
      if(condition(this[key] as V)){
        map[key] = this[key] as V;
      }
    }
    return map;
  }



  MapEntry<K,V> entryWhereFirstKey(bool Function(K key) condition){
    for (var key in keys) {
      if(condition(key)){
        return MapEntry(key, this[key] as V);
      }
    }
    throw Exception("No key found");
  }



  List<Widget> build(Widget Function(K key, V value) widgetBuilder){
    List<Widget> widgets = [];
    for (var key in keys) {
      widgets.add(widgetBuilder(key, this[key] as V));
    }
    return widgets;
  }



  Map<K2,V2> toType<K2,V2>(){
    Map<K2, V2> map = {};
    for (var key in keys) {
      map[key as K2] = this[key] as V2;
    }
    return map;
  }


  Map<K,V> get reversed{
    Map<K, V> map = {};
    Iterable<K> keys = this.keys.toList().reversed;
    for (var key in keys) {
      map[key] = this[key] as V;
    }
    return map;
  }



  bool hasNoKeyOrNull(K key) {
    return !containsKey(key) || this[key] == null;
  }



  hasDataOfKey(String key) {

    if(containsKey(key) && this[key] != null){

      if(this[key] is Map) {
        return (this[key] as Map).isNotEmpty;
      }

      if(this[key] is List) {
        return (this[key] as List).isNotEmpty;
      }

      return this[key] != null;

    }

    return false;
  }


  Map<K,V> get copy{
    Map<K,V> copiedMap = {};
    for(K key in keys){
      copiedMap[key] = this[key] as V;
    }
    return copiedMap;
  }




  Map withUpdatedKeys(List keysToUpdate, Function(dynamic currentValue) newValue, [bool deep = false]) {

    Map dynamicMap = copy;

    dynamicMap.forEach((key, value) {
      if (keysToUpdate.contains(key)) {
        dynamicMap[key] = newValue(value);
      } else if (deep && value is Map<String, dynamic>) {
        value.withUpdatedKeys(keysToUpdate, newValue);
      }
    });

    return dynamicMap;
  }


  MapEntry<K, V>? tryFirstWhere(bool Function(K key, V value) condition) {
    for (var key in keys) {
      if (condition(key, this[key] as V)) {
        return MapEntry(key, this[key] as V);
      }
    }
    return null;
  }

  Map<K,V> withRemovedWhere(bool Function(K key, V value) condition) {
    Map<K,V> map = {};
    for (var key in keys) {
      if(!condition(key, this[key] as V)){
        map[key] = this[key] as V;
      }
    }
    return map;
  }



  Map<V,K> get swapped{
    Map<V, K> map = {};
    for (var key in keys) {
      if(map.containsKey(this[key] as V)){
        throw Exception("Map has duplicate value");
      }
      map[this[key] as V] = key;
    }
    return map;
  }



  List<V> valuesOfKeys(List<K> keys){
    List<V> values = [];
    for (var key in keys) {
      values.add(this[key] as V);
    }
    return values;
  }




  List<T> toList<T> (T Function(K key, V value) builder) {
    List<T> list = [];
    for (var key in keys) {
      list.add(builder(key, this[key] as V));
    }
    return list;
  }



  MapEntry<K,V>? tryEntryWhere(bool Function(K key, V value) condition){
    for (var key in keys) {
      if(condition(key, this[key] as V)){
        return MapEntry(key, this[key] as V);
      }
    }
    return null;
  }



  K getNextKeyOf(K key, {bool loop = false, bool endStop = false}){

    if(loop&&endStop){
      throw Exception("You can't loop and end stop at the same time.");
    }

    int currentIndex = keys.toList().indexOf(key);
    if(currentIndex == keys.length - 1){
      if(loop){
        return keys.toList()[0];
      }else if(endStop){
        return key;
      }else{
        throw Exception("There is no next key.");
      }
    }
    return keys.toList()[currentIndex + 1];
  }



  K getPreviousKeyOf(K key, {bool loop = false, bool endStop = false}){

    if(loop&&endStop){
      throw Exception("You can't loop and end stop at the same time.");
    }

    int currentIndex = keys.toList().indexOf(key);
    if(currentIndex == 0){
      if(loop){
        return keys.toList()[keys.length - 1];
      }else if(endStop){
        return key;
      }else{
        throw Exception("There is no previous key.");
      }
    }
    return keys.toList()[currentIndex - 1];

  }





}