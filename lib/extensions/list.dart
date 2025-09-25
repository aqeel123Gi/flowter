part of 'extensions.dart';

extension ListFunctions<T> on List<T> {



  //
  //
  //
  //
  // Elements Modifications:
  //
  //
  //
  //

  List<T> filterElementsByRepeatedValueIn<K>(K Function(T element) valueToCompare){
    List<T> list = [];
    forEach((element){

      bool repeated = false;

      for (var element2 in list) {
        if (valueToCompare(element) == valueToCompare(element2)) {
          repeated = true;
          break;
        }
      }

      if(!repeated){
        list.add(element);
      }

    });
    return list;
  }

  void addInNotNull(T? value){
    if(value!=null){
      add(value);
    }
  }


  void addOrRemove(T value){
    if(contains(value)){
      remove(value);
    }else{
      add(value);
    }
  }

  void forIndexedEach(void Function(int index,T element) process){
    for (int i=0;i<length;i++){
      process(i,this[i]);
    }
  }

  List<T> get copy{
    List<T> list = [];
    for(int i=0;i<length;i++){
      list.add(this[i]);
    }
    return list;
  }


  List<T> insertAroundElements(T elementToBeInserted){
    if(isEmpty){
      return [];
    }
    List<T> list = [];
    for(int i=0;i<length;i++){
      list.add(elementToBeInserted);
      list.add(this[i]);

      if(i==length-1){
        list.add(elementToBeInserted);
      }
    }
    return list;
  }

  List<T> insertBetweenElements(T elementToBeInserted){
    if(isEmpty){
      return [];
    }
    List<T> list = [];
    for(int i=0;i<length;i++){

      list.add(this[i]);
      list.add(elementToBeInserted);
    }

    list.removeLast();

    return list;
  }

  //
  //
  //
  //
  // Elements Getters:
  //
  //
  //
  //

  T? getBeforeElement(T element){
    for(int i=0;i<length;i++){
      if(this[i] == element){
        return i==0?null:this[i-1];
      }
    }
    throw Exception("The element is not in the list.");
  }

  T getAfterElement(T element,[bool loop = false]){
    for(int i=0;i<length;i++){
      if(this[i] == element){
        return loop?this[(i+1)%length]:i==length-1?throw Exception("The element is the last."):this[i+1];
      }
    }
    throw Exception("The element is not in the list.");
  }

  T getNextElementOf(T element,[bool returnToFirst = false]){
    if(!contains(element)){
      throw Exception("The element is not in the list.");
    }
    int index = indexOf(element);
    if(index==length-1){
      if(returnToFirst){
        return this[0];
      }else{
        throw Exception("There is no next element.");
      }
    }
    return this[index+1];
  }

  T getFromLast(int from) => this[length-1-from];



  //
  //
  //
  //
  // Conditions:
  //
  //
  //
  //

  bool whereAllList(bool Function(T) function){
    for(var e in this){
      if(!function(e)){
        return false;
      }
    }
    return true;
  }

  List<A> indexedMap<A>(A Function(int index,T element) function){
    List<A> list = [];
    for(int i=0;i<length;i++){
      list.add(function(i,this[i]));
    }
    return list;
  }

  bool whereHas(bool Function(T) function){
    for(var e in this){
      if(function(e)){
        return true;
      }
    }
    return false;
  }





  bool anyContainsIn(List<T> list){
    return any((element) => list.contains(element));
  }

  printPositionOfElement(T element){
    if (kDebugMode) {
      String line = "";
      for(int i=0;i<length;i++){
        if(this[i] == element){
          line += "0";
        }else{
          line += "1";
        }
      }
      print(line);
    }
  }


  printAllBy(dynamic Function(T element) function){
    for(var e in this){
      if (kDebugMode) {
        print(function(e));
      }
    }
  }


  void sortBy(dynamic Function(T element) function, {bool skipOnNoSuchMethodError = false, bool reverse = false}){
    try{
      if(reverse){
        sort((a,b) => function(b).compareTo(function(a)));
      }else{
        sort((a,b) => function(a).compareTo(function(b)));
      }
    }catch(e){
      if(e is NoSuchMethodError && skipOnNoSuchMethodError){
        return;
      }else{
        rethrow;
      }
    }
  }


  Map<V,int> numberOfBy<V>(V Function(T element) by){
    Map<V,int> map = {};
    for(var e in this){
      map[by(e)] = map.containsKey(by(e))?map[by(e)]!+1:1;
    }
    return map;
  }



  LinePosition getLinePosition(T origin, T destination){

    int indexOrigin = indexOf(origin);
    int indexDestination = indexOf(destination);

    if(indexOrigin<indexDestination){
      return LinePosition.after;
    }else if(indexOrigin>indexDestination){
      return LinePosition.before;
    }else{
      return LinePosition.at;
    }
  }


  void insertIf(int index, T element, bool Function() condition){
    if(condition()){
      insert(index, element);
    }
  }



  List<Widget> expandedBuild([double spaceBetween = 0, double spaceAround = 0]){

    return [
      Space(spaceAround),
      ...map<Widget>((e)=>Expanded(child: e as Widget)).toList().insertBetweenElements(Space(spaceBetween)),
      Space(spaceAround)
    ];

  }




  Future<Iterable<T>> whereAsync(Future<bool> Function(T) condition)async{
    List<T> list = [];
    for(var e in this){
      if(await condition(e)){
        list.add(e);
      }
    }
    return list;
  }

  List<K> toType<K>(){
    List<K> list = [];
    for(var e in this){
      list.add(e as K);
    }
    return list;
  }


  // void insertIf(int index, T element, bool Function() condition){
  //   if(condition()){
  //     insert(index, element);
  //   }
  // }



  T? tryGetAtIndex(int index, [T? onNullElement]){
    if(index<0 || index>=length){
      return null;
    }
    return this[index];
  }




  List<V> concatenated<V>(){
    List<V> list = [];
    for(var e in this){
      list.addAll(e as List<V>);
    }
    return list;
  }


  Map<K,List<T>> groupedBy<K>(K Function(T element) by){
    Map<K,List<T>> map = {};
    for(var e in this){
      map[by(e)] = map.containsKey(by(e))?map[by(e)]!+[e]:[e];
    }
    return map;
  }




  Map<T,GlobalKey> pairedWithGlobalKey(){
    Map<T,GlobalKey> map = {};
    for(var e in this){
      map[e] = GlobalKey();
    }
    return map;
  }




  Map<K,List<T>> groupedByWithKeys<K>(List<K> keys, K Function(T element) by){

    Map<K,List<T>> map = keys.toMap(
      keyFrom: (index,key) => key,
      valueFrom: (index,key) => []
    );

    for(var e in this){
      if(!keys.contains(by(e))){
        continue;
      }
      map[by(e)]!.add(e);
    }

    return map;

  }



  T get getRandomElement => this[Random().nextInt(length)];


  T nextOf(T element, [bool returnToFirst = false]){
    int index = indexOf(element);
    if(index==length-1){
      if(returnToFirst){
        return this[0];
      }else{
        throw Exception("There is no next element.");
      }
    }
    return this[index+1];
  }



}