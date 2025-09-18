part of 'extensions.dart';

extension NumFunctions on num {

  bool isWithin(num number, num differenceWithOrigin){
    return isBetween(number, this-differenceWithOrigin, this+differenceWithOrigin);
  }

}