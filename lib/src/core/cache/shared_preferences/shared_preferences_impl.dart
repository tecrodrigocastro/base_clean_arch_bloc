import 'dart:convert';

import 'package:base_clean_arch_bloc/src/core/cache/cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesImpl implements ICache {
  @override
  Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.get(key);

    try {
      return jsonDecode(result as String);
    } catch (e) {
      return result;
    }
  }

  @override
  Future<bool> setData({required CacheParams params}) async {
    final prefs = await SharedPreferences.getInstance();
    switch (params.value.runtimeType.toString()) {
      case 'String':
        return await prefs.setString(params.key, params.value);
      case 'int':
        return await prefs.setInt(params.key, params.value);
      case 'bool':
        return await prefs.setBool(params.key, params.value);
      case 'double':
        return await prefs.setDouble(params.key, params.value);
      case 'List<String>':
        return await prefs.setStringList(params.key, params.value);
      default:
        return await prefs.setString(params.key, jsonEncode(params.value));
    }
  }

  @override
  Future<bool> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  @override
  Future<bool> clean() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
