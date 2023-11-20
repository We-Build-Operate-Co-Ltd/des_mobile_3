import 'package:des/forgot_password_otp_phone.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';

class ForgotPasswordOTPPhoneInputPage extends StatefulWidget {
  const ForgotPasswordOTPPhoneInputPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  State<ForgotPasswordOTPPhoneInputPage> createState() =>
      _ForgotPasswordOTPPhoneInputPageState();
}

class _ForgotPasswordOTPPhoneInputPageState
    extends State<ForgotPasswordOTPPhoneInputPage> {
  TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loadindSubmit = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        appBar: AppBar(
          backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.white
              : Colors.black,
          elevation: 0,
          flexibleSpace: _buildHead(),
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'กรุณากรอกหมายเลขโทรศัพท์ของท่าน เพื่อทำการรับรหัสสำหรับยืนยัน',
                  style: TextStyle(
                    fontSize: 15,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration:
                      _decorationBase(context, hintText: 'หมายเลขโทรศัพท์'),
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'กรุณากรอกข้อมูล ';
                    }

                    if (value.length < 3) {
                      return 'short ';
                    } else {
                      return null;
                    }
                  },
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final form = _formKey.currentState;
                        if (form!.validate() && !_loadindSubmit) {
                          form.save();

                          setState(() => _loadindSubmit = true);
                          _requestOTP();
                        }
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.5),
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFF7A4CB1)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                        child: Text(
                          'ดำเนินการต่อ',
                          style: TextStyle(
                            fontSize: 16,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (_loadindSubmit)
                      Positioned.fill(
                        left: 15,
                        right: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(22.5),
                          ),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      height: 60 + MediaQuery.of(context).padding.top,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: MediaQuery.of(context).padding.top,
      ),
      color: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      child: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF7A4CB1)
                        : Colors.black,
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    )),
                child: Image.asset(
                  'assets/images/back_arrow.png',
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'OTP ผ่านหมายเลขโทรศัพท์',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
          )
        ],
      ),
    );
  }

  static InputDecoration _decorationBase(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          // fontSize: 12,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFA924F0)),
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
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );

  @override
  void initState() {
    _phoneController = TextEditingController();
    _loadindSubmit = false;
    super.initState();
  }

  _requestOTP() async {
    try {
      Dio dio = Dio();
      dio.options.contentType = Headers.formUrlEncodedContentType;
      dio.options.headers["api_key"] = "db88c29e14b65c9db353c9385f6e5f28";
      dio.options.headers["secret_key"] = "XpM2EfFk7DKcyJzt";
      var response =
          await dio.post('https://portal-otp.smsmkt.com/api/otp-send', data: {
        "project_key": "XcvVbGHhAi",
        "phone": _phoneController.text.replaceAll('-', '').trim(),
        "ref_code": "xxx123"
      });

      var otp = response.data['result'];
      if (otp['token'] != null) {
        setState(() {
          _loadindSubmit = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ForgotPasswordOTPPhonePage(
              token: otp['token'],
              refCode: otp['ref_code'],
              phone: _phoneController.text,
              email: widget.email,
            ),
          ),
        );
      } else {
        setState(() {
          _loadindSubmit = false;
        });
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      setState(() {
        _loadindSubmit = false;
      });
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }
}
