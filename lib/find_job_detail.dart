import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/main.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_share/flutter_share.dart';

// ignore: must_be_immutable
class FindJobDetailPage extends StatefulWidget {
  const FindJobDetailPage({
    Key? key,
    this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  State<FindJobDetailPage> createState() => _FindJobDetailPageState();
}

class _FindJobDetailPageState extends State<FindJobDetailPage> {
  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;
  final storage = const FlutterSecureStorage();

  dynamic _detailModel = {};

  @override
  void initState() {
    if (MyApp.themeNotifier.value == ThemeModeThird.light) {
      backgroundTheme = Colors.white;
      colorTheme = Color(0xFF7A4CB1);
      buttonTheme = Color(0xFF7A4CB1);
      textTheme = Colors.black;
    } else if (MyApp.themeNotifier.value == ThemeModeThird.dark) {
      backgroundTheme = Colors.black;
      colorTheme = Colors.white;
      buttonTheme = Colors.black;
      textTheme = Colors.white;
    } else {
      backgroundTheme = Colors.black;
      colorTheme = Color(0xFFFFFD57);
      buttonTheme = Colors.black;
      textTheme = Color(0xFFFFFD57);
    }
    //  themeColor
    super.initState();
    _callRead();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundTheme,
      appBar: AppBar(
        backgroundColor: backgroundTheme,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          height: 60 + MediaQuery.of(context).padding.top,
          color: backgroundTheme,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 15,
            right: 15,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                _backButton(context),
                SizedBox(width: 10),
                Text(
                  'รายละเอียดงาน',
                  style: TextStyle(
                    fontSize: 24,
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
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 100,
                ),
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
                        'assets/images/rectangle.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      widget.model['jobpositionName'],
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
                              color: Theme.of(context).custom.b325f8_w_fffd57),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/images/work.png'),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          widget.model['employername'],
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
                            child: Image.asset('assets/images/clock_white.png'),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'ไม่ระบุ',
                          // widget.model['companyName'],
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
                            child:
                                Image.asset('assets/images/calendar_menu.png'),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'ไม่ระบุ',
                          // DateFormat('dd/MM/yyyy').format(
                          //   DateTime.parse(widget.model['announceDate']),
                          // ),
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
                      'ไม่ระบุ',
                      //widget.model['target'],
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
                      widget.model['jobpositionName'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tel : ไม่ระบุ',
                      // widget.model['investTel'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email : ไม่ระบุ',
                      // widget.model['investEmail'],
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
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFB325F8),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x40F3D2FF),
                              offset: Offset(0, -4),
                            )
                          ],
                        ),
                        child: Center(
                          child: const Text(
                            'สมัครงาน',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
    // ListView(
    //   shrinkWrap: true, // 1st add
    //   physics: const ClampingScrollPhysics(), // 2nd
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.all(20.0),
    //       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           // InkWell(
    //           //   onTap: () {
    //           //     // showCupertinoDialog(
    //           //     //   context: context,
    //           //     //   builder: (context) {
    //           //     //     return ImageViewer(
    //           //     //       initialIndex: 0,
    //           //     //       imageProviders: [widget.model['docs']]
    //           //     //           .map<ImageProvider<Object>>((e) => NetworkImage(e))
    //           //     //           .toList(),
    //           //     //     );
    //           //     //   },
    //           //     // );
    //           //   },
    //           //   child: Container(
    //           //     height: 194,
    //           //     width: double.infinity,
    //           //     padding: EdgeInsets.symmetric(horizontal: 15),
    //           //     child: ClipRRect(
    //           //       borderRadius: BorderRadius.circular(17.5),
    //           //       child: CachedNetworkImage(
    //           //         imageUrl: 'https://lms.dcc.onde.go.th/uploads/course/' +
    //           //             '${widget.model?['docs'] ?? ''}',
    //           //         width: MediaQuery.of(context).size.width,
    //           //         fit: BoxFit.cover,
    //           //         errorWidget: (context, url, error) =>
    //           //             Image.asset('assets/images/logo.png'),
    //           //       ),
    //           //     ),
    //           //   ),
    //           // ),
    //           Center(
    //             child: Container(
    //               height: 180,
    //               width: 320,
    //               decoration: BoxDecoration(
    //                 // color: Color(0xFFB325F8),
    //                 borderRadius: BorderRadius.circular(24),
    //               ),
    //               child: Image.asset('assets/images/rectangle.png'),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50, top: 10),
    //             child: Text(
    //               widget.model?['positionName'] ?? '',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 20,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50),
    //             child: Text(
    //               widget.model?['companyname'] ?? '',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 15,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50, top: 50),
    //             child: Text(
    //               'คุณสมบัติ',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 20,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50),
    //             child: Text(
    //               widget.model?['jobHightlight'] ?? '-',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 15,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50, top: 50),
    //             child: Text(
    //               'รายละเอียดงาน',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 20,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50),
    //             child: Text(
    //               _detailModel?['jobResponsibilityDto'] != null
    //                   ? _detailModel['jobResponsibilityDto'].length > 0
    //                       ? (_detailModel?['jobResponsibilityDto']?[0]
    //                               ['jobdescription'] ??
    //                           '')
    //                       : '-'
    //                   : '',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 15,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50, top: 50),
    //             child: Text(
    //               'สวัสดิการ',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 20,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50),
    //             child: Text(
    //               widget.model?['benefit'] ?? '-',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 15,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),

    //           SizedBox(height: 20),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50, top: 10),
    //             child: Text(
    //               'เงินเดือน',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 20,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50),
    //             child: Text(
    //               _detailModel?['jobPostSalaryDto']?['salary'] ?? '',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 15,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),

    //           SizedBox(height: 20),
    //           Container(
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             margin: const EdgeInsets.only(right: 50, top: 10),
    //             child: Text(
    //               'ข้อมูลติดต่อ',
    //               style: TextStyle(
    //                 color: textTheme,
    //                 fontSize: 20,
    //                 fontFamily: 'Kanit',
    //               ),
    //             ),
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               Container(
    //                 padding: const EdgeInsets.symmetric(horizontal: 10),
    //                 // margin: const EdgeInsets.only(right: 50),
    //                 child: Text(
    //                   'Tel : ',
    //                   style: TextStyle(
    //                     color: textTheme,
    //                     fontSize: 15,
    //                     fontFamily: 'Kanit',
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 padding: const EdgeInsets.symmetric(horizontal: 10),
    //                 margin: const EdgeInsets.only(right: 50),
    //                 child: Text(
    //                   _detailModel?['jobPostContactDto']?['mobile'] ?? '',
    //                   style: TextStyle(
    //                     color: textTheme,
    //                     fontSize: 15,
    //                     fontFamily: 'Kanit',
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Row(
    //             children: [
    //               Container(
    //                 padding: const EdgeInsets.symmetric(horizontal: 10),
    //                 // margin: const EdgeInsets.only(right: 50),
    //                 child: Text(
    //                   'Email : ',
    //                   style: TextStyle(
    //                     color: textTheme,
    //                     fontSize: 15,
    //                     fontFamily: 'Kanit',
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 padding: const EdgeInsets.symmetric(horizontal: 10),
    //                 margin: const EdgeInsets.only(right: 50),
    //                 child: Text(
    //                   _detailModel?['jobPostContactDto']?['email'] ?? '',
    //                   style: TextStyle(
    //                     color: textTheme,
    //                     fontSize: 15,
    //                     fontFamily: 'Kanit',
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),

    //           // Padding(
    //           //   padding: const EdgeInsets.symmetric(horizontal: 10),
    //           //   child: Row(
    //           //     children: [
    //           //       // Container(
    //           //       //   padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    //           //       //   decoration: BoxDecoration(
    //           //       //     color: buttonTheme,
    //           //       //     borderRadius: BorderRadius.circular(12.5),
    //           //       //     border: Border.all(color: colorTheme),
    //           //       //   ),
    //           //       //   child: Row(
    //           //       //     children: const [
    //           //       //       Icon(
    //           //       //         Icons.access_time_outlined,
    //           //       //         size: 10,
    //           //       //         color: Colors.white,
    //           //       //       ),
    //           //       //       SizedBox(width: 5),
    //           //       //       Text(
    //           //       //         '3 ชั่วโมง',
    //           //       //         style: TextStyle(
    //           //       //           fontSize: 9,
    //           //       //           color: Colors.white,
    //           //       //         ),
    //           //       //       ),
    //           //       //     ],
    //           //       //   ),
    //           //       // ),
    //           //       // const SizedBox(width: 5),
    //           //       // Container(
    //           //       //   padding: EdgeInsets.symmetric(
    //           //       //     horizontal: 9,
    //           //       //     vertical: 3,
    //           //       //   ),
    //           //       //   decoration: BoxDecoration(
    //           //       //     color: buttonTheme,
    //           //       //     borderRadius: BorderRadius.circular(12.5),
    //           //       //     border: Border.all(color: colorTheme),
    //           //       //   ),
    //           //       //   child: Row(
    //           //       //     children: [
    //           //       //       Image.asset(
    //           //       //         'assets/images/book.png',
    //           //       //         height: 10,
    //           //       //         width: 8.41,
    //           //       //       ),
    //           //       //       const SizedBox(width: 5),
    //           //       //       const Text(
    //           //       //         '4 บทเรียน',
    //           //       //         style: TextStyle(
    //           //       //           fontSize: 9,
    //           //       //           color: Colors.white,
    //           //       //         ),
    //           //       //       ),
    //           //       //     ],
    //           //       //   ),
    //           //       // ),
    //           //       const Expanded(child: SizedBox()),
    //           //       InkWell(
    //           //         onTap: () => _callShare(widget.model),
    //           //         child: Container(
    //           //           height: 30,
    //           //           width: 30,
    //           //           alignment: Alignment.center,
    //           //           decoration: BoxDecoration(
    //           //             color: buttonTheme,
    //           //             borderRadius: BorderRadius.circular(15),
    //           //             border: Border.all(color: colorTheme),
    //           //           ),
    //           //           child: Image.asset(
    //           //             'assets/images/share.png',
    //           //             width: 14.83,
    //           //             height: 13.38,
    //           //           ),
    //           //         ),
    //           //       ),
    //           //     ],
    //           //   ),
    //           // ),
    //           // SizedBox(height: 10),
    //           // Padding(
    //           //   padding: const EdgeInsets.only(
    //           //     right: 10,
    //           //     left: 10,
    //           //   ),
    //           //   child: Column(
    //           //     crossAxisAlignment: CrossAxisAlignment.start,
    //           //     children: [
    //           //       Text(
    //           //         'รายละเอียด',
    //           //         style: TextStyle(
    //           //           color: textTheme,
    //           //           fontSize: 15,
    //           //           fontWeight: FontWeight.w500,
    //           //         ),
    //           //       ),
    //           //       Text(
    //           //         widget.model?['details'] ?? '',
    //           //         style: TextStyle(
    //           //           color: textTheme,
    //           //           fontSize: 13,
    //           //           fontWeight: FontWeight.w400,
    //           //           overflow: TextOverflow.ellipsis,
    //           //         ),
    //           //         textAlign: TextAlign.left,
    //           //         maxLines: 3,
    //           //       ),
    //           //     ],
    //           //   ),
    //           // ),
    //           // GestureDetector(
    //           //   onTap: () => showDialog(
    //           //     context: context,
    //           //     useSafeArea: false,
    //           //     barrierColor: Colors.transparent,
    //           //     builder: (_) => Material(
    //           //       color: Color.fromARGB(0, 255, 255, 255),
    //           //       child: BackdropFilter(
    //           //         filter: ui.ImageFilter.blur(
    //           //           sigmaX: 5.0,
    //           //           sigmaY: 5.0,
    //           //         ),
    //           //         child: Container(
    //           //           color: MyApp.themeNotifier.value == ThemeModeThird.light
    //           //               ? Color(0xD953327A)
    //           //               : Colors.black,
    //           //           padding: EdgeInsets.only(
    //           //             top: MediaQuery.of(context).padding.top + 10,
    //           //             right: 10,
    //           //             bottom: 5,
    //           //             left: 10,
    //           //           ),
    //           //           child: Column(
    //           //             children: [
    //           //               Expanded(
    //           //                 child: FadingEdgeScrollView.fromScrollView(
    //           //                   child: ListView(
    //           //                     controller: _scController,
    //           //                     padding: EdgeInsets.zero,
    //           //                     children: [
    //           //                       SizedBox(height: 40),
    //           //                       Center(
    //           //                         child: Text(
    //           //                           'รายละเอียด',
    //           //                           style: TextStyle(
    //           //                             fontSize: 17,
    //           //                             fontWeight: FontWeight.w500,
    //           //                             color: MyApp.themeNotifier.value ==
    //           //                                     ThemeModeThird.light
    //           //                                 ? Colors.white
    //           //                                 : textTheme,
    //           //                           ),
    //           //                         ),
    //           //                       ),
    //           //                       SizedBox(height: 10),
    //           //                       Text(
    //           //                         widget.model['details'],
    //           //                         style: TextStyle(
    //           //                           color: Colors.white.withOpacity(0.8),
    //           //                         ),
    //           //                       ),
    //           //                       const SizedBox(height: 40),
    //           //                     ],
    //           //                   ),
    //           //                 ),
    //           //               ),
    //           //               Center(
    //           //                 child: GestureDetector(
    //           //                   onTap: () => Navigator.pop(context),
    //           //                   child: Container(
    //           //                     height: 40,
    //           //                     width: 40,
    //           //                     alignment: Alignment.center,
    //           //                     decoration: BoxDecoration(
    //           //                       color: buttonTheme,
    //           //                       borderRadius: BorderRadius.circular(10),
    //           //                       border: Border.all(color: colorTheme),
    //           //                     ),
    //           //                     child: Image.asset(
    //           //                       'assets/images/close_noti_list.png',
    //           //                       color: Colors.white,
    //           //                       height: 23.15,
    //           //                       width: 23.15,
    //           //                     ),
    //           //                   ),
    //           //                 ),
    //           //               ),
    //           //               const SizedBox(height: 38),
    //           //             ],
    //           //           ),
    //           //         ),
    //           //       ),
    //           //     ),
    //           //   ),
    //           //   child: Column(
    //           //     crossAxisAlignment: CrossAxisAlignment.start,
    //           //     children: [
    //           //       Padding(
    //           //         padding: const EdgeInsets.symmetric(horizontal: 10),
    //           //         child: Text(
    //           //           '${parseHtmlString(widget.model?['description'] ?? '')}',
    //           //           style: TextStyle(
    //           //             fontSize: 13,
    //           //             color: colorTheme,
    //           //             overflow: TextOverflow.ellipsis,
    //           //           ),
    //           //           maxLines: 4,
    //           //         ),
    //           //       ),
    //           //       SizedBox(height: 5),
    //           //       Padding(
    //           //         padding: const EdgeInsets.only(
    //           //           right: 10,
    //           //           left: 10,
    //           //         ),
    //           //         child: Text(
    //           //           'อ่านทั้งหมด',
    //           //           style: TextStyle(
    //           //             color: textTheme,
    //           //             fontSize: 13,
    //           //             fontWeight: FontWeight.w500,
    //           //           ),
    //           //         ),
    //           //       ),
    //           //     ],
    //           //   ),
    //           // ),
    //           // const SizedBox(height: 30),
    //           // const SizedBox(height: 85),
    //           // InkWell(
    //           //   onTap: () {
    //           //     Navigator.push(
    //           //       context,
    //           //       MaterialPageRoute(
    //           //         builder: (_) => WebViewInAppPage(
    //           //           url:
    //           //               'https://lms.dcc.onde.go.th/user/user/lesson_details/${widget.model['id']}',
    //           //           title: widget.model['name'],
    //           //         ),
    //           //       ),
    //           //     );

    //           //     // launchUrl(
    //           //     //   Uri.parse(
    //           //     //       'https://lms.dcc.onde.go.th/user/user/lesson_details/${widget.model['id']}'),
    //           //     //   mode: LaunchMode.externalApplication,
    //           //     // );
    //           //   },
    //           //   child: Container(
    //           //     height: 45,
    //           //     alignment: Alignment.center,
    //           //     margin: EdgeInsets.symmetric(horizontal: 15),
    //           //     decoration: BoxDecoration(
    //           //       color: buttonTheme,
    //           //       borderRadius: BorderRadius.circular(22.5),
    //           //       border: Border.all(color: colorTheme),
    //           //     ),
    //           //     child: Text(
    //           //       'เริ่มเรียน',
    //           //       style: TextStyle(
    //           //         color: Colors.white,
    //           //         fontSize: 15,
    //           //         fontWeight: FontWeight.w500,
    //           //       ),
    //           //     ),
    //           //   ),
    //           // ),
    //           // const SizedBox(height: 50),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 35,
        width: 35,
        child: Image.asset(
          'assets/images/back_arrow.png',
        ),
      ),
    );
  }

  _callRead() async {
    Dio dio = new Dio();
    var response = await dio.get(
        'http://dcc-portal.webview.co/dcc-api/api/Job/GetJobPost/${widget.model['jobapplicationno']}');

    setState(() {
      _detailModel = response.data['data'];
    });

    print(_detailModel.toString());
  }
}
