T numberChecker<T>(double number, T Function(double number) valueIfNumber,T valueIfNan, T valueIfInfinity){
  return
    number.isNaN?valueIfNan:
    number.isInfinite?valueIfInfinity:
    valueIfNumber(number);
}