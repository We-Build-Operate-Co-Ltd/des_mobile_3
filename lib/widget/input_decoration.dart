import 'package:flutter/material.dart';

import '../main.dart';
import '../shared/theme_data.dart';

class CusInpuDecoration {
  static InputDecoration base(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0x807209B7),
          fontSize: 12,
        ),
        alignLabelWithHint: true,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFCEA8F3),
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.only(left: 19, right: 19, bottom: 4),
        border: InputBorder.none,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 7,
        ),
      );

  static InputDecoration password(
    context, {
    String hintText = '',
    bool visibility = false,
    required Function? suffixTap,
  }) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFFB325F8)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
        ),
        alignLabelWithHint: true,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFFB325F8)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            suffixTap!();
          },
          child: visibility
              ? Icon(Icons.visibility_off,
                  size: 18,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57))
              : Icon(
                  Icons.visibility,
                  size: 18,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.only(left: 19, right: 19, bottom: 4),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFB325F8)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 2,
        ),
      );
}

class ChatInputDecoration {
  static InputDecoration base(context, {String hintText = ''}) =>
      InputDecoration(
        labelStyle: const TextStyle(
          color: Color(0x7D000000),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        alignLabelWithHint: true,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0x7D000000),
        ),
        hintText: hintText,
        filled: false,
        // fillColor: const Color(0xFFE4E5EB),
        contentPadding: const EdgeInsets.all(0),
        border: InputBorder.none,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(color: Colors.transparent),
        //   // borderRadius: BorderRadius.circular(28),
        // ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 7,
        ),
      );
}
