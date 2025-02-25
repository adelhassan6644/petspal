import 'package:petspal/data/config/di.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:petspal/features/cart/bloc/cart_bloc.dart';


import 'package:petspal/main_blocs/user_bloc.dart';

import '../../app/core/app_event.dart';
import '../../features/auth/logout/bloc/logout_bloc.dart';
import '../../features/categories/bloc/categories_bloc.dart';
import '../../features/chats/bloc/chats_bloc.dart';
import '../../features/home/bloc/home_ads_bloc.dart';
import '../../features/language/bloc/language_bloc.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/setting/bloc/setting_bloc.dart';
import '../../features/vendors/bloc/vendors_bloc.dart';

abstract class ProviderList {
  static List<BlocProvider> providers = [
    BlocProvider<LanguageBloc>(
        create: (_) => di.sl<LanguageBloc>()..add(Init())),
    BlocProvider<SettingBloc>(create: (_) => di.sl<SettingBloc>()),
    BlocProvider<ProfileBloc>(create: (_) => di.sl<ProfileBloc>()),
    BlocProvider<UserBloc>(create: (_) => di.sl<UserBloc>()),
    BlocProvider<HomeAdsBloc>(create: (_) => di.sl<HomeAdsBloc>()),
    BlocProvider<CategoriesBloc>(create: (_) => di.sl<CategoriesBloc>()),
    BlocProvider<CartBloc>(create: (_) => di.sl<CartBloc>()),



    ///Chats
    BlocProvider<ChatsBloc>(create: (_) => di.sl<ChatsBloc>()),

    ///Log out
    BlocProvider<LogoutBloc>(create: (_) => di.sl<LogoutBloc>()),
  ];
}
