import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'shared/config.dart';
import 'main.dart';
import 'shared/extension.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: _buildHead(),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Theme.of(context).custom.w_b_b,
        body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: const EdgeInsets.all(15.0),
            children: <Widget>[
              Text(
                'ระบุรหัสเก่า',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Kanit',
                  color: Theme.of(context).custom.b_w_y,
                ),
              ),
              SizedBox(height: 10),
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
                  suffixTap: () => setState(
                      () => _visibilityPasswordOld = !_visibilityPasswordOld),
                ),
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: Theme.of(context).custom.b_w_y,
                ),
                cursorColor: Theme.of(context).custom.b325f8_w_fffd57,
                validator: (value) {
                  var result = ValidateForm.password(value!);
                  return result == null ? null : result;
                },
              ),
              SizedBox(height: 10),
              Text(
                'กำหนดรหัสผ่านใหม่',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Kanit',
                  color: Theme.of(context).custom.b_w_y,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: txtPasswordNew,
                obscureText: _visibilityPasswordNew,
                inputFormatters: InputFormatTemple.password(),
                decoration: _decorationPasswordMember(
                  context,
                  labelText: 'รหัสผ่าน',
                  hintText:
                      'ตัวอักษร a-z, A-Z, 0-9 หรือ อักขระพิเศษ ขั้นต่ำ 6 ตัวอักษร',
                  visibility: _visibilityPasswordNew,
                  suffixTap: () => setState(
                      () => _visibilityPasswordNew = !_visibilityPasswordNew),
                ),
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: Theme.of(context).custom.b_w_y,
                ),
                cursorColor: Theme.of(context).custom.b325f8_w_fffd57,
                validator: (value) {
                  var result = ValidateForm.password(value!);
                  return result == null ? null : result;
                },
              ),
              SizedBox(height: 10),
              Text(
                'ยืนยันรหัสใหม่อีกครั้ง',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Kanit',
                  color: Theme.of(context).custom.b_w_y,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: txtPasswordNewConfirm,
                obscureText: _visibilityPasswordNewConfirm,
                inputFormatters: InputFormatTemple.password(),
                decoration: _decorationPasswordMember(
                  context,
                  labelText: 'รหัสผ่าน',
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
                cursorColor: Theme.of(context).custom.b325f8_w_fffd57,
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
                  GestureDetector(
                    onTap: () {
                      final form = _formKey.currentState;
                      if (form!.validate() && !_loadingSubmit) {
                        _submitUpdateUser();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'บันทึกข้อมูล',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
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
    );
  }

  Widget _buildHead() {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
        ],
      ),
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
            ? Color(0xFF7A4CB1)
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

  _dialogSuccess() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 127,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'เปลี่ยนรหัสผ่านสำเร็จ',
                    style: TextStyle(
                      color: Color(0xFF7A4CB1),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 95,
                      decoration: BoxDecoration(
                        color: Color(0xFF7A4CB1),
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
            '$server/de-api/m/register/reset/password',
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
