import 'package:bizrato_owner/core/dependencies/app_dependencies.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class LogoutService {
  LogoutService(this._authStorage);

  final AuthStorage _authStorage;

  Future<void> logout() async {
    // await _authRepo.logoutApi();
    await _authStorage.clear();
    Get.deleteAll();
    await AppDependencies.init(force: true);
    Get.offAllNamed(AppRoutes.login);
  }
}
