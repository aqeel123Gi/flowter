part of '../dictionary.dart';


/// The key => language => statement Nested Map dictionary reference as [Map<dynamic,Map<String,String>>].
class KeyToLanguageToStatementMapDictionaryReference extends DictionaryReference{

  KeyToLanguageToStatementMapDictionaryReference({required this.mapReference});
  final Map<dynamic,Map<String,String>> Function() mapReference;

  @override
  Future<Map<String, Map<dynamic, String>>> get extractStatements async {
    return transformMap(mapReference());
  }

}

