bool doesMapHaveSubstringForAllValues(Map map, String substring, {bool caseSensitive = true}){

  for (var entry in map.entries) {
    if(entry.value is! Map){
      if(entry.value is String){
        String value = entry.value;
        if(
          (caseSensitive && value.contains(substring)) ||
          (!caseSensitive && value.toLowerCase().contains(substring.toLowerCase()))
        ){
          return true;
        }
      }
    }else{
      if(doesMapHaveSubstringForAllValues(entry.value,substring,caseSensitive:caseSensitive)){
        return true;
      }
    }
  }

  return false;

}