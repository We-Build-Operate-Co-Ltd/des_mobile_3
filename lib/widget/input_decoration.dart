import 'package:flutter/material.dart';

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
        suffixIcon: GestureDetector(
          onTap: () {
            suffixTap!();
          },
          child: visibility
              ? const Icon(Icons.visibility_off, size: 18)
              : const Icon(Icons.visibility, size: 18),
        ),
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
