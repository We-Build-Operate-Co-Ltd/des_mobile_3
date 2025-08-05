import 'dart:async';
import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main.dart';

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

  late WebViewController _webViewController;
  late Future<dynamic> _futureHtml;
  bool _isLoading = true;
  bool _isHtmlLoaded =
      false; // เพิ่มตัวแปรนี้เพื่อตรวจสอบว่าโหลด HTML แล้วหรือยัง

  @override
  void initState() {
    super.initState();
    _futureHtml = _callRead();
    _initWebViewController();
  }

  void _initWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
            setState(() {
              _isLoading = true;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation request: ${request.url}');
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      );
  }

  // ฟังก์ชันสำหรับโหลด HTML
  void _loadHtml(String htmlContent) async {
    if (!_isHtmlLoaded) {
      try {
        // ใช้ loadHtmlString แทน loadRequest สำหรับ HTML content
        await _webViewController.loadHtmlString(htmlContent);
        _isHtmlLoaded = true;
      } catch (e) {
        print('Error loading HTML: $e');
      }
    }
  }

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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 35.0,
                  height: 35.0,
                  margin: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? 'assets/images/back_arrow.png'
                          : "assets/images/2024/back_balckwhite.png",
                    ),
                  ),
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
        future: _futureHtml,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is String && snapshot.data.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadHtml(snapshot.data);
              });

              return Stack(
                children: [
                  WebViewWidget(controller: _webViewController),
                  if (_isLoading)
                    Container(
                      color: Colors.white.withOpacity(0.8),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Color(0xFFB325F8)
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.black
                                      : Color(0xFFFFFD57),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'กำลังเชื่อมต่อกับน้องตาโต...',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Color(0xFFB325F8)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.black
                                          : Color(0xFFFFFD57)),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'เกิดข้อผิดพลาด: ไม่สามารถโหลดข้อมูลได้',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureHtml = _callRead();
                          _isHtmlLoaded = false;
                        });
                      },
                      child: Text('ลองใหม่'),
                    ),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'เกิดข้อผิดพลาด: ${snapshot.error}',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureHtml = _callRead();
                        _isHtmlLoaded = false;
                      });
                    },
                    child: Text('ลองใหม่'),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFB325F8)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.black
                            : Color(0xFFFFFD57),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'กำลังเชื่อมต่อกับน้องตาโต...',
                    style: TextStyle(
                        fontSize: 16,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFB325F8)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.black
                                : Color(0xFFFFFD57)),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  _callRead() async {
    try {
      String token = await ManageStorage.read('accessToken');
      String name = 'ศูนย์ดิจิทัลชุมชน';
      var shortToken = await _getShortToken(token);

      if (shortToken == null || shortToken.isEmpty) {
        throw Exception('ไม่สามารถได้รับ token ได้');
      }

      var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
      if (profileMe != null && profileMe['firstnameTh'] != null) {
        name = profileMe['firstnameTh'];
      }

      var html = '''<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />
    <title>น้องตาโต</title>
    <style>
        body { margin: 0; padding: 0; font-family: 'Sarabun', sans-serif; }
        #bn-root { width: 100%; height: 100vh; }
    </style>
</head>
<body>
    <div id="bn-root"></div>
    <div
        class="bn-customerchat"
        bot_id="65239937afe8b816d30878b6"
        theme_color="#2F9E79"
        bot_logo="https://decms.dcc.onde.go.th/botnoi/mascot.png"
        bot_name="น้องตาโต"
        locale="th"
        logged_in_greeting="ยินดีต้อนรับ"
        greeting_message="อยากให้น้องตาโตช่วยเหลือ แจ้งได้เลยค่ะ"
        default_open="false"
        name="$name"
        session_id="$shortToken"
    ></div>
    
    <script>
        console.log('Starting bot initialization...');
        console.log('Name: $name');
        console.log('Session ID: $shortToken');
        
        // Load the BotNoi script
        (function (d, s, id) {
            var js, bjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s);
            js.id = id;
            js.src = "https://console.dcc.onde.go.th/customerchat/index.js";
            js.onload = function() {
                console.log('BotNoi script loaded successfully');
                initBot();
            };
            js.onerror = function() {
                console.error('Failed to load BotNoi script');
            };
            bjs.parentNode.insertBefore(js, bjs);
        })(document, "script", "bn-jssdk");

        function initBot() {
            console.log('Initializing bot...');
            
            // Wait a bit for the script to fully initialize
            setTimeout(function() {
                const div = document.getElementsByClassName("bn-customerchat")[0];
                if (!div) {
                    console.error("BN div not found");
                    return;
                }
                
                console.log('Found BN div, setting attributes...');
                div.setAttribute("name", "$name");
                div.setAttribute("session_id", "$shortToken");

                if (typeof BN !== "undefined" && BN.init) {
                    console.log('Initializing BN...');
                    BN.init({ version: "1.0" });
                } else {
                    console.error("BN is not defined or BN.init is not available");
                    console.log('Available BN properties:', typeof BN !== "undefined" ? Object.keys(BN) : 'BN is undefined');
                }
            }, 1000);
        }
        
        // Fallback initialization
        window.addEventListener('load', function() {
            console.log('Window loaded, checking bot status...');
            setTimeout(initBot, 2000);
        });
    </script>
</body>
</html>''';

      print('Generated HTML: $html');
      return html;
    } catch (e) {
      print('Error in _callRead: $e');
      logE(e.toString());
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด: ${e.toString()}');
      return '';
    }
  }

  _getShortToken(String token) async {
    int retryCount = 3;
    for (int i = 0; i < retryCount; i++) {
      try {
        print('Attempting to get short token, attempt ${i + 1}');
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
            sendTimeout: 10000,
            receiveTimeout: 10000,
          ),
        );

        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');

        if (response.statusCode == 200) {
          var shortToken = response.data['data'];
          print('Successfully got short token: $shortToken');
          return shortToken;
        } else {
          print('Error response: ${response.data}');
          logE(response.data);
          if (response.data != null &&
              response.data['error_description'] != null) {
            Fluttertoast.showToast(msg: response.data['error_description']);
          }
        }
      } catch (e) {
        print('Exception in _getShortToken attempt ${i + 1}: $e');
        logE(e.toString());
        if (i == retryCount - 1) {
          Fluttertoast.showToast(msg: "ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่");
        } else {
          await Future.delayed(Duration(seconds: 2));
        }
      }
    }
    return '';
  }
}
