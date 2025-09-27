part of '../dictionary.dart';


/// A dictionary reference that loads the dictionary from an excel sheet with [.xlsx] extension .
/// Note: Loading a dictionary from an excel sheet is slow, takes about ~0.25 of second.
class ExcelSheetDictionaryReference extends DictionaryReference{


  ExcelSheetDictionaryReference({required this.assetPath, required this.tables, this.keyParser});

  final String assetPath;
  final Function(dynamic key)? keyParser;
  final List<String> tables;

  Map<String, Map<dynamic, String>>? _statements;

  @override
  Future<Map<String, Map<dynamic, String>>> get extractStatements async {
    if (_statements != null) {
      return _statements!;
    }

    _statements = {};

    List<int> bytes = (await rootBundle.load(assetPath)).buffer.asUint8List();
    SpreadsheetDecoder spreadsheet = SpreadsheetDecoder.decodeBytes(bytes);

    for (String tableName in tables) {
      // Check if the table exists
      if (!spreadsheet.tables.containsKey(tableName)) {
        throw Exception("Table $tableName not found");
      }

      // Set the columns of languages (in Header).
      Map<int, String> columnToLanguage = {};
      List<dynamic> headerRow = spreadsheet.tables[tableName]!.rows[0];
      for (int i = 1; i < headerRow.length; i++) {
        columnToLanguage[i] = headerRow[i];
        _statements!.addKeyWithValueIfKeyNotExists(headerRow[i], {});
      }

      // Set the statements.
      for (List<dynamic> row in spreadsheet.tables[tableName]!.rows) {
        for (int i = 1; i < row.length; i++) {
          Map<dynamic, String> statements = _statements![columnToLanguage[i]!]!;

          dynamic key = keyParser != null ? keyParser!(row[0]) : row[0];

          if (statements.containsKey(key)) {
            throw Exception("Duplicate key: $key");
          }
          if(row[i] == null) continue;
          _statements![columnToLanguage[i]!]![key] = row[i]!;
        }
      }
    }

    return _statements!;
  }

}