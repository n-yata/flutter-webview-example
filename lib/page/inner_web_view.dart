import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class InnerWebView extends StatefulWidget {
  const InnerWebView({super.key});

  @override
  State<InnerWebView> createState() => _InnerWebViewState();
}

class _InnerWebViewState extends State<InnerWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: backButton(context),
            ),
          ),
          body: WebView(
            initialUrl: 'https://flutter.dev',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              debugPrint('webView created');
            },
            navigationDelegate: (NavigationRequest request) async {
              debugPrint('blocking navigation to $request}');
              WebViewController con = await _controller.future;
              con.loadUrl('https://github.com/n-yata');
              return NavigationDecision.prevent;
            },
          ),
        ));
  }

  /// 戻るボタン
  TextButton backButton(BuildContext context) {
    return TextButton(
      child: const Text(
        '×',
        style: TextStyle(
          color: Colors.black, //文字の色を白にする
          fontWeight: FontWeight.normal, //文字を太字する
          fontSize: 30.0, //文字のサイズを調整する
        ),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
