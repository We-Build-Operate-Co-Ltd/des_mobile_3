import 'dart:convert';

import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/verify_otp_email_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: library_prefixes
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'main.dart';

class VerifyOTPPhonePage extends StatefulWidget {
  const VerifyOTPPhonePage(
      {Key? key, required this.token, required this.refCode})
      : super(key: key);
  final String token;
  final String refCode;

  @override
  State<VerifyOTPPhonePage> createState() => _VerifyOTPPhonePageState();
}

class _VerifyOTPPhonePageState extends State<VerifyOTPPhonePage> {
  final txtNumber1 = TextEditingController();
  bool loading = false;
  String image = '';
  final _formKey = GlobalKey<FormState>();
  late dynamic _userData;

  // face recognition start
  var image1 = Regula.MatchFacesImage();
  var image2 = Regula.MatchFacesImage();
  var img1 = Image.asset('logo.png');
  var img2 = Image.asset('logo.png');
  // ignore: unused_field
  String _liveness = "nil";
  String _token = "";
  String _refCode = "";

  @override
  void initState() {
    _token = widget.token;
    _refCode = widget.refCode;
    super.initState();
  }

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'กรุณากรอกรหัสที่ท่านได้รับผ่านเบอร์โทรศัพท์',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.all(20),
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
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
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/icon_phone.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: PinCodeTextField(
                  appContext: context,
                  controller: txtNumber1,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  length: 6,
                  obscureText: false,
                  obscuringCharacter: '*',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 6) {
                      return "";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    inactiveColor: Colors.transparent,
                    activeColor: Colors.transparent,
                    selectedColor: Theme.of(context).primaryColor,
                    // disabledColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Color(0xFFEEEEEE),
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(15),
                    fieldHeight: 45.2,
                    fieldWidth: 45.2,
                    activeFillColor: Color(0xFFEEEEEE),
                  ),
                  backgroundColor: Colors.white,
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  // controller: textEditingController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) async {
                    if (await _validateOTP()) {
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VerifyOTPEmailInputPage(),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(msg: 'OTP ไม่ถูกต้อง');
                    }
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      // currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => _requestOTP(),
                  child: Text(
                    'ท่านต้องการรับรหัสใหม่',
                    style: TextStyle(
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () async {
                  if (txtNumber1.text.isNotEmpty) {
                    if (await _validateOTP()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VerifyOTPEmailInputPage(),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(msg: 'OTP ไม่ถูกต้อง');
                    }
                  } else {
                    Fluttertoast.showToast(msg: 'OTP ไม่ครบ');
                  }
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.5),
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF7A4CB1)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  child: Text(
                    'ดำเนินการต่อ',
                    style: TextStyle(
                      fontSize: 16,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _buildHead() {
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
              'กรอกรหัส OTP',
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

  _requestOTP() async {
    var value = await ManageStorage.read('profileData') ?? '';
    var result = json.decode(value);
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.headers["api_key"] = "db88c29e14b65c9db353c9385f6e5f28";
    dio.options.headers["secret_key"] = "XpM2EfFk7DKcyJzt";
    var response = await dio.post('https://portal-otp.smsmkt.com/api/otp-send',
        data: {
          "project_key": "XcvVbGHhAi",
          "phone": result['phone'],
          "ref_code": "xxx123"
        });

    var otp = response.data['result'];
    if (otp['token'] != null) {
      setState(() {
        _token = otp['token'];
        _refCode = otp['ref_code'];
      });
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _validateOTP() async {
    try {
      Dio dio = Dio();
      dio.options.contentType = Headers.formUrlEncodedContentType;
      dio.options.headers["api_key"] = "db88c29e14b65c9db353c9385f6e5f28";
      dio.options.headers["secret_key"] = "XpM2EfFk7DKcyJzt";
      var response = await dio
          .post('https://portal-otp.smsmkt.com/api/otp-validate', data: {
        "token": _token,
        "otp_code": '${txtNumber1.text}',
        "refCode": _refCode
      });
      var validate = response.data['result'];
      if (validate != null && validate['status']) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }
}
