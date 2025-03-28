import 'dart:convert';

import 'package:des/shared/secure_storage.dart';
import 'package:des/verify_complete.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'shared/config.dart';
import 'shared/extension.dart';

class RegisterVerifyThaiIDPage extends StatefulWidget {
  const RegisterVerifyThaiIDPage({Key? key}) : super(key: key);

  @override
  State<RegisterVerifyThaiIDPage> createState() =>
      _RegisterVerifyThaiIDPageState();
}

class _RegisterVerifyThaiIDPageState extends State<RegisterVerifyThaiIDPage> {
  dynamic _userData = {};
  String _thiaDCode = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        _thiaDCode = prefs.getString('thaiDCode') ?? '';
        if (_thiaDCode.isNotEmpty) {
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
    var value = await ManageStorage.read('tempRegister') ?? '';
    var result = json.decode(value);
    setState(() {
      _userData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/BG.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 130,
                right: 30,
                child: Image(
                  image: AssetImage('assets/images/Owl-6 3.png'),
                ),
              ),
              Positioned(
                top: 80,
                left: 60,
                child: Image(
                  image: AssetImage('assets/images/Rectangle 7803.png'),
                  height: 149,
                  width: 149,
                ),
              ),
              Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          'assets/images/back_profile.png',
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    height: 10,
                                  ),
                                  Text(
                                    'ยืนยันตัวตน\nด้วยแอปพลิเคชัน ThaID',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFB325F8)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                'ขั้นตอนสุดท้าย\nเพิ่มความน่าเชื่อถือให้กับบัญชีของคุณ\nเพียงยืนยันตัวตนด้วยแอปพลิเคชัน ThaID\n\nหากคุณยังไม่เคยติดตั้งแอปพลิเคชัน ThaID\nไม่ต้องเป็นห่วง ระบบจะช่วยติดตั้งให้คุณอัตโนมัต',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                          color: Color(0xFFB325F8),
                                          borderRadius:
                                              BorderRadius.circular(23),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x40F3D2FF),
                                              offset: Offset(0, 4),
                                            )
                                          ],
                                        ),
                                        child: const Text(
                                          'เริ่มยืนยันตัวตน',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
      //  Scaffold(
      //   resizeToAvoidBottomInset: false,
      //   backgroundColor: const Color(0xFFFAF4FF),
      //   body: Stack(
      //     children: [
      //       ListView(
      //         padding: EdgeInsets.only(
      //           top: MediaQuery.of(context).padding.top,
      //           bottom: MediaQuery.of(context).padding.bottom,
      //           left: 20,
      //           right: 20,
      //         ),
      //         children: [
      //           const SizedBox(height: 120),
      //           Image.asset(
      //             'assets/images/verify_thai_id.png',
      //             height: 166,
      //             width: 205,
      //           ),
      //           Text(
      //             'ยืนยันตัวตน\nด้วยแอปพลิเคชัน ThaiD',
      //             style: TextStyle(
      //               fontSize: 30,
      //               fontWeight: FontWeight.w700,
      //               color: Theme.of(context).primaryColor,
      //             ),
      //             textAlign: TextAlign.start,
      //           ),
      //           const Text(
      //             'ยืนยันตัวตนขั้นสุดท้าย!', //ท่านสามารถข้ามขั้นตอนนี้ \nและกลับมายืนยันตัวตนด้วยแอปพลิเคชัน ThaiD \nอีกครั้งได้ในภายหลัง ที่เมนูโปรไฟล์ของคุณ
      //             style: TextStyle(
      //               fontSize: 13,
      //               fontWeight: FontWeight.w400,
      //             ),
      //           ),
      //           const SizedBox(height: 30),
      //           GestureDetector(
      //             onTap: () async {
      //               _callThaiID();
      //             },
      //             child: Container(
      //               height: 50,
      //               width: double.infinity,
      //               alignment: Alignment.center,
      //               decoration: BoxDecoration(
      //                 color: Theme.of(context).primaryColor,
      //                 borderRadius: BorderRadius.circular(7),
      //                 boxShadow: const [
      //                   BoxShadow(
      //                     blurRadius: 4,
      //                     color: Color(0x40F3D2FF),
      //                     offset: Offset(0, 4),
      //                   )
      //                 ],
      //               ),
      //               child: const Text(
      //                 'ยืนยันตัวตน',
      //                 style: TextStyle(
      //                   fontSize: 16,
      //                   fontWeight: FontWeight.w400,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           // const SizedBox(height: 10),
      //           // GestureDetector(
      //           //   onTap: () async {
      //           //     _userData['hasThaiD'] = false; // ไม่ได้ยืนยัน thaiD.
      //           //     _register();
      //           //   },
      //           //   child: Container(
      //           //     height: 50,
      //           //     width: double.infinity,
      //           //     alignment: Alignment.center,
      //           //     decoration: BoxDecoration(
      //           //       color: Colors.white,
      //           //       border: Border.all(
      //           //         color: Theme.of(context).primaryColor,
      //           //         width: 1,
      //           //       ),
      //           //       borderRadius: BorderRadius.circular(7),
      //           //       boxShadow: const [
      //           //         BoxShadow(
      //           //           blurRadius: 4,
      //           //           color: Color(0x40F3D2FF),
      //           //           offset: Offset(0, 4),
      //           //         )
      //           //       ],
      //           //     ),
      //           //     child: Text(
      //           //       'ข้ามขั้นตอนนี้',
      //           //       style: TextStyle(
      //           //         fontSize: 16,
      //           //         fontWeight: FontWeight.w400,
      //           //         color: Theme.of(context).primaryColor,
      //           //       ),
      //           //     ),
      //           //   ),
      //           // ),
      //           const SizedBox(height: 20),
      //         ],
      //       ),
      //       if (_loadingSubmit)
      //         Positioned.fill(
      //           child: Container(
      //             alignment: Alignment.center,
      //             color: Colors.white.withOpacity(0.5),
      //             child: const SizedBox(
      //               height: 50,
      //               width: 50,
      //               child: CircularProgressIndicator(),
      //             ),
      //           ),
      //         )
      //     ],
      //   ),
      // ),
    );
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

      //random string, 1 = use for admin,2 = use for guest.
      String state = '2${getRandomString()}';
      String scope =
          'pid%20given_name%20family_name%20address%20birthdate%20gender%20openid';
      String parameter =
          '?response_type=$responseType&client_id=$clientId&redirect_uri=$redirectUri&scope=$scope&state=$state';

      // logWTF(state);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('thaiDState', state);
      await prefs.setString('thaiDAction', 'create');

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
        // "redirect_uri": "https://decms.dcc.onde.go.th/auth",
        "redirect_uri": 'https://dlapp.we-builds.com/dcc-thaid',
        "code":
            "ZGJlNWUzMmQtOWUxMS00NGVkLTk1ZjQtOTU0MzJlNjU4N2NjI2ZhYzFlMDg3LTJjOGMtNGNjYy05MDhlLWJmMDIzNTllNTg5ZA"
      });

      var res = await dio.post(
        'https://imauth.bora.dopa.go.th/api/v2/oauth2/token/',
        // data: formData,
        data: {
          "grant_type": "authorization_code",
          // "redirect_uri": "https://decms.dcc.onde.go.th/auth",
          "redirect_uri": 'https://dlapp.we-builds.com/dcc-thaid',
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

      Map<String, dynamic> idData = JwtDecoder.decode(res.data['id_token']);

      _userData['hasThaiD'] = true; // ยืนยัน thaiD. = true;
      _userData['thaiID'] = {
        'pid': idData['pid'],
        'name': '',
        'name_th': '',
        'birthdate': idData['birthdate'],
        'address': idData['address']['formatted'],
        'given_name': idData['given_name'],
        'middle_name': '',
        'family_name': idData['family_name'],
        'given_name_en': '',
        'middle_name_en': '',
        'family_name_en': '',
        'gender': idData['gender'],
      };

      _userData['firstName'] = idData['given_name'];
      _userData['lastName'] = idData['family_name'];
      _userData['sex'] = idData['gender'];
      _userData['idcard'] = idData['pid'];

      _register();
    } catch (e) {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _register() async {
    try {
      var response = await Dio().post(
        '$server/dcc-api/m/Register/create',
        data: _userData,
      );

      setState(() {});

      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const VerifyCompletePage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            ),
          );
        } else {
          logE(response.data['message']);
          Fluttertoast.showToast(
              msg: response.data['message'] ?? 'เกิดข้อผิดพลาด');
        }
      } else {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      logE(e);
      setState(() {});
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }
}
