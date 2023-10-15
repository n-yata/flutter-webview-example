import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InnerWebView extends StatelessWidget {
  const InnerWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              // title: const Text("webView"),
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: backButton(context),
            ),
          ),
          body: const WebView(
            initialUrl: 'https://github.com/n-yata',
            javascriptMode: JavascriptMode.unrestricted,
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
