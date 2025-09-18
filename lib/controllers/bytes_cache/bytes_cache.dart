import 'dart:typed_data';
import 'package:framework/functions/functions.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class BytesCache {
  static Database? _db;

  /// Initialize the SQLite database
  static Future<void> init(String path) async {
    final dbPath = "${(await getApplicationDocumentsDirectory()).path}/$path";
    final path_ = '$dbPath/.cache';

    _db = await openDatabase(
      path_,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cache (
            uri TEXT PRIMARY KEY,
            data BLOB,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  /// Get data from cache or server
  static Future<Uint8List> get(String uri) async {
    if (_db == null) {
      throw Exception('Database is not initialized. Call init() first.');
    }
    // Check if data exists in cache
    final result = await _db!.query(
      'cache',
      where: 'uri = ?',
      whereArgs: [uri],
    );
    if (result.isNotEmpty) {
      // Return cached data
      return result.first['data'] as Uint8List;
    }
    // Fetch data from server
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode != 200) {
      throw Exception('Failed to load data from server: ${response.statusCode}');
    }
    final data = response.bodyBytes;

    // Save data to cache
    await _db!.insert(
      'cache',
      {
        'uri': uri,
        'data': data,
        'timestamp': parseDateTimeToString(DateTime.now(), 'yyyy-MM-dd HH:mm:ss'),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return data;
  }


  /// Get image from cache or server
  static Future<Uint8List> getAsImage(String uri) async {
    if (_db == null) {
      throw Exception('Database is not initialized. Call init() first.');
    }
    // Check if data exists in cache
    final result = await _db!.query(
      'cache',
      where: 'uri = ?',
      whereArgs: [uri],
    );
    if (result.isNotEmpty) {
      // Return cached data
      return result.first['data'] as Uint8List;
    }
    // Fetch data from server
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode != 200) {
      throw Exception('Failed to load data from server: ${response.statusCode}');
    }
    final data = response.bodyBytes;

    if(!await _isImageData(data)){
      throw Exception('Invalid image data');
    }

    // Save data to cache
    await _db!.insert(
      'cache',
      {
        'uri': uri,
        'data': data,
        'timestamp': parseDateTimeToString(DateTime.now(), 'yyyy-MM-dd HH:mm:ss'),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return data;
  }

  /// Check if data is a valid image
  static Future<bool> _isImageData(Uint8List data) async{
    try {
      // Check the minimum header length
      if (data.length < 8) {
        return false; // Too small to be a valid image
      }

      // Check common file headers (JPEG, PNG, GIF, BMP, WebP)
      final headerBytes = data.take(8).toList();

      // Check for JPEG, PNG, GIF, BMP, WebP
      if ((headerBytes[0] == 0xFF && headerBytes[1] == 0xD8 && headerBytes[2] == 0xFF) || // JPEG
          (headerBytes[0] == 0x89 && headerBytes[1] == 0x50 && headerBytes[2] == 0x4E && headerBytes[3] == 0x47) || // PNG
          (headerBytes[0] == 0x47 && headerBytes[1] == 0x49 && headerBytes[2] == 0x46) || // GIF
          (headerBytes[0] == 0x42 && headerBytes[1] == 0x4D) || // BMP
          (headerBytes[0] == 0x52 && headerBytes[1] == 0x49 && headerBytes[2] == 0x46 && headerBytes[3] == 0x46)) { // WebP
        // Attempt to decode image
        return true;
      }

      // Check if the data starts with SVG (XML format)
      final svgSignature = String.fromCharCodes(data.take(4));
      if (svgSignature == '<svg') {
        return true; // SVG format detected
      }

      return false; // Unknown format
    } catch (e) {
      return false; // If any error occurs, it's not a valid image
    }
  }



  static Future<void> clear() async {
    if (_db == null) {
      throw Exception('Database is not initialized. Call init() first.');
    }
    await _db!.delete('cache');
  }


}


