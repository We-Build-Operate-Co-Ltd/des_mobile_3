// ignore_for_file: unnecessary_null_comparison

import 'package:des/forgot_password.dart';
import 'package:des/login_second.dart';
import 'package:des/menu.dart';
import 'package:des/register.dart';
import 'package:des/shared/apple_firebase.dart';
import 'package:des/shared/google_firebase.dart';
import 'package:des/shared/line.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/facebook_firebase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginFirstPage extends StatefulWidget {
  const LoginFirstPage({Key? key}) : super(key: key);

  @override
  State<LoginFirstPage> createState() => _LoginFirstPageState();
}

class _LoginFirstPageState extends State<LoginFirstPage>
    with SingleTickerProviderStateMixin {
  String? _username = '';
  String? _imageUrl = '';
  String? _category;
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final Duration duration = const Duration(milliseconds: 200);
  AnimationController? _controller;
  bool passwordVisibility = true;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool openLine = false;
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: () => confirmExit(),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_login_page.png"),
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
                    height: 535,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: ClampingScrollPhysics(),
                        children: [
                          // Image.asset(
                          //   'assets/images/logo.png',
                          //   height: 35,
                          //   alignment: Alignment.centerLeft,
                          // ),
                          Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: txtEmail,
                            decoration: _decorationRegisterMember(
                              context,
                              hintText: 'อีเมล',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรอกอีเมล';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage(),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child: Text(
                                'ลืมรหัสผ่าน',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF7A4CB1),
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                _callUser();
                              }
                            },
                            child: _buildButtonLogin(
                              '',
                              'ดำเนินการต่อ',
                              color: Color(0xFF7A4CB1),
                              colorTitle: Color(0xFFFFFFFF),
                            ),
                          ),
                          SizedBox(height: 30),
                          _buildOR(),
                          SizedBox(height: 25),
                          InkWell(
                            onTap: () {
                              if (!openLine) {
                                openLine = true;
                                _callLoginLine();
                              }
                            },
                            child: _buildButtonLogin(
                              'assets/images/line_circle.png',
                              'เข้าใช้ผ่าน Line',
                              color: Color(0xFF06C755),
                              colorTitle: Color(0xFFFFFFFF),
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () => _callLoginFacebook(),
                            child: _buildButtonLogin(
                              'assets/images/logo_facebook_login_page.png',
                              'เข้าใช้ผ่าน Facebook',
                              color: Color(0xFF227BEF),
                              colorTitle: Color(0xFFFFFFFF),
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () => _callLoginGoogle(),
                            child: _buildButtonLogin(
                              'assets/images/logo_google_login_page.png',
                              'เข้าใช้ผ่าน Google',
                              colorBorder: Color(0xFFE4E4E4),
                            ),
                          ),
                          SizedBox(height: 35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ท่านเป็นผู้ใช้ใหม่',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => RegisterPage(),
                                  ),
                                ),
                                child: Text(
                                  'ต้องการสมัครสมาชิก',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFB325F8),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_loading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    debugPrint('current ${currentBackPressTime.toString()}');
    debugPrint('now ${now.toString()}');
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'กดอีกครั้งเพื่อออก');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildButtonLogin(
    String image,
    String title, {
    Color colorBorder = Colors.transparent,
    Color colorTitle = const Color(0xFF000000),
    Color color = Colors.transparent,
  }) {
    return Container(
      height: 45,
      // padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorBorder,
        ),
        borderRadius: BorderRadius.circular(25),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image.isNotEmpty)
            Image.asset(
              image,
              height: 25,
            ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colorTitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOR() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Color(0x4D707070),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'หรือ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Color(0xFF707070),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Color(0x4D707070),
          ),
        ),
      ],
    );
  }

  static InputDecoration _decorationRegisterMember(context,
          {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  // login guest -----

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    super.initState();
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  void _callUser() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _category = 'guest';
    });
    if (txtEmail.text.isEmpty && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'กรุณากรอกชื่อผู้ใช้',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(" "),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      _loading = true;
      Response<dynamic> response;
      try {
        response = await Dio()
            .post('http://122.155.223.63/td-des-api/m/register/read', data: {
          'username': txtEmail.text.trim(),
          'category': _category.toString(),
        });
      } catch (ex) {
        setState(() {
          _loading = false;
        });
        Fluttertoast.showToast(msg: 'error');
        return null;
      }

      setState(() {
        _loading = false;
      });
      if (response.data['status'] == 'S') {
        List<dynamic> result = response.data['objectData'];
        if (result.length > 0) {
          setState(() {
            _username = txtEmail.text.trim();
            _imageUrl = response.data['objectData'][0]['imageUrl'] ?? '';
          });
          txtEmail.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  LoginSecondPage(username: _username!, imageUrl: _imageUrl!),
            ),
          );
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Text(
                'ชื่อผู้ใช้งาน ไม่พบในระบบ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF000070),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    new TextEditingController().clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      } else {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    }
  }

  void _callLoginFacebook() async {
    var obj = await signInWithFacebook();
    if (obj != null) {
      var model = {
        "username": obj.user.email,
        "email": obj.user.email,
        "imageUrl":
            obj.user.photoURL != null ? obj.user.photoURL + "?width=9999" : '',
        "firstName": obj.user.displayName,
        "lastName": '',
        "facebookID": obj.user.uid
      };

      Dio dio = new Dio();
      try {
        var response = await dio.post(
          'http://122.155.223.63/td-des-api/m/v2/register/facebook/login',
          data: model,
        );

        await ManageStorage.createSecureStorage(
          key: 'imageUrlSocial',
          value: obj.user.photoURL != null
              ? obj.user.photoURL + "?width=9999"
              : '',
        );

        await ManageStorage.createProfile(
          value: response.data['objectData'],
          key: 'facebook',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  void _callLoginGoogle() async {
    var obj = await signInWithGoogle();

    print('---signInWithGoogle---' + obj.toString());

    if (obj != null) {
      var model = {
        "username": obj.user!.email,
        "email": obj.user!.email,
        "imageUrl": obj.user!.photoURL ?? '',
        "firstName": obj.user!.displayName,
        "lastName": '',
        "googleID": obj.user!.uid
      };

      Dio dio = new Dio();
      try {
        var response = await dio.post(
          'http://122.155.223.63/td-des-api/m/v2/register/google/login',
          data: model,
        );

        await ManageStorage.createSecureStorage(
          key: 'imageUrlSocial',
          value: obj.user!.photoURL != null ? obj.user!.photoURL : '',
        );

        ManageStorage.createProfile(
          value: response.data['objectData'],
          key: 'google',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  void _callLoginLine() async {
    var obj = await loginLine();
    openLine = false;

    if (obj != null) {
      final idToken = obj.accessToken.idToken;
      final userEmail = (idToken != null)
          ? idToken['email'] != null
              ? idToken['email']
              : ''
          : '';
      var model = {
        "username": (userEmail != '' && userEmail != null)
            ? userEmail
            : obj.userProfile!.userId,
        "email": userEmail,
        "imageUrl": (obj.userProfile!.pictureUrl != '' &&
                obj.userProfile!.pictureUrl != null)
            ? obj.userProfile!.pictureUrl
            : '',
        "firstName": obj.userProfile!.displayName,
        "lastName": '',
        "lineID": obj.userProfile!.userId
      };

      Dio dio = new Dio();
      try {
        var response = await dio.post(
          'http://122.155.223.63/td-des-api/m/v2/register/line/login',
          data: model,
        );

        await ManageStorage.createSecureStorage(
          key: 'imageUrlSocial',
          value: model['imageUrl'],
        );

        await ManageStorage.createProfile(
          value: response.data['objectData'],
          key: 'line',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  void _callLoginApple() async {
    var obj = await signInWithApple();

    var model = {
      "username": obj.user!.email ?? obj.user!.uid,
      "email": obj.user!.email ?? '',
      "imageUrl": '',
      "firstName": obj.user!.email,
      "lastName": '',
      "appleID": obj.user!.uid
    };

    Dio dio = new Dio();
    var response = await dio.post(
      'http://122.155.223.63/td-des-api/m/v2/register/apple/login',
      data: model,
    );

    ManageStorage.createProfile(
      value: response.data['objectData'],
      key: 'apple',
    );

    if (obj != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
      );
    }
  }
}
