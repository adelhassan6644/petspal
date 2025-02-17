import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/data/local_data/local_database.dart';
import 'package:petspal/features/language/bloc/language_bloc.dart';
import 'app/core/app_storage_keys.dart';
import 'app/core/un_focus.dart';
import 'app/localization/app_localization.dart';
import 'app/notifications/notification_helper.dart';
import 'app/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/core/app_strings.dart';
import 'data/config/di.dart' as di;
import 'data/config/di.dart';
import 'data/config/provider.dart';
import 'navigation/custom_navigation.dart';

import 'navigation/routes.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await CountryCodes.init();

  // await MediaCacheManager.instance.init(
  //   encryptionPassword: 'i love flutter',
  //   daysToExpire: 12098,
  // );

  if (!kDebugMode) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseNotifications.setUpFirebase();
  }

  await dotenv.load(fileName: ".env");
  await di.init();
  await sl<LocaleDatabase>().initDatabase();

  runApp(MultiBlocProvider(
      providers: ProviderList.providers, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppStorageKey.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));

    return BlocBuilder<LanguageBloc, AppState>(
      builder: (context, state) {
        return MaterialApp(
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: UnFocus(
                  child: Stack(
                children: [
                  child!,
                ],
              ))),
          initialRoute: Routes.splash,
          navigatorKey: CustomNavigator.navigatorState,
          onGenerateRoute: CustomNavigator.onCreateRoute,
          navigatorObservers: [CustomNavigator.routeObserver],
          title: AppStrings.appName,
          scaffoldMessengerKey: CustomNavigator.scaffoldState,
          debugShowCheckedModeBanner: false,
          theme: light(LanguageBloc.instance.isLtr
              ? AppStrings.enFontFamily
              : AppStrings.arFontFamily),
          supportedLocales: locals,
          locale: LanguageBloc.instance.selectLocale != null
              ? LanguageBloc.instance.selectLocale!
              : const Locale('en', 'US'),
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
