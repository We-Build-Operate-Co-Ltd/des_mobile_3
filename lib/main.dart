import 'package:des/shared/theme_data.dart';
import 'package:des/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  LineSDK.instance.setup('1660694688').then((_) {
    print('LineSDK Prepared');
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final ValueNotifier<ThemeModeThird> themeNotifier =
      ValueNotifier(ThemeModeThird.light);
  static final ValueNotifier<FontKanit> fontKanit =
      ValueNotifier(FontKanit.small);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return ValueListenableBuilder<ThemeModeThird>(
      valueListenable: themeNotifier,
      builder: (_, ThemeModeThird currentMode, __) {
        return MaterialApp(
          title: 'DES ดิจิทัลชุมชน',
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(
            fontFamily: 'kanit',
            colors: FlexSchemeColor.from(
              primary: const Color(0xFF7A4CB1),
              brightness: Brightness.light,
            ),
          ),
          home: const SplashPage(),
          builder: (context, child) {
            return ValueListenableBuilder<FontKanit>(
      valueListenable: fontKanit,
      builder: (_, FontKanit currentMode, __) {
       return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 
                currentMode == FontKanit.small ? 1.0 : 
                currentMode == FontKanit.medium ? 1.5 : 
                2.0
              ),
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
