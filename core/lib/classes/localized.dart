class Localized<T>{

  Localized([Map<String,T>? values]){
    this.values = values ?? {};
  }
  Map<String,T> values = {};

  static void getLanguageCodeFromApp(String Function() getLanguageCode, String languageCodeOnNotFound){
    Localized.getLanguageCode = getLanguageCode;
    Localized.languageCodeOnNotFound = languageCodeOnNotFound;
  }
  
  static late String Function() getLanguageCode;
  static late String languageCodeOnNotFound;


  T get value{
    String languageCode = getLanguageCode();
    if(values.containsKey(languageCode)){
      return values[languageCode]!;
    }
    return values[languageCodeOnNotFound]!;
  }

  static Localized<K> fromJson<K>(dynamic jsonBody,[bool addKeyOnNullValue= true]){
    Localized<K> localized = Localized<K>();
    for (var key in jsonBody.keys) {
        if(jsonBody[key] == null && !addKeyOnNullValue){
          continue;
        }
        localized.values[key] = jsonBody[key] as K;
      }

    return localized;
  }

  static Localized<K> fromJsonWherePrefix<K>(dynamic jsonBody, String prefix,[bool addKeyOnNullValue= true]){
    Localized<K> localized = Localized<K>();
    for (var key in jsonBody.keys) {
      if(key.startsWith(prefix)){
        if(jsonBody[key] == null && !addKeyOnNullValue){
          continue;
        }
        localized.values[key.substring(prefix.length)] = jsonBody[key] as K;
      }
    }
    return localized;
  }

  Map<String,T> toMapWithPrefix(String prefix){
    Map<String,T> map = {};
    for (var key in values.keys) {
      map[prefix+key] = values[key] as T;
    }
    return map;
  }

  Map<String,T> toMap(){
    Map<String,T> map = {};
    for (var key in values.keys) {
      map[key] = values[key] as T;
    }
    return map;
  }


  @override
  toString(){
    return values.toString();
  }


}