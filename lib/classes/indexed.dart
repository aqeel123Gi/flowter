import 'package:flutter/cupertino.dart';

class Indexed{

  late int _recordLength;
  late List<Type> _types;
  late List<List<dynamic>> _data;
  // late Set<dynamic> _allData;

  Indexed(List<List<dynamic>> data, [List<Type>? types]){
    _data = data;
    _types = types ?? List.filled(data.length, dynamic);
    _recordLength = data.first.length;
    // _allData = Set.from(data.expand((e) => e));
  }

  dynamic get(int indexOfRow, indexOfElement){
    return _data[indexOfRow][indexOfElement];
  }


  List<dynamic> recordByElement(dynamic element){
    return _data.firstWhere((e) => e.contains(element));
  }


  List<Widget> builder(Widget Function(int index,List data) builder){
    return List.generate(_types.length, (i) => builder(i,_data[i]));
  }

  add(List<dynamic> data){
    if(data.length != _recordLength) throw Exception("Record length must be $_recordLength");
    _data.add(data);
  }




}