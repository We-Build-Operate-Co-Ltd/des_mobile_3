// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:des/forgot_password.dart';
import 'package:des/menu.dart';
import 'package:des/register.dart';
import 'package:des/register_link_account.dart';
import 'package:des/register_thaid.dart';
import 'package:des/shared/apple_firebase.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/line.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/widget/input_decoration.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as fb;
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:twitter_login/twitter_login.dart';
import 'package:url_launcher/url_launcher.dart';

import 'shared/config.dart';
import 'main.dart';
import 'dart:ui' as ui show ImageFilter;

import 'shared/google_firebase.dart';

class LoginFirstPage extends StatefulWidget {
  const LoginFirstPage({Key? key}) : super(key: key);

  @override
  State<LoginFirstPage> createState() => _LoginFirstPageState();
}

class _LoginFirstPageState extends State<LoginFirstPage> {
  String? _username = '';
  String? _imageUrl = '';
  String? _category;
  late TextEditingController txtEmail;
  late TextEditingController txtPassword;
  final Duration duration = const Duration(milliseconds: 200);
  // AnimationController? _controller;
  bool passwordVisibility = true;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool openLine = false;
  DateTime? currentBackPressTime;
  final storage = const FlutterSecureStorage();
  String? fontStorageValue;
  List<dynamic> _listSwitchColors = [
    {'code': '1', 'title': 'ปกติ', 'isSelected': true},
    {'code': '2', 'title': 'ขาวดำ', 'isSelected': false},
    {'code': '3', 'title': 'ดำเหลือง', 'isSelected': false},
  ];
  bool _loadingSubmit = false;

