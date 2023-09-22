import 'package:des/shared/theme_data.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class HistoryOfApplyJobPage extends StatefulWidget {
  HistoryOfApplyJobPage({
    Key? key,
    this.model,
  }) : super(key: key);
  final dynamic model;
  @override
  _HistoryOfApplyJobState createState() => _HistoryOfApplyJobState();
}

class _HistoryOfApplyJobState extends State<HistoryOfApplyJobPage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

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
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เรียงตาม',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFF53327A)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
              Row(
                children: [
                  Text(
                    'วันที่สมัคร',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFB325F8)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                  SizedBox(width: 6),
                  Image.asset(
                    'assets/images/arrow_down.png',
                    width: 11,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFB325F8)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 25),
          ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: widget.model.length,
            separatorBuilder: (_, __) => const SizedBox(height: 25),
            itemBuilder: (context, _) {
              return _buildHistoryOfApplyJob(widget.model[_]);
            },
          )
          //
        ],
      ),
    );
  }

  Widget _buildHistoryOfApplyJob(model) {
    // String title, String title2, int hour, String date, String time
    return Container(
      // color: Colors.red,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 35,
                width: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFB325F8).withOpacity(.1)
                        : Colors.black,
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFB325F8).withOpacity(.1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    )),
                child: Image.asset(
                  'assets/images/computer.png',
                  width: 17,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFF53327A)
                      : Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
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
                      '${model['title2']}',
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
          SizedBox(height: 17),
          Row(
            children: [
              SizedBox(width: 50),
              Image.asset(
                'assets/images/calendar_check.png',
                width: 10,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFF53327A)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              SizedBox(width: 5),
              Text(
                _dateStringToDateSlashBuddhistShort(model['date']),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFF53327A)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
              SizedBox(width: 10),
              Image.asset(
                'assets/images/time_user_profile_page.png',
                width: 10,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFF53327A)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              SizedBox(width: 5),
              Text(
                '${model['time']} น.',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFF53327A)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
              SizedBox(width: 10),
              Text(
                '${model['hour']} ชั่วโมง',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFF53327A)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: Container(
                    height: 1,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF707070).withOpacity(0.50)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57)),
              ),
            ],
          ),
          // SizedBox(height: 25),
        ],
      ),
    );
  }

  // Widget _buildHead() {
  //   return Container(
  //     padding: EdgeInsets.only(
  //       top: MediaQuery.of(context).padding.top,
  //     ),
  //     color: Colors.white,
  //     child: Column(
  //       children: [
  //         SizedBox(height: 13),
  //         Row(
  //           children: [
  //             InkWell(
  //               onTap: () => Navigator.pop(context),
  //               child: Image.asset('assets/images/back.png',
  //                   height: 40, width: 40),
  //             ),
  //             SizedBox(width: 34),
  //             Text(
  //               'ประวัติการจองใช้บริการ',
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w400,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHead() {
    return Container(
      height: 60 + MediaQuery.of(context).padding.top,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: MediaQuery.of(context).padding.top,
      ),
      color: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      child: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
          ),
          Center(
            child: Text(
              'ประวัติการสมัครงาน',
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
          )
        ],
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
    return day + '/' + month + '/' + yearBuddhistStringShort;
  }
//
}
