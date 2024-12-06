import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'forgot_password_new_password.dart';
import 'main.dart';

class ForgotPasswordOTPEmailPage extends StatefulWidget {
  const ForgotPasswordOTPEmailPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  State<ForgotPasswordOTPEmailPage> createState() =>
      _ForgotPasswordOTPEmailPageState();
}

class _ForgotPasswordOTPEmailPageState
    extends State<ForgotPasswordOTPEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final txtNumber1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: double.infinity,
          // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/BG.png"),
              fit: BoxFit.cover,
              colorFilter: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? null
                  : ColorFilter.mode(Colors.grey, BlendMode.saturation),
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.white
                    : Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(20),
              // alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 35.0,
                            height: 35.0,
                            margin: EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? 'assets/images/back_profile.png'
                                    : "assets/images/2024/back_balckwhite.png",
                                width: 35,
                                height: 35,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'กรอกรหัส OTP',
                          style: TextStyle(
                            fontFamily: "Kanit",
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFFB325F8)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 55),
                      child: Text(
                        'กรุณากรอกรหัส OTP ที่ท่านได้รับผ่านอีเมล',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.black
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PinCodeTextField(
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
                        inactiveColor: Color(
                            0xFFEEEEEE), // สีของเส้นขอบช่องที่ไม่ได้ใช้งาน
                        activeColor:
                            Color(0xFFEEEEEE), //สีของเส้นขอบช่องที่กำลังใช้งาน
                        selectedColor:
                            // Color(0xFFB325F8), //สีพื้นหลังของช่องที่ถูกเลือก
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Color(0xFFB325F8)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                        // disabledColor: Colors.white,
                        activeFillColor: Color(
                            0xFFEEEEEE), // สีพื้นหลังของช่องที่กำลังใช้งาน
                        selectedFillColor:
                            Color(0xFFEEEEEE), //สีพื้นหลังของช่องที่ถูกเลือก
                        inactiveFillColor: Color(
                            0xFFEEEEEE), // สีพื้นหลังของช่องที่ไม่ได้ใช้งาน
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 50.42,
                        fieldWidth: 50.42,
                      ),
                      textStyle: TextStyle(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFB325F8)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.black
                                  : Color.fromARGB(255, 239, 237,
                                      84), // เปลี่ยนสีของข้อความที่กรอกเป็นสีน้ำเงิน
                          fontSize: 32, // ขนาดของข้อความ
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Kanit' // ความหนาของข้อความ
                          ),
                      backgroundColor: Colors.transparent,
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      // onCompleted: (v) async {
                      //   if (await _validateOTP()) {
                      //     if (!mounted) return;
                      //     await submitForgotPassword();
                      //   } else {
                      //     Fluttertoast.showToast(msg: 'OTP ไม่ถูกต้อง');
                      //   }
                      // },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          // currentText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () => _requestOTP(),
                        child: Text(
                          'ท่านต้องการรับรหัสใหม่',
                          style: TextStyle(
                            fontSize: 13,
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
                    Expanded(
                      child: SizedBox(height: 20),
                    ),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        await _submitForgotPassword();
                        // if (txtNumber1.text.isNotEmpty) {
                        //   if (await _validateOTP()) {
                        //     await _submitForgotPassword();
                        //   } else {
                        //     Fluttertoast.showToast(msg: 'OTP ไม่ถูกต้อง');
                        //   }
                        // } else {
                        //   Fluttertoast.showToast(msg: 'OTP ไม่ครบ');
                        // }
                      },
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFB325F8)
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
                  ],
                ),
              ),
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
  void initState() {
    super.initState();
  }

  _requestOTP() async {
    var response = await Dio().post('$server/dcc-api/m/register/otp/request',
        data: {'email': widget.email});
    if (response.data['status'] == 'S') {
      // pass
      return true;
    } else {
      logE(response.data['message']);
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      return false;
    }
  }

  _validateOTP() async {
    try {
      // logWTF(widget.email);
      // logWTF(txtNumber1.text);
      var response = await Dio().post(
        '$server/dcc-api/m/register/otp/validate',
        data: {
          'email': widget.email,
          'title': txtNumber1.text,
        },
      );

      print('----------' + response.data.toString());

      if (response.data['status'] == 'S') {
        // pass
        return true;
      } else {
        logE(response.data['message']);
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      logE(e);
    }
  }

  _submitForgotPassword() async {
    try {
      logWTF(widget.email);

      //  setState(() => _loadingSubmit = false);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ForgotPasswordNewPasswordPage(
            email: widget.email,
          ),
        ),
      );
    } catch (e) {
      // logWTF(e);
      Fluttertoast.showToast(msg: 'ลองอีกครั้ง');
    }
  }
}
