part of '../dictionary.dart';


/// The key => language => statement Nested Map dictionary reference as [Map<String,Map<dynamic,String>>].
class LanguageToKeyToStatementMapDictionaryReference extends DictionaryReference{

  LanguageToKeyToStatementMapDictionaryReference({required this.mapReference});
  final Map<String,Map<dynamic,String>> Function() mapReference;

  @override
  Future<Map<String, Map<dynamic, String>>> get extractStatements async {
    return mapReference();
  }

}