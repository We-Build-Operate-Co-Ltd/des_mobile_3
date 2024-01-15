import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/models/mock_data.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'build_modal_connection_in_progress.dart';
import 'course_detail.dart';
import 'main.dart';
import 'models/user.dart';
import 'detail.dart';
import 'shared/config.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key, this.userData, this.model}) : super(key: key);
  final User? userData;
  final dynamic model;
  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  dynamic model = {
    "title": 'สกัดสมุนไพร เพื่อผลิตภัณฑ์เสริมความงาม',
    "description": 'หมู่ที่ 5 99/99 ตำบล เสาธงหิน อำเภอบางใหญ่ นนทบุรี 11140',
    "time": '11:00:00',
    "date": '20220911110000',
    "timeOfUse": '3',
  };

  dynamic _model = [];

  @override
  void initState() {
    // logWTF('fksdjflksdjflfsdkfjskldfjslkdf');
    _get_course();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 25,
          right: 15,
          left: 15,
        ),
        children: [
          _buildHead(),
          const SizedBox(height: 15),
          const SizedBox(height: 25),
          ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _model.length,
            separatorBuilder: (_, __) => const SizedBox(height: 25),
            itemBuilder: (context, _) {
              return _buildHistoryOfServiceReservations(_model[_]);
              // return Container(
              //   child: Text(_model[_]['name']),
              // );
            },
          )
        ],
      ),
    );
  }

  Widget _buildHistoryOfServiceReservations(dynamic model) {
    // String title, String title2, int hour, String date, String time
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         DetailPage(slug: 'mock', model: mockDataObject1),
        //   ),
        // );
        var data = {
          'course_id': model?['id'] ?? '',
          "course_name": model?['name'] ?? '',
          "course_cat_id": model?['course_cat_id'] ?? '',
          "cover_image": model?['docs'] ?? '',
          "description": model['details'] ?? '',
          "created_at": model['created_at'] ?? '',
          "category_name": model['cat_name'] ?? '',
          "certificate": model['certificate'] ?? '',
        };
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(
              model: data,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: (model?['docs'] ?? '') != ''
                    ? CachedNetworkImage(
                        imageUrl: 'https://lms.dcc.onde.go.th/uploads/course/' +
                            model['docs'],
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/icon.png',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['name']}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      '${model['details']}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF707070)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          // Row(
          //   children: [
          //     const SizedBox(width: 150),
          //     Image.asset(
          //       'assets/images/calendar_check.png',
          //       width: 10,
          //       color: MyApp.themeNotifier.value == ThemeModeThird.light
          //           ? Color(0xFF53327A)
          //           : MyApp.themeNotifier.value == ThemeModeThird.dark
          //               ? Colors.white
          //               : Color(0xFFFFFD57),
          //     ),
          //     const SizedBox(width: 5),
          //     // Text(
          //     //   _dateStringToDateSlashBuddhistShort(model['date']),
          //     //   style: TextStyle(
          //     //     fontSize: 10,
          //     //     fontWeight: FontWeight.w400,
          //     //     color: MyApp.themeNotifier.value == ThemeModeThird.light
          //     //         ? Color(0xFF53327A)
          //     //         : MyApp.themeNotifier.value == ThemeModeThird.dark
          //     //             ? Colors.white
          //     //             : Color(0xFFFFFD57),
          //     //   ),
          //     // ),
          //     // const SizedBox(width: 10),
          //     // Image.asset(
          //     //   'assets/images/time_user_profile_page.png',
          //     //   width: 10,
          //     //   color: MyApp.themeNotifier.value == ThemeModeThird.light
          //     //       ? Color(0xFF53327A)
          //     //       : MyApp.themeNotifier.value == ThemeModeThird.dark
          //     //           ? Colors.white
          //     //           : Color(0xFFFFFD57),
          //     // ),
          //     // const SizedBox(width: 5),
          //     // // Text(
          //     //   '${model['time']} น.',
          //     //   style: TextStyle(
          //     //     fontSize: 10,
          //     //     fontWeight: FontWeight.w400,
          //     //     color: MyApp.themeNotifier.value == ThemeModeThird.light
          //     //         ? Color(0xFF53327A)
          //     //         : MyApp.themeNotifier.value == ThemeModeThird.dark
          //     //             ? Colors.white
          //     //             : Color(0xFFFFFD57),
          //     //   ),
          //     // ),
          //     // const SizedBox(width: 10),
          //     // Text(
          //     //   '${model['timeOfUse']} ชั่วโมง',
          //     //   style: TextStyle(
          //     //     fontSize: 10,
          //     //     fontWeight: FontWeight.w400,
          //     //     color: MyApp.themeNotifier.value == ThemeModeThird.light
          //     //         ? Color(0xFF53327A)
          //     //         : MyApp.themeNotifier.value == ThemeModeThird.dark
          //     //             ? Colors.white
          //     //             : Color(0xFFFFFD57),
          //     //   ),
          //     // ),
          //   ],
          // ),
          const SizedBox(height: 6),
          Row(
            children: [
              const SizedBox(width: 50),
              Expanded(
                child: Container(
                  height: 1,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFF707070)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                  // color:  Color(0xFF707070),
                ),
              ),
            ],
          ),
          // SizedBox(height: 25),
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
      child: Center(
        child: Text(
          'การเรียน',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
      ),
    );
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

  _get_course() async {
    // logWTF('==========rerwerwerwerw=========');
    Dio dio = Dio();
    var response;
    var map = new Map<String, dynamic>();
    FormData formData = new FormData.fromMap({"apikey": apiKeyLMS});
    // map['apikey'] = _api_key;
    try {
      //https://lms.dcc.onde.go.th/api/api/recomend/003138ecf4ad3c45f1b903d72a860181
      //response = await dio.post('${service}api/popular_course', data: formData);
      response =
          await dio.post('$serverLMS/recomend/$apiKeyLMS', data: formData);
      // logWTF(response.data);
      if (response.data['status']) {
        setState(() {
          _model = response.data['data'];

          // logWTF('==========trtrgdfgdfgdfgdf=========');
          // logWTF(_model.toString());
        });

        // logWTF('_get_course' + response.data['data']);
        // return response.data['data'];
      }
    } catch (e) {
      // logWTF(e);
    }
    return [];
  }
}
