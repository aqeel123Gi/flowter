import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../functions/functions.dart';

class Logs {


  static late Database _database;




  static Future<void> initialize(String path) async {
    _database = await openDatabase("$path/logs.db", version: 1);
  }




  static Future<void> _createCategoryTable(String category) async {
    await _database.execute('''
      CREATE TABLE IF NOT EXISTS $category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL
      )
    ''');
  }




  static Future<void> add({
    required String category,
    required String key,
    required String content,
  }) async {
    await _createCategoryTable(category);
    DateTime now = DateTime.now();
    final log = {
      'key': key,
      'content': content,
      'date': parseDateTimeToString(now, "yyyyMMdd"),
      'time': parseDateTimeToString(now, "HHmmssSSS"),
    };

    if(kDebugMode){
      print("\n[$category]=>[$key]\n$content\n\n");
    }

    await _database.insert(category, log);
  }




  static Future<List<Map<String, dynamic>>> fetch({
    required String category,
    List<String>? byKeys,
    String? fromDate,
    String? toDate,
  }) async {
    await _createCategoryTable(category);

    final List<String> whereClauses = [];
    final List<dynamic> whereArgs = [];

    if (byKeys != null && byKeys.isNotEmpty) {
      final placeholders = List.filled(byKeys.length, '?').join(', ');
      whereClauses.add('key IN ($placeholders)');
      whereArgs.addAll(byKeys);
    }

    if (fromDate != null) {
      whereClauses.add('date >= ?');
      whereArgs.add(fromDate);
    }

    if (toDate != null) {
      whereClauses.add('date <= ?');
      whereArgs.add(toDate);
    }

    final whereClause = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    return await _database.query(
      category,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'date DESC, time DESC',
    );
  }






  static Future<int> remove({
    required String category,
    List<String>? byKeys,
    String? fromDate,
    String? toDate,
  }) async {
    await _createCategoryTable(category);

    final List<String> whereClauses = [];
    final List<dynamic> whereArgs = [];

    if (byKeys != null && byKeys.isNotEmpty) {
      whereClauses.add('key IN (${List.filled(byKeys.length, '?').join(', ')})');
      whereArgs.addAll(byKeys);
    }

    if (fromDate != null) {
      whereClauses.add('date >= ?');
      whereArgs.add(fromDate);
    }

    if (toDate != null) {
      whereClauses.add('date <= ?');
      whereArgs.add(toDate);
    }

    final whereClause = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    return await _database.delete(
      category,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }







  static Future<void> close() async {
    await _database.close();
  }




}


