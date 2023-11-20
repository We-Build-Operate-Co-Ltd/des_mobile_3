import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PolicyWebPage extends StatefulWidget {
  const PolicyWebPage({super.key});
  // final String? idCard;
  // final String? type;
  @override
  _PolicyWebPageState createState() => new _PolicyWebPageState();
}

class _PolicyWebPageState extends State<PolicyWebPage> {
  String faceScanUrl = "https://decms.dcc.onde.go.th/privacy-policy/";
  @override
  Widget build(BuildContext context) {
    // if (widget.type == "checkIn") {
    //   faceScanUrl =
    //       "https://uis.dcc.onde.go.th/staff/check-in?id=${widget.idCard}&start=1";
    // } else if (widget.type == "checkOut") {
    //   faceScanUrl =
    //       "https://uis.dcc.onde.go.th/staff/check-out?id=${widget.idCard}&start=1";
    // }
    return Scaffold(body: InAppWebViewPage(scanFaceWeb: faceScanUrl));
  }
}

class InAppWebViewPage extends StatefulWidget {
  InAppWebViewPage({this.scanFaceWeb});
  String? scanFaceWeb;

  @override
  _InAppWebViewPageState createState() =>
      new _InAppWebViewPageState(scanFaceWeb: scanFaceWeb);
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  _InAppWebViewPageState({this.scanFaceWeb});
  String? scanFaceWeb;
  late InAppWebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 50 + MediaQuery.of(context).padding.bottom,
          left: 10,
          right: 10,
          bottom: 50 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: <Widget>[
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
                  androidOnPermissionRequest:
                      (InAppWebViewController controller, String origin,
                          List<String> resources) async {
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
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                // FocusScope.of(context).unfocus();
                Navigator.pop(context, true);
              },
              child: Container(
                height: 45,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x40F3D2FF),
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  'ยอมรับการใช้งาน',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