  late TextEditingController _passwordModalController;
  bool _obscureTextPassword = true;
  String _passwordStringValidate = '';
  dynamic configLoginSocial = 0;
  String _thiaDCode = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        _thiaDCode = prefs.getString('thaiDCode') ?? '';
        if (_thiaDCode.isNotEmpty) {
          _loadingSubmit = true;
          _getToken();
        }
      });
    });
    txtEmail = TextEditingController(text: '');
    txtPassword = TextEditingController(text: '');
    ;

    // _controller = AnimationController(
    //   vsync: this,
    //   duration: duration,
    // );
    _callReadConfig();
    super.initState();
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

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
        child: WillPopScope(
          onWillPop: () => confirmExit(),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                // height: 300,
                // alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/BG.png"),
                    fit: BoxFit.cover,
                    colorFilter: MyApp.themeNotifier.value ==
                            ThemeModeThird.light
                        ? null
                        : ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  ),
                ),
              ),
              // Logo
              Container(
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Image(
                          height: MediaQuery.of(context).size.height * 0.35,
                          image: AssetImage(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? "assets/images/Owl-8 2.png"
                                : "assets/images/2024/Owl-8 2__Blackwhite.png",
                          ),
                          // fit: BoxFit.contain,
                        ))
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: MediaQuery.of(context).size.height * 0.650,
                    // height: (deviceHeight >= 500 && deviceHeight < 800)
                    //     ? 300
                    //     : (deviceHeight >= 800)
                    //         ? 500
                    //         : deviceHeight * 0.2,
                    padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                    decoration: BoxDecoration(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: ClampingScrollPhysics(),
                        children: [
                          // Image.asset(
                          //   'assets/images/logo.png',
                          //   height: 35,
                          //   alignment: Alignment.centerLeft,
                          // ),
                          Container(
                            height: 60,
                            // margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    'เข้าสู่ระบบ',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 28,
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                      color: MyApp.themeNotifier.value ==
                                              ThemeModeThird.light
                                          ? Color(0xFFBD4BF7)
                                          : MyApp.themeNotifier.value ==
                                                  ThemeModeThird.dark
                                              ? Colors.white
                                              : Color(0xFFFFFD57),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Positioned(
                                  height: 35,
                                  width: 35,
                                  right: 0,
                                  top: 0,
                                  // bottom: 0,
                                  // left: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      buildModalSwitch(context);
                                    },
                                    child: Container(
                                      // height: 35,
                                      // width: 35,
                                      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 1,
                                            style: BorderStyle.solid,
                                            color:
                                                Theme.of(context).custom.b_w_y,
                                          )),
                                      child: Icon(
                                        Icons.visibility_outlined,
                                        color: Theme.of(context).custom.w_w_y,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: txtEmail,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9a-zA-Z@!#$%?*~^<>._.-]'))
                            ],
                            decoration: _decorationRegisterMember(
                              context,
                              hintText: 'อีเมล ',
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
                                ? Color(0xFFB325F8)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                            validator: (model) {
                              String pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              if (model!.isEmpty) {
                                return 'กรุณากรอกอีเมล.';
                              } else if (!regex.hasMatch(model)) {
                                return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 10),
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
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                if (await connectInternet()) {
                                  _callLogin();
                                }
                              }
                            },
                            child: _buildButtonLogin(
                              '',
                              'เข้าสู่ระบบ',
                              color: Theme.of(context).custom.A4CB1_w_fffd57,
                              colorTitle: Theme.of(context).custom.w_b_b,
                              colorBorder:
                                  Theme.of(context).custom.A4CB1_w_fffd57,
                            ),
                          ),

                          SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage(),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                child: Text(
                                  'ลืมรหัสผ่าน',
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
                                    decoration: TextDecoration.underline,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ),

                          if (configLoginSocial.toString() == "1") _buildOR(),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (configLoginSocial.toString() == "1")
                                SizedBox(height: 10),
                              if (configLoginSocial.toString() == "1")
                                InkWell(
                                  onTap: () => _callLoginGoogle(),
                                  child: _buildButtonLoginSocial(
                                    'assets/images/logo_google_login_page.png',
                                    colorBorder: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFFE4E4E4)
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57),
                                  ),
                                ),
                              if (configLoginSocial.toString() == "1")
                                SizedBox(height: 10),
                              if (configLoginSocial.toString() == "1")
                                InkWell(
                                  onTap: () => _callLoginFacebook(),
                                  child: _buildButtonLoginSocial(
                                    'assets/images/Icon awesome-facebook-f.png',
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFF227BEF)
                                        : Colors.black,
                                    colorBorder: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFF227BEF)
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57),
                                  ),
                                ),
                              if (configLoginSocial.toString() == "1")
                                SizedBox(height: 25),
                              if (configLoginSocial.toString() == "1")
                                InkWell(
                                  onTap: () {
                                    if (!openLine) {
                                      openLine = true;
                                      _callLoginLine();
                                    }
                                  },
                                  child: _buildButtonLoginSocial(
                                    'assets/images/line_circle.png',
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFF06C755)
                                        : Colors.black,
                                    colorBorder: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFF06C755)
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57),
                                  ),
                                ),
                              // if (configLoginSocial.toString() == "1")
                              //   SizedBox(height: 10),
                              // if (configLoginSocial.toString() == "1")
                              //   InkWell(
                              //     onTap: () => _callLoginX(),
                              //     child: _buildButtonLoginSocial(
                              //       'assets/images/X.png',
                              //       color: MyApp.themeNotifier.value ==
                              //               ThemeModeThird.light
                              //           ? Color(0xFF292929)
                              //           : Colors.black,
                              //       colorBorder: MyApp.themeNotifier.value ==
                              //               ThemeModeThird.light
                              //           ? Color(0xFF292929)
                              //           : MyApp.themeNotifier.value ==
                              //                   ThemeModeThird.dark
                              //               ? Colors.white
                              //               : Color(0xFFFFFD57),
                              //     ),
                              //   ),
                              if (configLoginSocial.toString() == "1")
                                SizedBox(height: 10),
                              if (configLoginSocial.toString() == "1")
                                InkWell(
                                  onTap: () {
                                    _callThaiID();
                                  },
                                  child: _buildButtonLoginSocial(
                                    'assets/images/Rectangle 7803.png',
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFF030650)
                                        : Colors.black,
                                    colorBorder: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFF030650)
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57),
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(height: 35),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'ท่านเป็นผู้ใช้ใหม่',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Colors.black
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => RegisterPage(),
                                    ),
                                  ),
                                  child: Text(
                                    'ต้องการสมัครสมาชิก',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: MyApp.themeNotifier.value ==
                                              ThemeModeThird.light
                                          ? Color(0xFFB325F8)
                                          : MyApp.themeNotifier.value ==
                                                  ThemeModeThird.dark
                                              ? Colors.white
                                              : Color(0xFFFFFD57),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                version,
                                style: TextStyle(
                                  fontSize: 12,
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
                            ],
                          ),
                        ],
                      ),
                    ),
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
                    child: CircularProgressIndicator(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFB325F8)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  buildModalSwitch(
    BuildContext context,
  ) {
    return showCupertinoModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : Color(0xFF121212),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: ListView(
                    children: [
                      Text(
                        'ขนาดตัวหนังสือ',
                        style: TextStyle(
                          fontSize: 20,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.black
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      contentCard(context, "ปกติ", "1", "size"),
                      SizedBox(height: 10),
                      contentCard(context, "ปานกลาง", "2", "size"),
                      SizedBox(height: 10),
                      contentCard(context, "ใหญ่", "3", "size"),
                      SizedBox(height: 20),
                      Text(
                        'ความตัดกันของสี',
                        style: TextStyle(
                          fontSize: 20,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.black
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      contentCardV2(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  contentCard(BuildContext context, String title, String size, String type) {
    var a = storage.read(key: 'switchSizeFont');
    a.then((value) async => {
          setState(() {
            fontStorageValue = value;
          })
        });
    return InkWell(
      onTap: () {
        setState(
          (() {
            storage.write(
              key: 'switchSizeFont',
              value: title,
            );
            if (title == "ปกติ") {
              // MyApp.themeNotifier.value = ThemeModeThird.light;
              MyApp.fontKanit.value = FontKanit.small;
            } else if (title == "ปานกลาง") {
              MyApp.fontKanit.value = FontKanit.medium;
            } else {
              MyApp.fontKanit.value = FontKanit.large;
            }
            var a = storage.read(key: 'switchSizeFont');
            a.then((value) => {
                  setState(() {
                    fontStorageValue = value;
                  })
                });
          }),
        );
        Navigator.pop(context);
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          height: 45,
          // width: 145,
          decoration: BoxDecoration(
            // border: Border.all(
            //   width: 1,
            //   style: BorderStyle.solid,
            //   color: MyApp.themeNotifier.value == ThemeModeThird.light
            //       ? (title == fontStorageValue ? Colors.white : Colors.black)
            //       : MyApp.themeNotifier.value == ThemeModeThird.dark
            //           ? (title == fontStorageValue
            //               ? Colors.black
            //               : Colors.white)
            //           : (title == fontStorageValue
            //               ? Colors.black
            //               : Color(0xFFFFFD57)),
            // ),
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? (title == fontStorageValue ? Color(0xFF7A4CB1) : Colors.white)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? (title == fontStorageValue
                        ? Colors.white
                        : Color(0xFF121212))
                    : (title == fontStorageValue
                        ? Color(0xFFFFFD57)
                        : Color(0xFF121212)),
            borderRadius: BorderRadius.circular(73),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  type == "color"
                      ? Image.asset(
                          title == "ปกติ"
                              ? 'assets/images/icon_rp.png'
                              : title == "ขาวดำ"
                                  ? 'assets/images/icon_wb.png'
                                  : "assets/images/icon_yb.png",
                          height: 35,
                          // width: 35,
                        )
                      : Container(),
                  SizedBox(width: 5),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? (title == fontStorageValue
                              ? Colors.white
                              : Colors.black)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? (title == fontStorageValue
                                  ? Colors.black
                                  : Colors.white)
                              : (title == fontStorageValue
                                  ? Colors.black
                                  : Color(0xFFFFFD57)),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                height: 25,
                width: 25,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? (title == fontStorageValue
                            ? Colors.white
                            : Color(0xFFDDDDDD))
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? (title == fontStorageValue
                                ? Colors.black
                                : Colors.white)
                            : (title == fontStorageValue
                                ? Colors.black
                                : Color(0xFFFFFD57)),
                  ),
                  shape: BoxShape.circle,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? (title == fontStorageValue
                          ? Colors.white
                          : Color(0xFFDDDDDD))
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? (title == fontStorageValue
                              ? Colors.black
                              : Color(0xFF1E1E1E))
                          : (title == fontStorageValue
                              ? Colors.black
                              : Colors.black),
                ),
                child: Container(
                  // height: 15,
                  // width: 15,
                  // padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? (title == fontStorageValue
                            ? Color(0xFF7A4CB1)
                            : Color(0xFFDDDDDD))
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? (title == fontStorageValue
                                ? Colors.white
                                : Color(0xFF1E1E1E))
                            : (title == fontStorageValue
                                ? Color(0xFFFFFD57)
                                : Colors.black),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 12,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? (title == fontStorageValue
                            ? Colors.white
                            : Color(0xFFDDDDDD))
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? (title == fontStorageValue
                                ? Colors.black
                                : Color(0xFF1E1E1E))
                            : (title == fontStorageValue
                                ? Colors.black
                                : Colors.black),
                  ),
                ),
                //   child:
                //   Image.asset(
                //   item['isSelected'] == true
                //       ? 'assets/images/icon_check.png'
                //       : "assets/images/icon_nocheck.png",

                // )
              ),
            ],
          )),
    );
  }

  contentCardV2(BuildContext context) {
    return Container(
      child: Wrap(
          children: _listSwitchColors
              .map(
                (item) => GestureDetector(
                  onTap: () {
                    setState(
                      (() async {
                        await storage.write(
                          key: 'switchColor',
                          value: item['title'],
                        );
                        setState(
                          () {
                            if (item['title'] == "ปกติ") {
                              MyApp.themeNotifier.value = ThemeModeThird.light;
                            } else if (item['title'] == "ขาวดำ") {
                              MyApp.themeNotifier.value = ThemeModeThird.dark;
                            } else {
                              MyApp.themeNotifier.value =
                                  ThemeModeThird.blindness;
                            }
                            for (int i = 0; i < _listSwitchColors.length; i++) {
                              if (_listSwitchColors[i]['code'] ==
                                  item['code']) {
                                item['isSelected'] = !item['isSelected'];
                              } else {
                                _listSwitchColors[i]['isSelected'] = false;
                              }
                            }
                          },
                        );
                      }),
                    );
                    // _callRead();
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      height: 45,
                      // width: 145,
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? (item['isSelected'] == true
                                ? Color(0xFF7A4CB1)
                                : Colors.white)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? (item['isSelected'] == true
                                    ? Colors.white
                                    : Color(0xFF121212))
                                : (item['isSelected'] == true
                                    ? Color(0xFFFFFD57)
                                    : Color(0xFF121212)),
                        // item['isSelected'] == true
                        //     ? Color(0xFF7A4CB1)
                        //     : Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(73),
                        // border: Border.all(
                        //   width: 1,
                        //   style: BorderStyle.solid,
                        //   color: MyApp.themeNotifier.value ==
                        //           ThemeModeThird.light
                        //       ? (item['isSelected'] == true
                        //           ? Color(0xFF7A4CB1)
                        //           : Colors.white)
                        //       : MyApp.themeNotifier.value ==
                        //               ThemeModeThird.dark
                        //           ? (item['isSelected'] == true
                        //               ? Colors.white
                        //               : Color(0xFF292929))
                        //           : (item['isSelected'] == true
                        //               ? Color(0xFFFFFD57)
                        //               : Color(0xFF292929)),
                        // )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                item['code'] == '1'
                                    ? 'assets/images/icon_rp.png'
                                    : item['code'] == '2'
                                        ? 'assets/images/icon_wb.png'
                                        : "assets/images/icon_yb.png",
                                height: 35,
                                // width: 35,
                              ),
                              SizedBox(width: 5),
                              Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 17,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? (item['isSelected'] == true
                                          ? Colors.white
                                          : Colors.black)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? (item['isSelected'] == true
                                              ? Colors.black
                                              : Colors.white)
                                          : (item['isSelected'] == true
                                              ? Colors.black
                                              : Color(0xFFFFFD57)),
                                  // color: item['isSelected'] == true
                                  //     ? Color(0xFFFFFFFF)
                                  //     : Color(0xFF000000),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? (item['isSelected'] == true
                                        ? Colors.white
                                        : Color(0xFFDDDDDD))
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? (item['isSelected'] == true
                                            ? Colors.black
                                            : Colors.white)
                                        : (item['isSelected'] == true
                                            ? Colors.black
                                            : Color(0xFFFFFD57)),
                              ),
                              shape: BoxShape.circle,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? (item['isSelected'] == true
                                      ? Colors.white
                                      : Color(0xFFDDDDDD))
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? (item['isSelected'] == true
                                          ? Colors.black
                                          : Color(0xFF1E1E1E))
                                      : (item['isSelected'] == true
                                          ? Colors.black
                                          : Colors.black),
                            ),
                            child: Container(
                              // height: 15,
                              // width: 15,
                              // padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? (item['isSelected'] == true
                                        ? Color(0xFF7A4CB1)
                                        : Color(0xFFDDDDDD))
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? (item['isSelected'] == true
                                            ? Colors.white
                                            : Color(0xFF1E1E1E))
                                        : (item['isSelected'] == true
                                            ? Color(0xFFFFFD57)
                                            : Colors.black),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 12,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? (item['isSelected'] == true
                                        ? Colors.white
                                        : Color(0xFFDDDDDD))
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? (item['isSelected'] == true
                                            ? Colors.black
                                            : Color(0xFF1E1E1E))
                                        : (item['isSelected'] == true
                                            ? Colors.black
                                            : Colors.black),
                              ),
                            ),
                            //   child:
                            //   Image.asset(
                            //   item['isSelected'] == true
                            //       ? 'assets/images/icon_check.png'
                            //       : "assets/images/icon_nocheck.png",

                            // )
                          ),
                        ],
                      )),
                ),
              )
              .toList()),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'กดอีกครั้งเพื่อออก');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildButtonLogin(String image, String title,
      {Color colorBorder = Colors.transparent,
      Color colorTitle = const Color(0xFF000000),
      Color color = Colors.transparent,
      double fontSize = 13}) {
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
          if (image.isNotEmpty)
            Image.asset(
              image,
              height: 25,
            ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: colorTitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonLoginSocial(String image,
      {Color colorBorder = Colors.transparent,
      Color color = Colors.transparent}) {
    return Container(
      height: 50,
      width: 50,
      // padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorBorder,
        ),
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image.isNotEmpty)
            Image.asset(
              image,
              height: 25,
            ),
        ],
      ),
    );
  }

  Widget _buildOR() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFD4D4D4)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'หรือเข้าสู่ระบบด้วย',
            style: TextStyle(
              fontSize: 15,
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
            height: 2,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFD4D4D4)
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
              ? Colors.black
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.black
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
                ? Color(0xFFB325F8)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFDDDDDD)
                // Colors.black.withOpacity(0.2)
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
  // void _callUser() async {
  //   FocusScope.of(context).unfocus();
  //   setState(() {
  //     _category = 'guest';
  //     _username = txtEmail.text.trim();
  //   });
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) =>
  //           LoginSecondPage(username: _username!, imageUrl: _imageUrl!),
  //     ),
  //   );
  //   return;
  //   if (txtEmail.text.isEmpty && _category == 'guest') {
  //     return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) => new CupertinoAlertDialog(
  //         title: new Text(
  //           'กรุณากรอกชื่อผู้ใช้',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontFamily: 'Kanit',
  //             color: Colors.black,
  //             fontWeight: FontWeight.normal,
  //           ),
  //         ),
  //         content: Text(" "),
  //         actions: [
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: new Text(
  //               "ตกลง",
  //               style: TextStyle(
  //                 fontSize: 13,
  //                 fontFamily: 'Kanit',
  //                 color: Color(0xFF000070),
  //                 fontWeight: FontWeight.normal,
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     _loading = true;
  //     Response<dynamic> response;
  //     try {
  //       print('------');
  //       response = await Dio().post('$server/dcc-api/m/register/read', data: {
  //         'username': txtEmail.text.trim(),
  //         'category': _category.toString(),
  //       });
  //     } catch (ex) {
  //       setState(() {
  //         _loading = false;
  //       });
  //       Fluttertoast.showToast(msg: 'error');
  //       return null;
  //     }
  //     setState(() {
  //       _loading = false;
  //     });
  //     print(response.data.toString());
  //     if (response.data['status'] == 'S') {
  //       List<dynamic> result = response.data['objectData'];
  //       if (result.length > 0) {
  //         setState(() {
  //           _username = txtEmail.text.trim();
  //           // _imageUrl = response.data['objectData'][0]['imageUrl'] ?? '';
  //         });
  //         txtEmail.clear();
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) =>
  //                 LoginSecondPage(username: _username!, imageUrl: _imageUrl!),
  //           ),
  //         );
  //       } else {
  //         showDialog(
  //           barrierDismissible: false,
  //           context: context,
  //           builder: (BuildContext context) => new CupertinoAlertDialog(
  //             title: new Text(
  //               'ชื่อผู้ใช้งาน ไม่พบในระบบ',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontFamily: 'Kanit',
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.normal,
  //               ),
  //             ),
  //             content: Text(" "),
  //             actions: [
  //               CupertinoDialogAction(
  //                 isDefaultAction: true,
  //                 child: new Text(
  //                   "ตกลง",
  //                   style: TextStyle(
  //                     fontSize: 13,
  //                     fontFamily: 'Kanit',
  //                     color: Color(0xFF000070),
  //                     fontWeight: FontWeight.normal,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   FocusScope.of(context).unfocus();
  //                   new TextEditingController().clear();
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     } else {
  //       Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
  //     }
  //   }
  // }

  void _callLogin() async {
    try {
      setState(() => _loadingSubmit = true);

      // logWTF('token');
      String accessToken = await _getTokenKeycloak(
        username: txtEmail.text.trim(),
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
      logE(responseProfileMe);
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

      await ManageStorage.createSecureStorage(
        value: txtPassword.text,
        key: 'password',
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

  _createUserProfile(param) async {
    logD(param);
    try {
      logWTF('create');
      var data = {
        'username': txtEmail.text.trim(),
        'password': txtPassword.text,
        'idcard': param['idcard'] ?? "",
        'category': 'guest',
        'email': txtEmail.text.trim(),
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

  _callThaiID() async {
    try {
      String responseType = 'code';
      String clientId = 'TVE4MVpwQWNrc0NxSzNLWXFQYjVmdGFTdFgxNVN3bU4';
      String client_secret =
          'cjhOVEpmdk03NUZydFlCU3B0bHhwb2t3SkhSbFZnWjJOQm9lMkx3Mg';
      // String redirectUri = 'https://decms.dcc.onde.go.th/auth';
      String redirectUri = 'https://dlapp.we-builds.com/dcc-thaid';
      String base = 'https://imauth.bora.dopa.go.th/api/v2/oauth2/auth/';
      // Random string for state, '1' for login.
      String state = '1${getRandomString()}';
      // String state = 'mobile';
      String scope =
          'pid given_name family_name address birthdate gender openid';
      String parameter =
          '?response_type=$responseType&client_id=$clientId&redirect_uri=$redirectUri&scope=$scope&state=$state';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('thaiDState', state);
      await prefs.setString(
          'thaiDAction', 'login'); // Set state to 'login' instead of 'create'
      await launchUrl(
        Uri.parse('$base$parameter'),
        mode: LaunchMode.externalApplication,
      );
      // _callLogin();
    } catch (ex) {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');

      String clientId = 'TVE4MVpwQWNrc0NxSzNLWXFQYjVmdGFTdFgxNVN3bU4';
      String clientSecret =
          'cjhOVEpmdk03NUZydFlCU3B0bHhwb2t3SkhSbFZnWjJOQm9lMkx3Mg';
      String credentials = "$clientId:$clientSecret";
      String encoded = base64Url.encode(utf8.encode(credentials));

      Dio dio = Dio();

      var formData = FormData.fromMap({
        "grant_type": "authorization_code",
        // "redirect_uri": "https://decms.dcc.onde.go.th/auth",
        "redirect_uri": 'https://dlapp.we-builds.com/dcc-thaid',
        "code": _thiaDCode
      });

      var res = await dio.post(
        'https://imauth.bora.dopa.go.th/api/v2/oauth2/token/',
        data: formData,
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.json,
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic $encoded',
          },
        ),
      );

      // Decode token to get user info
      Map<String, dynamic> idData = JwtDecoder.decode(res.data['id_token']);

      // Prepare data for login instead of registration
      var _userData = {};
      _userData['thaiID'] = {
        'pid': idData['pid'],
        'name': idData['given_name'],
        'family_name': idData['family_name'],
        'birthdate': idData['birthdate'],
        'address': idData['address']['formatted'],
        'gender': idData['gender'],
      };
      _userData['firstName'] = idData['given_name'];
      _userData['lastName'] = idData['family_name'];
      _userData['sex'] = idData['gender'];
      _userData['idcard'] = idData['pid'];

      // Use _login instead of _register for login process
      _login(_userData);
    } catch (e) {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _login(param) async {
    setState(() => _loadingSubmit = true);
    try {
      var response = await Dio().post(
        '$server/dcc-api/m/register/login/idCard', // Replace with your actual login API
        data: param,
      );

      setState(() {
        _loadingSubmit = false;
      });
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          // logWTF('token');
          txtEmail.text = response.data['objectData']['email'];
          txtPassword.text = response.data['objectData']['password'];

          String accessToken = await _getTokenKeycloak(
            username: txtEmail.text.trim(),
            password: txtPassword.text,
          );

          if (accessToken == 'invalid_grant' || accessToken == '') {
            Fluttertoast.showToast(
                msg: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
                gravity: ToastGravity.CENTER);
            setState(() => _loadingSubmit = false);
            return;
            // กรอกรหัสผ่าน
          }

          dynamic responseKeyCloak = await _getUserInfoKeycloak(accessToken);

          if (responseKeyCloak == null) {
            return;
          }

          dynamic responseProfileMe = await _getProfileMe(accessToken);
          if (responseProfileMe == null) {
            return;
          }
          dynamic responseUser = await _getUserProfile();

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
            key: 'thaiid',
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegisterThaidPage(model: param, category: ""),
            ),
          );
        }
      } else {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      setState(() {
        _loadingSubmit = false;
      });
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
        logE(response.data);
        Fluttertoast.showToast(msg: response.data['error_description']);
        setState(() => _loadingSubmit = false);
      }
    } on DioError catch (e) {
      logE(e.error);
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data.toString();
      }
      Fluttertoast.showToast(msg: err);
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
    Response response = await Dio().post(
      '$server/dcc-api/m/register/read',
      data: {
        'username': txtEmail.text.trim(),

        // 'category': 'guest',
      },
    );
    print("----------_getUserProfile------------${response}");
    // logWTF(response.data);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      logE(response.data);
      Fluttertoast.showToast(msg: response.data['error_description']);
      return null;
    }
  }

  void _callLoginFacebook() async {
    final fb.LoginResult result = await fb.FacebookAuth.instance
        .login(); // by default we request the email and the public profile
    // or FacebookAuth.i.login()
    if (result.status == fb.LoginStatus.success) {
      // you are logged
      final fb.AccessToken? accessToken = result.accessToken;

      if (accessToken != null) {
        // user is logged
        print(accessToken.toString());
        final userData = await fb.FacebookAuth.i.getUserData();
        print(userData['email'].toString());

        if (userData['email'] == null || userData['email'].toString().isEmpty) {
          Fluttertoast.showToast(msg: 'ไม่พบบัญชีของคุณ');
          Navigator.of(context).pushReplacementNamed('/login');
          return;
        }

        try {
          setState(() => _loadingSubmit = true);

          // var model = {
          //   "username": userData['email'].toString(),
          //   "email": userData['email'].toString(),
          //   "imageUrl": userData['picture']['data']['url'].toString(),
          //   "firstName": userData['name'].toString(),
          //   "lastName": '',
          //   "facebookID": userData['id'].toString()
          // };

          var model = {
            "username": userData['id'].toString(),
            "email": userData['email'].toString(),
            "imageUrl": userData['picture']['data']['url'].toString(),
            "firstName": userData['name'].toString(),
            "lastName": '',
            "facebookID": userData['id'].toString()
          };
          _callLoginSocial(model, 'facebook');
          print('=====================> ${model}');
        } catch (e) {
          // setState(() => _loadingSubmit = false);
        }
      }
    } else {
      print(result.status);
      print(result.message);
    }

    // var obj = await signInWithFacebook();

    // logWTF(obj.toString());
    // // print(obj.user.displayName);
    // // print(obj.user.uid);
    // if (obj != null) {
    //   var model = {
    //     "username": obj.user.uid.toString(),
    //     "email": obj.user.email,
    //     "imageUrl":
    //         obj.user.photoURL != null ? obj.user.photoURL + "?width=9999" : '',
    //     "firstName": obj.user.displayName,
    //     "lastName": '',
    //     "facebookID": obj.user.uid.toString(),
    //   };
    //   _callLoginSocial(model, 'facebook');
    // } else {
    //   Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    // }
  }

  // void _callLoginX() async {
  //   try {
  //     final twitterLogin = TwitterLogin(
  //       // Consumer API keys
  //       apiKey: 'VZWc4305qtisGTva2z52ue5A3',
  //       // Consumer API Secret keys
  //       apiSecretKey: 'WlBAmdIiGgUsDRJ0w2JuoFKrvh34CAwlC4l3ChzQhkHlt6Qd1W',
  //       // Registered Callback URLs in TwitterApp
  //       // Android is a deeplink
  //       // iOS is a URLScheme
  //       redirectURI: 'dcc://thaid',
  //     );
  //     final obj = await twitterLogin.login();
  //     switch (obj.status) {
  //       case TwitterLoginStatus.loggedIn:
  //         // success
  //         logWTF(obj.user!.id);
  //         logWTF(obj.user!.name);
  //         break;
  //       case TwitterLoginStatus.cancelledByUser:
  //         // cancel
  //         break;
  //       case TwitterLoginStatus.error:
  //         // error
  //         break;
  //       case null:
  //         break;
  //     }

  //     if (obj != null) {
  //       var model = {
  //         "username": obj.user!.id.toString(),
  //         "email": obj.user!.email.toLowerCase(),
  //         "imageUrl": obj.user!.thumbnailImage,
  //         "firstName": obj.user!.name,
  //         "lastName": '',
  //         "xID": obj.user!.id.toString()
  //       };
  //       _callLoginSocial(model, 'x');
  //     } else {
  //       logE('obj :: ');
  //       logE(obj);
  //       // setState(() => _loadingSubmit = false);
  //       Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'ยกเลิก');
  //   }
  // }

  void _callLoginGoogle() async {
    setState(() => _loadingSubmit = true);
    try {
      UserCredential obj = await signInWithGoogle();

      if (obj != null) {
        var model = {
          "username": obj.user!.uid,
          "email": obj.user!.email,
          "imageUrl": obj.user!.photoURL ?? '',
          "firstName": obj.user!.displayName,
          "lastName": '',
          "googleID": obj.user!.uid
        };
        _callLoginSocial(model, 'google');
      } else {
        setState(() => _loadingSubmit = false);
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      setState(() => _loadingSubmit = false);
    }
  }

  void _callLoginLine() async {
    try {
      LoginResult? obj = await loginLine();
      openLine = false;
      logWTF(obj!.data);

      if (obj != null) {
        final idToken = obj.accessToken.idToken;
        final userEmail = (idToken != null)
            ? idToken['email'] != null
                ? idToken['email']
                : ''
            : '';
        var model = {
          "username": obj.userProfile!.userId.toString(),
          "email": userEmail,
          "imageUrl": (obj.userProfile!.pictureUrl != '' &&
                  obj.userProfile!.pictureUrl != null)
              ? obj.userProfile!.pictureUrl
              : '',
          "firstName": obj.userProfile!.displayName,
          "lastName": '',
          "lineID": obj.userProfile!.userId.toString()
        };
        _callLoginSocial(model, 'line');
      } else {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'ยกเลิก');
    }
  }

  void _callLoginApple() async {
    try {
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
    } catch (e) {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  void _callLoginSocial(dynamic param, String type) async {
    setState(() => _loadingSubmit = true);
    logWTF('_callLoginSocial');
    try {
      if (param != null) {
        txtEmail.text = param['email'];
        Dio dio = Dio();
        var check = await dio.post(
          '$server/dcc-api/m/register/check/login/social/guest',
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

          logWTF('token');
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
          if (responseKeyCloak == null || responseProfileMe == null) {
            setState(() => _loadingSubmit = false);
            // Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
            return;
          }

          // check isMember
          // if (responseProfileMe['data']['isMember'] == 0) {
          //   Fluttertoast.showToast(msg: 'บัญชีนี้เป็นเจ้าหน้าที่');
          //   return;
          // }

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
            key: type,
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
          String usernameDup = await _checkDuplicateUser();
          if (usernameDup.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RegisterLinkAccountPage(
                  email: param['email'],
                  category: type,
                  model: param,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RegisterPage(model: param, category: type),
              ),
            );
          }
          // if (!mounted) return;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => RegisterPage(model: param, category: type),
          //   ),
          // );
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

  static InputDecoration _decorationPasswordMember(
    context, {
    String hintText = '',
    bool visibility = false,
    Function? suffixTap,
  }) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.black
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.black
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,

        suffixIcon: GestureDetector(
          onTap: () {
            suffixTap!();
          },
          child: visibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
        suffixIconColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Color(0xFFB325F8)
            : MyApp.themeNotifier.value == ThemeModeThird.dark
                ? Colors.white
                : Color(0xFFFFFD57),

        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
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
          logWTF(response.data);
          if (response.data['status'] != 'S') {
            setState(() => _loadingSubmit = false);
            return null;
          }

          logWTF(response.data);

          logWTF('token');
          String accessToken = await _getTokenKeycloak(
            username: response.data['objectData']['email'],
            password: response.data['objectData']['password'],
          );
          logWTF(accessToken);

          if (accessToken == 'invalid_grant') {
            logWTF('password fail');
            Fluttertoast.showToast(msg: 'รหัสผ่านไม่ถูกต้อง');
            setState(() => _loadingSubmit = false);
            _modalPassword(param, type);
            return;
            // กรอกรหัสผ่าน
          }
          logWTF(response);
          logWTF('responseKeyCloak');
          dynamic responseKeyCloak = await _getUserInfoKeycloak(accessToken);
          logWTF('responseProfileMe');
          dynamic responseProfileMe = await _getProfileMe(accessToken);
          if (responseKeyCloak == null || responseProfileMe == null) {
            // Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
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
            key: type,
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
        setState(() => _loadingSubmit = false);
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      setState(() => _loadingSubmit = false);
      Fluttertoast.showToast(msg: 'ยกเลิก');
    }
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

  void _callReadConfig() async {
    var response = await Dio().get(
        '$server/py-api/dcc/config/login_social/' + versionNumber.toString());

    setState(() {
      configLoginSocial = response;
    });
  }

  Future<String> _checkDuplicateUser() async {
    try {
      Response<String> response = await Dio().get(
        '$server/dcc-api/m/register/guest/duplicate/${txtEmail.text}/${txtEmail.text}',
      );
      if (response.data == 'email') {
        return 'อีเมลนี้ถูกใช้งานไปแล้ว';
      }
      if (response.data == 'server') {
        return 'internal server error';
      }

      return '';
    } catch (e) {
      logE(e);
      return 'เกิดข้อผิดพลาด';
    }
  }
}
