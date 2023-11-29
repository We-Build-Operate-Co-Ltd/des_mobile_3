import 'package:des/forgot_password_otp_email.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:des/login_first.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'shared/config.dart';
import 'main.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
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
            child: Column(
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
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                'กรุณากรอกอีเมลเพื่อทำการรับรหัสเพื่อรีเซ็ตข้อมูลใหม่',
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
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
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
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                  final form = _formKey.currentState;
                                  if (form!.validate()) {
                                    form.save();
                                    _send();
                                  }
                                },
                                validator: (_emailController) {
                                  if (_emailController!.isEmpty) {
                                    return 'กรุณากรอก' + 'อีเมล' + '.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      final form = _formKey.currentState;
                                      if (form!.validate()) {
                                        form.save();
                                        _send();
                                      }
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                        "รับรหัส",
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
                                  if (_loading)
                                    Positioned.fill(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(23),
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  void goBack() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginFirstPage(),
      ),
    );
  }

  _send() async {
    try {
      setState(() => _loading = true);
      Dio dio = Dio();
      var response = await dio.get(
        '$server/de-api/m/register/find/email/guest/${_emailController.text}',
      );

      if (response.data['status'] == 'S') {
        var data = response.data['objectData'];
        if (data['status']) {
          //pass
          _requestOTP();
        } else {
          setState(() => _loading = false);
          Fluttertoast.showToast(msg: 'ไม่พบข้อมูล');
        }
      } else {
        setState(() => _loading = false);
        Fluttertoast.showToast(msg: 'ลองใหม่อีกครั้ง');
      }
    } catch (e) {
      logE(e);
      setState(() => _loading = false);
      Fluttertoast.showToast(msg: 'ลองใหม่อีกครั้ง');
    }
  }

  _requestOTP() async {
    try {
      var response = await Dio().post('$server/de-api/m/register/otp/request',
          data: {'email': _emailController.text});

      setState(() => _loading = false);

      if (response.data['status'] == 'S') {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ForgotPasswordOTPEmailPage(
              email: _emailController.text,
            ),
          ),
        );
      }
    } catch (e) {
      logE(e);
      setState(() => _loading = false);
      Fluttertoast.showToast(msg: 'ลองใหม่อีกครั้ง');
    }
  }
}
