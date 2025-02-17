import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../app/core/styles.dart';
import '../../app/localization/language_constant.dart';
import '../../components/custom_app_bar.dart';
import '../../navigation/custom_navigation.dart';
import '../../navigation/routes.dart';

class InAppViewPage extends StatefulWidget {
  final String url;

  const InAppViewPage({super.key, required this.url});

  @override
  State<InAppViewPage> createState() => _InAppViewPageState();
}

class _InAppViewPageState extends State<InAppViewPage> {
  bool isLoading = true;
  bool isSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("payment"),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true),
            onWebViewCreated: (controller) => evaluateJavaScript(controller),
            onLoadStart: (controller, url) => setState(() => isLoading = true),
            onLoadStop: (controller, url) {
              isLoading = false;
              setState(() {});

              /// Evaluate JavaScript to check for a response
              evaluateJavaScript(controller);
            },
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

  void evaluateJavaScript(controller) async {
    if (controller != null) {
      /// Execute JavaScript code within the WebView
      String? result = await controller!
          .evaluateJavascript(source: 'document.body.innerHTML');
      log("======>result: $result");

      /// Process the JavaScript response
      if (result != null && result.contains('Transaction successful')) {
        Future.delayed(const Duration(seconds: 1), () {
          CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
        });
      }

      if (result != null && result.contains('Transaction not completed')) {
        Future.delayed(const Duration(seconds: 1), () {
          CustomNavigator.pop();
        });
      }
    }
  }
}
