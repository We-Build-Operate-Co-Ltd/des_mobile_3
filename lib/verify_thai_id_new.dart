import 'dart:convert';

import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/verify_complete.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'shared/config.dart';
import 'shared/extension.dart';

class VerifyThaiIDNewPage extends StatefulWidget {
  const VerifyThaiIDNewPage({Key? key}) : super(key: key);

  @override
  State<VerifyThaiIDNewPage> createState() => _VerifyThaiIDNewPageState();
}

class _VerifyThaiIDNewPageState extends State<VerifyThaiIDNewPage> {
  dynamic _userData = {};
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
              colorFilter: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? null
                  : ColorFilter.matrix(
                      <double>[
                        0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                        0.2126, 0.7152, 0.0722, 0, 0, // Green channel
                        0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                        0, 0, 0, 1, 0, // Alpha channel
                      ],
                    ),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 130,
                right: 30,
                child: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Image(
                        image: AssetImage('assets/images/Owl-6 3.png'),
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.matrix(<double>[
                          0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                          0.2126, 0.7152, 0.0722, 0, 0, // Green channel
                          0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                          0, 0, 0, 1, 0, // Alpha channel
                        ]),
                        child: Image(
                          image: AssetImage('assets/images/Owl-6 3.png'),
                        ),
                      ),
              ),
              Positioned(
                top: 80,
                left: 60,
                child: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Image(
                        image: AssetImage('assets/images/Rectangle 7803.png'),
                        height: 149,
                        width: 149,
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.matrix(<double>[
                          0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                          0.2126, 0.7152, 0.0722, 0, 0, // Green channel
                          0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                          0, 0, 0, 1, 0, // Alpha channel
                        ]),
                        child: Image(
                          image: AssetImage('assets/images/Rectangle 7803.png'),
                          height: 149,
                          width: 149,
                        ),
                      ),
              ),
              Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Colors.white
                                  : Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: ListView(
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
                                        child: MyApp.themeNotifier.value ==
                                                ThemeModeThird.light
                                            ? Image.asset(
                                                'assets/images/back_profile.png',
                                              )
                                            : ColorFiltered(
                                                colorFilter:
                                                    ColorFilter.matrix(<double>[
                                                  0.2126, 0.7152, 0.0722, 0,
                                                  0, // Red channel
                                                  0.2126, 0.7152, 0.0722, 0,
                                                  0, // Green channel
                                                  0.2126, 0.7152, 0.0722, 0,
                                                  0, // Blue channel
                                                  0, 0, 0, 1,
                                                  0, // Alpha channel
                                                ]),
                                                child: Image.asset(
                                                  'assets/images/back_profile.png',
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'ยืนยันตัวตน\nด้วยแอปพลิเคชัน ThaID',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: MyApp.themeNotifier.value ==
                                                ThemeModeThird.light
                                            ? Color(0xFFB325F8)
                                            : MyApp.themeNotifier.value ==
                                                    ThemeModeThird.dark
                                                ? Colors.white
                                                : Color(0xFFFFFD57),
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                'ขั้นตอนสุดท้าย\nเพิ่มความน่าเชื่อถือให้กับบัญชีของคุณ\nเพียงยืนยันตัวตนด้วยแอปพลิเคชัน ThaID\n\nหากคุณยังไม่เคยติดตั้งแอปพลิเคชัน ThaID\nไม่ต้องเป็นห่วง ระบบจะช่วยติดตั้งให้คุณอัตโนมัต',
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
                              SizedBox(height: 20),
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
                                          color: MyApp.themeNotifier.value ==
                                                  ThemeModeThird.light
                                              ? Color(0xFFB325F8)
                                              : Colors.black,
                                          border: Border.all(
                                            color: MyApp.themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? Color(0xFFB325F8)
                                                : MyApp.themeNotifier.value ==
                                                        ThemeModeThird.dark
                                                    ? Colors.white
                                                    : Color(0xFFFFFD57),
                                          ),
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
                                        child: Text(
                                          'เริ่มยืนยันตัวตน',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: MyApp.themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? Colors.white
                                                : MyApp.themeNotifier.value ==
                                                        ThemeModeThird.dark
                                                    ? Colors.white
                                                    : Color(0xFFFFFD57),
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
      await prefs.setString('thaiDAction', 'updateNew');

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

      var user = await ManageStorage.readDynamic('profileData') ?? '';
      var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
      var password = await ManageStorage.read('password') ?? '';
      // logWTF(profileMe);

      user['email'] = profileMe['email'];
      user['phone'] = profileMe['phonenumber'];
      user['phonenumber'] = profileMe['phonenumber'];
      user['password'] = password;

      user['status'] = "A";
      user['isActive'] = true;
      user['hasThaiD'] = true;

      user['thaiID'] = {
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
      // logWTF(user);

      final response = await Dio()
          .post('$server/dcc-api/m/Register/user/verify/update', data: user);

      var result = response.data;
      logWTF(result);
      // setState(() => _loadindSubmit = false);
      if (result['status'] == 'S') {
        await ManageStorage.createProfile(
          value: user,
          key: 'guest',
        );
        profileMe['isVerify'] = 1;
        await ManageStorage.createSecureStorage(
          value: json.encode(profileMe),
          key: 'profileMe',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCompletePage(action: 'update'),
          ),
        );
      } else {
        // setState(() => _loadindSubmit = false);
        debugPrint(result['message']);
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');
      setState(() => _loadingSubmit = false);
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _register() async {
    setState(() => _loadingSubmit = true);
    try {
      var response = await Dio().post(
        '$server/dcc-api/m/Register/create',
        data: _userData,
      );

      setState(() {
        _loadingSubmit = false;
      });

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
      setState(() {
        _loadingSubmit = false;
      });
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }
}
