part of 'dictionary.dart';

extension SheetDictionaryExtension on Object{

  /// Get the statement from the dictionary by the key, it will return [toString()] value of any object.
  String st({Map<String, dynamic>? replace}){

      // Get the statement from current language.
      String? statement = DictionaryController._statements[DictionaryController.currentLanguage.code]![this];

      // Get the statement from default language if setting is enabled.
      if(statement==null){
        if(DictionaryController._getStatementFromDefaultLanguageOnNotFound){
          statement = DictionaryController._statements[DictionaryController._defaultLanguage]![this];
        }
      }

      // Get the statement from [DictionaryController._onNotFoundStatement] if it is not null, otherwise throw an exception.
      if(statement==null){
        if(DictionaryController._onNotFoundStatement!=null){
          statement = DictionaryController._onNotFoundStatement!(this);
        }else{
          throw Exception("statement not found");
        }
      }

      // Replace the content of statement within {{key}} from [replace] arg.
      if(replace!=null){
        replace.forEach((key, value) {
          statement = statement!.replaceAll("{{$key}}", value.toString());
        });
      }

      return statement!;

  }

}