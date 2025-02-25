import 'dart:io';
import 'package:petspal/features/best_seller/page/best_seller_page.dart';
import 'package:petspal/features/cart/page/cart_page.dart';
import 'package:petspal/features/categories/model/categories_model.dart';
import 'package:petspal/features/categories/page/categories_page.dart';
import 'package:petspal/features/edit_profile/page/edit_profile_page.dart';
import 'package:petspal/features/maps/models/location_model.dart';
import 'package:petspal/features/payment/in_app_web_view_page.dart';
import 'package:petspal/features/product_details/page/package_details_page.dart';
import 'package:petspal/features/products/page/products_page.dart';
import 'package:petspal/features/transactions/page/transactions_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petspal/features/vendors/page/vendors_page.dart';
import '../features/chat/page/chat_page.dart';
import '../components/video_preview_page.dart';
import '../features/contact_with_us/page/contact_with_us_page.dart';
import '../features/faqs/page/faqs_page.dart';
import '../features/feedbacks/view/my_feedbacks_page.dart';
import '../features/maps/page/pick_map_page.dart';
import '../features/notifications/page/notifications_page.dart';
import '../main.dart';
import 'routes.dart';
import '../main_page/page/dashboard.dart';
import '../features/profile/page/my_profile.dart';
import '../features/auth/forget_password/page/forget_password.dart';
import '../features/auth/login/page/login.dart';
import '../features/auth/register/page/register.dart';
import '../features/auth/reset_password/page/reset_password.dart';
import '../features/auth/verification/model/verification_model.dart';
import '../features/auth/verification/page/verification.dart';
import '../features/change_password/page/change_password_page.dart';
import '../features/on_boarding/pages/on_boarding.dart';
import '../features/setting/pages/privacy_policy.dart';
import '../features/setting/pages/terms.dart';
import '../features/splash/page/splash.dart';

abstract class CustomNavigator {
  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldState =
      GlobalKey<ScaffoldMessengerState>();

  static Route<dynamic> onCreateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.app:
        return _pageRoute(const MyApp());
      case Routes.splash:
        return _pageRoute(const Splash());
      case Routes.onBoarding:
        return _pageRoute(const OnBoarding());
      case Routes.login:
        return _pageRoute(Login());

      case Routes.register:
        return _pageRoute(const Register());

      case Routes.forgetPassword:
        return _pageRoute(const ForgetPassword());

      case Routes.resetPassword:
        return _pageRoute(ResetPassword(
          data: settings.arguments as VerificationModel,
        ));

      case Routes.changePassword:
        return _pageRoute(const ChangePassword());

      case Routes.verification:
        return _pageRoute(
            Verification(model: settings.arguments as VerificationModel));

      case Routes.editProfile:
        return _pageRoute(EditProfilePage(
            fromComplete: (settings.arguments as bool?) ?? false));

      case Routes.profile:
        return _pageRoute(const MyProfile());

      case Routes.dashboard:
        return _pageRoute(DashBoard(
          index:
              settings.arguments != null ? (settings.arguments as int) : null,
        ));

      case Routes.notifications:
        return _pageRoute(const NotificationsPage());

      case Routes.categories:
        return _pageRoute(const CategoriesPage());

      case Routes.vendors:
        return _pageRoute(const VendorsPage());

      case Routes.bestSeller:
        return _pageRoute(const BestSellerPage());

      case Routes.videoPreview:
        return _pageRoute(VideoPreviewPage(data: settings.arguments as Map));

      case Routes.chat:
        return _pageRoute(ChatPage(data: settings.arguments as Map));

      case Routes.pickLocation:
        return _pageRoute(
            PickMapPage(data: settings.arguments as LocationModel));

      case Routes.cart:
        return _pageRoute(CartPage());

      case Routes.payment:
        return _pageRoute(InAppViewPage(url: settings.arguments as String));

      case Routes.products:
        return _pageRoute(
            ProductsPage(category: settings.arguments as CategoryModel));

      case Routes.productDetails:
        return _pageRoute(ProductDetailsPage(id: settings.arguments as int));

      case Routes.myFeedbacks:
        return _pageRoute(const MyFeedbacksPage());

      case Routes.transactions:
        return _pageRoute(const TransactionPage());

      case Routes.contactWithUs:
        return _pageRoute(const ContactWithUsPage());

      case Routes.privacy:
        return _pageRoute(const PrivacyPolicy());

      case Routes.terms:
        return _pageRoute(const Terms());

      case Routes.faqs:
        return _pageRoute(const FaqsPage());

      default:
        return MaterialPageRoute(builder: (_) => const MyApp());
    }
  }

  static _pageRoute(Widget child) => Platform.isIOS
      ? CupertinoPageRoute(builder: (_) => child)
      : MaterialPageRoute(builder: (_) => child);

  // static PageRouteBuilder<dynamic> _pageRoute(Widget child) => PageRouteBuilder(
  //     transitionDuration: const Duration(milliseconds: 100),
  //     reverseTransitionDuration: const Duration(milliseconds: 100),
  //     transitionsBuilder: (c, anim, a2, child) {
  //       var begin = const Offset(1.0, 0.0);
  //       var end = Offset.zero;
  //       var tween = Tween(begin: begin, end: end);
  //       var curveAnimation =
  //           CurvedAnimation(parent: anim, curve: Curves.linearToEaseOut);
  //       return SlideTransition(
  //         position: tween.animate(curveAnimation),
  //         child: child,
  //       );
  //     },
  //     opaque: false,
  //     pageBuilder: (_, __, ___) => child);

  static pop({dynamic result}) {
    if (navigatorState.currentState!.canPop()) {
      navigatorState.currentState!.pop(result);
    }
  }

  static push(String routeName,
      {arguments, bool replace = false, bool clean = false}) {
    if (clean) {
      return navigatorState.currentState!.pushNamedAndRemoveUntil(
          routeName, (_) => false,
          arguments: arguments);
    } else if (replace) {
      return navigatorState.currentState!.pushReplacementNamed(
        routeName,
        arguments: arguments,
      );
    } else {
      return navigatorState.currentState!
          .pushNamed(routeName, arguments: arguments);
    }
  }
}
