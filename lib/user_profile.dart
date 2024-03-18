import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/certificate_all.dart';
import 'package:des/detail.dart';
import 'package:des/models/mock_data.dart';
import 'package:des/my_class_all.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/user_profile_edit.dart';
import 'package:des/user_profile_setting.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'shared/config.dart';
import 'history_of_apply_job.dart';
import 'main.dart';
import 'shared/dcc.dart';

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
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'คอร์สเรียนของคุณ',
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
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyClassAllPage(
                        title: 'คอร์สเรียนของคุณ',
                      ),
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

            if (_modelCourse.length != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMyClass(_modelCourse[0] ?? {}, 50),
                  _buildMyClass(_modelCourse[1] ?? {}, 80),
                ],
              ),
            // FutureBuilder<List<dynamic>>(
            //   future: Future.value(_modelCourse),
            //   builder: (_, snapshot) {
            //     if (snapshot.hasData) {
            //       if (snapshot.data?.length == 0) {
            //         return Container(
            //           height: 100,
            //           alignment: Alignment.center,
            //           child: Text(
            //             'ยังไม่มีคอร์สกำลังเรียน',
            //             style: TextStyle(
            //               color: Theme.of(context).custom.b_W_fffd57,
            //             ),
            //           ),
            //         );
            //       }
            //       return Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           _buildMyClass(_modelCourse[0] ?? {}, 50),
            //           _buildMyClass(_modelCourse[1] ?? {}, 80),
            //         ],
            //       );
            //     } else {
            //       return Container();
            //     }
            //   },
            // ),
            SizedBox(height: 33),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'วุฒิบัตร',
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
                GestureDetector(
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
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Text(
                'ยังไม่มีวุฒิบัตร',
                style: TextStyle(
                  color: Theme.of(context).custom.b_W_fffd57,
                ),
              ),
            ),
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
                GestureDetector(
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
            SizedBox(height: 33),
          ],
        ),
      ),
    );
  }

  // Widget _buildHistoryOfApplyJob(dynamic model) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //     decoration: BoxDecoration(
  //       color: MyApp.themeNotifier.value == ThemeModeThird.light
  //           ? Color(0xFFB325F8).withOpacity(0.10)
  //           : Color(0xFF292929),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           model?['title'] ?? '',
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w400,
  //             color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                 ? Colors.black
  //                 : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                     ? Colors.white
  //                     : Color(0xFFFFFD57),
  //           ),
  //           overflow: TextOverflow.ellipsis,
  //           maxLines: 1,
  //         ),
  //         Text(
  //           model?['title2'] ?? '',
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w400,
  //             color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                 ? Colors.black
  //                 : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                     ? Colors.white
  //                     : Color(0xFFFFFD57),
  //           ),
  //           overflow: TextOverflow.ellipsis,
  //           maxLines: 1,
  //         ),
  //         SizedBox(height: 10),
  //         Text(
  //           '${model?['hour'] ?? ''} ชั่วโมง',
  //           style: TextStyle(
  //             fontSize: 10,
  //             fontWeight: FontWeight.w500,
  //             color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                 ? Color(0xFFB325F8)
  //                 : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                     ? Colors.white
  //                     : Color(0xFFFFFD57),
  //           ),
  //         ),
  //         SizedBox(height: 5),
  //         Row(
  //           children: [
  //             Image.asset(
  //               'assets/images/calendar.png',
  //               height: 10,
  //               width: 10,
  //               color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                   ? Colors.black
  //                   : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                       ? Colors.white
  //                       : Color(0xFFFFFD57),
  //             ),
  //             SizedBox(width: 5),
  //             Text(
  //               _dateStringToDateSlashBuddhistShort(model?['date'] ?? ""),
  //               style: TextStyle(
  //                 fontSize: 7,
  //                 fontWeight: FontWeight.w400,
  //                 color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                     ? Colors.black
  //                     : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                         ? Colors.white
  //                         : Color(0xFFFFFD57),
  //               ),
  //             ),
  //             SizedBox(width: 20),
  //             Image.asset(
  //               'assets/images/clock.png',
  //               height: 10,
  //               width: 10,
  //               color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                   ? Colors.black
  //                   : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                       ? Colors.white
  //                       : Color(0xFFFFFD57),
  //             ),
  //             SizedBox(width: 5),
  //             Text(
  //               '${model?['time'] ?? ''} น.',
  //               style: TextStyle(
  //                 fontSize: 7,
  //                 fontWeight: FontWeight.w400,
  //                 color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                     ? Colors.black
  //                     : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                         ? Colors.white
  //                         : Color(0xFFFFFD57),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildHistoryOfServiceReservations(
  //     String title, String title2, int hour, String date, String time) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //     decoration: BoxDecoration(
  //       color: MyApp.themeNotifier.value == ThemeModeThird.light
  //           ? Color(0xFFB325F8).withOpacity(0.10)
  //           : Color(0xFF292929),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w400,
  //                   color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                       ? Colors.black
  //                       : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                           ? Colors.white
  //                           : Color(0xFFFFFD57),
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //               ),
  //               Text(
  //                 title2,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w400,
  //                   color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                       ? Colors.black
  //                       : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                           ? Colors.white
  //                           : Color(0xFFFFFD57),
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //               ),
  //               SizedBox(height: 11),
  //               Row(
  //                 children: [
  //                   Image.asset(
  //                     'assets/images/calendar.png',
  //                     height: 10,
  //                     width: 10,
  //                     color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                         ? Colors.black
  //                         : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                             ? Colors.white
  //                             : Color(0xFFFFFD57),
  //                   ),
  //                   SizedBox(width: 5),
  //                   Text(
  //                     date,
  //                     style: TextStyle(
  //                       fontSize: 7,
  //                       fontWeight: FontWeight.w400,
  //                       color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                           ? Colors.black
  //                           : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                               ? Colors.white
  //                               : Color(0xFFFFFD57),
  //                     ),
  //                   ),
  //                   SizedBox(width: 20),
  //                   Image.asset(
  //                     'assets/images/clock.png',
  //                     height: 10,
  //                     width: 10,
  //                     color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                         ? Colors.black
  //                         : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                             ? Colors.white
  //                             : Color(0xFFFFFD57),
  //                   ),
  //                   SizedBox(width: 5),
  //                   Text(
  //                     '$time น.',
  //                     style: TextStyle(
  //                       fontSize: 7,
  //                       fontWeight: FontWeight.w400,
  //                       color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                           ? Colors.black
  //                           : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                               ? Colors.white
  //                               : Color(0xFFFFFD57),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(width: 10),
  //         Text(
  //           '$hour ชั่วโมง',
  //           style: TextStyle(
  //             fontSize: 10,
  //             fontWeight: FontWeight.w500,
  //             color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                 ? Color(0xFFB325F8)
  //                 : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                     ? Colors.white
  //                     : Color(0xFFFFFD57),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFavoriteClass(dynamic model) {
  //   var screenSize = (44 * MediaQuery.of(context).size.width) / 100;
  //   return GestureDetector(
  //     onTap: () => Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => DetailPage(
  //           slug: 'eventcalendar',
  //           model: model,
  //         ),
  //       ),
  //     ),
  //     child: SizedBox(
  //       // height: screenSize,
  //       width: screenSize,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(10),
  //             child: CachedNetworkImage(
  //               imageUrl: '${model['imageUrl']}',
  //               fit: BoxFit.fill,
  //               height: 92,
  //               width: screenSize,
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           SizedBox(
  //             width: screenSize,
  //             child: Text(
  //               '${model['title']}',
  //               style: TextStyle(
  //                 fontSize: 13,
  //                 fontWeight: FontWeight.w500,
  //                 color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                     ? Colors.black
  //                     : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                         ? Colors.white
  //                         : Color(0xFFFFFD57),
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //               maxLines: 2,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildCertificateClass(dynamic model) {
  //   var screenSize = (44 * MediaQuery.of(context).size.width) / 100;
  //   return GestureDetector(
  //     onTap: () => Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => DetailPage(
  //           slug: 'certificatePage',
  //           model: model,
  //         ),
  //       ),
  //     ),
  //     child: SizedBox(
  //       // height: screenSize,
  //       width: screenSize,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(10),
  //             child: CachedNetworkImage(
  //               imageUrl: '${model['imageUrl']}',
  //               fit: BoxFit.fill,
  //               height: 92,
  //               width: screenSize,
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           SizedBox(
  //             width: screenSize,
  //             child: Text(
  //               '${model['title']}',
  //               style: TextStyle(
  //                 fontSize: 13,
  //                 fontWeight: FontWeight.w500,
  //                 color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                     ? Colors.black
  //                     : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                         ? Colors.white
  //                         : Color(0xFFFFFD57),
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //               maxLines: 2,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMyClass(dynamic model, double study) {
    var screenSize = (45.07 * MediaQuery.of(context).size.width) / 100;
    return GestureDetector(
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
              child: (model?['docs'] ?? '') != ''
                  ? CachedNetworkImage(
                      imageUrl: 'https://lms.dcc.onde.go.th/uploads/course/' +
                          model['docs'],
                      fit: BoxFit.fill,
                      height: 95,
                      width: screenSize,
                    )
                  : Image.asset(
                      'assets/icon.png',
                      fit: BoxFit.fill,
                      height: 95,
                      width: screenSize,
                    ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 170,
              child: Text(
                model['name'] ?? '',
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
                          "assets/images/profile_empty.png",
                          fit: BoxFit.fill,
                        ),
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
                    GestureDetector(
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
                if (_isVerify)
                  Container(
                    alignment: Alignment.center,
                    width: 73,
                    height: 19,
                    decoration: BoxDecoration(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color.fromARGB(255, 37, 248, 79).withOpacity(0.10)
                          : Color(0xFF292929),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: Text(
                      'ยืนยันตัวตนแล้ว',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color.fromARGB(255, 12, 168, 33)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
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

  // Widget _buildVerifyYourIdentity() {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (builder) => VerifyMainPage()),
  //       );
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: MyApp.themeNotifier.value == ThemeModeThird.light
  //               ? Color(0x1AB325F8)
  //               : Color(0xFF292929)

  //           // Color(0x1AB325F8),
  //           ),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Image.asset('assets/images/announce_user_profile.png',
  //           //     height: 55, width: 55,
  //           //     ),

  //           Container(
  //             height: 55,
  //             width: 55,
  //             padding: EdgeInsets.all(11),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                   ? Color(0xFFF7D930)
  //                   : Colors.black,
  //               border: Border.all(
  //                 width: 1,
  //                 style: BorderStyle.solid,
  //                 color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                     ? Color(0xFFF7D930)
  //                     : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                         ? Colors.white
  //                         : Color(0xFFFFFD57),
  //               ),
  //             ),
  //             child: Image.asset(
  //               'assets/images/announce.png',
  //               color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                   ? Colors.black
  //                   : Colors.white,
  //             ),
  //           ),
  //           // announce.png
  //           SizedBox(width: 20),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'กรุณายืนยันตัวตน',
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.w500,
  //                     color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                         ? Colors.black
  //                         : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                             ? Colors.white
  //                             : Color(0xFFFFFD57),
  //                   ),
  //                 ),
  //                 Text(
  //                   'เพื่อเข้าใช้งานคอร์สเรียน จองใช้บริการ และบริการอื่นๆ',
  //                   style: TextStyle(
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w400,
  //                     color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                         ? Colors.black
  //                         : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                             ? Colors.white
  //                             : Color(0xFFFFFD57),
  //                   ),
  //                 ),
  //                 SizedBox(height: 8),
  //                 Container(
  //                   height: 32,
  //                   width: 160,
  //                   decoration: BoxDecoration(
  //                     color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                         ? Color(0xFF7A4CB1)
  //                         : Colors.black,
  //                     border: Border.all(
  //                       width: 1,
  //                       style: BorderStyle.solid,
  //                       color: MyApp.themeNotifier.value == ThemeModeThird.light
  //                           ? Color(0xFF7A4CB1)
  //                           : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                               ? Colors.white
  //                               : Color(0xFFFFFD57),
  //                     ),
  //                     borderRadius: BorderRadius.circular(94),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Image.asset(
  //                         'assets/images/next_user_profile.png',
  //                         height: 16,
  //                         width: 16,
  //                         color: MyApp.themeNotifier.value ==
  //                                 ThemeModeThird.light
  //                             ? Colors.white
  //                             : MyApp.themeNotifier.value == ThemeModeThird.dark
  //                                 ? Colors.white
  //                                 : Color(0xFFFFFD57),
  //                       ),
  //                       SizedBox(width: 5),
  //                       Text(
  //                         'ยืนยันตัวตน',
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w400,
  //                           color: MyApp.themeNotifier.value ==
  //                                   ThemeModeThird.light
  //                               ? Colors.white
  //                               : MyApp.themeNotifier.value ==
  //                                       ThemeModeThird.dark
  //                                   ? Colors.white
  //                                   : Color(0xFFFFFD57),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  // _get_course() async {
  //   Dio dio = Dio();
  //   var response;
  //   var map = new Map<String, dynamic>();
  //   FormData formData = new FormData.fromMap({"apikey": apiKeyLMS});
  //   // map['apikey'] = _api_key;
  //   try {
  //     //https://lms.dcc.onde.go.th/api/api/recomend/003138ecf4ad3c45f1b903d72a860181
  //     //response = await dio.post('${service}api/popular_course', data: formData);
  //     response = await dio.post('$serverLMS/recommend_course', data: formData);
  //     // logWTF(response.data);
  //     if (response.data['status']) {
  //       setState(() {
  //         _modelCourse = response.data?['data'] ?? [];
  //       });
  //     }
  //   } catch (e) {}
  //   return [];
  // }

  _callReadGetCourse() async {
    dynamic response = await Dio().get('$server/py-api/dcc/lms/recomend');
    print(response.data.toString());

    setState(() {
      _modelCourse = response.data;
    });
  }
}
