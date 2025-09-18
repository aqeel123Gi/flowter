import 'package:flutter/material.dart';

class TableAsset<T>{
  TableAsset(int rows, int columns, T defaultNonElement){
    _defaultNonElement = defaultNonElement;
    _table = List.generate(rows, (_)=>List.filled(columns,_defaultNonElement));
    _filledElement = List.generate(rows, (_)=>List.filled(columns,false));
  }

  late T _defaultNonElement;
  late List<List<T>> _table;
  late List<List<bool>> _filledElement;


  Widget build(BuildContext context, {
    TextDirection? textDirection,
    required Widget Function(int row, int column, T element) builder,
  })=>Directionality(
      textDirection: textDirection??Directionality.of(context),
      child:Builder(
        builder: (_){
          List<Widget> rows = [];
          for (int i=0;i<_table.length;i++) {
            List<Widget> list = [];
            for (int j=0;j<_table[i].length;j++) {
              list.add(Expanded(child:builder(i,j,_table[i][j])));
            }
            rows.add(Expanded(child:Row(children:list)));
          }
          return Column(children:rows);
        },
      ));

  T get(int row, int column){
    return _table[row][column];
  }

  void set(TableElement<T> element){
    _table[element.row][element.column] = element.element;
    _filledElement[element.row][element.column] = true;
  }

  void setAll(List<TableElement<T>> elements){
    for(var element in elements){
      _table[element.row][element.column] = element.element;
      _filledElement[element.row][element.column] = true;
    }
  }

  T remove(int row, int column){
    T element = _table[row][column];
    _table[row][column] = _defaultNonElement;
    _filledElement[row][column] = false;
    return element;
  }

  List<TableElement<T>> filledElements(){
    List<TableElement<T>> filled = [];
    for (int i=0;i<_table.length;i++) {
      for (int j=0;j<_table[0].length;j++) {
        if(_filledElement[i][j]){
          filled.add(TableElement(i,j,_table[i][j]));
        }
      }
    }
    return filled;
  }

  TableElement<T> firstFilledElement(){
    for (int i=0;i<_table.length;i++) {
      for (int j=0;j<_table[0].length;j++) {
        if(_filledElement[i][j]){
          return TableElement(i,j,_table[i][j]);
        }
      }
    }
    throw Exception("No filled elements");
  }
}

class TableElement<T>{

  TableElement(this.row,this.column,this.element);

  final int row;
  final int column;
  final T element;
}