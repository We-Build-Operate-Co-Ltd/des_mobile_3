import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/about_us_bk.dart';
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
import 'package:des/user_profile_change_password.dart';
import 'package:des/user_profile_edit_bk.dart';
import 'package:des/verify_main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'about_us.dart';
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
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      body: GestureDetector(
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
                  image: AssetImage("assets/images/BG.png"),
                  fit: BoxFit.cover,
                  colorFilter: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? null
                      : ColorFilter.mode(Colors.grey, BlendMode.saturation),
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
                    children: [
                      _buildHead(),
                      const SizedBox(height: 30),
                      _buildRowAboutAccount(),
                      const SizedBox(height: 30),
                      _buildRowHelp(),
                      const SizedBox(height: 70),
                      Center(
                        child: GestureDetector(
                          onTap: () => logout(),
                          child: Container(
                            height: MyApp.fontKanit.value == FontKanit.small
                                ? 40
                                : MyApp.fontKanit.value == FontKanit.medium
                                    ? 45
                                    : 50,
                            width: MyApp.fontKanit.value == FontKanit.small
                                ? 145
                                : MyApp.fontKanit.value == FontKanit.medium
                                    ? 185
                                    : 225,
                            decoration: BoxDecoration(
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
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
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Color(0xFFB325F8)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
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
                          ),
                        ),
                      ),
                      //
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
        lineBottom(),
        InkWell(
          child: _buildRow('เกี่ยวกับ'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AboutUsPage(),
            ),
          ),
        ),
        lineBottom(),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Container(
                child: WebViewInAppPage(
                  url: 'https://decms.dcc.onde.go.th/privacy-policy/pp.html',
                  title: 'นโยบาย',
                ),
              ),
            ),
          ),
          child: _buildRow('นโยบาย'),
        ),
        lineBottom(),
      ],
    );
  }

  Future<String?> getProfileCategory() async {
    return await ManageStorage.read('profileCategory') as String?;
  }

  Widget _buildRowAboutAccount() {
    return FutureBuilder<String?>(
      future: getProfileCategory(),
      builder: (context, snapshot) {
        final profileCategory = snapshot.data ?? '';
        final showChangePassword = profileCategory == 'guest';
        // print('=========111111=======> ${profileCategory}');

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
            if (showChangePassword)
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => UserProfileChangePasswordPage(),
                    ),
                  );
                },
                child: _buildRow('เปลี่ยนรหัสผ่าน'),
              ),
            if (showChangePassword) lineBottom(),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {
                _dialogDeleteAccount();
              },
              child: _buildRow('ขอลบบัญชี'),
            ),
            lineBottom(),
          ],
        );
      },
    );
  }

  Widget _buildRow(String title) {
    return Container(
      color: Theme.of(context).custom.w_b_b,
      padding: EdgeInsets.symmetric(horizontal: 10),
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
            // padding: EdgeInsets.all(5),
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
              MyApp.themeNotifier.value == ThemeModeThird.light
                  ? 'assets/images/back_arrow.png'
                  : "assets/images/2024/back_balckwhite.png",
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: Text(
            'ตั้งค่า',
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
        ),
      ],
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
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'คุณต้องการขอลบบัญชีหรือไม่',
                            style: TextStyle(
                              color: Color(0xFFB325F8),
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
                                  width: 120,
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
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFB325F8),
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

  // _dialogDeleteAccountSuccess() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) => StatefulBuilder(
  //       builder: (BuildContext context, StateSetter mSetState) {
  //         return WillPopScope(
  //           onWillPop: () => Future.value(false),
  //           child: Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             elevation: 0,
  //             child: Padding(
  //               padding: const EdgeInsets.all(20.0),
  //               child: SizedBox(
  //                 height: 127,
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Image.asset(
  //                       'assets/images/check_purple.png',
  //                       height: 40,
  //                     ),
  //                     Text(
  //                       'ยื่นขอยกเลิกบัญชีสำเร็จ',
  //                       style: TextStyle(
  //                         color: Color(0xFF7A4CB1),
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                     SizedBox(height: 10),
  //                     GestureDetector(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Container(
  //                         height: 40,
  //                         width: 95,
  //                         decoration: BoxDecoration(
  //                           color: Color(0xFF7A4CB1),
  //                           borderRadius: BorderRadius.circular(25),
  //                         ),
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           'ตกลง',
  //                           style: TextStyle(
  //                             fontSize: 15,
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
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
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 210,
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
                        'ยื่นขอยกเลิกบัญชีสำเร็จ!',
                        style: TextStyle(
                          color: Color(0xFF19AA6A),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'ยื่นขอยกเลิกบัญชีของคุณเรียบร้อยแล้ว',
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
                          width: 230,
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

  lineBottom() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1.0,
          ),
        ),
      ),
    );
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
