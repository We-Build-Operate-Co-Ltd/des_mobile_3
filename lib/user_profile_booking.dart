import 'package:des/login_first.dart';
import 'package:des/shared/facebook_firebase.dart';
import 'package:des/shared/google_firebase.dart';
import 'package:des/shared/line.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'main.dart';

class UserProfileBookingPage extends StatefulWidget {
  const UserProfileBookingPage({Key? key}) : super(key: key);

  @override
  State<UserProfileBookingPage> createState() => _UserProfileBookingPageState();
}

class _UserProfileBookingPageState extends State<UserProfileBookingPage> {
  final storage = const FlutterSecureStorage();
  String profileCode = '';

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
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    children: [
                      _buildHead(),
                      const SizedBox(height: 30),
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
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFB325F8)
                    : Colors.black,
                border: Border.all(
                  width: 1,
                  style: BorderStyle.solid,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                )),
            child: Image.asset(
              'assets/images/back_arrow.png',
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: Text(
            'การจองของฉัน',
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: Color(0xFFB325F8)),
          ),
        ),
      ],
    );
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
    setState(() {});
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
