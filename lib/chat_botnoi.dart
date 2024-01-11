import 'dart:async';
import 'dart:convert';
import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();
  await Permission.microphone.request();

  runApp(ChatBotNoiPage());
}

class ChatBotNoiPage extends StatefulWidget {
  const ChatBotNoiPage({super.key, this.idCard});
  final String? idCard;
  @override
  _ChatBotNoiPageState createState() => new _ChatBotNoiPageState();
}

class _ChatBotNoiPageState extends State<ChatBotNoiPage> {
  String faceScanUrl = "";
  @override
  Widget build(BuildContext context) {
    faceScanUrl = "https://decms.dcc.onde.go.th/botnoi/";
    // return MaterialApp(home: InAppWebViewPage(scanFaceWeb: faceScanUrl));
    return InAppWebViewPage(scanFaceWeb: faceScanUrl);
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
  // late InAppWebViewController _webViewController;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late String _htmlStr;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).custom.w_b_b,
        automaticallyImplyLeading: false,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.replay),
        //     onPressed: () {
        //       setState(() {});
        //     },
        //   ),
        // ],
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
                  'สนทนา',
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
      body: FutureBuilder<dynamic>(
        future: _callRead(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WebView(
              initialUrl: snapshot.data,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                print("WebView is loading (progress : $progress%)");
              },
              javascriptChannels: <JavascriptChannel>{
                // _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                // if (request.url.startsWith('https://www.youtube.com/')) {
                //   print('blocking navigation to $request}');
                //   return NavigationDecision.prevent;
                // }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _callRead() async {
    try {
      String token = await ManageStorage.read('accessToken');
      String name = 'ศูนย์ดิจิทัลชุมชน'; // ศูนย์ดิจิทัลชุมชน
      String welcome = 'ยินดีต้อนรับ'; // ยินดีต้อนรับ
      String message =
          'อยากให้ศูนย์ดิจิทัลช่วยเหลือ แจ้งได้เลยค่ะ'; // อยากให้ศูนย์ดิจิทัลช่วยเหลือ แจ้งได้เลยค่ะ
      var shortToken = await _getShortToken(token);
      var html = '''<!DOCTYPE html lang="en">
	<head>
		<title></title>
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=0.9, maximum-scale=0.9, user-scalable=no, shrink-to-fit=no" />
	</head>

<body>
	<div id="bn-root"></div>
	<script>
		window.onload = function () {
      			BN.init({ version: "1.0" });
  		};
	</script>
	<script>
		(function (d, s, id) {
      			var js,
          		bjs = d.getElementsByTagName(s)[0];
      			if (d.getElementById(id)) return;
      			js = d.createElement(s);
      			js.id = id;
      			js.src = "https://console.dcc.onde.go.th/customerchat/index.js";
      			bjs.parentNode.insertBefore(js, bjs);
  		})(document, "script", "bn-jssdk");
	</script>

	<div class="bn-customerchat"
   bot_id="65239937afe8b816d30878b6"
    theme_color="#7A4CB1" 
    bot_logo="https://decms.dcc.onde.go.th/botnoi/mascot.png" 
    bot_name="${name}" locale="th" 
    logged_in_greeting="${welcome}" 
    greeting_message="${message}" 
    default_open="false" name="" 
    session_id="${shortToken}"></div>
</body>

</html>''';

      final String contentBase64 =
          base64Encode(const Utf8Encoder().convert(html));
      return 'data:text/html;base64,$contentBase64';
    } catch (e) {
      logE(e.toString());
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      return '';
    }
  }

  _getShortToken(String token) async {
    try {
      // get token
      Response response = await Dio().get(
        '$ondeURL/api/user/SaveUserToken',
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.json,
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        logE(response.data);
        Fluttertoast.showToast(msg: response.data['error_description']);
      }
    } on DioError catch (e) {
      logE(e.error);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data.toString();
      }
      Fluttertoast.showToast(msg: err);
    }
  }
}
