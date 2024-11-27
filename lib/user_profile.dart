import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/certificate_all.dart';
import 'package:des/detail.dart';
import 'package:des/models/mock_data.dart';
import 'package:des/my_class_all_bk.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/user_profile_bk.dart';
import 'package:des/user_profile_booking.dart';
import 'package:des/user_profile_class.dart';
import 'package:des/user_profile_edit.dart';
import 'package:des/user_profile_edit_bk.dart';
import 'package:des/user_profile_setting.dart';
import 'package:des/verify_main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'booking_service.dart';
import 'shared/config.dart';
import 'history_of_apply_job.dart';
import 'main.dart';
import 'shared/dcc.dart';
import 'package:des/verify_thai_id_new.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({
    Key? key,
    this.changePage,
  }) : super(key: key);
  late _UserProfilePageState UserProfilePageState;
  Function? changePage;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();

  getState() => UserProfilePageState;
}

class _UserProfilePageState extends State<UserProfilePage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late String _imageProfile;
  late String _firstName;
  late String _lastName;
  late bool _isVerify = false;

  @override
  void initState() {
    _imageProfile = '';
    _firstName = '';
    _lastName = '';
    _getUser();
    _getImage();
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
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
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
                    image: AssetImage(
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? "assets/images/BG.png"
                          : "assets/images/2024/BG_Blackwhite.jpg",
                    ),
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                widget.changePage!(0);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                // padding: EdgeInsets.all(6),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(8),
                                //   color: MyApp.themeNotifier.value ==
                                //           ThemeModeThird.light
                                //       ? Color(0xFFB325F8)
                                //       : Colors.black,
                                //   border: Border.all(
                                //     color: MyApp.themeNotifier.value ==
                                //             ThemeModeThird.light
                                //         ? Color(0xFFB325F8)
                                //         : MyApp.themeNotifier.value ==
                                //                 ThemeModeThird.dark
                                //             ? Colors.white
                                //             : Color(0xFFFFFD57),
                                //   ),
                                // ),
                                child: Image.asset(
                                  MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? 'assets/images/back_arrow.png'
                                      : "assets/images/2024/back_balckwhite.png",
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfileSettingPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Color(0xFFB325F8)
                                      : Colors.black,
                                  border: Border.all(
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFFB325F8)
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57),
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/setting_icon.png',
                                ),
                              ),
                            ),
                            // Container(
                            //   width: 35.0,
                            //   height: 35.0,
                            //   margin: EdgeInsets.all(5),
                            //   child: InkWell(
                            //     onTap: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) =>
                            //               UserProfileSettingNewPage(),
                            //         ),
                            //       );
                            //     },
                            //     child: Image.asset(
                            //       'assets/images/setting_profile.png',
                            //       // color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 60),
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
                                width: MyApp.fontKanit.value == FontKanit.small
                                    ? 75
                                    : MyApp.fontKanit.value == FontKanit.medium
                                        ? 100
                                        : 125,
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
                        const SizedBox(height: 20),
                        if (!_isVerify) _buildVerifyYourIdentity(),
                        const SizedBox(height: 30),
                        _buildRowAboutAccount(),
                      ],
                    ),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 100,
                    child: Container(
                      height: 168,
                      width: 168,
                      child: GestureDetector(
                        child: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? _imageProfile != ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.memory(
                                      base64Decode(_imageProfile),
                                      fit: BoxFit.cover,
                                      height: 168,
                                      width: 168,
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
                                  )
                            : ColorFiltered(
                                colorFilter: ColorFilter.matrix(<double>[
                                  0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                                  0.2126, 0.7152, 0.0722, 0, 0, // Green channel
                                  0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                                  0, 0, 0, 1, 0, // Alpha channel
                                ]),
                                child: _imageProfile != ''
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.memory(
                                          base64Decode(_imageProfile),
                                          fit: BoxFit.cover,
                                          height: 168,
                                          width: 168,
                                          errorBuilder: (_, __, ___) =>
                                              Image.asset(
                                            "assets/images/avatar_empty.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.asset(
                                            "assets/images/avatar_empty.png",
                                            fit: BoxFit.fill,
                                          ),
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
                builder: (_) => UserProfileEditPage(),
              ),
            );
          },
          child: _buildRow('แก้ไขข้อมูลส่วนตัว'),
        ),
        lineBottom(),
        GestureDetector(
          onTap: () {
            widget.changePage!(1);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => BookingServicePage(),
            //   ),
            // );
          },
          child: _buildRow('การจองของฉัน'),
        ),
        lineBottom(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileClassPage(),
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

  Widget _buildVerifyYourIdentity() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyThaiIDNewPage(),
          ),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (builder) => VerifyMainPage()),
        // );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0x1AB325F8)
                : Color(0xFF292929)

            // Color(0x1AB325F8),
            ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.asset('assets/images/announce_user_profile.png',
            //     height: 55, width: 55,
            //     ),

            Container(
              height: 55,
              width: 55,
              padding: EdgeInsets.all(11),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFFFFFFF)
                    : Colors.black,
                border: Border.all(
                  width: 1,
                  style: BorderStyle.solid,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFF7D930)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
              child: Image.asset(
                'assets/images/announce.png',
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFB325F8)
                    : Colors.white,
              ),
            ),
            // announce.png
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'กรุณายืนยันตัวตน',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                  Text(
                    'เพื่อเข้าใช้งานคอร์สเรียน จองใช้บริการ และบริการอื่นๆ',
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
                  SizedBox(height: 8),
                  Container(
                    height: MyApp.fontKanit.value == FontKanit.small
                        ? 35
                        : MyApp.fontKanit.value == FontKanit.medium
                            ? 40
                            : 45,
                    width: MyApp.fontKanit.value == FontKanit.small
                        ? 160
                        : MyApp.fontKanit.value == FontKanit.medium
                            ? 170
                            : 180,
                    decoration: BoxDecoration(
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
                      ),
                      borderRadius: BorderRadius.circular(94),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/next_user_profile.png',
                          height: 16,
                          width: 16,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.white
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'ยืนยันตัวตน',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
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
            )
          ],
        ),
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
    _getImage();
    _refreshController.refreshCompleted();
  }

  void _getUser() async {
    
    var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
    setState(() {

      _firstName = profileMe['firstnameTh'];
      _lastName = profileMe['lastnameTh'];
      _isVerify = profileMe['isVerify'] == 1 ? true : false;
    });
  }

   void _getImage() async {
    
    var img = await DCCProvider.getImageProfile();
    setState(() {
      _imageProfile = img;
    });
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

}
