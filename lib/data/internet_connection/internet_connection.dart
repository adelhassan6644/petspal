import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../app/core/app_core.dart';
import '../../components/custom_simple_dialog.dart';
import '../../navigation/custom_navigation.dart';
import 'check_connection_dialog.dart';

class InternetConnection {
  final Connectivity connectivity;
  InternetConnection({required this.connectivity});

  bool showDialog = false;

  StreamSubscription<List<ConnectivityResult>> connectionStream(onVisible) {
    return connectivity.onConnectivityChanged
        .listen((v) => checkConnectivity(result: v, onVisible: onVisible));
  }

  checkConnectivity(
      {required List<ConnectivityResult> result, Function()? onVisible}) async {
    bool isNotConnected;
    if (result.contains(ConnectivityResult.none)) {
      isNotConnected = true;
    } else {
      isNotConnected = !await updateConnectivityStatus();
    }

    // isNotConnected ? null : AppCore.hideSnackBar();
    // AppCore.showSnackBar(
    //     notification: AppNotification(
    //   message: getTranslated(!isNotConnected ? "connected" : "no_connection"),
    //   backgroundColor: isNotConnected
    //       ? Colors.red.withOpacity(0.85)
    //       : Colors.green.withOpacity(0.85),
    //   borderColor: isNotConnected
    //       ? Colors.red.withOpacity(0.85)
    //       : Colors.green.withOpacity(0.85),
    //   isFloating: true,
    // ));

    if (isNotConnected && showDialog != true) {
      showDialog = true;
      // _updateConnectionMessage(result).then((v) => AppCore.showToast(v));
      CustomSimpleDialog.parentSimpleDialog(
          canDismiss: false,
          coverAllPage: true,
          customWidget: const CheckConnectionDialog());
    }

    if (showDialog && !isNotConnected) {
      _updateConnectionMessage(result).then((v) => AppCore.showToast(v));
      showDialog = false;
      onVisible?.call();
      if (CustomNavigator.navigatorState.currentState!.canPop()) {
        CustomNavigator.navigatorState.currentState!.pop();
      }
    }

    log("===> onConnectivityChanged${result.toString()}");
    log("===> isNotConnected $isNotConnected");
    log("===> showDialog $showDialog");
  }

  Future<bool> updateConnectivityStatus() async {
    bool isConnected = true;
    try {
      final List<InternetAddress> result =
      await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } catch (e) {
      isConnected = false;
    }
    return isConnected;
  }

  Future<String> _updateConnectionMessage(
      List<ConnectivityResult> result) async {
    switch (result.last) {
      case ConnectivityResult.wifi:
        return 'Connected to WiFi';
      case ConnectivityResult.mobile:
        return 'Connected to Mobile Network';
      case ConnectivityResult.none:
        return 'No Internet Connection';
      default:
        return 'No Internet Connection';
    }
  }
}
