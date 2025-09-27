toStringWithZerosDigits(int number,int length){
  String x = number.toString();
  while(x.length<length){
    x = "0$x";
  }
  return x;
}