// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/forgot_password.dart';
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

class LoginSecondPage extends StatefulWidget {
  const LoginSecondPage({
    Key? key,
    required this.username,
    required this.imageUrl,
  }) : super(key: key);

  final String username;
  final String imageUrl;

  @override
  State<LoginSecondPage> createState() => _LoginSecondPageState();
}

class _LoginSecondPageState extends State<LoginSecondPage>
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
          onWillPop: () {
            _controller!.forward();
            return Future.value(false);
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_login_page.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: 490,
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 35,
                            ),
                            Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            if (_username!.isEmpty)
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
                            if (_username!.isNotEmpty) ...[
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.asset(
                                          'assets/images/bg_profile_login.png',
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      if (_imageUrl!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: CachedNetworkImage(
                                            imageUrl: _imageUrl!,
                                            width: 45,
                                            height: 45,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _username!,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          'สมาชิก',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF707070),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:
                                              Color.fromARGB(255, 255, 46, 46),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        'เปลี่ยน',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 255, 46, 46),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: txtPassword,
                                obscureText: passwordVisibility,
                                decoration: _decorationPasswordMember(context,
                                    hintText: 'รหัสผ่าน',
                                    visibility: passwordVisibility,
                                    suffixTap: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                }),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรอกรหัสผ่าน';
                                  }
                                  return null;
                                },
                              ),
                            ],
                            SizedBox(height: 10),
                            _buildButton(),
                            SizedBox(height: 30),
                            _buildOR(),
                            SizedBox(height: 25),
                            InkWell(
                              onTap: () => _callLoginLine(),
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
                            if (_username!.isEmpty) ...[
                              SizedBox(height: 35),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => RegisterPage(),
                                  ),
                                ),
                                child: Row(
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
                                    Text(
                                      'ต้องการสมัครสมาชิก',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFB325F8),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
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
          ),
        ),
      ),
    );
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

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgotPasswordPage(),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0x807A4CB1),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'ลืมรหัสผ่าน',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0x807A4CB1),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        InkWell(
          onTap: () {
            final form = _formKey.currentState;
            if (form!.validate()) {
              form.save();
              if (_username!.isEmpty) {
                _callUser();
              } else {
                _callLoginGuest();
              }
            }
            ;
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF7A4CB1),
            ),
            child: Text(
              'ดำเนินการต่อ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ],
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

  static InputDecoration _decorationPasswordMember(
    context, {
    String labelText = '',
    String hintText = '',
    bool visibility = false,
    Function? suffixTap,
  }) =>
      InputDecoration(
        label: Text(labelText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 8,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            suffixTap!();
          },
          child: visibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
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
    _username = widget.username;
    _imageUrl = widget.imageUrl;
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

      debugPrint('---> ${response.statusCode}');

      _loading = false;
      if (response.data['status'] == 'S') {
        List<dynamic> result = response.data['objectData'];
        if (result.length > 0) {
          setState(() {
            _username = txtEmail.text.trim();
            _imageUrl = response.data['objectData'][0]['imageUrl'] ?? '';
          });
          txtEmail.clear();
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

  void _callLoginGuest() async {
    _loading = true;
    var response = await Dio().post(
      'http://122.155.223.63/td-des-api/m/register/login',
      data: {
        'username': _username,
        'password': txtPassword.text.toString(),
      },
    );
    _loading = false;
    if (response.data['status'] == 'S') {
      FocusScope.of(context).unfocus();

      await ManageStorage.createProfile(
        value: response.data['objectData'],
        key: 'guest',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'รหัสผ่านไม่ถูกต้อง \nกรุณากรอกรหัสใหม่',
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
      var response = await dio.post(
        'http://122.155.223.63/td-des-api/m/v2/register/facebook/login',
        data: model,
      );

      await ManageStorage.createSecureStorage(
        key: 'imageUrlSocial',
        value:
            obj.user.photoURL != null ? obj.user.photoURL + "?width=9999" : '',
      );

      ManageStorage.createProfile(
        value: response.data['objectData'],
        key: 'facebook',
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

  void _callLoginLine() async {
    var obj = await loginLine();

    final idToken = obj.accessToken.idToken;
    final userEmail = (idToken != null)
        ? idToken['email'] != null
            ? idToken['email']
            : ''
        : '';

    if (obj != null) {
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
      var response = await dio.post(
        'http://122.155.223.63/td-des-api/m/v2/register/line/login',
        data: model,
      );

      await ManageStorage.createSecureStorage(
        key: 'imageUrlSocial',
        value: model['imageUrl'],
      );

      ManageStorage.createProfile(
        value: response.data['objectData'],
        key: 'line',
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

  // void _callLoginApple() async {
  //   var obj = await signInWithApple();

  //   var model = {
  //     "username": obj.user!.email ?? obj.user!.uid,
  //     "email": obj.user!.email ?? '',
  //     "imageUrl": '',
  //     "firstName": obj.user!.email,
  //     "lastName": '',
  //     "appleID": obj.user!.uid
  //   };

  //   Dio dio = new Dio();
  //   var response = await dio.post(
  //     'http://122.155.223.63/td-des-api/m/v2/register/apple/login',
  //     data: model,
  //   );

  //   ManageStorage.createProfile(
  //     value: response.data['objectData'],
  //     key: 'apple',
  //   );

  //   if (obj != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Menu(),
  //       ),
  //     );
  //   }
  // }
}
