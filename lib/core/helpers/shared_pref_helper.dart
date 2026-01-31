// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  /// Removes a value from SharedPrefrences with given [key]
  static removeData(String key) async {
    debugPrint('SharedPrefHelper: data with key : $key has been removed');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }

  /// Removes all keys and valued in the SharedPrefrences
  static clearAllData() async {
    debugPrint('SharedPrefHelper: all data has been cleared');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  /// Saves a [value] with a [key] in a SharedPrefrences
  static setData(String key, value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    debugPrint('SharedPrefHelper: setData with key: $key and value: $value');

    switch (value.runtimeType) {
      case String:
        await sharedPreferences.setString(key, value);
        break;
      case int:
        await sharedPreferences.setInt(key, value);
        break;
      case bool:
        await sharedPreferences.setBool(key, value);
        break;
      case double:
        await sharedPreferences.setDouble(key, value);
        break;
      default:
        return null;
    }
  }

  /// Gets a bool value from SharedPrefrences with given [key]
  static getBool(String key) async {
    debugPrint('SharedPrefHelper: getBool with key : $key');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key) ?? false;
  }

  /// Gets a double value from SharedPrefrences with given [key]
  static getDouble(String key) async {
    debugPrint('SharedPrefHelper: getDouble with key : $key');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(key) ?? 0.0;
  }

  /// Gets a int value from SharedPrefrences with given [key]
  static getInt(String key) async {
    debugPrint('SharedPrefHelper: getInt with key : $key');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(key) ?? 0;
  }

  /// Gets a string value from SharedPrefrences with given [key]
  static getString(String key) async {
    debugPrint('SharedPrefHelper: getString with key : $key');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? '';
  }

  /// Saves a [value] with a [key] in a SharedPrefrences
  static setSecuredString(String key, String value) async {
    const flutterSecureStorage = FlutterSecureStorage();
    debugPrint(
      'flutterSecureStorage: setSecuredString with key: $key and value: $value',
    );
    await flutterSecureStorage.write(key: key, value: value);
  }

  /// Gets a string value from SharedPrefrences with given [key]
  static getSecuredString(String key) async {
    const flutterSecureStorage = FlutterSecureStorage();
    debugPrint('flutterSecureStorage: getSecuredString with key : $key');
    return await flutterSecureStorage.read(key: key) ?? '';
  }

  /// Removes all keys and valued in the SharedPrefrences
  static clearAllSecuredData() async {
    const flutterSecureStorage = FlutterSecureStorage();
    debugPrint('flutterSecureStorage: all data has been cleared');
    await flutterSecureStorage.deleteAll();
  }
}
