import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class ThemeColorData extends ChangeNotifier {
  Color primary;
  Color b_w_y;
  Color b_b_b;
  Color w_b_y;
  Color f70f70_y;
  Color w_w_y;
  Color w_b_b;
  Color w_292929;
  Color b325f8_w_fffd57;
  Color b325f8_w_g;
  Color b_W_fffd57;
  Color A4CB1_w_fffd57;
  Color b_w;
  Color eeba33_b_b;
  Color w_w_fffd57;
  Color g05_w01_w01;
  Color f70f70_b_b;
  Color f70f70_w_fffd57;
  Color f70f70_292929_292929;
  Color eeba33_292929_292929;

  ThemeColorData(
      {required this.primary,
      required this.b_w_y,
      required this.b_b_b,
      required this.w_b_y,
      required this.f70f70_y,
      required this.w_w_y,
      required this.w_b_b,
      required this.w_292929,
      required this.b325f8_w_fffd57,
      required this.b325f8_w_g,
      required this.b_W_fffd57,
      required this.A4CB1_w_fffd57,
      required this.b_w,
      required this.eeba33_b_b,
      required this.w_w_fffd57,
      required this.g05_w01_w01,
      required this.f70f70_b_b,
      required this.f70f70_w_fffd57,
      required this.f70f70_292929_292929,
      required this.eeba33_292929_292929});

  Future<void> swapTheme(ThemeModeThird selectedTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (selectedTheme == ThemeModeThird.blindness) {
      await prefs.setString("themeMode", 'light');
    } else if (selectedTheme == ThemeModeThird.dark) {
      await prefs.setString("themeMode", "light");
    } else {
      await prefs.setString("themeMode", "blindness");
    }

    notifyListeners();
  }
}

final themeLight = ThemeColorData(
    primary: Color(0xFFFFFFFF),
    b_w_y: Color(0xFF000000),
    b_b_b: Color(0xFF000000),
    w_b_y: Color(0xFFFFFFFF),
    b_w: Colors.black,
    f70f70_y: Color(0xFF707070),
    w_w_y: Color(0xFFFFFFFF),
    w_b_b: Color(0xFFFFFFFF),
    w_292929: Colors.white,
    b325f8_w_fffd57: Color(0xFFb325f8),
    b325f8_w_g: Color(0xFFb325f8),
    b_W_fffd57: Colors.black,
    A4CB1_w_fffd57: Color(0xFF7A4CB1),
    eeba33_b_b: Color(0xFFeeba33),
    w_w_fffd57: Colors.white,
    g05_w01_w01: Colors.grey.withOpacity(0.5),
    f70f70_b_b: Color(0xFF707070),
    f70f70_w_fffd57: Color(0xFF707070),
    f70f70_292929_292929: Color(0xFF707070),
    eeba33_292929_292929: Color(0xFFeeba33));
final themeDark = ThemeColorData(
    primary: Color(0xFF000000),
    b_w_y: Color(0xFFFFFFFF),
    b_b_b: Color(0xFF000000),
    w_b_y: Color(0xFF000000),
    b_w: Colors.white,
    f70f70_y: Color(0xFF707070),
    w_w_y: Color(0xFFFFFFFF),
    w_b_b: Colors.black,
    w_292929: Color(0xFF292929),
    b325f8_w_fffd57: Colors.white,
    b325f8_w_g: Colors.white,
    b_W_fffd57: Colors.white,
    A4CB1_w_fffd57: Colors.white,
    eeba33_b_b: Colors.black,
    w_w_fffd57: Colors.white,
    g05_w01_w01: Colors.white.withOpacity(0.1),
    f70f70_b_b: Colors.black,
    f70f70_w_fffd57: Colors.white,
    f70f70_292929_292929: Color(0xFf292929),
    eeba33_292929_292929: Color(0xFf292929));
final themeBlindness = ThemeColorData(
    primary: Color(0xFF000000),
    b_w_y: Colors.yellow,
    b_b_b: Color(0xFF000000),
    w_b_y: Colors.yellow,
    b_w: Colors.white,
    f70f70_y: Colors.yellow,
    w_w_y: Colors.yellow,
    w_b_b: Colors.black,
    w_292929: Color(0xFF292929),
    b325f8_w_fffd57: Color(0xFFfffd57),
    b325f8_w_g: Color(0xFF707070),
    b_W_fffd57: Color(0xFFfffd57),
    A4CB1_w_fffd57: Color(0xFFfffd57),
    eeba33_b_b: Colors.black,
    w_w_fffd57: Color(0xFFfffd57),
    g05_w01_w01: Colors.white.withOpacity(0.1),
    f70f70_b_b: Colors.black,
    f70f70_w_fffd57: Color(0xFFfffd57),
    f70f70_292929_292929: Color(0xFf292929),
    eeba33_292929_292929: Color(0xFf292929));

// ref: https://stackoverflow.com/questions/54139924/flutter-how-do-i-change-theme-brightness-at-runtime
// use it with "Theme.of(context).custom"
extension CustomThemeData on ThemeData {
  static ThemeData customLight({
    final Iterable<ThemeExtension<dynamic>>? extensions,
  }) =>
      ThemeData();
  ThemeColorData get custom {
    if (MyApp.themeNotifier.value == ThemeModeThird.dark) {
      return themeDark;
    } else if (MyApp.themeNotifier.value == ThemeModeThird.blindness) {
      return themeBlindness;
    } else {
      return themeLight;
    }
  }
}

enum ThemeModeThird {
  system,
  light,
  dark,
  blindness,
}

enum FontKanit {
  small,
  medium,
  large,
}

class ChangeDarkMode extends StatefulWidget {
  const ChangeDarkMode({Key? key}) : super(key: key);

  @override
  State<ChangeDarkMode> createState() => _ChangeDarkModeState();
}

class _ChangeDarkModeState extends State<ChangeDarkMode> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        MyApp.themeNotifier.value == ThemeModeThird.blindness
            ? Icons.blind
            : MyApp.themeNotifier.value == ThemeModeThird.dark
                ? Icons.dark_mode
                : Icons.light_mode,
      ),
      onPressed: () {
        setState(
          () {
            if (MyApp.themeNotifier.value == ThemeModeThird.light) {
              MyApp.themeNotifier.value = ThemeModeThird.dark;
            } else if (MyApp.themeNotifier.value == ThemeModeThird.dark) {
              MyApp.themeNotifier.value = ThemeModeThird.blindness;
            } else {
              MyApp.themeNotifier.value = ThemeModeThird.light;
            }
          },
        );
      },
    );
  }
}
