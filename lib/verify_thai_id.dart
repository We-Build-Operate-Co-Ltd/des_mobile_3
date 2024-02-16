import 'dart:convert';
import 'package:des/verify_otp_phone_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'shared/extension.dart';

class VerifyThaiIDPage extends StatefulWidget {
  const VerifyThaiIDPage({Key? key}) : super(key: key);

  @override
  State<VerifyThaiIDPage> createState() => _VerifyThaiIDPageState();
}

class _VerifyThaiIDPageState extends State<VerifyThaiIDPage> {
  bool _loadingSubmit = false;
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
    super.initState();
    _getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getUserData() async {
    // var result = await ManageStorage.readDynamic('verifyTemp') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFAF4FF),
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom,
            left: 20,
            right: 20,
          ),
          child: ListView(
            children: [
              const SizedBox(height: 120),
              Image.asset(
                'assets/images/verify_thai_id.png',
                height: 166,
                width: 205,
              ),
              Text(
                'ยืนยันตัวตน\nด้วยแอปพลิเคชัน ThaiD',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.start,
              ),
              const Text(
                'ยืนยันตัวตนขั้นสุดท้าย! ท่านสามารถข้ามขั้นตอนนี้ \nและกลับมายืนยันตัวตนด้วยแอปพลิเคชัน ThaiD \nอีกครั้งได้ในภายหลัง ที่เมนูโปรไฟล์ของคุณ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      _callThaiID();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
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
                        'ยืนยันตัวตน',
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
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _callThaiID() async {
    try {
      String responseType = 'code';
      String clientId = 'TVE4MVpwQWNrc0NxSzNLWXFQYjVmdGFTdFgxNVN3bU4';
      String client_secret =
          'cjhOVEpmdk03NUZydFlCU3B0bHhwb2t3SkhSbFZnWjJOQm9lMkx3Mg';
      String redirectUri = 'https://decms.dcc.onde.go.th/auth';
      String base = 'https://imauth.bora.dopa.go.th/api/v2/oauth2/auth/';

      //random string, 1 = use for admin,2 = use for guest.
      String state = '2${getRandomString()}';
      String scope =
          'pid%20given_name%20family_name%20address%20birthdate%20gender%20openid';
      String parameter =
          '?response_type=$responseType&client_id=$clientId&redirect_uri=$redirectUri&scope=$scope&state=$state';

      // logWTF(state);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('thaiDState', state);
      await prefs.setString('thaiDAction', 'update');

      launchUrl(
        Uri.parse('$base$parameter'),
        mode: LaunchMode.externalApplication,
      );
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
      // dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
      // dio.options.headers["Authorization"] = "Basic $encoded";
      // dio.options.contentType = 'application/x-www-form-urlencoded';
      // dio.options.validateStatus = (status) => true;

      var formData = FormData.fromMap({
        "grant_type": "authorization_code",
        "redirect_uri": "https://decms.dcc.onde.go.th/auth",
        "code":
            "ZGJlNWUzMmQtOWUxMS00NGVkLTk1ZjQtOTU0MzJlNjU4N2NjI2ZhYzFlMDg3LTJjOGMtNGNjYy05MDhlLWJmMDIzNTllNTg5ZA"
      });

      var res = await dio.post(
        'https://imauth.bora.dopa.go.th/api/v2/oauth2/token/',
        // data: formData,
        data: {
          "grant_type": "authorization_code",
          "redirect_uri": "https://decms.dcc.onde.go.th/auth",
          "code": _thiaDCode
        },
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

      await prefs.setString('thaiDToken', res.data['id_token']);

      // Map<String, dynamic> idData = JwtDecoder.decode(res.data['id_token']);

      // dynamic thaiDData = {
      //   'pid': idData['pid'],
      //   'name': '',
      //   'name_th': '',
      //   'birthdate': idData['birthdate'],
      //   'address': idData['address']['formatted'],
      //   'given_name': idData['given_name'],
      //   'middle_name': '',
      //   'family_name': idData['family_name'],
      //   'given_name_en': '',
      //   'middle_name_en': '',
      //   'family_name_en': '',
      //   'gender': idData['gender'],
      // };

      setState(() => _loadingSubmit = false);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => VerifyLastStepPage(
      //       isThaiD: true, // ยืนยัน thaiD. = true;
      //       model: thaiDData,
      //     ),
      //   ),
      // );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOTPPhoneInputPage(),
        ),
      );
    } catch (e) {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');
      setState(() => _loadingSubmit = false);
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }
}
