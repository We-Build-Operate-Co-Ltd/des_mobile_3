import 'dart:async';
import 'package:des/shared/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewInAppPage extends StatefulWidget {
  const WebViewInAppPage({super.key, this.url, this.title});
  final String? url;
  final String? title;
  @override
  _WebViewInAppPageState createState() => new _WebViewInAppPageState();
}

class _WebViewInAppPageState extends State<WebViewInAppPage> {
  String? faceScanUrl = "";
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: InAppWebViewPage(scanFaceWeb: faceScanUrl));
    return InAppWebViewPage(
      scanFaceWeb: widget.url,
      title: widget.title,
    );
  }
}

class InAppWebViewPage extends StatefulWidget {
  InAppWebViewPage({this.scanFaceWeb, this.title});
  String? scanFaceWeb;
  String? title;

  @override
  _InAppWebViewPageState createState() =>
      new _InAppWebViewPageState(scanFaceWeb: scanFaceWeb, title: title);
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  _InAppWebViewPageState({this.scanFaceWeb, this.title});
  String? scanFaceWeb;
  String? title;
  late InAppWebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).custom.w_b_b,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/back.png',
                    height: 40,
                    width: 40,
                  ),
                ),
                Expanded(
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).custom.b_w_y,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
        ),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: Container(
              child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: Uri.parse(scanFaceWeb ?? '')),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
                    // debuggingEnabled: true,
                  ),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                androidOnPermissionRequest: (InAppWebViewController controller,
                    String origin, List<String> resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onReceivedServerTrustAuthRequest:
                    (controller, challenge) async {
                  return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED);
                },
              ),
            ),
          ),
        ])));
  }
}