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
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          child: Card(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.white
                : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: Container(
              height: 300,
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
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
                          'กรอกรหัส',
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
                            // logWTF('close');
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
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
                        ),
                      ],
                    ),
                    Text(
                      'กรุณากรอกรหัสที่ท่านได้รับผ่านอีเมล',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.black
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        inactiveColor: Color(0xFF707070),
                        activeColor: Theme.of(context).primaryColor,
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
