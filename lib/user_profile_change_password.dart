import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'shared/config.dart';
import 'main.dart';
import 'shared/extension.dart';

class UserProfileChangePasswordPage extends StatefulWidget {
  UserProfileChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<UserProfileChangePasswordPage> createState() =>
      _UserProfileChangePasswordPageState();
}

class _UserProfileChangePasswordPageState
    extends State<UserProfileChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  bool _loadingSubmit = false;
  bool passwordVisibility = true;

  late bool _visibilityPasswordOld;
  late bool _visibilityPasswordNew;
  late bool _visibilityPasswordNewConfirm;

  final txtPasswordOld = TextEditingController();
  final txtPasswordNew = TextEditingController();
  final txtPasswordNewConfirm = TextEditingController();

  @override
  void initState() {
    _visibilityPasswordOld = true;
    _visibilityPasswordNew = true;
    _visibilityPasswordNewConfirm = true;
    super.initState();
  }

  @override
  void dispose() {
    txtPasswordOld.dispose();
    txtPasswordNew.dispose();
    txtPasswordNewConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).custom.w_b_b,
        body: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  height: 1000,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/new_bg.png"),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      // height:  MediaQuery.of(context).size.height * .650,
                      height: deviceHeight * 0.8,
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.white
                            : Colors.black,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          _buildHead(),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: txtPasswordOld,
                            obscureText: _visibilityPasswordOld,
                            inputFormatters: InputFormatTemple.password(),
                            decoration: _decorationPasswordMember(
                              context,
                              labelText: 'รหัสผ่าน',
                              hintText:
                                  'ตัวอักษร a-z, A-Z, 0-9 หรือ อักขระพิเศษ ขั้นต่ำ 6 ตัวอักษร',
                              visibility: _visibilityPasswordOld,
                              suffixTap: () => setState(() =>
                                  _visibilityPasswordOld =
                                      !_visibilityPasswordOld),
                            ),
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: Theme.of(context).custom.b_w_y,
                            ),
                            cursorColor:
                                Theme.of(context).custom.b325f8_w_fffd57,
                            validator: (value) {
                              var result = ValidateForm.password(value!);
                              return result == null ? null : result;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: txtPasswordNew,
                            obscureText: _visibilityPasswordNew,
                            inputFormatters: InputFormatTemple.password(),
                            decoration: _decorationPasswordMember(
                              context,
                              labelText: 'กำหนดรหัสผ่านใหม่',
                              hintText:
                                  'ตัวอักษร a-z, A-Z, 0-9 หรือ อักขระพิเศษ ขั้นต่ำ 6 ตัวอักษร',
                              visibility: _visibilityPasswordNew,
                              suffixTap: () => setState(() =>
                                  _visibilityPasswordNew =
                                      !_visibilityPasswordNew),
                            ),
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: Theme.of(context).custom.b_w_y,
                            ),
                            cursorColor:
                                Theme.of(context).custom.b325f8_w_fffd57,
                            validator: (value) {
                              var result = ValidateForm.password(value!);
                              return result == null ? null : result;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: txtPasswordNewConfirm,
                            obscureText: _visibilityPasswordNewConfirm,
                            inputFormatters: InputFormatTemple.password(),
                            decoration: _decorationPasswordMember(
                              context,
                              labelText: 'ยืนยันรหัสผ่านใหม่',
                              hintText:
                                  'ตัวอักษร a-z, A-Z, 0-9 หรือ อักขระพิเศษ ขั้นต่ำ 6 ตัวอักษร',
                              visibility: _visibilityPasswordNewConfirm,
                              suffixTap: () => setState(() =>
                                  _visibilityPasswordNewConfirm =
                                      !_visibilityPasswordNewConfirm),
                            ),
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: Theme.of(context).custom.b_w_y,
                            ),
                            cursorColor:
                                Theme.of(context).custom.b325f8_w_fffd57,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณากรอกยืนยันรหัสผ่าน.';
                              } else if (txtPasswordNew.text !=
                                  txtPasswordNewConfirm.text) {
                                return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          Stack(
                            children: [
                              if (_loadingSubmit)
                                Positioned.fill(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      final form = _formKey.currentState;
                      if (form!.validate() && !_loadingSubmit) {
                        _submitUpdateUser();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFB325F8)
                            : Colors.black,
                        border: Border.all(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFB325F8)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                        borderRadius: BorderRadius.circular(22.5),
                      ),
                      child: Text(
                        'บันทึกข้อมูล',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.white
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          fontSize: 16,
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

  Widget _buildHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 35,
            width: 35,
            // padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //     color: MyApp.themeNotifier.value == ThemeModeThird.light
            //         ? Color(0xFFB325F8)
            //         : Colors.black,
            //     border: Border.all(
            //       width: 1,
            //       style: BorderStyle.solid,
            //       color: MyApp.themeNotifier.value == ThemeModeThird.light
            //           ? Color(0xFFB325F8)
            //           : MyApp.themeNotifier.value == ThemeModeThird.dark
            //               ? Colors.white
            //               : Color(0xFFFFFD57),
            //     )),
            child: Image.asset(
              'assets/images/back_arrow.png',
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          'เปลี่ยนรหัสผ่าน',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w500,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFB325F8)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
      ],
    );
  }

  static InputDecoration _decorationPasswordMember(
    context, {
    String labelText = '',
    String hintText = '',
    bool visibility = false,
    Function? suffixTap,
  }) =>
      InputDecoration(
        label: Text(labelText),
        labelStyle: TextStyle(
          color: Theme.of(context).custom.f70f70_w_fffd57,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: Theme.of(context).custom.f70f70_w_fffd57,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintText: hintText,
        suffixIcon: GestureDetector(
          onTap: () {
            suffixTap!();
          },
          child: visibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
        suffixIconColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Color(0xFFB325F8)
            : MyApp.themeNotifier.value == ThemeModeThird.dark
                ? Colors.white
                : Color(0xFFFFFD57),
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

  // _dialogSuccess() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) => WillPopScope(
  //       onWillPop: () => Future.value(false),
  //       child: Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         elevation: 0,
  //         child: Padding(
  //           padding: const EdgeInsets.all(20.0),
  //           child: SizedBox(
  //             height: 127,
  //             width: MediaQuery.of(context).size.width,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   'เปลี่ยนรหัสผ่านสำเร็จ',
  //                   style: TextStyle(
  //                     color: Color(0xFF7A4CB1),
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 Text(
  //                   '',
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: 10),
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Container(
  //                     height: 40,
  //                     width: 95,
  //                     decoration: BoxDecoration(
  //                       color: Color(0xFF7A4CB1),
  //                       borderRadius: BorderRadius.circular(25),
  //                     ),
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       'ตกลง',
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  _dialogSuccess() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter mSetState) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 230,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/update_success.png',
                        height: 80,
                        width: 80,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'เปลี่ยนรหัสผ่านสำเร็จ!',
                        style: TextStyle(
                          color: Color(0xFF19AA6A),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'บันทึกรหัสผ่านที่คุณแก้ไขเรียบร้อยแล้ว',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Color(0xFFB325F8),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'ตกลง',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> _submitUpdateUser() async {
    try {
      setState(() => _loadingSubmit = true);
      var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
      profileMe['email'];

      var accessToken = await _getTokenKeycloak(
          username: profileMe['email'], password: txtPasswordOld.text);
      logWTF(accessToken);
      if (accessToken == null) {
        Fluttertoast.showToast(msg: 'รหัสผ่านไม่ถูกต้อง');
        return;
      } else {
        _send();
      }
    } catch (e) {
      logE(e);
      setState(() => _loadingSubmit = false);
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
        setState(() => _loadingSubmit = false);
        return null;
      }
    } on DioError catch (e) {
      logE(e.error);
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data.toString();
      }
      Fluttertoast.showToast(msg: err);
      return null;
    }
  }

  _send() async {
    try {
      var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
      setState(() => _loadingSubmit = true);
      // update password
      Response response = await Dio().post(
        '$ondeURL/api/user/resetpassword',
        data: {
          'email': profileMe['email'],
          'password': txtPasswordNew.text,
        },
      );

      if (response.statusCode == 200) {
        logWTF(response.data);
        if (response.data) {
          logWTF('success');
          await Dio().post(
            '$server/dcc-api/m/register/reset/password',
            data: {
              'email': profileMe['email'],
              'password': txtPasswordNew.text,
            },
          );

          setState(() => _loadingSubmit = false);
          if (!mounted) return;
          _dialogSuccess();
          return;
        }
      }
      setState(() => _loadingSubmit = false);
      logE(response.data);
      Fluttertoast.showToast(msg: response.data?['title'] ?? 'ลองใหม่อีกครั้ง');
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
