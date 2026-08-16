import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static late SharedPreferences sharedPreferences;

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  String? getString({required String key}) {
    return sharedPreferences.getString(key);
  }

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    if (value is List<String>) {
      return await sharedPreferences.setStringList(key, value);
    }
    throw ArgumentError(
      'CacheService.saveData: unsupported type ${value.runtimeType}',
    );
  }

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

  Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }
}
