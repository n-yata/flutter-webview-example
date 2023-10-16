import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_example/page/inner_web_view.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebViewController wvController;

  @override
  void initState() {
    super.initState();
    // Androidに対応させる
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo')),
      body: WebView(
        initialUrl: 'https://github.com/n-yata',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          wvController = webViewController;
        },
        navigationDelegate: (NavigationRequest request) async {
          if (request.url.contains('download')) {
            launchUrl(Uri.parse(request.url), mode: LaunchMode.inAppWebView);
            return NavigationDecision.prevent;
          }

          if (request.url.contains('insert')) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const InnerWebView();
            }));
            return NavigationDecision.prevent;
          }

          String url = await _addGeolocationParam(request.url);

          Map<String, String> addParams = {
            'longitudei': '0',
            'latitude': '0',
          };

          Uri uri = Uri.parse(url);
          Map<String, String> constParams = uri.queryParameters;
          Map<String,String> params = {};
          params.addAll(constParams);
          params.addAll(addParams);

          url = uri.replace(queryParameters: params).toString();

          wvController.loadUrl(url);
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  /// 端末の位置情報を取得し、queryParameterに追加する
  /// 位置情報の取得が許可されていない場合、0を返却する
  Future<String> _addGeolocationParam(String url) async {
    Map<String, String> params = {
      'longitude': '0',
      'latitude': '0',
    };

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      return Uri.parse(url).replace(queryParameters: params).toString();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    params['longitude'] = position.longitude.toString();
    params['latitude'] = position.latitude.toString();

    return Uri.parse(url).replace(queryParameters: params).toString();
  }
}
