import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petspal/features/auth/register/repo/register_repo.dart';
import '../../app/theme/theme_provider/theme_provider.dart';
import '../../features/auth/activation_account/repo/activation_account_repo.dart';
import '../../features/auth/deactivate_account/repo/deactivate_account_repo.dart';
import '../../features/auth/forget_password/repo/forget_password_repo.dart';
import '../../features/auth/login/repo/login_repo.dart';
import '../../features/auth/logout/bloc/logout_bloc.dart';
import '../../features/auth/logout/repo/logout_repo.dart';
import '../../features/auth/reset_password/repo/reset_password_repo.dart';
import '../../features/auth/social_media_login/repo/social_media_repo.dart';
import '../../features/auth/verification/repo/verification_repo.dart';
import '../../features/best_seller/repo/best_seller_repo.dart';
import '../../features/brands/repo/brands_repo.dart';
import '../../features/cart/bloc/cart_bloc.dart';
import '../../features/cart/repo/cart_repo.dart';
import '../../features/categories/bloc/categories_bloc.dart';
import '../../features/categories/repo/categories_repo.dart';
import '../../features/chat/repo/chat_repo.dart';
import '../../features/chats/bloc/chats_bloc.dart';
import '../../features/chats/repo/chats_repo.dart';
import '../../features/change_password/repo/change_password_repo.dart';
import '../../features/edit_profile/repo/edit_profile_repo.dart';
import '../../features/faqs/repo/faqs_repo.dart';
import '../../features/countries/repo/countries_repo.dart';
import '../../features/feedbacks/repo/feedbacks_repo.dart';
import '../../features/home/bloc/home_ads_bloc.dart';
import '../../features/home/repo/home_repo.dart';
import '../../features/language/bloc/language_bloc.dart';
import '../../features/language/repo/language_repo.dart';
import '../../features/maps/repo/maps_repo.dart';
import '../../features/notifications/repo/notifications_repo.dart';
import '../../features/product_details/repo/product_details_repo.dart';
import '../../features/products/repo/products_repo.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/repo/profile_repo.dart';
import '../../features/setting/bloc/setting_bloc.dart';
import '../../features/setting/repo/setting_repo.dart';
import '../../features/contact_with_us/repo/contact_with_us_repo.dart';
import '../../features/transactions/repo/transactions_repo.dart';
import '../../features/vendors/repo/vendors_repo.dart';
import '../../features/wishlist/bloc/wishlist_bloc.dart';
import '../../features/wishlist/repo/wishlist_repo.dart';
import '../../helpers/pickers/repo/picker_helper_repo.dart';
import '../../helpers/social_media_login_helper.dart';
import '../../main_blocs/user_bloc.dart';
import '../../main_page/bloc/dashboard_bloc.dart';
import '../../main_repos/download_repo.dart';
import '../../main_repos/user_repo.dart';
import '../api/end_points.dart';
import '../internet_connection/internet_connection.dart';
import '../local_data/local_database.dart';
import '../dio/dio_client.dart';
import '../dio/logging_interceptor.dart';
import '../../features/splash/repo/splash_repo.dart';
import '../securty/secure_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => LocaleDatabase());
  sl.registerLazySingleton(() => DioClient(
        EndPoints.baseUrl,
        dio: sl(),
        loggingInterceptor: sl(),
        sharedPreferences: sl(),
      ));
  sl.registerLazySingleton(() => SocialMediaLoginHelper());
  sl.registerLazySingleton(() => InternetConnection(connectivity: sl()));

  /// Repository
  sl.registerLazySingleton(
      () => LocalizationRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => SettingRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => FaqsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(() => DownloadRepo());

  sl.registerLazySingleton(
      () => CountriesRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => PickerHelperRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => UserRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => LoginRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => RegisterRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => VerificationRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ForgetPasswordRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ResetPasswordRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChangePasswordRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => LogoutRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ActivationAccountRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ProfileRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => EditProfileRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => MapsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(() => SocialMediaRepo(
      sharedPreferences: sl(), dioClient: sl(), socialMediaLoginHelper: sl()));

  sl.registerLazySingleton(
      () => DeactivateAccountRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => BestSellerRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => BrandsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => VendorsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => CategoriesRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ProductsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ProductDetailsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => WishlistRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => NotificationsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => HomeRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => CartRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChatsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChatRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ContactWithUsRepo(sharedPreferences: sl(), dioClient: sl()));

  ///Feedback
  sl.registerLazySingleton(
      () => FeedbacksRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => TransactionsRepo(sharedPreferences: sl(), dioClient: sl()));

  //provider
  sl.registerLazySingleton(() => LanguageBloc(repo: sl()));
  sl.registerLazySingleton(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerLazySingleton(() => SettingBloc(repo: sl()));
  sl.registerLazySingleton(() => DashboardBloc());
  sl.registerLazySingleton(() => ProfileBloc(repo: sl()));
  sl.registerLazySingleton(() => UserBloc(repo: sl()));
  sl.registerLazySingleton(() => HomeAdsBloc(repo: sl(), internetConnection: sl()));
  sl.registerLazySingleton(() => CategoriesBloc(repo: sl(), internetConnection: sl()));
  sl.registerLazySingleton(() => WishlistBloc(repo: sl(), internetConnection: sl()));
  sl.registerLazySingleton(() => CartBloc(repo: sl(), internetConnection: sl()));
  sl.registerLazySingleton(() => ChatsBloc(repo: sl()));

  ///Log out
  sl.registerLazySingleton(() => LogoutBloc(repo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => SecureStorage(flutterSecureStorage: sl()));
  sl.registerLazySingleton(() => LoggingInterceptor());
}
