// ignore_for_file: unnecessary_null_comparison

import 'package:des/forgot_password.dart';
import 'package:des/login_second.dart';
import 'package:des/menu.dart';
import 'package:des/register.dart';
import 'package:des/shared/apple_firebase.dart';
import 'package:des/shared/google_firebase.dart';
import 'package:des/shared/line.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/facebook_firebase.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'shared/config.dart';
import 'main.dart';
import 'dart:ui' as ui show ImageFilter;

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

  @override
  void initState() {
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
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
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
                height: 1000,
                // height: 300,
                // alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? "assets/images/bg_login_first_page.png"
                          : "assets/images/bg_login_first_page-dark.png",
                    ),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    // height:  MediaQuery.of(context).size.height * .650,
                    height: (deviceHeight >= 500 && deviceHeight < 800)
                        ? 400
                        : (deviceHeight >= 800)
                            ? 600
                            : deviceHeight * 0.2,
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                            height: 40,
                            // margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    'เข้าสู่ระบบ',
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

                                    //       // Image.asset(
                                    //       //   MyApp.themeNotifier.value ==
                                    //       //           ThemeModeThird.light
                                    //       //       ? 'assets/images/icon_blind.png'
                                    //       //       : MyApp.themeNotifier.value ==
                                    //       //               ThemeModeThird.dark
                                    //       //           ? 'assets/images/icon_blind_d.png'
                                    //       //           : 'assets/images/icon_blind_d-y.png',
                                    //       //   height: 55,
                                    //       //   width: 55,
                                    //       // ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          SizedBox(height: 10),
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
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'กรอกอีเมล';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
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
                                      ? Color(0xFF7A4CB1)
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
                          InkWell(
                            onTap: () {
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();

                                print('_callUser');
                                _callUser();
                              }
                            },
                            child: _buildButtonLogin(
                              '',
                              'ดำเนินการต่อ',
                              color: Theme.of(context).custom.A4CB1_w_fffd57,
                              colorTitle: Theme.of(context).custom.w_b_b,
                              colorBorder:
                                  Theme.of(context).custom.A4CB1_w_fffd57,
                            ),
                          ),
                          SizedBox(height: 30),
                          if (configLoginSocial.toString() == "1") _buildOR(),
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
                              child: _buildButtonLogin(
                                'assets/images/line_circle.png',
                                'เข้าใช้ผ่าน Line',
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF06C755)
                                    : Colors.black,
                                colorTitle: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.white
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                                colorBorder: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF06C755)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                            ),
                          // SizedBox(height: 10),
                          // InkWell(
                          //   onTap: () => _callLoginFacebook(),
                          //   child: _buildButtonLogin(
                          //     'assets/images/logo_facebook_login_page.png',
                          //     'เข้าใช้ผ่าน Facebook',
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
                          if (configLoginSocial.toString() == "1")
                            SizedBox(height: 10),
                          if (configLoginSocial.toString() == "1")
                            InkWell(
                              onTap: () => _callLoginGoogle(),
                              child: _buildButtonLogin(
                                'assets/images/logo_google_login_page.png',
                                'เข้าใช้ผ่าน Google',
                                colorTitle: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.black
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                                colorBorder: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFFE4E4E4)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                            ),
                          SizedBox(height: 35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
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
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      // contentCard(context, "ปกติ", "1", "color"),
                      // SizedBox(height: 10),
                      // contentCard(context, "ขาวดำ", "2", "color"),
                      // SizedBox(height: 10),
                      // contentCard(context, "ดำเหลือง", "3", "color"),
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
            setState(
              () {
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
              },
            );
          }),
        );
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
          if (image.isNotEmpty)
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

  // login guest -----

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
        print('------');

        response = await Dio().post('$server/de-api/m/register/read', data: {
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

      setState(() {
        _loading = false;
      });

      // print(response.data.toString());
      if (response.data['status'] == 'S') {
        List<dynamic> result = response.data['objectData'];
        if (result.length > 0) {
          setState(() {
            _username = txtEmail.text.trim();
            _imageUrl = response.data['objectData'][0]['imageUrl'] ?? '';
          });
          txtEmail.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  LoginSecondPage(username: _username!, imageUrl: _imageUrl!),
            ),
          );
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
          '$server/de-api/m/v2/register/facebook/login',
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
          '$server/de-api/m/v2/register/google/login',
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
          '$server/de-api/m/v2/register/line/login',
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

    Dio dio = new Dio();
    var response = await dio.post(
      '$server/de-api/m/v2/register/apple/login',
      data: model,
    );

    ManageStorage.createProfile(
      value: response.data['objectData'],
      key: 'apple',
    );

    if (obj != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
      );
    }
  }

  dynamic configLoginSocial = 0;
  void _callReadConfig() async {
    var response = await Dio().get('$server/py-api/dcc/config/login_social');
    print(response);
    setState(() {
      configLoginSocial = response;
    });
  }
}
