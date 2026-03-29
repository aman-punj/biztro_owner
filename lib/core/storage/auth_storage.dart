import 'package:bizrato_owner/core/storage/storage_keys.dart';
import 'package:bizrato_owner/core/storage/storage_service.dart';

class AuthStorage {
  AuthStorage(this._storage);

  final StorageService _storage;

  Future<bool> saveToken(String token) =>
      _storage.setString(StorageKeys.authToken, token);

  String? get token => _storage.getString(StorageKeys.authToken);

  Future<bool> setLoggedIn(bool value) =>
      _storage.setBool(StorageKeys.isLoggedIn, value);

  bool get isLoggedIn => _storage.getBool(StorageKeys.isLoggedIn) ?? false;

  Future<bool> saveMerchantId(int id) =>
      _storage.setInt(StorageKeys.merchantId, id);

  int? get merchantId => _storage.getInt(StorageKeys.merchantId);

  Future<bool> saveProfileStep(int step) =>
      _storage.setInt(StorageKeys.businessProfileStep, step);

  int get profileStep => _storage.getInt(StorageKeys.businessProfileStep) ?? 0;

  Future<bool> saveUserJson(String json) =>
      _storage.setString(StorageKeys.userJson, json);

  String? get userJson => _storage.getString(StorageKeys.userJson);

  Future<void> clear() => _storage.clearAuth();
}
