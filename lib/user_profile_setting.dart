import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/about_us.dart';
import 'package:des/change_password.dart';
import 'package:des/login_first.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/dcc.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/facebook_firebase.dart';
import 'package:des/shared/google_firebase.dart';
import 'package:des/shared/line.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/user_profile_edit.dart';
import 'package:des/verify_main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'chat_botnoi.dart';
import 'main.dart';
import 'webview_inapp.dart';

class UserProfileSettingPage extends StatefulWidget {
  const UserProfileSettingPage({Key? key}) : super(key: key);

  @override
  State<UserProfileSettingPage> createState() => _UserProfileSettingPageState();
}

class _UserProfileSettingPageState extends State<UserProfileSettingPage> {
  final storage = const FlutterSecureStorage();
  String _imageProfile = '';
  String _firstName = '';
  String _lastName = '';
  String profileCode = '';
  bool _hasThaiD = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 25,
          right: 15,
          left: 15,
        ),
        children: [
          _buildHead(),
          const SizedBox(height: 15),
          _buildUserDetail(),
          const SizedBox(height: 40),
          _buildRowAboutAccount(),
          const SizedBox(height: 40),
          // _buildRowNotifications(),
          // const SizedBox(height: 40),
          _buildRowHelp(),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => _dialogDeleteAccount(),
              child: Text(
                'ขอลบบัญชี',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SizedBox(height: 70),
          Center(
            child: GestureDetector(
              onTap: () => logout(),
              child: Container(
                height: 32,
                width: 145,
                decoration: BoxDecoration(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8).withOpacity(0.10)
                      : Color(0xFF292929),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logout.png',
                      height: 18.75,
                      width: 15,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFB325F8)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'ออกจากระบบ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFB325F8)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  Widget _buildRowHelp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ช่วยเหลือ',
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatBotNoiPage(),
              // builder: (context) => ChatPage(),
            ),
          ),
          child: _buildRow('ศูนย์ช่วยเหลือ'),
        ),
        // const SizedBox(height: 10),
        InkWell(
          child: _buildRow('เกี่ยวกับ'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AboutUsPage(),
            ),
          ),
        ),
        // const SizedBox(height: 10),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WebViewInAppPage(
                url: 'https://decms.dcc.onde.go.th/privacy-policy/pp.html',
                title: 'นโยบาย',
              ),
            ),
          ),
          child: _buildRow('นโยบาย'),
        ),
      ],
    );
  }

  Widget _buildRowNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'การแจ้งเตือน',
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        const SizedBox(height: 5),
        _buildRow('ตั้งค่าการแจ้งเตือน'),
        // const SizedBox(height: 10),
        _buildRow('ตั้งค่าความเป็นส่วนตัว'),
      ],
    );
  }

  Widget _buildRowAboutAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เกี่ยวกับบัญชี',
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileEditPage(),
              ),
            );
          },
          child: _buildRow('แก้ไขโปรไฟล์'),
        ),
        // const SizedBox(height: 25),
        if (!_hasThaiD)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => const VerifyMainPage(),
              ),
            ),
            child: _buildRow('ยืนยันตัวตน'),
          ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => ChangePasswordPage(),
              ),
            );
          },
          child: _buildRow('เปลี่ยนรหัสผ่าน'),
        ),
      ],
    );
  }

  Widget _buildRow(String title) {
    return Container(
      color: Theme.of(context).custom.w_b_b,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w400,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.black
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
          Image.asset(
            'assets/images/go.png',
            height: 11,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ],
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      color: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      child: Column(
        children: [
          const SizedBox(height: 13),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
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
        ],
      ),
    );
  }

  Widget _buildUserDetail() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserProfileEditPage(),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.memory(
                  base64Decode(_imageProfile),
                  fit: BoxFit.cover,
                  height: 120,
                  width: 120,
                  errorBuilder: (_, __, ___) => Image.asset(
                    "assets/images/profile_empty.png",
                    fit: BoxFit.fill,
                  ),
                ),
              )),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          _firstName ?? '',
                          style: TextStyle(
                            fontSize: 20,
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
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          _lastName ?? '',
                          style: TextStyle(
                            fontSize: 20,
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
                      ],
                    ),
                  ],
                ),
                Text(
                  'แก้ไขโปรไฟล์',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _dialogDeleteAccount() {
    bool loadingC = false;
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
                child: Stack(
                  children: [
                    SizedBox(
                      height: 127,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'คุณต้องการขอลบบัญชีหรือไม่',
                            style: TextStyle(
                              color: Color(0xFF7A4CB1),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'การขอลบบัญชี ระบบจะทำการยกเลิกบัญชี ให้ภายใน 30 วัน',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    mSetState(() => loadingC = true);
                                    await _requestDeleteAccount();
                                    mSetState(() => loadingC = false);
                                    Navigator.pop(context);
                                    _dialogDeleteAccountSuccess();
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: 'ลองใหม่อีกครั้ง');
                                    mSetState(() => loadingC = false);
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 95,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF707070),
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
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  logWTF('test');
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
                                    'ยกเลิก',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    if (loadingC)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF707070).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _dialogDeleteAccountSuccess() {
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
                  height: 127,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/check_purple.png',
                        height: 40,
                      ),
                      Text(
                        'ยื่นขอยกเลิกบัญชีสำเร็จ',
                        style: TextStyle(
                          color: Color(0xFF7A4CB1),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
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
          );
        },
      ),
    );
  }

  _requestDeleteAccount() async {
    try {
      var profileMe = await ManageStorage.readDynamic('profileMe');
      var pf = await ManageStorage.read('profileCode$version') ?? '';
      var data = {
        'profileCode': pf,
        'uuid': profileMe['uuid'],
        "userid": profileMe['userid'],
        "firstName": profileMe['firstnameTh'],
        "lastName": profileMe['lastnameTh'],
        "email": profileMe['email'],
        "role": profileMe['role'],
        "isVerify": profileMe['isVerify'],
        "isMember": profileMe['isMember'],
        "isStaff": profileMe['isStaff'],
        "lmsUserId": profileMe['lmsUserId'],
      };
      Response response = await Dio()
          .post('$server/dcc-api/m/register/delete/account', data: data);
      logE(response.data);

      // setState(() => _loadingSubmit = false);
    } on DioError catch (e) {
      logE(e.toString());
      // setState(() => _loadingSubmit = false);
      Fluttertoast.showToast(msg: e.response!.data['message']);
    }
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getUser() async {
    var proflieMe = await ManageStorage.readDynamic('profileMe') ?? '';
    setState(() {
      _hasThaiD = proflieMe?['isVerify'] == 1 ? true : false;
      _firstName = proflieMe['firstnameTh'];
      _lastName = proflieMe['lastnameTh'];
    });
    var img = await DCCProvider.getImageProfile();
    setState(() => _imageProfile = img);
  }

  void logout() async {
    String profileCategory = await ManageStorage.read('profileCategory') ?? '';
    switch (profileCategory) {
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
    await ManageStorage.deleteStorageAll();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginFirstPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
