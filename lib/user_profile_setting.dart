import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/about_us.dart';
import 'package:des/login_first.dart';
import 'package:des/shared/facebook_firebase.dart';
import 'package:des/shared/google_firebase.dart';
import 'package:des/shared/line.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/user_profile_edit.dart';
import 'package:des/verify_first_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'main.dart';

class UserProfileSettingPage extends StatefulWidget {
  const UserProfileSettingPage({Key? key}) : super(key: key);

  @override
  State<UserProfileSettingPage> createState() => _UserProfileSettingPageState();
}

class _UserProfileSettingPageState extends State<UserProfileSettingPage> {
  final storage = const FlutterSecureStorage();
  String? _imageUrl = '';
  String? _firstName = '';
  String? _lastName = '';
  String? profileCode = '';

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
          _buildRowNotifications(),
          const SizedBox(height: 40),
          _buildRowHelp(),
          const SizedBox(height: 50),
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
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
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
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
          ),
        ),
        const SizedBox(height: 5),
        _buildRow('ศูนย์ช่วยเหลือ'),
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
        _buildRow('นโยบาย'),
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
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
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
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserProfileEditPage(),
            ),
          ),
          child: _buildRow('แก้ไขข้อมูลส่วนตัว'),
        ),
        // const SizedBox(height: 25),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => const VerifyFirstStepPage(),
            ),
          ),
          child: _buildRow('ยืนยันตัวตน'),
        ),
      ],
    );
  }

  Widget _buildRow(String title) {
    return Container(
      // color: Colors.red,
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
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
            ),
          ),
          Image.asset(
            'assets/images/go.png',
            height: 11,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Colors.black
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
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
            child: _imageUrl != null && _imageUrl != ''
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: _imageUrl!,
                      fit: BoxFit.fill,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/profile_empty.png",
                      fit: BoxFit.fill,
                    ),
                  ),
          ),
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
                            color: MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Colors.black
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Text(
                          _lastName ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: MyApp.themeNotifier.value == ThemeModeThird.light
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
                  'แก้ไขข้อมูล',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Colors.black
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var data = await ManageStorage.read('profileData') ?? '';
      var result = json.decode(data);
      setState(() {
        _imageUrl = result['imageUrl'];
        _firstName = result['firstName'];
        _lastName = result['lastName'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
