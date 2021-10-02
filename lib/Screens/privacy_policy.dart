import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String page_name;

  WebViewScreen({Key key, this.url = "", this.page_name = ""})
      : super(key: key);

  @override
  _CommonWebviewScreenState createState() => _CommonWebviewScreenState();
}

class _CommonWebviewScreenState extends State<WebViewScreen> {
  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  buildBody() {
    return SizedBox.expand(
      child: Container(
        child: WebView(
          debuggingEnabled: false,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _webViewController = controller;
            _webViewController.loadUrl(widget.url);
          },
          onWebResourceError: (error) {},

          onPageFinished: (page) {

            //print(page.toString());
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        "${widget.page_name}",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
