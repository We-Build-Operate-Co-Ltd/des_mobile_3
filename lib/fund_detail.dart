import 'package:des/main.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FundDetailPage extends StatefulWidget {
  const FundDetailPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  State<FundDetailPage> createState() => _FundDetailPageState();
}

class _FundDetailPageState extends State<FundDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: EdgeInsets.all(5),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/images/back_profile.png',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'รายละเอียดแหล่งทุน',
                  style: TextStyle(
                    fontSize: 18,
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
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 195,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            // color: Color(0xFFB325F8),
                            borderRadius: BorderRadius.circular(24),
                            // border: Border.all(),
                          ),
                          child: Image.asset(
                            'assets/images/03.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.model['annoucement'],
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Color(0xFF00B4C5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                    'assets/images/Frame 11489.png'),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              widget.model['catName'],
                              // widget.model['category'].toString(),
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Color(0xFFB325F8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                    'assets/images/clock_white.png'),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              widget.model['companyName'],
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Color(0xFFB325F8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                          'assets/images/calendar_menu.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(
                                          widget.model['announceDate']),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Color(0xFFB325F8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child:
                                          Image.asset('assets/images/eye.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '120',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 1,
                          color: Color(0xFFDDDDDD),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.model['target'],
                          style: TextStyle(
                              fontFamily: "Kanit",
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF707070)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 1,
                          color: Color(0xFFDDDDDD),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'ข้อมูลบริษัท',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFB325F8),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Kanit"),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.model['companyName'],
                          style: TextStyle(
                              fontFamily: "Kanit",
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF707070)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.model['investTel'],
                          style: TextStyle(
                              fontFamily: "Kanit",
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF707070)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.model['investEmail'],
                          style: TextStyle(
                              fontFamily: "Kanit",
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF707070)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'ข้อมูลงบประมาณของโครงการ',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFB325F8),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Kanit"),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'ไม่ได้ระบุ',
                          // widget.model['investTel'],
                          style: TextStyle(
                              fontFamily: "Kanit",
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF707070)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Container(
            //           padding: EdgeInsets.only(left: 20, right: 20),
            //           height: 100,
            //           width: double.infinity,
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(24.0),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withOpacity(0.15),
            //                 blurRadius: 4,
            //                 offset: Offset(0, -4),
            //               ),
            //             ],
            //           ),
            //           child: Center(
            //             child: GestureDetector(
            //               onTap: () {},
            //               child: Container(
            //                 height: 50,
            //                 width: double.infinity,
            //                 decoration: BoxDecoration(
            //                   color: Color(0xFFB325F8),
            //                   borderRadius: BorderRadius.circular(24),
            //                   boxShadow: const [
            //                     BoxShadow(
            //                       blurRadius: 4,
            //                       color: Color(0x40F3D2FF),
            //                       offset: Offset(0, -4),
            //                     )
            //                   ],
            //                 ),
            //                 child: Center(
            //                   child: const Text(
            //                     'สนใจเข้าร่วม',
            //                     style: TextStyle(
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w400,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           )),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
