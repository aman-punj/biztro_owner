import 'package:bizrato_owner/core/storage/storage_keys.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clearAll() => _prefs.clear();

  Future<void> clearAuth() async {
    await Future.wait([
      remove(StorageKeys.authToken),
      remove(StorageKeys.isLoggedIn),
      remove(StorageKeys.merchantId),
      remove(StorageKeys.userJson),
      remove(StorageKeys.businessProfileStep),
    ]);
  }
}
