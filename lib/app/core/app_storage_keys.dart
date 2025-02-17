import '../../../features/language/model/language_model.dart';
import 'images.dart';

abstract class AppStorageKey {
  static const String configVideo = "config_video";
  static const String token = "token";
  static const String notFirstTime = "not_first_time";
  static const String isLogin = "is_login";
  static const String credentials = "credentials";
  static const String userData = "user_data";
  static const String userId = "user_id";
  static const String isSubscribe = "is_subscribe";
  static String firstTimeOnApp = "first_time";
  static const String languageCode = "languageCode";
  static const String countryCode = "countryCode";
  static List<LanguageModel> languages = [
    LanguageModel(
        icon: Images.english,
        name: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        icon: Images.arabic,
        name: "عربي",
        countryCode: 'SA',
        languageCode: 'ar'),
  ];
}
