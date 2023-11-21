import 'package:des/forgot_password_otp_phone.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
                                    'รับ OTP',
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
                                'กรุณากรอกหมายเลขโทรศัพท์ของท่าน เพื่อทำการรับรหัสสำหรับยืนยัน',
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
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: _decorationRegisterMember(
                                  context,
                                  hintText: 'หมายเลขโทรศัพท์',
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
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกข้อมูล ';
                                  }

                                  if (value.length < 10) {
                                    return 'ตรวจสอบจำนวน ';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  final form = _formKey.currentState;
                                  if (form!.validate() && !_loadindSubmit) {
                                    form.save();

                                    setState(() => _loadindSubmit = true);
                                    _requestOTP();
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
