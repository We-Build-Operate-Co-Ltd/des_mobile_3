import 'dart:convert';

import 'package:des/register.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/facebook_firebase.dart';
import 'package:des/shared/google_firebase.dart';
import 'package:des/shared/line.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/widget/input_decoration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_first.dart';
import 'main.dart';
import 'menu.dart';

class RegisterLinkAccountPage extends StatefulWidget {
  const RegisterLinkAccountPage({
    super.key,
    required this.email,
    required this.category,
    this.model,
  });

  final String email;
  final String category;
  final dynamic model;

  @override
  State<RegisterLinkAccountPage> createState() =>
      _RegisterLinkAccountPageState();
}

class _RegisterLinkAccountPageState extends State<RegisterLinkAccountPage> {
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _loadingSubmit = false;
  String _passwordStringValidate = '';
  bool _visibilityPassword = true;

  @override
  void initState() {
    _passwordController = TextEditingController(text: '');
    logWTF(widget.email);
    logWTF(widget.category);
    logWTF(widget.model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Container(
            height: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  MyApp.themeNotifier.value == ThemeModeThird.light
                      ? "assets/images/BG.png"
                      : "",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                // color: Colors.white,
                height: 700,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            switch (widget.category) {
                              case 'facebook':
                                logoutFacebook();
                                break;
                              case 'google':
                                logoutGoogle();
                                break;
                              case 'line':
                                logoutLine();
                                break;
                              default:
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 35.0,
                            height: 35.0,
                            margin: EdgeInsets.all(5),
                            child: Image.asset(
                              'assets/images/back_profile.png',
                              // color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'เชื่อมต่อบัญชี ${widget.category}',
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
                      padding: EdgeInsets.only(left: 55),
                      child: Text(
                        'ระบบกำลังเชื่อมต่อบัญช ${widget.category} \nกับอีเมล ${widget.email} \nกรุณากรอกรหัสผ่านเพื่อเข้าสู่ระบบ',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFeildPassword(
                      controller: _passwordController,
                      hint: 'รหัสผ่าน',
                      inputFormatters: InputFormatTemple.password(),
                      validateString: _passwordStringValidate,
                      visibility: _visibilityPassword,
                      suffixTap: () {
                        setState(() {
                          _visibilityPassword = !_visibilityPassword;
                        });
                      },
                      validator: (value) {
                        var result = ValidateForm.password(value!);
                        setState(() {
                          _passwordStringValidate = result ?? '';
                        });
                        return result == null ? null : '';
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.46),
                    GestureDetector(
                      onTap: () => _submit(),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFB325F8),
                          // _loadingSubmit
                          //     ? Theme.of(context).primaryColor.withOpacity(0.8)
                          //     : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(23),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x40F3D2FF),
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            const Text(
                              'ยืนยัน',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            if (_loadingSubmit)
                              const Positioned.fill(
                                child: Center(
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator()),
                                ),
                              ),
                          ],
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

  Widget _buildFeildPassword({
    required TextEditingController controller,
    String hint = '',
    Function(String?)? validator,
    String validateString = '',
    bool visibility = false,
    List<TextInputFormatter>? inputFormatters,
    Function? suffixTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x40F3D2FF),
                offset: Offset(0, 4),
              )
            ],
          ),
          child: TextFormField(
            obscureText: visibility,
            controller: controller,
            style: const TextStyle(fontSize: 14),
            onEditingComplete: () => FocusScope.of(context).unfocus(),
            decoration: CusInpuDecoration.password(
              context,
              hintText: hint,
              visibility: visibility,
              suffixTap: suffixTap,
            ),
            inputFormatters: inputFormatters,
            validator: (String? value) => validator!(value),
          ),
        ),
        if (validateString.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 3),
            child: Text(
              validateString,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.red,
              ),
            ),
          )
      ],
    );
  }

  _submit() async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    logWTF('submit');
    if (form!.validate() && !_loadingSubmit) {
      form.save();
      try {
        setState(() => _loadingSubmit = true);
        String accessToken = await _getTokenKeycloak(
          username: widget.email,
          password: _passwordController.text,
        );
        logWTF('accessToken');
        logWTF('${widget.email} ${_passwordController.text}');
        logWTF(accessToken);
        if (accessToken == 'invalid_grant') {
          logWTF('password fail');
          Fluttertoast.showToast(msg: 'รหัสผ่านไม่ถูกต้อง');
          setState(() => _loadingSubmit = false);
          return;
          // กรอกรหัสผ่าน
        }

        logWTF('responseProfileMe');
        dynamic responseProfileMe = await _getProfileMe(accessToken);
        // check isMember
        // if (responseProfileMe['data']['isMember'] == 0) {
        //   Fluttertoast.showToast(msg: 'บัญชีนี้เป็นเจ้าหน้าที่');
        //   setState(() => _loadingSubmit = false);
        //   return;
        // }
        logWTF('${responseProfileMe}');
        var param = {
          'username': widget.email,
          'password': _passwordController.text,
          'lineID': widget.model?['lineID'] ?? '',
          'googleID': widget.model?['googleID'] ?? '',
          'xID': widget.model?['xID'] ?? '',
          'facebookID': widget.model?['facebookID'] ?? '',

        //   'firstName': responseProfileMe?['data']?['firstnameTh'] ?? '',
        //  'lastName': responseProfileMe?['data']?['lastnameTh'] ?? '',
        //  'idcard': responseProfileMe?['data']?['idcard'] ?? '',
        //  'email': responseProfileMe?['data']?['email'] ?? '',
        //  'phone': responseProfileMe?['data']?['phonenumber'] ?? '',
        //  'ageRange': responseProfileMe?['data']?['ageRange'] ?? '',
        };
        logWTF(param);
        Response response = await Dio().post(
          '$server/dcc-api/m/register/link/socialaccount',
          data: param,
        );
        logWTF(response);
        setState(() => _loadingSubmit = false);
        if (response.data['status'] == 'S') {
          _callLoginSocial();
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(
          //     builder: (context) => const LoginFirstPage(),
          //   ),
          //   (Route<dynamic> route) => false,
          // );
        } else {
          setState(() => _loadingSubmit = false);
          Fluttertoast.showToast(msg: response.data['message']);
          //error
        }
      } catch (e) {
        // logE(e);
        setState(() => _loadingSubmit = false);
        Fluttertoast.showToast(msg: 'error $e');
      }
    }
  }

  void _callLoginSocial() async {
    setState(() => _loadingSubmit = true);
    logWTF('_callLoginSocial');
    try {
      Response response = await Dio().post(
        '$server/dcc-api/m/v2/register/social/login',
        data: widget.model,
      );
      // logWTF(response.data);
      if (response.data['status'] != 'S') {
        setState(() => _loadingSubmit = false);
        return null;
      }

      logWTF('token');
      String accessToken = await _getTokenKeycloak(
        username: response.data['objectData']['email'],
        password: response.data['objectData']['password'],
      );

      // logWTF(response);
      logWTF('responseKeyCloak');
      dynamic responseKeyCloak = await _getUserInfoKeycloak(accessToken);
      logWTF('responseProfileMe');
      dynamic responseProfileMe = await _getProfileMe(accessToken);
      if (responseKeyCloak == null || responseProfileMe == null) {
        setState(() => _loadingSubmit = false);
        // Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
        return;
      }

      // check isMember
      // if (responseProfileMe['data']['isMember'] == 0) {
      //   Fluttertoast.showToast(msg: 'บัญชีนี้เป็นเจ้าหน้าที่');
      //   return;
      // }

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
        value: response.data['objectData'],
        key: 'guest',
      );

      setState(() => _loadingSubmit = false);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Menu(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      logE('login social catch');
      logE(e);
      setState(() => _loadingSubmit = false);
      Fluttertoast.showToast(msg: 'ยกเลิก');
    }
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
        // logE(response.data);
        // Fluttertoast.showToast(msg: response.data['error_de d////  scription']);
        // setState(() => _loadingSubmit = false);
        return response.data['error'];
        return response.data['error_description'];
      }
    } on DioError catch (e) {
      logE(e.error);
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data.toString();
      }
      // Fluttertoast.showToast(msg: err);
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
        logE(response.data);
        Fluttertoast.showToast(msg: response.data['error_description']);
        setState(() => _loadingSubmit = false);
        return null;
      }
    } on DioError catch (e) {
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data.toString();
      }
      Fluttertoast.showToast(msg: err);
      return null;
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
        logE(response.data);
        Fluttertoast.showToast(msg: response.data['title']);
        setState(() => _loadingSubmit = false);
        return null;
      }
    } on DioError catch (e) {
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data['title'].toString();
      }
      Fluttertoast.showToast(msg: err);
      return null;
    }
  }

  dynamic _getUser() async {
    try {
      Response response = await Dio().post(
        '$server/dcc-api/m/register/login',
        data: {
          'username': widget.email,
          'password': _passwordController.text,
          'category': 'face',
        },
      );
      setState(() => _loadingSubmit = false);
      logWTF(response.data);
      if (response.data['status'] == 'S') {
        return response.data['objectData'];
      }
      return null;
    } on DioError catch (e) {
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data['title'].toString();
      }
      Fluttertoast.showToast(msg: err);
      return null;
    }
  }
}
