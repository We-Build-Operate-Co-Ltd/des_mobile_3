import 'package:flutter/material.dart';
import '../main.dart';

class ThemeColorData {
  Color primary;
  Color bwy;
  Color f70f70y;
  Color wwy;

  ThemeColorData({
    required this.primary,
    required this.bwy,
    required this.f70f70y,
    required this.wwy,
  });
}

final themeLight = ThemeColorData(
  primary: Color(0xFFFFFFFF),
  bwy: Color(0xFF000000),
  f70f70y: Color(0xFF707070),
  wwy: Color(0xFFFFFFFF),
);
final themeDark = ThemeColorData(
  primary: Color(0xFF000000),
  bwy: Color(0xFFFFFFFF),
  f70f70y: Color(0xFF707070),
  wwy: Color(0xFFFFFFFF),
);
final themeBlindness = ThemeColorData(
  primary: Color(0xFF000000),
  bwy: Colors.yellow,
  f70f70y: Colors.yellow,
  wwy: Colors.yellow,
);

ThemeData customLight({
  final Iterable<ThemeExtension<dynamic>>? extensions,
}) =>
    ThemeData();

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
