import 'dart:io';

import 'package:des/login_first.dart';
import 'package:des/shared/counterNotifier.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/notification_service.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/splash.dart';
import 'package:des/register_verify_thai_id.dart';
import 'package:des/verify_thai_id.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  LineSDK.instance.setup('1660694688').then((_) {
    // print('LineSDK Prepared');
  });

  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => CounterNotifier(),
        child: const MyApp(),
      ),
    );
  });
  // runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final ValueNotifier<ThemeModeThird> themeNotifier =
      ValueNotifier(ThemeModeThird.light);
  static final ValueNotifier<FontKanit> fontKanit =
      ValueNotifier(FontKanit.small);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      try {
        uriLinkStream.listen((Uri? uri) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? state = prefs.getString('thaiDState') ?? '';
          String? action = prefs.getString('thaiDAction') ?? '';

          // logWTF('got uri: $uri');

          if (state == uri!.queryParameters['state']) {
            await prefs.setString(
              'thaiDCode',
              uri.queryParameters['code'].toString(),
            );
              if (action == 'login') {
              navigatorKey.currentState!.pushReplacementNamed('/loginFirst');
            }
            if (action == 'create') {
              navigatorKey.currentState!
                  .pushReplacementNamed('/registerVerifyThaiId');
            }
            if (action == 'update') {
              navigatorKey.currentState!.pushReplacementNamed('/verifyThaiId');
            }
          } else {
            // clear data.
            await prefs.remove('thaiDCode');
            await prefs.remove('thaiDState');
            await prefs.remove('thaiDAction');
          }
        }, onError: (Object err) {
          logD('got err: $err');
        });
      } catch (e) {
        logE(e);
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return ValueListenableBuilder<ThemeModeThird>(
      valueListenable: MyApp.themeNotifier,
      builder: (_, ThemeModeThird currentMode, __) {
        return MaterialApp(
          title: 'DCC',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          navigatorKey: navigatorKey,
          routes: <String, WidgetBuilder>{
            '/registerVerifyThaiId': (BuildContext context) =>
                const RegisterVerifyThaiIDPage(),
            '/verifyThaiId': (BuildContext context) => const VerifyThaiIDPage(),
            '/loginFirst': (BuildContext context) =>
                const LoginFirstPage(),
          },
          theme: FlexThemeData.light(
            fontFamily: 'kanit',
            useMaterial3: true,
            colors: FlexSchemeColor.from(
              primary: const Color(0xFF7A4CB1),
              brightness: Brightness.light,
            ),
          ),
          home: const SplashPage(),
          builder: (context, child) {
            return ValueListenableBuilder<FontKanit>(
              valueListenable: MyApp.fontKanit,
              builder: (_, FontKanit currentMode, __) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                      textScaleFactor: currentMode == FontKanit.small
                          ? 1.0
                          : currentMode == FontKanit.medium
                              ? 1.5
                              : 2.0),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// blocks rotation; sets orientation to: portrait
void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
