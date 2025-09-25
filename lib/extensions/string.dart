part of 'extensions.dart';

extension StringFunctions on String {

  String withQueriesOnUrlPath(Map<String,dynamic> filters, {bool removeNulls = false}) {

    String urlWithQueries = this;
    urlWithQueries += "?";
    filters.forEach((key, value) {
        if(!removeNulls || (removeNulls && value!=null)){
          urlWithQueries += "$key=$value&";
        }
    });

    urlWithQueries = urlWithQueries.substring(0, urlWithQueries.length - 1);
    return urlWithQueries;

  }

  String get fromScreamingSnakeCaseToCamelCase{

    return split('_').indexedMap((index, word) => index == 0 ? word.toLowerCase() : word.capitalize).join('');
  }


  String get fromCamelCaseToKebabCase{

    return replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (Match m) => '${m[1]}-${m[2]?.toLowerCase()}').toLowerCase();
  }


  String get fromCamelCaseToScreamingSnakeCase{

    return replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (Match m) => '${m[1]}_${m[2]?.toLowerCase()}').toUpperCase();
  }


  String get fromPascalCaseToKebabCase{
    return replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (Match m) => '${m[1]}-${m[2]?.toLowerCase()}').toLowerCase();
  }

  String get fromCamelCaseToSnakeCase{

    return replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (Match m) => '${m[1]}_${m[2]?.toLowerCase()}').toLowerCase();
  }

  String get fromCamelCaseToPascalCase{

    return replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (Match m) => '${m[1]} ${m[2]?.toLowerCase()}').capitalize;
  }


  String get fromKebabCaseToCamelCase{
    return split('-').indexedMap((index, word) => index == 0 ? word.toLowerCase() : word.capitalize).join('');
  }



  String get toCamelCase{
    final words = split(RegExp(r'\s+'));
    return words.indexedMap((index, word) {
      return index == 0 ? word.toLowerCase() : word.capitalize;
    }).join('').replaceAll("_", "");
  }

  String get oPascalCase{
    final words = split(RegExp(r'\s+'));
    return words.map((w)=>w.capitalize).join('');
  }

  String get toSnakeCase{
    final words = split(RegExp(r'\s+'));
    return words.map((word) => word.toLowerCase()).join('_');
  }

  String get toKebabCase{
    final words = split(RegExp(r'\s+'));
    return words.map((word) => word.toLowerCase()).join('-');
  }

  String get toScreamingSnakeCase{
    final words = split(RegExp(r'\s+'));
    return words.map((word) => word.toUpperCase()).join('_');
  }

  String get capitalize{
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }


  T toEnumFromLaravelModelPath<T extends Enum>(List<T> values) {
    String name = split('\\').last.toCamelCase;
    return values.firstWhere((element) => element.name == name);
  }


  String hideDigitsByWords({
    String hiddenChar = "*",
    int visibleWordHeaderDigits = 0,
    int visibleWordTailDigits = 0,
  }){
    return split(' ').map((word) {
        if (word.length <= visibleWordHeaderDigits + visibleWordTailDigits) {
          return word;
        } else {
          String header = word.substring(0, visibleWordHeaderDigits);
          String tail = word.substring(word.length - visibleWordTailDigits);
          String hidden = hiddenChar * (word.length - visibleWordHeaderDigits - visibleWordTailDigits);
          return '$header$hidden$tail';
        }
      }).join(' ');
  }



  String get shortName{

    if(isEmpty){
      return "";
    }

    String tmp = replaceAll("عبد ", "عبد");

    List<String> list = tmp.split(" ");

    if(list.length>1){
      return "${list[0]} ${list[list.length-1]}";
    }else{
      return list[0];
    }

  }


  String get fullName{

    if(isEmpty){
      return "";
    }

    String tmp;
    tmp = replaceAll("عبد ", "عبد");
    tmp = tmp.replaceAll(" بن ", " ");

    List<String> list = split(" ");

    if(list.length>1){
      return "${list[0]} ${list[list.length-1]}";
    }else{
      return list[0];
    }

  }


  String get reversed => split('').reversed.join();


  substringFromLast(int index) => substring(0, length  - index);


  List<String> splitedToListOfFixedSubstringsLengths(int length) {
    List<String> list = [];

    for (int i = 0; i < this.length; i=i+length) {
      list.add(substring(i, i + length));
    }

    return list;
  }



  String reversedWithElementLengths(int length){
    return splitedToListOfFixedSubstringsLengths(length).reversed.join();
  }



  num get versionWeight{

    List<String> list = split('.').reversed.toList();

    num weight = 0;

    //for from last element
    for(int i=0; i<list.length; i++){
      weight += int.parse(list[i])*pow(1000,i);
    }

    return weight;
  }


  bool get isInt => int.tryParse(this) != null;

  bool get isDouble => double.tryParse(this) != null;


  String replaceIfNotChar(String char, String replaceTo){
    String tmp = "";
    for(int i=0;i<length;i++){
      if(this[i]!=char){
        tmp+=replaceTo;
      }else{
        tmp+=this[i];
      }
    }
    return tmp;
  }


  String withInserted(int index, String element) {

    return substring(0, index) + element + substring(index);

  }




  Uint8List get toUint8List {
    return Uint8List.fromList(utf8.encode(this));
  }



  Color get hexTextToColor {
    String tmp = replaceAll("#", "");
    int hexValue = int.parse(tmp, radix: 16);
    return Color(hexValue | 0xFF000000);
  }


  int numberOfChar(String char) {
    List<String> list = split('');
    return list.where((element) => element == char).length;
  }

  Color get hexToColor {

    String tmp = toUpperCase().replaceAll("#", "");
    if (tmp.length == 6) {
      tmp = "FF$tmp";
    }

    final hexNum = int.parse(tmp, radix: 16);

    if (hexNum == 0) {
      return const Color(0xff000000);
    }

    return Color(hexNum);
  }



}

