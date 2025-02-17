import 'dart:ui';
import 'package:zurex/main_repos/base_repo.dart';
import '../../../app/core/app_storage_keys.dart';

class LocalizationRepo extends BaseRepo {
  LocalizationRepo(
      {required super.dioClient, required super.sharedPreferences});

  refreshHeader() async {
    await dioClient.refreshHeader();
  }

  updateLanguage(Locale locale) async {
    await dioClient.updateLang(locale.languageCode);
    _saveLanguage(locale);
    refreshHeader();
  }

  _saveLanguage(Locale locale) async {
    sharedPreferences.setString(
        AppStorageKey.languageCode, locale.languageCode);
    sharedPreferences.setString(AppStorageKey.countryCode, locale.countryCode!);
  }

  loadLanguage() async {
    return Locale(
        sharedPreferences.getString(AppStorageKey.languageCode) ?? 'en',
        sharedPreferences.getString(AppStorageKey.countryCode) ?? 'US');
  }
}
