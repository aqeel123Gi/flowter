double? tryForceToDouble(dynamic value) {
  if(value==null){
    return null;
  }
  try{
    return double.parse(value.toString());
  }catch(e){
    return null;
  }
}


num? tryForceToNum(dynamic value) {
  if(value==null){
    return null;
  }
  try{
    return num.parse(value.toString());
  }catch(e){
    return null;
  }
}