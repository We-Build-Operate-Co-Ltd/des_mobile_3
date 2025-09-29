// ignore_for_file: deprecated_member_use

import 'package:des/shared/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

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
  final String? scanFaceWeb;
  final String? title;

  @override
  _InAppWebViewPageState createState() =>
      new _InAppWebViewPageState(scanFaceWeb: scanFaceWeb, title: title);
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  _InAppWebViewPageState({this.scanFaceWeb, this.title});
  String? scanFaceWeb;
  String? title;
  InAppWebViewController? _webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).custom.w_b_b,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 2,
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
                  MyApp.themeNotifier.value == ThemeModeThird.light
                      ? 'assets/images/back_arrow.png'
                      : 'assets/images/2024/back_balckwhite.png',
                  height: 40,
                  width: 40,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).custom.b_w_y,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child:
                    //  InAppWebView(
                    //   initialUrlRequest: URLRequest(
                    //       url: WebUri.uri(Uri.parse(scanFaceWeb ?? ''))),
                    //   initialOptions: InAppWebViewGroupOptions(
                    //     crossPlatform: InAppWebViewOptions(
                    //       mediaPlaybackRequiresUserGesture: false,
                    //       // debuggingEnabled: true,
                    //     ),
                    //   ),
                    //   onWebViewCreated: (InAppWebViewController controller) {
                    //     // _webViewController = controller;
                    //   },
                    //   androidOnPermissionRequest:
                    //       (InAppWebViewController controller, String origin,
                    //           List<String> resources) async {
                    //     return PermissionRequestResponse(
                    //         resources: resources,
                    //         action: PermissionRequestResponseAction.GRANT);
                    //   },
                    //   onReceivedServerTrustAuthRequest:
                    //       (controller, challenge) async {
                    //     return ServerTrustAuthResponse(
                    //         action: ServerTrustAuthResponseAction.PROCEED);
                    //   },
                    // ),
                    InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri.uri(Uri.parse(widget.scanFaceWeb ?? "")),
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      mediaPlaybackRequiresUserGesture: true,
                      useShouldOverrideUrlLoading: true, // บังคับเช็ค url
                    ),
                    android: AndroidInAppWebViewOptions(
                      useWideViewPort: true,
                      builtInZoomControls: true,
                      thirdPartyCookiesEnabled: true,
                      domStorageEnabled: true,
                      clearSessionCache: true,
                      allowFileAccess: true,
                      allowContentAccess: true,
                      mixedContentMode:
                          AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                    ),
                    ios: IOSInAppWebViewOptions(
                      allowsInlineMediaPlayback: true,
                      allowsBackForwardNavigationGestures: true,
                    ),
                  ),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    final uri = navigationAction.request.url;

                    if (uri == null) return NavigationActionPolicy.ALLOW;

                    if (uri.scheme == "http" || uri.scheme == "https") {
                      return NavigationActionPolicy.ALLOW;
                    }
                    return NavigationActionPolicy.CANCEL;
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT,
                    );
                  },
                  onReceivedServerTrustAuthRequest:
                      (controller, challenge) async {
                    return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED,
                    );
                  },
                  onLoadError: (controller, url, code, message) {
                    debugPrint("Load error: $url $message");
                  },
                  onLoadHttpError: (controller, url, statusCode, description) {
                    debugPrint("HTTP error: $url $statusCode $description");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
