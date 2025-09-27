part of 'dictionary.dart';


class DictionaryController{

  static late ValueNotifier<String> _selectedLanguageCode;
  static late String _defaultLanguage;
  static String Function(dynamic key)? _onNotFoundStatement;
  static late bool _getStatementFromDefaultLanguageOnNotFound;
  static late List<DictionaryReference> _dictionariesReferences;
  static late Map<String, Map<dynamic,String>> _statements;



  static Future<void> initialize({
    required List<DictionaryReference> dictionariesReferences,
    required String defaultLanguageCode,
    String Function(dynamic key)? onNotFoundStatement,
    bool getStatementFromDefaultLanguageOnNotFound = true
  }) async {

    // Set the last chosen language if it exists, otherwise the default language.
    _selectedLanguageCode = ValueNotifier<String>(await Memory.get('.settings', 'dictionary/language-code', defaultLanguageCode));

    // Set the default language.
    _defaultLanguage = defaultLanguageCode;

    // Set the statement on not found.
    _onNotFoundStatement = onNotFoundStatement;

    // Set if should get statement from default language on not found.
    _getStatementFromDefaultLanguageOnNotFound = getStatementFromDefaultLanguageOnNotFound;

    // Set the dictionaries references.
    _dictionariesReferences = dictionariesReferences;

    // Load the dictionaries.
    await reloadDictionaries();

  }

  static Future<void> reloadDictionaries() async {
    _statements = {};
    for(var dictionaryReference in _dictionariesReferences){
      Map<String, Map<dynamic,String>> statements = await dictionaryReference.extractStatements;
      statements.forEach((languageCode, keyToStatementMap) {
        _statements.addKeyWithValueIfKeyNotExists(languageCode, {});
        _statements[languageCode]!.addAll(keyToStatementMap);
      });
    }

  }


  static Language get currentLanguage => _codeToLanguageMap.containsKey(_selectedLanguageCode.value)?_codeToLanguageMap[_selectedLanguageCode.value]!:throw Exception("Invalid language code : ${_selectedLanguageCode.value}");


  static List<Language> get availableLanguages => _statements.keys.map((k) => _codeToLanguageMap[k]!).toList();


  static Future<void> setLanguageByCode (String languageCode) async{
    _selectedLanguageCode.value = languageCode;
    Memory.save('.settings', 'dictionary/language-code', languageCode);
  }


  static statement (Map<String,String> statementsByLanguagesCodes){
    return statementsByLanguagesCodes[_selectedLanguageCode.value]??"<?>";
  }


  static TextDirection get currentTextDirection => _codeToLanguageMap[_selectedLanguageCode.value]!.direction;


  static bool get isCurrentLanguageRTL => currentTextDirection == TextDirection.rtl;


  static void addOnLanguageChangedListener(void Function() onLanguageChange) => _selectedLanguageCode.addListener(onLanguageChange);


}