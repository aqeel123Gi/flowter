part of 'extensions.dart';

extension DoubleFunctions on double {

  static double dynamicParse (dynamic value){

    if(value is double){
      return value;
    }
    if(value is int){
      return value.toDouble();
    }

    if(value is String && double.tryParse(value)!=null){
      return double.parse(value);
    }

    throw Exception("Invalid Type or Value: type: ${value.runtimeType}, value: $value.");

  }


}