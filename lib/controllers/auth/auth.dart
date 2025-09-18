import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flowter/flowter.dart';

class AbstractAppAuth {
  AbstractAppAuth fromMemoryAsMap(Map<String, dynamic> json) {
    // TODO: implement AppUser.fromJson
    throw UnimplementedError();
  }

  Map<String, dynamic> toMemoryAsMap() {
    // TODO: implement AppUser.toJson
    throw UnimplementedError();
  }
}

class AuthController {
  static String _userBoxName = '.auth';

  static late Box _userBox;
  static String? _token;
  static AbstractAppAuth? _user;

  static String? get token => _token;
  static T? getUser<T extends AbstractAppAuth>() => _user as T?;

  static Future<void> initialize(
      Map<Type, AbstractAppAuth Function(Map<String, dynamic>)>
          possibleAuthTypeWithFromMemoryAsMapFunctions,
      {String? fileName}) async {
    if (fileName != null) _userBoxName = fileName;

    _userBox = await Hive.openBox(_userBoxName);
    _token = _userBox.get('token');

    String? type = _userBox.get('type');
    dynamic body = par(_userBox.get('data'), "DATA");
    if (type != null) {
      try {
        MapEntry<Type, AbstractAppAuth Function(Map<String, dynamic>)> entry =
            possibleAuthTypeWithFromMemoryAsMapFunctions.entryWhereFirstKey(
                (possibleAuthType) => possibleAuthType.toString() == type);
        _user = entry.value(json.decode(body));
      } catch (e) {
        throw Exception(
            'Type $type is not found in ${possibleAuthTypeWithFromMemoryAsMapFunctions.keys.toList()}');
      }
    }
  }

  static bool get isLoggedIn => _token != null;

  static Future<void> set(
      {required String token, AbstractAppAuth? user}) async {
    await _userBox.put('token', token);
    _token = token;

    _user = user;
    if (user != null) {
      await _userBox.put('data', json.encode(user.toMemoryAsMap()));
      await _userBox.put('type', user.runtimeType.toString());
    }
  }

  static Future<void> clear() async {
    await _userBox.delete('token');
    await _userBox.delete('data');
    await _userBox.delete('type');
    _token = null;
    _user = null;
  }

  static Future<void> update() async {
    await set(token: _token!, user: _user);
  }
}
