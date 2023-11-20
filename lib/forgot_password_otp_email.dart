import 'package:des/shared/config.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:des/login_first.dart';

import 'main.dart';

class ForgotPasswordOTPEmailPage extends StatefulWidget {
  const ForgotPasswordOTPEmailPage({
    Key? key,
    required this.email,
  }) : super(key: key);
  final String email;

  @override
  _ForgotPasswordOTPEmailPageState createState() =>
      _ForgotPasswordOTPEmailPageState();
}

class _ForgotPasswordOTPEmailPageState
    extends State<ForgotPasswordOTPEmailPage> {
  final _formKey = GlobalKey<FormState>();

  String text = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> submitForgotPassword() async {
    Dio().post('$server/de-api/m/Register/forgot/password', data: {
      'email': widget.email,
    });

    return showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(
          'รหัสผ่านที่ใช้ยืนยันตัวตนได้ส่งไปในอีเมลเรียบร้อยแล้ว',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ยกเลิก",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF005C9E),
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
  }

  void goBack() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginFirstPage(),
      ),
    );
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xFFF1B435), width: 0),
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFFF7F7F7),
        ),
        child: Center(
          child: Text(
            text[position],
            style: TextStyle(
              color: Color(0xFF7A4CB1),
              fontSize: 30,
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xFFF1B435), width: 0),
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFFF7F7F7),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        // appBar: header(context, goBack),
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SizedBox(height: 120),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Card(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.white
                    : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ลืมรหัสผ่าน',
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
                          Text(
                            'กรุณากรอกรหัสที่ท่านได้รับผ่านอีเมล',
                            style: TextStyle(
                              fontSize: 13,
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
                          SizedBox(height: 10),
                          Container(
                            // constraints: const BoxConstraints(maxWidth: 500),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                otpNumberWidget(0),
                                otpNumberWidget(1),
                                otpNumberWidget(2),
                                otpNumberWidget(3),
                                otpNumberWidget(4),
                                // otpNumberWidget(5),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: GestureDetector(
                              onTap: () => {},
                              child: Text(
                                'ท่านต้องการรับรหัสใหม่',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Colors.black
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          InkWell(
                            onTap: () {
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                submitForgotPassword();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7A4CB1)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                              child: Text(
                                "ดำเนินการต่อ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
