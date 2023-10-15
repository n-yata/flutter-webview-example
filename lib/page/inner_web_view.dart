import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InnerWebView extends StatelessWidget {
  const InnerWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("webView"),
      ),
      body: const WebView(
        initialUrl: 'https://github.com/n-yata',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}