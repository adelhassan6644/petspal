import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app/core/styles.dart';
import '../../app/localization/language_constant.dart';
import '../../components/custom_app_bar.dart';
import '../../navigation/custom_navigation.dart';
import '../../navigation/routes.dart';

class PaymentPage extends StatefulWidget {
  final String url;

  const PaymentPage({super.key, required this.url});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = true;
  late WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
            onPageStarted: (String url) {
              isLoading = true;
              setState(() {});
            },
            onPageFinished: (String url) {
              isLoading = false;
              evaluateJavaScript();
              setState(() {});
            },
            onUrlChange: (url) => evaluateJavaScript()),)
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("payment"),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (isLoading)
            Column(
              children: [
                Expanded(
                    child: Container(
                        color: Styles.WHITE_COLOR,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Styles.PRIMARY_COLOR,
                        )))),
              ],
            ),
        ],
      ),
    );
  }

  void evaluateJavaScript() async {
    // Execute JavaScript code within the WebView
    String? result = (await controller.platform
        .runJavaScriptReturningResult('document.body.innerHTML')) as String?;
    log("======>result: $result");
    // Process the JavaScript response
    if (result != null && result.contains('Transaction successful')) {
      Future.delayed(const Duration(seconds: 1), () {
        CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
      });
    }

    if (result != null && result.contains('Transaction not completed')) {
      log("fail");
      Future.delayed(const Duration(seconds: 1), () {
        CustomNavigator.pop();
      });
    }
  }
}
