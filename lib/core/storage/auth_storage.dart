import 'package:bizrato_owner/core/storage/storage_keys.dart';
import 'package:bizrato_owner/core/storage/storage_service.dart';

class AuthStorage {
  AuthStorage(this._storage);

  final StorageService _storage;
  static const int completedProfileStep = 3;

  Future<bool> saveToken(String token) =>
      _storage.setString(StorageKeys.authToken, token);

  String? get token => _storage.getString(StorageKeys.authToken);

  Future<bool> setLoggedIn(bool value) =>
      _storage.setBool(StorageKeys.isLoggedIn, value);

  bool get isLoggedIn =>
      (_storage.getBool(StorageKeys.isLoggedIn) ?? false) &&
      hasActiveSession &&
      hasCompletedOnboarding;

  Future<bool> saveMerchantId(int id) =>
      _storage.setInt(StorageKeys.merchantId, id);

  int? get merchantId => _storage.getInt(StorageKeys.merchantId);

  Future<bool> saveBusinessId(String? id) {
    if (id == null || id.isEmpty) {
      return Future.value(false);
    }
    return _storage.setString(StorageKeys.businessId, id);
  }

  String? get businessId => _storage.getString(StorageKeys.businessId);

  Future<void> saveProfileStep(int step) async {
    await _storage.setInt(StorageKeys.businessProfileStep, step);
    await setLoggedIn(step >= completedProfileStep);
  }

  int get profileStep => _storage.getInt(StorageKeys.businessProfileStep) ?? 0;

  bool get hasCompletedOnboarding => profileStep >= completedProfileStep;

  bool get hasActiveSession =>
      (token?.isNotEmpty ?? false) && (merchantId != null && merchantId! > 0);

  Future<bool> saveUserJson(String json) =>
      _storage.setString(StorageKeys.userJson, json);

  String? get userJson => _storage.getString(StorageKeys.userJson);

  Future<void> clear() => _storage.clearAuth();
}
