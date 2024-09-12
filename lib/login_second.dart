// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/forgot_password.dart';
import 'package:des/menu.dart';
import 'package:des/register.dart';
import 'package:des/shared/apple_firebase.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/google_firebase.dart';
import 'package:des/shared/line.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/facebook_firebase.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/widget/input_decoration.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'shared/config.dart';
import 'main.dart';

class LoginSecondPage extends StatefulWidget {
  const LoginSecondPage({
    Key? key,
    required this.username,
    required this.imageUrl,
  }) : super(key: key);

  final String username;
  final String imageUrl;

  @override
  State<LoginSecondPage> createState() => _LoginSecondPageState();
}

class _LoginSecondPageState extends State<LoginSecondPage>
    with SingleTickerProviderStateMixin {
  String _username = '';
  String _imageUrl = '';
  String? _category;
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final Duration duration = const Duration(milliseconds: 200);
  AnimationController? _controller;
  bool passwordVisibility = true;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool openLine = false;
  bool _loadingSubmit = false;
  late TextEditingController _passwordModalController;
  bool _obscureTextPassword = true;
  String _passwordStringValidate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  MyApp.themeNotifier.value == ThemeModeThird.light
                      ? "assets/images/bg_login_page.png"
                      : "assets/images/bg_login_page-dark.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: 490,
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image.asset(
                          //   'assets/images/logo.png',
                          //   height: 35,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'กรอกรหัสผ่าน',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Colors.black
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  'assets/images/close_noti_list.png',
                                  height: 18.52,
                                  width: 18.52,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Colors.black
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          if (_username.isEmpty)
                            TextFormField(
                              controller: txtEmail,
                              decoration: _decorationRegisterMember(
                                context,
                                hintText: 'อีเมล',
                              ),
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.black
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                              cursorColor: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Color(0xFF7A4CB1)
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรอกอีเมล';
                                }
                                return null;
                              },
                            ),

                          if (_username.isNotEmpty) ...[
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        'assets/images/bg_profile_login.png',
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (_imageUrl!.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          imageUrl: _imageUrl!,
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _username,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: MyApp.themeNotifier.value ==
                                                  ThemeModeThird.light
                                              ? Colors.black
                                              : MyApp.themeNotifier.value ==
                                                      ThemeModeThird.dark
                                                  ? Colors.white
                                                  : Color(0xFFFFFD57),
                                        ),
                                      ),
                                      Text(
                                        'สมาชิก',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: MyApp.themeNotifier.value ==
                                                  ThemeModeThird.light
                                              ? Color(0xFF707070)
                                              : MyApp.themeNotifier.value ==
                                                      ThemeModeThird.dark
                                                  ? Colors.white
                                                  : Color(0xFFFFFD57),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: txtPassword,
                              obscureText: passwordVisibility,
                              decoration: _decorationPasswordMember(context,
                                  hintText: 'รหัสผ่าน',
                                  visibility: passwordVisibility,
                                  suffixTap: () {
                                setState(() {
                                  passwordVisibility = !passwordVisibility;
                                });
                              }),
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.black
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                              cursorColor: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Color(0xFF7A4CB1)
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรอกรหัสผ่าน';
                                }
                                return null;
                              },
                            ),
                          ],

                          SizedBox(height: 10),
                          _buildButton(),
                          // SizedBox(height: 30),
                          // _buildOR(),
                          // SizedBox(height: 25),
                          // InkWell(
                          //   onTap: () {
                          //     if (!openLine) {
                          //       openLine = true;
                          //       _callLoginLine();
                          //     }
                          //   },
                          //   child: _buildButtonLogin(
                          //     'assets/images/line_circle.png',
                          //     'เข้าใช้งานผ่าน Line',
                          //     color: MyApp.themeNotifier.value ==
                          //             ThemeModeThird.light
                          //         ? Color(0xFF06C755)
                          //         : Colors.black,
                          //     colorTitle: MyApp.themeNotifier.value ==
                          //             ThemeModeThird.light
                          //         ? Colors.white
                          //         : MyApp.themeNotifier.value ==
                          //                 ThemeModeThird.dark
                          //             ? Colors.white
                          //             : Color(0xFFFFFD57),
                          //     colorBorder: MyApp.themeNotifier.value ==
                          //             ThemeModeThird.light
                          //         ? Color(0xFF06C755)
                          //         : MyApp.themeNotifier.value ==
                          //                 ThemeModeThird.dark
                          //             ? Colors.white
                          //             : Color(0xFFFFFD57),
                          //   ),
                          // ),
                          // SizedBox(height: 10),
                          // InkWell(
                          //   onTap: () => _callLoginFacebook(),
                          //   child: _buildButtonLogin(
                          //     'assets/images/logo_facebook_login_page.png',
                          //     'เข้าใช้งานผ่าน Facebook',
                          //     color: MyApp.themeNotifier.value ==
                          //             ThemeModeThird.light
                          //         ? Color(0xFF227BEF)
                          //         : Colors.black,
                          //     colorTitle: MyApp.themeNotifier.value ==
                          //             ThemeModeThird.light
                          //         ? Colors.white
                          //         : MyApp.themeNotifier.value ==
                          //                 ThemeModeThird.dark
                          //             ? Colors.white
                          //             : Color(0xFFFFFD57),
                          //     colorBorder: MyApp.themeNotifier.value ==
                          //             ThemeModeThird.light
                          //         ? Color(0xFF227BEF)
                          //         : MyApp.themeNotifier.value ==
                          //                 ThemeModeThird.dark
                          //             ? Colors.white
                          //             : Color(0xFFFFFD57),
                          //   ),
                          // ),
                          // SizedBox(height: 10),
                          // InkWell(
                          //   onTap: () => _callLoginGoogle(),
                          //   child: _buildButtonLogin(
                          //     'assets/images/logo_google_login_page.png',
                          //     'เข้าใช้งานผ่าน Google',
                          //     colorTitle: MyApp.themeNotifier.value ==
                          //             ThemeModeThird.light
                          //         ? Colors.black
                          //         : MyApp.themeNotifier.value ==
                          //                 ThemeModeThird.dark
                          //             ? Colors.white
                          //             : Color(0xFFFFFD57),
                          //     colorBorder: MyApp.themeNotifier.value ==
                          //             ThemeModeThird.light
                          //         ? Color(0xFFE4E4E4)
                          //         : MyApp.themeNotifier.value ==
                          //                 ThemeModeThird.dark
                          //             ? Colors.white
                          //             : Color(0xFFFFFD57),
                          //   ),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       'ท่านเป็นผู้ใช้ใหม่',
                          //       style: TextStyle(
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.w400,
                          //         color: MyApp.themeNotifier.value ==
                          //                 ThemeModeThird.light
                          //             ? Colors.black
                          //             : MyApp.themeNotifier.value ==
                          //                     ThemeModeThird.dark
                          //                 ? Colors.white
                          //                 : Color(0xFFFFFD57),
                          //       ),
                          //     ),
                          //     SizedBox(width: 8),
                          //     GestureDetector(
                          //       onTap: () => Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (builder) => RegisterPage(),
                          //         ),
                          //       ),
                          //       child: Text(
                          //         'ต้องการสมัครสมาชิก',
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w400,
                          //           color: MyApp.themeNotifier.value ==
                          //                   ThemeModeThird.light
                          //               ? Color(0xFFB325F8)
                          //               : MyApp.themeNotifier.value ==
                          //                       ThemeModeThird.dark
                          //                   ? Colors.white
                          //                   : Color(0xFFFFFD57),
                          //           decoration: TextDecoration.underline,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                  if (_loading)
                    Positioned.fill(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonLogin(
    String image,
    String title, {
    Color colorBorder = Colors.transparent,
    Color colorTitle = const Color(0xFF000000),
    Color color = Colors.transparent,
  }) {
    return Container(
      height: 45,
      // padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorBorder,
        ),
        borderRadius: BorderRadius.circular(25),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 25,
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colorTitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgotPasswordPage(),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFF7A4CB1).withOpacity(.50)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'ลืมรหัสผ่าน',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).custom.A4CB1_w_fffd57,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Stack(
          children: [
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                final form = _formKey.currentState;
                if (form!.validate()) {
                  form.save();
                  if (await connectInternet()) {
                    _callLogin();
                  }
                  // if (_username.isEmpty) {
                  //   _callUser();
                  // } else {
                  //   _callLoginGuest();
                  // }
                }
                ;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).custom.A4CB1_w_fffd57,
                ),
                child: Text(
                  'ดำเนินการต่อ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).custom.w_b_b,
                  ),
                ),
              ),
            ),
            if (_loadingSubmit)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildOR() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0x4D707070)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'หรือ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF707070)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0x4D707070)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
      ],
    );
  }

  static InputDecoration _decorationRegisterMember(context,
          {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black.withOpacity(0.2)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Color(0xFF707070)
                    : Color(0xFFFFFD57),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  static InputDecoration _decorationPasswordMember(
    context, {
    String labelText = '',
    String hintText = '',
    bool visibility = false,
    Function? suffixTap,
  }) =>
      InputDecoration(
        label: Text(labelText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintText: hintText,
        suffixIcon: GestureDetector(
          onTap: () {
            suffixTap!();
          },
          child: visibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
        suffixIconColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Color(0xFF7A4CB1)
            : MyApp.themeNotifier.value == ThemeModeThird.dark
                ? Colors.white
                : Color(0xFFFFFD57),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black.withOpacity(0.2)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Color(0xFF707070)
                    : Color(0xFFFFFD57),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  // login guest -----

  void _modalPassword(dynamic param, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: txtPassword,
                  obscureText: passwordVisibility,
                  decoration: _decorationPasswordMember(context,
                      hintText: 'รหัสผ่าน',
                      visibility: passwordVisibility, suffixTap: () {
                    setState(() {
                      passwordVisibility = !passwordVisibility;
                    });
                  }),
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFF7A4CB1)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรอกรหัสผ่าน';
                    }
                    return null;
                  },
                ),
                _buildFeildPassword(
                  controller: _passwordModalController,
                  hint: 'รหัสผ่าน',
                  obscureText: _obscureTextPassword,
                  autofillHints: const [AutofillHints.password],
                  validateString: _passwordStringValidate,
                  inputFormatters: InputFormatTemple.password(),
                  suffixTap: () {
                    setState(() {
                      _obscureTextPassword = !_obscureTextPassword;
                    });
                  },
                  validator: (value) {
                    var result = ValidateForm.username(value!);
                    setState(() {
                      _passwordStringValidate = result ?? '';
                    });
                    return result == null ? null : '';
                  },
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        _callLoginSocialNewPassword(param, type);
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _loadingSubmit
                              ? Theme.of(context).primaryColor.withOpacity(0.8)
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x40F3D2FF),
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Text(
                          'ยืนยัน',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (_loadingSubmit)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ));
      },
    );
  }

  Widget _buildFeildPassword({
    required TextEditingController controller,
    String hint = '',
    Function(String?)? validator,
    String validateString = '',
    Iterable<String>? autofillHints,
    bool obscureText = false,
    bool visibility = false,
    List<TextInputFormatter>? inputFormatters,
    Function? suffixTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.only(top: 12),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x40F3D2FF),
                offset: Offset(0, 4),
              )
            ],
          ),
          child: TextFormField(
            obscureText: obscureText,
            controller: controller,
            autofillHints: autofillHints,
            style: const TextStyle(fontSize: 14),
            onEditingComplete: () => FocusScope.of(context).unfocus(),
            decoration: CusInpuDecoration.password(
              context,
              hintText: hint,
              visibility: visibility,
              suffixTap: suffixTap,
            ),
            inputFormatters: inputFormatters,
            validator: (String? value) => validator!(value),
          ),
        ),
        if (validateString.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 3),
            child: Text(
              validateString,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.red,
              ),
            ),
          )
      ],
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _username = widget.username;
    _imageUrl = widget.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  void _callUser() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _category = 'guest';
    });
    if (txtEmail.text.isEmpty && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'กรุณากรอกชื่อผู้ใช้',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(" "),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      _loading = true;
      Response<dynamic> response;
      try {
        response = await Dio().post('$server/dcc-api/m/register/read', data: {
          'username': txtEmail.text.trim(),
          'category': _category.toString(),
        });
      } catch (ex) {
        setState(() {
          _loading = false;
        });
        Fluttertoast.showToast(msg: 'error');
        return null;
      }

      _loading = false;
      if (response.data['status'] == 'S') {
        List<dynamic> result = response.data['objectData'];
        if (result.length > 0) {
          setState(() {
            _username = txtEmail.text.trim();
            _imageUrl = response.data['objectData'][0]['imageUrl'] ?? '';
          });
          txtEmail.clear();
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Text(
                'ชื่อผู้ใช้งาน ไม่พบในระบบ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF000070),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    new TextEditingController().clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      } else {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    }
  }

  void _callLoginGuest() async {
    // _loading = true;
    var response = await Dio().post(
      '$server/dcc-api/m/register/login',
      data: {
        'username': _username,
        'password': txtPassword.text.toString(),
      },
    );
    _loading = false;
    if (response.data['status'] == 'S') {
      FocusScope.of(context).unfocus();

      await ManageStorage.createProfile(
        value: response.data['objectData'],
        key: 'guest',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'รหัสผ่านไม่ถูกต้อง \nกรุณากรอกรหัสใหม่',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(" "),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                new TextEditingController().clear();
                Navigator.of(context).pop();

                setState(() {
                  _loading = false;
                });
              },
            ),
          ],
        ),
      );
    }
  }

  void _callLoginFacebook() async {
    var obj = await signInWithFacebook();
    if (obj != null) {
      var model = {
        "username": obj.user.email,
        "email": obj.user.email,
        "imageUrl":
            obj.user.photoURL != null ? obj.user.photoURL + "?width=9999" : '',
        "firstName": obj.user.displayName,
        "lastName": '',
        "facebookID": obj.user.uid
      };

      Dio dio = new Dio();
      try {
        var response = await dio.post(
          '$server/dcc-api/m/v2/register/facebook/login',
          data: model,
        );

        await ManageStorage.createSecureStorage(
          key: 'imageUrlSocial',
          value: obj.user.photoURL != null
              ? obj.user.photoURL + "?width=9999"
              : '',
        );

        await ManageStorage.createProfile(
          value: response.data['objectData'],
          key: 'facebook',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  void _callLoginGoogle() async {
    var obj = await signInWithGoogle();

    print('---signInWithGoogle---' + obj.toString());

    if (obj != null) {
      var model = {
        "username": obj.user!.email,
        "email": obj.user!.email,
        "imageUrl": obj.user!.photoURL ?? '',
        "firstName": obj.user!.displayName,
        "lastName": '',
        "googleID": obj.user!.uid
      };

      Dio dio = new Dio();
      try {
        var response = await dio.post(
          '$server/dcc-api/m/v2/register/google/login',
          data: model,
        );

        await ManageStorage.createSecureStorage(
          key: 'imageUrlSocial',
          value: obj.user!.photoURL != null ? obj.user!.photoURL : '',
        );

        ManageStorage.createProfile(
          value: response.data['objectData'],
          key: 'google',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  void _callLoginLine() async {
    var obj = await loginLine();
    openLine = false;

    if (obj != null) {
      final idToken = obj.accessToken.idToken;
      final userEmail = (idToken != null)
          ? idToken['email'] != null
              ? idToken['email']
              : ''
          : '';
      var model = {
        "username": (userEmail != '' && userEmail != null)
            ? userEmail
            : obj.userProfile!.userId,
        "email": userEmail,
        "imageUrl": (obj.userProfile!.pictureUrl != '' &&
                obj.userProfile!.pictureUrl != null)
            ? obj.userProfile!.pictureUrl
            : '',
        "firstName": obj.userProfile!.displayName,
        "lastName": '',
        "lineID": obj.userProfile!.userId
      };

      Dio dio = new Dio();
      try {
        var response = await dio.post(
          '$server/dcc-api/m/v2/register/line/login',
          data: model,
        );

        await ManageStorage.createSecureStorage(
          key: 'imageUrlSocial',
          value: model['imageUrl'],
        );

        await ManageStorage.createProfile(
          value: response.data['objectData'],
          key: 'line',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  void _callLogin() async {
    try {
      setState(() => _loadingSubmit = true);

      // logWTF('token');
      String accessToken = await _getTokenKeycloak(
        username: _username,
        password: txtPassword.text,
      );

      if (accessToken == 'invalid_grant' || accessToken == '') {
        Fluttertoast.showToast(
            msg: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง', gravity: ToastGravity.CENTER);
        setState(() => _loadingSubmit = false);
        return;
        // กรอกรหัสผ่าน
      }

      // logWTF('key cloak');
      dynamic responseKeyCloak = await _getUserInfoKeycloak(accessToken);
      // logWTF('responseKeyCloak');
      // logWTF(responseKeyCloak);

      if (responseKeyCloak == null) {
        return;
      }

      dynamic responseProfileMe = await _getProfileMe(accessToken);
      // logWTF('responseProfileMe');
      // logWTF(responseProfileMe);
      if (responseProfileMe == null) {
        return;
      }

      // check isStaff
      // if (responseProfileMe['data']['isMember'] == 0) {
      //   Fluttertoast.showToast(msg: 'บัญชีนี้ไม่ได้เป็นสมาชิก');
      //   setState(() => _loadingSubmit = false);
      //   return;
      // }

      dynamic responseUser = await _getUserProfile();
      // logWTF('responseUser');
      // logWTF(responseUser);

      if (responseUser?['message'] == 'code_not_found') {
        // logWTF('create');
        var create = await _createUserProfile(responseProfileMe['data']);
        if (create == null) {
          return;
        }
        responseUser = await _getUserProfile();
      }

      if (responseUser == null) {
        Fluttertoast.showToast(msg: responseUser['message']);
        return;
      }
      if (responseUser?['status'] == "F") {
        Fluttertoast.showToast(msg: responseUser['message']);
        return;
      }

      await ManageStorage.createSecureStorage(
        value: accessToken,
        key: 'accessToken',
      );
      await ManageStorage.createSecureStorage(
        value: json.encode(responseKeyCloak),
        key: 'loginData',
      );
      await ManageStorage.createSecureStorage(
        value: json.encode(responseProfileMe?['data']),
        key: 'profileMe',
      );

      // logWTF(responseUser);
      await ManageStorage.createProfile(
        value: responseUser['objectData'][0],
        key: 'guest',
      );

      setState(() => _loadingSubmit = false);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Menu(),
        ),
      );
    } catch (e) {
      setState(() => _loadingSubmit = false);
      // logE(e);
      Fluttertoast.showToast(msg: e.toString());
      // Fluttertoast.showToast(
      //     msg: 'รหัสผ่านหรืออีเมลไม่ถูกต้อง', gravity: ToastGravity.CENTER);
    }
  }

  _getTokenKeycloak({String username = '', String password = ''}) async {
    try {
      // get token
      Response response = await Dio().post(
        '$ssoURL/realms/$keycloakReaml/protocol/openid-connect/token',
        data: {
          'username': username,
          'password': password.toString(),
          'client_id': clientID,
          'client_secret': clientSecret,
          'grant_type': 'password',
        },
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        return response.data['access_token'];
      } else {
        // logE(response.data);
        // Fluttertoast.showToast(msg: response.data['error_description']);
        // Fluttertoast.showToast(
        //     msg: 'รหัสผ่านหรืออีเมลไม่ถูกต้อง..', gravity: ToastGravity.CENTER);
        setState(() => _loadingSubmit = false);
        return '';
      }
    } on DioError catch (e) {
      logE(e.error);
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data.toString();
      }
      // Fluttertoast.showToast(msg: err);
      Fluttertoast.showToast(msg: 'การเชื่อมต่อเซิฟเวอร์ขัดข้อง');
    }
  }

  dynamic _getUserInfoKeycloak(String token) async {
    try {
      // get info
      if (token.isEmpty) return null;
      Response response = await Dio().get(
        '$ssoURL/realms/dcc-portal/protocol/openid-connect/userinfo',
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
        return response.data;
      } else {
        logE(response.data);
        Fluttertoast.showToast(msg: response.data['error_description']);
        setState(() => _loadingSubmit = false);
        return null;
      }
    } on DioError catch (e) {
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data.toString();
      }
      Fluttertoast.showToast(msg: err);
      return null;
    }
  }

  dynamic _getProfileMe(String token) async {
    try {
      // get info
      if (token.isEmpty) return null;
      Response response = await Dio().get(
        '$ondeURL/api/user/ProfileMe',
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
        return response.data;
      } else {
        logE(response.data);
        Fluttertoast.showToast(msg: response.data['title']);
        setState(() => _loadingSubmit = false);
        return null;
      }
    } on DioError catch (e) {
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data['title'].toString();
      }
      Fluttertoast.showToast(msg: err);
      return null;
    }
  }

  _getUserProfile() async {
    Response response =
        await Dio().post('$server/dcc-api/m/register/read', data: {
      'username': _username,
    });

    if (response.statusCode == 200) {
      // logWTF('register read');
      // logWTF(response.data);
      return response.data;
    } else {
      // logE('error _getUserProfile');
      // logE(response.data);
      Fluttertoast.showToast(msg: response.data['error_description']);
      return null;
    }
  }

  _createUserProfile(param) async {
    logD(param);
    try {
      logWTF('create');
      var data = {
        'username': widget.username,
        // 'password': txtPassword.text,
        'idcard': param['idcard'] ?? "",
        'category': 'guest',
        'email': _username,
        // 'phone': param?['phonenumber'] ?? '',
        // 'gender': param?['gender'] ?? '',
        // 'uuid': param['uuid'],
        // 'firstName': param['firstnameTh'],
        // 'lastName': param['lastnameTh'],
        // 'age': param['ageRange'],
        // 'career': param?['jobName'] ?? '',
        // 'favorites': param?['lmsCat'] ?? '',
        // 'centerCode': param['centerId'].toString(),
        'status': 'N',
        'hasThaiD': false,
      };
      logE(data);
      Response response = await Dio()
          .post('$server/dcc-api/m/register/link/account/create', data: data);

      if (response.statusCode == 200) {
        return response.data['objectData'];
      } else {
        Fluttertoast.showToast(msg: response.data['error_description']);
        return null;
      }
    } on DioError catch (e) {
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data['title'].toString();
      }
      logE(err);
      Fluttertoast.showToast(msg: err);
      return null;
    }
  }

  void _callLoginApple() async {
    var obj = await signInWithApple();

    var model = {
      "username": obj.user!.email ?? obj.user!.uid,
      "email": obj.user!.email ?? '',
      "imageUrl": '',
      "firstName": obj.user!.email,
      "lastName": '',
      "appleID": obj.user!.uid
    };
    _callLoginSocial(model, 'apple');
  }

  void _callLoginSocial(dynamic param, String type) async {
    setState(() => _loadingSubmit = true);
    logWTF('_callLoginSocial');
    try {
      if (param != null) {
        Dio dio = Dio();
        var check = await dio.post(
          '$server/dcc-api/m/register/check/login/social',
          data: {'username': param['username']},
        );
        logWTF(check.data);
        if (check.data) {
          Response response = await dio.post(
            '$server/dcc-api/m/v2/register/social/login',
            data: param,
          );
          // logWTF(response.data);
          if (response.data['status'] != 'S') {
            setState(() => _loadingSubmit = false);
            return null;
          }

          // logWTF('token');
          String accessToken = await _getTokenKeycloak(
            username: response.data['objectData']['email'],
            password: response.data['objectData']['password'],
          );
          // logWTF(accessToken);

          if (accessToken == 'invalid_grant') {
            logWTF('password fail');
            Fluttertoast.showToast(msg: 'รหัสผ่านไม่ถูกต้อง');
            setState(() => _loadingSubmit = false);
            _modalPassword(param, type);
            return;
            // กรอกรหัสผ่าน
          }
          // logWTF(response);
          logWTF('responseKeyCloak');
          dynamic responseKeyCloak = await _getUserInfoKeycloak(accessToken);
          logWTF('responseProfileMe');
          dynamic responseProfileMe = await _getProfileMe(accessToken);
          logWTF('responseStaffProfileData');
          if (responseKeyCloak == null || responseProfileMe == null) {
            setState(() => _loadingSubmit = false);
            // Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
            return;
          }

          // check isStaff
          if (responseProfileMe['data']['isMember'] == 0) {
            Fluttertoast.showToast(msg: 'บัญชีนี้ไม่ได้เป็นเจ้าหน้าที่');
            return;
          }

          await ManageStorage.createSecureStorage(
            value: accessToken,
            key: 'accessToken',
          );
          await ManageStorage.createSecureStorage(
            value: json.encode(responseKeyCloak),
            key: 'loginData',
          );
          await ManageStorage.createSecureStorage(
            value: json.encode(responseProfileMe['data']),
            key: 'profileMe',
          );
          await ManageStorage.createProfile(
            value: response.data['objectData'],
            key: 'guest',
          );

          setState(() => _loadingSubmit = false);
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Menu(),
            ),
          );
        } else {
          setState(() => _loadingSubmit = false);
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegisterPage(model: param, category: type),
            ),
          );
        }
      } else {
        logE('login social else');
        setState(() => _loadingSubmit = false);
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      logE('login social catch');
      logE(e);
      setState(() => _loadingSubmit = false);
      Fluttertoast.showToast(msg: 'ยกเลิก');
    }
  }

  void _callLoginSocialNewPassword(dynamic param, String type) async {
    setState(() => _loadingSubmit = true);
    try {
      if (param != null) {
        Dio dio = Dio();

        try {
          await Dio().post(
            '$server/dcc-api/m/register/reset/passwordbyusername',
            data: {
              'username': param['username'],
              'password': _passwordModalController.text,
            },
          );
        } catch (e) {
          Fluttertoast.showToast(msg: 'ลองใหม่อีกครั้ง');
          setState(() => _loadingSubmit = false);
          return;
        }
        _callLoginSocial(param, type);
      } else {
        setState(() => _loadingSubmit = false);
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      setState(() => _loadingSubmit = false);
      Fluttertoast.showToast(msg: 'ยกเลิก');
    }
  }
}
