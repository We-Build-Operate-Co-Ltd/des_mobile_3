import 'dart:convert';

import 'package:des/login_first.dart';
import 'package:des/menu.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyCompletePage extends StatefulWidget {
  const VerifyCompletePage({super.key, this.action = 'create'});

  final String action;

  @override
  State<VerifyCompletePage> createState() => _VerifyCompletePageState();
}

class _VerifyCompletePageState extends State<VerifyCompletePage> {
  dynamic _userData = {};

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {});
    _clearData();
    super.initState();
  }

  _clearData() async {
    var value = await ManageStorage.read('tempRegister') ?? '';
    var result = json.decode(value);
    setState(() {
      _userData = result;
    });
    ManageStorage.deleteStorage('tempRegister');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('thaiDCode');
    await prefs.remove('thaiDState');
    await prefs.remove('thaiDAction');
  }

  _getTokenKeycloak({String username = '', String password = ''}) async {
    try {
      // get token

      Response response = await Dio().post(
        '$ssoURL/realms/$keycloakReaml/protocol/openid-connect/token',
        data: {
          'username': username,
          'password': password.toString(),
          'client_id': clientID,
          'client_secret': clientSecret,
          'grant_type': 'password',
        },
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        return response.data['access_token'];
      } else {
        _goLoginFirstPage();
      }
    } on DioError catch (e) {
      _goLoginFirstPage();
    }
  }

  dynamic _getUserInfoKeycloak(String token) async {
    try {
      // get info
      if (token.isEmpty) return null;
      Response response = await Dio().get(
        '$ssoURL/realms/dcc-portal/protocol/openid-connect/userinfo',
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.json,
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        _goLoginFirstPage();
      }
    } on DioError catch (e) {
      _goLoginFirstPage();
    }
  }

  dynamic _getProfileMe(String token) async {
    try {
      // get info
      if (token.isEmpty) return null;
      Response response = await Dio().get(
        '$ondeURL/api/user/ProfileMe',
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.json,
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        _goLoginFirstPage();
      }
    } on DioError catch (e) {
      _goLoginFirstPage();
    }
  }

  _goLoginFirstPage() {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginFirstPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF4FF),
        body: Center(
          child: SizedBox(
            height: 330,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/like_success.png',
                  height: 150,
                  width: 150,
                ),
                Text(
                  'ลงทะเบียนสมาชิก\nและยืนยันตัวตนสำเร็จ!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.action == 'create') {
                        // Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(
                        //     builder: (context) => const LoginFirstPage(),
                        //   ),
                        //   (Route<dynamic> route) => false,
                        // );
                        String accessToken = await _getTokenKeycloak(
                          username: _userData['email'],
                          password: _userData['password'],
                        );
                        // logWTF(accessToken);
                        // logWTF(response);
                        dynamic responseKeyCloak =
                            await _getUserInfoKeycloak(accessToken);
                        dynamic responseProfileMe =
                            await _getProfileMe(accessToken);

                        await ManageStorage.createSecureStorage(
                          value: accessToken,
                          key: 'accessToken',
                        );
                        await ManageStorage.createSecureStorage(
                          value: json.encode(responseKeyCloak),
                          key: 'loginData',
                        );
                        await ManageStorage.createSecureStorage(
                          value: json.encode(responseProfileMe['data']),
                          key: 'profileMe',
                        );
                        await ManageStorage.createProfile(
                          value: _userData,
                          key: _userData['category2'],
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const Menu(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const Menu(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
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
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
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
}
