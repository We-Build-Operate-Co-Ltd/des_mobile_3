import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/certificate_all.dart';
import 'package:des/detail.dart';
import 'package:des/favorite_class_all.dart';
import 'package:des/history_of_service_reservations.dart';
import 'package:des/models/mock_data.dart';
import 'package:des/my_class_all.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/user_profile_edit.dart';
import 'package:des/user_profile_setting.dart';
import 'package:des/verify_main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'shared/config.dart';
import 'history_of_apply_job.dart';
import 'main.dart';

// ignore: must_be_immutable
class UserProfilePage extends StatefulWidget {
  UserProfilePage({
    Key? key,
    this.changePage,
  }) : super(key: key);
  late _UserProfilePageState userProfilePageState;
  Function? changePage;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();

  getState() => userProfilePageState;
}

class _UserProfilePageState extends State<UserProfilePage> {
  final storage = FlutterSecureStorage();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String? _imageUrl = '';
  String? _firstName = '';
  String? _lastName = '';
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).custom.primary,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 15,
            bottom: MediaQuery.of(context).padding.bottom + 25,
            right: 15,
            left: 15,
          ),
          children: [
            _buildUserDetail(),
            if (_status != 'A') SizedBox(height: 20),
            if (_status != 'A') _buildVerifyYourIdentity(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'คลาสเรียนของฉัน',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyClassAllPage(),
                    ),
                  ),
                  child: Text(
                    'ดูทั้งหมด',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            FutureBuilder<List<dynamic>>(
              future: Future.value([]),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.length == 0) {
                    return Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: Text(
                        'ยังไม่มีคลาสกำลังเรียน',
                        style: TextStyle(
                          color: Theme.of(context).custom.b_W_fffd57,
                        ),
                      ),
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMyClass(snapshot.data?[0] ?? {}, 50),
                      _buildMyClass(snapshot.data?[1] ?? {}, 80),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 33),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ใบรับรอง',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CertificateAllPage(model: mockDataCertificateList),
                    ),
                  ),
                  child: Text(
                    'ดูทั้งหมด',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // FutureBuilder(
            //   future: _readEventcalendar(),
            //   builder: (context, snapshot) => Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: snapshot.data!
            //         .map<Widget>((e) => _buildFavoriteClass(e))
            //         .toList(),
            //   ),
            // ),
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Text(
                'ยังไม่มีใบรับรอง',
                style: TextStyle(
                  color: Theme.of(context).custom.b_W_fffd57,
                ),
              ),
            ),
            // FutureBuilder(
            //   future: Future.value(mockDataCertificateList),
            //   builder: (context, snapshot) => Container(
            //     height: 150,
            //     child: ListView.separated(
            //       scrollDirection: Axis.horizontal,
            //       itemBuilder: (_, __) =>
            //           _buildCertificateClass(snapshot.data![__]),
            //       separatorBuilder: (_, __) => SizedBox(width: 10),
            //       itemCount: snapshot.data!.length,
            //     ),
            //   ),
            // ),
            SizedBox(height: 33),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ประวัติการสมัครงาน',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF7A4CB1)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HistoryOfApplyJobPage(model: mockDataApplyJobList),
                    ),
                  ),
                  child: Text(
                    'ดูทั้งหมด',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Text(
                'ยังไม่มีประวัติการสมัครงาน',
                style: TextStyle(
                  color: Theme.of(context).custom.b_W_fffd57,
                ),
              ),
            ),
            // FutureBuilder(
            //   future: Future.value(mockDataApplyJobList),
            //   builder: (context, snapshot) => Container(
            //     height: 110,
            //     child: ListView.separated(
            //       scrollDirection: Axis.horizontal,
            //       itemBuilder: (_, __) =>
            //           _buildHistoryOfApplyJob(snapshot.data![__]),
            //       separatorBuilder: (_, __) => SizedBox(width: 10),
            //       itemCount: snapshot.data!.length,
            //     ),
            //   ),
            // ),
            SizedBox(height: 33),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ประวัติการจองใช้บริการ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF7A4CB1)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryOfServiceReservationsPage(),
                    ),
                  ),
                  child: Text(
                    'ดูทั้งหมด',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildHistoryOfServiceReservations(
                'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน',
                'อำเภอบางใหญ่ นนทบุรี',
                3,
                _dateStringToDateSlashBuddhistShort('20220911'),
                '11.00'),
            SizedBox(height: 10),
            _buildHistoryOfServiceReservations(
                'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน',
                'อำเภอบางใหญ่ นนทบุรี',
                3,
                _dateStringToDateSlashBuddhistShort('20220911'),
                '11.00'),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryOfApplyJob(dynamic model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Color(0xFFB325F8).withOpacity(0.10)
            : Color(0xFF292929),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model['title'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.black
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            model['title2'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.black
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: 10),
          Text(
            '${model['hour']} ชั่วโมง',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFB325F8)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Image.asset(
                'assets/images/calendar.png',
                height: 10,
                width: 10,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              SizedBox(width: 5),
              Text(
                _dateStringToDateSlashBuddhistShort(model['date']),
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w400,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
              SizedBox(width: 20),
              Image.asset(
                'assets/images/clock.png',
                height: 10,
                width: 10,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              SizedBox(width: 5),
              Text(
                '${model['time']} น.',
                style: TextStyle(
                  fontSize: 7,
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
        ],
      ),
    );
  }

  Widget _buildHistoryOfServiceReservations(
      String title, String title2, int hour, String date, String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Color(0xFFB325F8).withOpacity(0.10)
            : Color(0xFF292929),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  title2,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 11),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/calendar.png',
                      height: 10,
                      width: 10,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                    SizedBox(width: 5),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w400,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.black
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/images/clock.png',
                      height: 10,
                      width: 10,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '$time น.',
                      style: TextStyle(
                        fontSize: 7,
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
              ],
            ),
          ),
          SizedBox(width: 10),
          Text(
            '$hour ชั่วโมง',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFB325F8)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteClass(dynamic model) {
    var screenSize = (44 * MediaQuery.of(context).size.width) / 100;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(
            slug: 'eventcalendar',
            model: model,
          ),
        ),
      ),
      child: SizedBox(
        // height: screenSize,
        width: screenSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: '${model['imageUrl']}',
                fit: BoxFit.fill,
                height: 92,
                width: screenSize,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: screenSize,
              child: Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateClass(dynamic model) {
    var screenSize = (44 * MediaQuery.of(context).size.width) / 100;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(
            slug: 'certificatePage',
            model: model,
          ),
        ),
      ),
      child: SizedBox(
        // height: screenSize,
        width: screenSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: '${model['imageUrl']}',
                fit: BoxFit.fill,
                height: 92,
                width: screenSize,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: screenSize,
              child: Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyClass(dynamic model, double study) {
    var screenSize = (45.07 * MediaQuery.of(context).size.width) / 100;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(slug: 'mock', model: model),
          ),
        );
      },
      child: SizedBox(
        // height: screenSize,
        width: screenSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: model['imageUrl'],
                fit: BoxFit.fill,
                height: 95,
                width: screenSize,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 170,
              child: Text(
                model['title'],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
            SizedBox(height: 23),
            Row(
              children: [
                Flexible(
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0x80B325F8).withOpacity(0.47)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          ),
                        ),
                      ),
                      Container(
                        width: 80 * study / 100,
                        height: 9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFB325F8)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          // border: Border.all(
                          //   color: MyApp.themeNotifier.value == ThemeModeThird.light
                          //             ? Color(0xFFB325F8)
                          //             : MyApp.themeNotifier.value ==
                          //                     ThemeModeThird.dark
                          //                 ? Colors.white
                          //                 : Color(0xFFFFFD57),
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'เรียนแล้ว $study%',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w300,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetail() {
    return GestureDetector(
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
            child: InkWell(
              child: _imageUrl!.isNotEmpty && _imageUrl != ''
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: _imageUrl!,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "assets/images/profile_empty.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${_firstName} ${_lastName}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.black
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileSettingPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          "assets/images/settings.png",
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.black
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          height: 18,
                          width: 17,
                        ),
                      ),
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
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
                SizedBox(height: 5),
                _status != 'A'
                    ? Container(
                        alignment: Alignment.center,
                        width: 73,
                        height: 19,
                        decoration: BoxDecoration(
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Color(0xFFB325F8).withOpacity(0.10)
                                  : Color(0xFF292929),
                          borderRadius: BorderRadius.circular(12.5),
                        ),
                        child: Text(
                          'รอยืนยันตัวตน',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7A4CB1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          ),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        width: 73,
                        height: 19,
                        decoration: BoxDecoration(
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
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
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyYourIdentity() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (builder) => VerifyMainPage()),
        );
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
                    ? Color(0xFFF7D930)
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
                    ? Colors.black
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
                    'เพื่อเข้าใช้งานคลาสเรียน จองใช้บริการ และบริการอื่นๆ',
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
                    height: 32,
                    width: 160,
                    decoration: BoxDecoration(
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

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<dynamic>> _readEventcalendar() async {
    Dio dio = Dio();
    Response<dynamic> response;
    try {
      response = await dio.post('$server/de-api/m/eventcalendar/read',
          data: {'skip': 0, 'limit': 10});
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          return response.data['objectData'];
        }
      }
    } on DioError catch (e) {
      print(e.toString());
    }
    return [];
  }

  void _onRefresh() async {
    _getUser();
    _readEventcalendar();
    _refreshController.refreshCompleted();
  }

  void _getUser() async {
    var data = await ManageStorage.read('profileData') ?? '';
    var result = json.decode(data);
    setState(() {
      _imageUrl = result['imageUrl'];
      _firstName = result['firstName'];
      _lastName = result['lastName'];
      _status = result['status'];
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
