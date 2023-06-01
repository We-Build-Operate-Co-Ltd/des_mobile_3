import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class ThemeColorData {
  Color primary;
  Color second;

  ThemeColorData({
    required this.primary,
    required this.second,
  });
}

ThemeData customLight({
  final Iterable<ThemeExtension<dynamic>>? extensions,
}) =>
    ThemeData();

// ref: https://stackoverflow.com/questions/54139924/flutter-how-do-i-change-theme-brightness-at-runtime
// use it with "Theme.of(context).myCustomColor"
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

final themeLight = ThemeColorData(
  primary: Color(0xFFFFFFFF),
  second: Color(0xFF000000),
);
final themeDark = ThemeColorData(
  primary: Color(0xFF000000),
  second: Color(0xFFFFFFFF),
);
final themeBlindness = ThemeColorData(
  primary: Color(0xFF000000),
  second: Colors.yellow,
);

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
