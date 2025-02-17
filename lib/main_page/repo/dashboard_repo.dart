import '../../app/core/app_storage_keys.dart';
import '../../main_repos/base_repo.dart';

class DashboardRepo extends BaseRepo {
  DashboardRepo({required super.dioClient, required super.sharedPreferences});

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppStorageKey.isLogin);
  }
}
