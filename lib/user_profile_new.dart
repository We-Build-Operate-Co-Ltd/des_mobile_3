import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/certificate_all.dart';
import 'package:des/detail.dart';
import 'package:des/models/mock_data.dart';
import 'package:des/my_class_all.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/user_profile.dart';
import 'package:des/user_profile_edit.dart';
import 'package:des/user_profile_edit_new.dart';
import 'package:des/user_profile_setting.dart';
import 'package:des/user_profile_setting_new.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'shared/config.dart';
import 'history_of_apply_job.dart';
import 'main.dart';
import 'shared/dcc.dart';

class UserProfileNewPage extends StatefulWidget {
  UserProfileNewPage({
    Key? key,
    this.changePage,
  }) : super(key: key);
  late _UserProfileNewPageState userProfileNewPageState;
  Function? changePage;

  @override
  State<UserProfileNewPage> createState() => _UserProfileNewPageState();

  getState() => userProfileNewPageState;
}

class _UserProfileNewPageState extends State<UserProfileNewPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late String _imageProfile;
  late String _firstName;
  late String _lastName;
  late bool _isVerify;

  late List<dynamic> _modelCourse;

  @override
  void initState() {
    _imageProfile = '';
    _firstName = '';
    _lastName = '';
    _isVerify = false;
    _modelCourse = [];
    _getUser();
    _callReadGetCourse();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).custom.primary,
      resizeToAvoidBottomInset: false,
      extendBody: true,
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
                  fit: BoxFit.contain,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 35.0,
                            height: 35.0,
                            margin: EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'assets/images/back_profile.png',
                                // color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 35.0,
                            height: 35.0,
                            margin: EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfileSettingNewPage(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/images/setting_profile.png',
                                // color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${_firstName} ${_lastName}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.black
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 10),
                          if (_isVerify)
                            Container(
                              alignment: Alignment.center,
                              width: 75,
                              height: 20,
                              decoration: BoxDecoration(
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color.fromARGB(255, 37, 248, 79)
                                        .withOpacity(0.10)
                                    : Color(0xFF292929),
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              child: Text(
                                'ยืนยันตัวตนแล้ว',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Color.fromARGB(255, 12, 168, 33)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildRowAboutAccount(),
                    ],
                  ),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Positioned(
                  top: 100,
                  child: SizedBox(
                    height: 168,
                    width: 168,
                    child: GestureDetector(
                      child: _imageProfile != ''
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.memory(
                                base64Decode(_imageProfile),
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  "assets/images/avatar_empty.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/avatar_empty.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowAboutAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileEditNewPage(),
              ),
            );
          },
          child: _buildRow('แก้ไขข้อมูลส่วนตัว'),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileEditPage(),
              ),
            );
          },
          child: _buildRow('การจองของฉัน'),
        ),
        lineBottom(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileEditPage(),
              ),
            );
          },
          child: _buildRow('คลาสและความสำเร็จ'),
        ),
        lineBottom(),
      ],
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

  void _onRefresh() async {
    _getUser();
    _callReadGetCourse();
    _refreshController.refreshCompleted();
  }

  void _getUser() async {
    var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
    setState(() {
      _firstName = profileMe['firstnameTh'];
      _lastName = profileMe['lastnameTh'];
      _isVerify = profileMe['isVerify'] == 1 ? true : false;
    });
    var img = await DCCProvider.getImageProfile();
    setState(() => _imageProfile = img);
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  _dateStringToDateSlashBuddhistShort(String date) {
    if (date.isEmpty) return '';
    var year = date.substring(0, 4);
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    var yearBuddhist = int.parse(year) + 543;
    var yearBuddhistString = yearBuddhist.toString();
    var yearBuddhistStringShort = yearBuddhistString.substring(2, 4);
    return '$day/$month/$yearBuddhistStringShort';
  }

  _callReadGetCourse() async {
    dynamic response = await Dio().get('$server/py-api/dcc/lms/recomend');
    // print(response.data.toString());

    setState(() {
      _modelCourse = response.data;
    });
  }
}
