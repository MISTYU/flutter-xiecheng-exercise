import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  String? url;

  WebViewExample({
    this.url,
  }) {
    if (url != null && url!.contains('ctrip.com')) {
      url = url!.replaceAll("http://", 'https://');
    }
  }
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Example'),
      ),
      body: WebView(
        initialUrl: 'http://127.0.0.1:10086',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
