import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:des/detail.dart';
import 'package:des/find_job.dart';
import 'package:des/fund.dart';
import 'package:des/models/mock_data.dart';
import 'package:des/notification_list.dart';
import 'package:des/report_problem.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:ui' as ui show ImageFilter;

import 'chat_botnoi.dart';
import 'course_detail.dart';
import 'my_class_all.dart';
import 'notification_booking.dart';
import 'shared/config.dart';
import 'main.dart';
import 'shared/notification_service.dart';
import 'webview_inapp.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key, this.changePage});
  late _HomePageState homeCentralPageState;
  Function? changePage;

  @override
  State<HomePage> createState() => _HomePageState();

  getState() => homeCentralPageState;
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  DateTime? currentBackPressTime;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  dynamic futureNotificationTire;
  List<dynamic>? dataCharts1;
  int? notificationCount = 0;

  int addBadger = 0;
  int currentTabIndex = 0;

  String? profileCode = "";
  String? profileUserName = "";
  String? userCode = '';
  String? $imageUrl = '';
  String? priceToday = '';
  String? selectedSize = "";
  late StreamSubscription<Map> _notificationSubscription;

  bool hiddenMainPopUp = false;
  String percentPrice = '';
  bool moreThen = false;
  List<dynamic> _listSwitchColors = [
    {'code': '1', 'title': 'ปกติ', 'isSelected': true},
    {'code': '2', 'title': 'ขาวดำ', 'isSelected': false},
    {'code': '3', 'title': 'ดำเหลือง', 'isSelected': false},
  ];
  String dateNow = DateFormat('dd/MM/yyyy').format(DateTime.now());
  LatLng? latLng;
  String? currentLocation = 'ตำแหน่งปัจจุบัน';
  int? _currentBanner = 0;

  Future<dynamic>? _futureNews;
  Future<dynamic>? _futureBanner;
  String? fontStorageValue;
  String? colorStorageValue;

  String _api_key = '19f072f9e4b14a19f72229719d2016d1';
  String service = 'https://lms.dcc.onde.go.th/api/';

  @override
  void initState() {
    NotificationService.instance.start(context);

    // _notificationSubscription = NotificationsBloc.instance.notificationStream
    //     .listen(_performActionOnNotification);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _determinePosition();
    });

    _callRead();
    _callReadGetCourse();

    super.initState();
  }

  @override
  void dispose() {
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
        onRefresh: onRefresh,
        // onLoading: _onLoading,
        child: ListView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            right: 15,
            left: 15,
          ),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 39,
                    width: 48,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'ศูนย์ดิจิทัลชุมชน',
                    style: TextStyle(
                      fontSize: 15,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      buildModalSwitch(context);
                    },
                    child: Image.asset(
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? 'assets/images/icon_blind.png'
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? 'assets/images/icon_blind_d.png'
                              : 'assets/images/icon_blind_d-y.png',
                      height: 35,
                      width: 35,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Fluttertoast.showToast(
                      //     msg: '''ยังไม่เปิดให้ใช้บริการ''');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationBookingPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? 'assets/images/notification.png'
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? 'assets/images/notification_d.png'
                              : 'assets/images/notification_d-y.png',
                      height: 35,
                      width: 35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF53327A).withOpacity(.5)
                        : Colors.black,
                    blurRadius: 10,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(
                    MyApp.themeNotifier.value == ThemeModeThird.light
                        ? 'assets/images/card_purple_v2.png'
                        : 'assets/images/card_black.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyClassAllPage(
                            title: 'คอร์สเรียนของคุณ',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      // alignment: Alignment.centerLeft,
                      height: 35,
                      // width: MediaQuery.of(context).size.width - 100,
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.white
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Colors.black,
                        borderRadius: BorderRadius.circular(46),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          Image.asset(
                            'assets/images/search.png',
                            height: 16,
                            width: 16,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7A4CB1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.black
                                    : Color(0xFFFFFD57),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              'ค้นหาคอร์สเรียน',
                              style: TextStyle(
                                fontSize: 13,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7A4CB1)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.black
                                        : Color(0xFFFFFD57),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 100,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        // Container(
                        //   width: 85,
                        //   height: 85,
                        //   child: columnButton(
                        //     MyApp.themeNotifier.value == ThemeModeThird.light
                        //         ? 'assets/images/icon_devcourse.png'
                        //         : MyApp.themeNotifier.value ==
                        //                 ThemeModeThird.dark
                        //             ? 'assets/images/icon_devcourse.png'
                        //             : 'assets/images/icon_devcourse.png',
                        //     'DevCourse',
                        //     code: 'devcourse',
                        //   ),
                        // ),
                        Container(
                          width: 85,
                          // color: Colors.black,
                          child: columnButton(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/icon_market.png'
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? 'assets/images/icon_market.png'
                                    : 'assets/images/icon_market.png',
                            '''ด้านการพัฒนาผลิตภัณฑ์และการสื่อสารทางการตลาด''',
                            code: 'market',
                          ),
                        ),
                        Container(
                          width: 85,
                          height: 85,
                          child: columnButton(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/icon_digital.png'
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? 'assets/images/icon_digital.png'
                                    : 'assets/images/icon_digital.png',
                            'ด้านดิจิทัล',
                            code: 'digital',
                          ),
                        ),
                        Container(
                          width: 75,
                          child: columnButton(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/icon_travel.png'
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? 'assets/images/icon_travel.png'
                                    : 'assets/images/icon_travel.png',
                            'ด้านการท่องเที่ยวเชิงการแพทย์และสุขภาพ',
                            code: 'btn4',
                          ),
                        ),
                        Container(
                          width: 75,
                          child: columnButton(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/care_old.png'
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? 'assets/images/care_old_d.png'
                                    : 'assets/images/care_old_d-y.png',
                            'ด้านการดูแลผู้สูงอายุ',
                            code: 'btn3',
                          ),
                        ),
                        Container(
                          width: 85,
                          height: 85,
                          child: columnButton(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/modern_farmer.png'
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? 'assets/images/modern_farmer_d.png'
                                    : 'assets/images/modern_farmer_d-y.png',
                            'ด้านการเกษตรสมัยใหม่',
                            code: 'btn1',
                          ),
                        ),
                        Container(
                          width: 75,
                          child: columnButton(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/community_business.png'
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? 'assets/images/community_business_d.png'
                                    : 'assets/images/community_business_d-y.png',
                            'ด้านการจัดการธุรกิจชุมชน',
                            code: 'btn2',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       flex: 1,
                  //       fit: FlexFit.tight,
                  //       child: columnButton(
                  //         MyApp.themeNotifier.value == ThemeModeThird.light
                  //             ? 'assets/images/modern_farmer.png'
                  //             : MyApp.themeNotifier.value == ThemeModeThird.dark
                  //                 ? 'assets/images/modern_farmer_d.png'
                  //                 : 'assets/images/modern_farmer_d-y.png',
                  //         'เกษตรกรสมัยใหม่',
                  //         code: 'btn1',
                  //       ),
                  //     ),
                  //     Flexible(
                  //       flex: 1,
                  //       fit: FlexFit.tight,
                  //       child: columnButton(
                  //         MyApp.themeNotifier.value == ThemeModeThird.light
                  //             ? 'assets/images/community_business.png'
                  //             : MyApp.themeNotifier.value == ThemeModeThird.dark
                  //                 ? 'assets/images/community_business_d.png'
                  //                 : 'assets/images/community_business_d-y.png',
                  //         'ธุรกิจชุมชน',
                  //         code: 'btn2',
                  //       ),
                  //     ),
                  //     Flexible(
                  //       fit: FlexFit.tight,
                  //       flex: 1,
                  //       child: columnButton(
                  //         MyApp.themeNotifier.value == ThemeModeThird.light
                  //             ? 'assets/images/care_old.png'
                  //             : MyApp.themeNotifier.value == ThemeModeThird.dark
                  //                 ? 'assets/images/care_old_d.png'
                  //                 : 'assets/images/care_old_d-y.png',
                  //         'ดูแลผู้สูงอายุ',
                  //         code: 'btn3',
                  //       ),
                  //     ),
                  //     Flexible(
                  //       flex: 1,
                  //       fit: FlexFit.tight,
                  //       child: columnButton(
                  //         MyApp.themeNotifier.value == ThemeModeThird.light
                  //             ? 'assets/images/more.png'
                  //             : MyApp.themeNotifier.value == ThemeModeThird.dark
                  //                 ? 'assets/images/more_d.png'
                  //                 : 'assets/images/more_d-y.png',
                  //         'ท่องเที่ยว',
                  //         code: 'btn4',
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'บริการสำหรับคุณ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).custom.b_w_y,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _determinePosition();
                    // ปิดก่อน ios เด้ง
                    // if (latLng != null)
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => PoiPage(latLng: latLng!),
                    //     ),
                    //   );
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/images/vector.png', height: 10),
                      const SizedBox(width: 3),
                      Text(
                        '${currentLocation}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).custom.b_w_y,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              height: 100,
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                children: [
                  columnButton(
                    MyApp.themeNotifier.value == ThemeModeThird.light
                        ? 'assets/images/reserve_service.png'
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? 'assets/images/reserve_service_d.png'
                            : 'assets/images/reserve_service_d-y.png',
                    'จองใช้บริการ',
                    type: 'serviceforyou',
                    code: 'booking',
                  ),
                  columnButton(
                    MyApp.themeNotifier.value == ThemeModeThird.light
                        ? 'assets/images/find_job.png'
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? 'assets/images/find_job_d.png'
                            : 'assets/images/find_job_d-y.png',
                    'จับคู่งาน',
                    type: 'serviceforyou',
                    code: 'job',
                  ),
                  columnButton(
                    MyApp.themeNotifier.value == ThemeModeThird.light
                        ? 'assets/images/funding_source.png'
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? 'assets/images/funding_source_d.png'
                            : 'assets/images/funding_source_d-y.png',
                    '''สรรหา
                    แหล่งทุน''',
                    type: 'serviceforyou',
                    code: 'fund',
                  ),
                  columnButton(
                    MyApp.themeNotifier.value == ThemeModeThird.light
                        ? 'assets/images/reskill.png'
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? 'assets/images/reskill_d.png'
                            : 'assets/images/reskill_d-y.png',
                    '''ระบบส่งเสริม
                    Re-skill''',
                    type: 'serviceforyou',
                    code: 'skill',
                  ),
                  columnButton(
                    MyApp.themeNotifier.value == ThemeModeThird.light
                        ? 'assets/images/chat2.png'
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? 'assets/images/chat2_d.png'
                            : 'assets/images/chat2_d-y.png',
                    'สนทนา',
                    type: 'serviceforyou',
                    code: 'chat',
                  ),
                  columnButton(
                    MyApp.themeNotifier.value == ThemeModeThird.light
                        ? 'assets/images/data_warehouse.png'
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? 'assets/images/data_warehouse_d.png'
                            : 'assets/images/data_warehouse_d-y.png',
                    'คลังข้อมูล',
                    type: 'serviceforyou',
                    code: 'knowledge',
                  ),
                  columnButton(
                    MyApp.themeNotifier.value == ThemeModeThird.light
                        ? 'assets/images/report_problem.png'
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? 'assets/images/report_problem_d.png'
                            : 'assets/images/report_problem_d-y.png',
                    'แจ้งปัญหา',
                    type: 'serviceforyou',
                    code: 'report',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   'คอร์สกำลังเรียน',
                //   style: TextStyle(
                //     fontSize: 15,
                //     fontWeight: FontWeight.w400,
                //     color: Theme.of(context).custom.b_w_y,
                //   ),
                // ),
                // Text(
                //   'ดูทั้งหมด',
                //   style: TextStyle(
                //     fontSize: 13,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),
            // FutureBuilder(
            //   future: Future.value(mockDataList),
            //   builder: (_, snapshot) {
            //     if (snapshot.hasData) {
            //       return Column(
            //         children: [
            //           const SizedBox(height: 10),
            //           containerStudy(snapshot.data![0], 50),
            //           const SizedBox(height: 10),
            //           containerStudy(snapshot.data![1], 80),
            //           const SizedBox(height: 24),
            //         ],
            //       );
            //     } else {
            //       return Container();
            //     }
            //   },
            // ),
            FutureBuilder(
              future: _futureBanner,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) return const SizedBox();
                  return Stack(
                    children: [
                      SizedBox(
                        height: 180,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 4,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            viewportFraction: 0.9,
                            autoPlay: true,
                            enlargeFactor: 0.4,
                            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentBanner = index;
                              });
                            },
                          ),
                          items: snapshot.data.map<Widget>(
                            (item) {
                              int index = snapshot.data.indexOf(item);
                              return GestureDetector(
                                onTap: () {
                                  if (snapshot.data[_currentBanner]['action'] ==
                                      'out') {
                                    if (snapshot.data[_currentBanner]
                                        ['isPostHeader']) {
                                      var path = snapshot.data[_currentBanner]
                                          ['linkUrl'];
                                      if (profileCode != '') {
                                        var splitCheck =
                                            path.split('').reversed.join();
                                        if (splitCheck[0] != "/") {
                                          path = path + "/";
                                        }
                                        var codeReplae = "B" +
                                            profileCode!.replaceAll('-', '') +
                                            snapshot.data[_currentBanner]
                                                    ['code']
                                                .replaceAll('-', '');
                                        // launchUrl(Uri.parse('$path$codeReplae'),
                                        //     mode:
                                        //         LaunchMode.externalApplication);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => WebViewInAppPage(
                                              url: "$path$codeReplae",
                                              title:
                                                  snapshot.data[_currentBanner]
                                                      ['title'],
                                            ),
                                          ),
                                        );
                                      }
                                    } else
                                      // launchUrl(
                                      //     Uri.parse(snapshot
                                      //         .data[_currentBanner]['linkUrl']),
                                      //     mode: LaunchMode.externalApplication);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => WebViewInAppPage(
                                            url: snapshot.data[_currentBanner]
                                                ['linkUrl'],
                                            title: snapshot.data[_currentBanner]
                                                ['title'],
                                          ),
                                        ),
                                      );
                                  } else if (snapshot.data[_currentBanner]
                                          ['action'] ==
                                      'in') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          slug: 'mock',
                                          model: snapshot.data[_currentBanner],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: _currentBanner == index
                                      ? BorderRadius.all(Radius.circular(20))
                                      : BorderRadius.circular(0),
                                  child: Image.network(
                                    item['imageUrl'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: mockBannerList.map<Widget>((url) {
                            int index = mockBannerList.indexOf(url);
                            return Container(
                              width: _currentBanner == index ? 17.5 : 7.0,
                              height: 7.0,
                              margin: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'คอร์สแนะนำ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: _futureNews,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              MyApp.fontKanit.value == FontKanit.small
                                  ? 10 / 12.5
                                  : MyApp.fontKanit.value == FontKanit.medium
                                      ? 10 / 13
                                      : 10 / 14,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15),
                      physics: const ClampingScrollPhysics(),
                      // itemCount: snapshot.data!.length,
                      itemCount: (snapshot.data.length >= 4
                          ? 4
                          : snapshot.data.length),
                      itemBuilder: (context, index) =>
                          containerRecommendedClass(snapshot.data![index]),
                    );
                  }
                }
                return const SizedBox();
              },
            ),
            Container(),
            SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget containerRecommendedClass(dynamic model) {
    return GestureDetector(
      onTap: () {
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
      child: Container(
        // elevation: 4,
        color: Theme.of(context).custom.primary,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).custom.primary,
            // border: Border.all(
            //   color: Theme.of(context).custom.b_w_y,
            // ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(0, 0, 0, 0).withOpacity(0.15),
                offset: const Offset(
                  3.0,
                  3.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: (model?['docs'] ?? '') != ''
                    ? Image.network(
                        'https://lms.dcc.onde.go.th/uploads/course/' +
                            model?['docs'],
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
              const SizedBox(height: 9),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    model?['name'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).custom.b_w_y,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Image.asset('assets/images/time_home_page.png',
                        height: 24, width: 24),
                    const SizedBox(width: 8),
                    Text(
                      model?['course_duration'],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerStudy(dynamic model, double study) {
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
        height: 95,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                model['imageUrl'] ?? '',
                fit: BoxFit.fill,
                height: 95,
                width: 169,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      model!['title'] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                border: Border.all(
                                  color: Theme.of(context).custom.b_w_y,
                                ),
                              ),
                            ),
                            Container(
                              width: 80 * study / 100,
                              height: 9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                color: Theme.of(context).custom.b_w_y,
                                border: Border.all(
                                  color: Theme.of(context).custom.b_w_y,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'เรียนแล้ว $study%',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).custom.b_w_y,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget columnButton(String image, String title,
      {String type = '', String code = ''}) {
    //serviceforyou ใช้สำหรับ บริการสำหรับคุณ
    return Container(
      constraints: type == 'serviceforyou'
          ? BoxConstraints(minWidth: 80, maxWidth: 100)
          : null,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _callOpenPage(code);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                height: type == 'serviceforyou' ? 45 : 30,
                width: type == 'serviceforyou' ? 45 : 30,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: type == 'serviceforyou' ? 7 : 5),
          type == 'serviceforyou'
              ? SizedBox(
                  height: 40,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 0.5,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      // Theme.of(context).custom.bwy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    // _callOpenPage(code);
                  },
                  child: SizedBox(
                    height: 55,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 11,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.white
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        // Theme.of(context).custom.bwy,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  void _callRead() async {
    fontStorageValue = await storage.read(key: 'switchSizeFont') ?? 'ปกติ';
    colorStorageValue = await storage.read(key: 'switchColor') ?? 'ปกติ';
    FirebaseMessaging.instance.getToken().then((token) async {
      print('token: $token');
    });

    setState(() {
      _futureBanner = _readBanner();
      // _futureNews = _readGetCourse();
    });
    var sizeName = await storage.read(key: 'switchSize');
    selectedSize = sizeName;
  }

  void _callReadGetCourse() async {
    // print('------------hello');
    dynamic response = await Dio().get('$server/py-api/dcc/lms/recomend');
    // print(response.data.toString());

    setState(() {
      _futureNews = Future.value(response.data);
    });

    // return Future.value(response);
  }

  Future<List<dynamic>> _readBanner() async {
    Dio dio = Dio();
    Response<dynamic> response;
    try {
      response = await dio.post('$server/dcc-api/m/Banner/main/read', data: {});
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          return response.data['objectData'];
        }
      }
    } catch (e) {}
    return [];
  }

  void onRefresh() async {
    _determinePosition();
    _callRead();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  // Future<Null> _callReadPolicy() async {
  //   var policy = await postDio(server + "m/policy/read", {
  //     "category": "application",
  //   });
  //   if (policy.length > 0) {
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (context) => PolicyPage(
  //           category: 'application',
  //           navTo: () {
  //             Navigator.of(context).pushAndRemoveUntil(
  //               MaterialPageRoute(
  //                 builder: (context) => Menu(),
  //               ),
  //               (Route<dynamic> route) => false,
  //             );
  //           },
  //         ),
  //       ),
  //       (Route<dynamic> route) => false,
  //     );
  //   }
  // }

  void _callOpenPage(param) {
    if (param == 'devcourse') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewInAppPage(
            url: "https://dcc.onde.go.th/user/digitalskill/coursecategory/46",
            title: "DevCourse",
          ),
        ),
      );
    } else if (param == 'digital') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewInAppPage(
            url: "https://dcc.onde.go.th/user/digitalskill/coursecategory/13",
            title: "Digital Literacy",
          ),
        ),
      );
    } else if (param == 'market') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewInAppPage(
            url: "https://dcc.onde.go.th/user/digitalskill/coursecategory/27",
            title: "DevCourse",
          ),
        ),
      );
    } else if (param == 'btn1') {
      // buildModalWaiting(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewInAppPage(
            url: "https://dcc.onde.go.th/user/digitalskill/coursecategory/6",
            title: "การเกษตรสมัยใหม่",
          ),
        ),
      );
    } else if (param == 'btn2') {
      // buildModalWaiting(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewInAppPage(
            url: "https://dcc.onde.go.th/user/digitalskill/coursecategory/5",
            title: "ธุรกิจชุมชน",
          ),
        ),
      );
    } else if (param == 'btn3') {
      // buildModalWaiting(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewInAppPage(
            url: "https://dcc.onde.go.th/user/digitalskill/coursecategory/7",
            title: "ดูแลผู้สูงอายุ",
          ),
        ),
      );
    } else if (param == 'btn4') {
      // buildModalWaiting(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewInAppPage(
            url: "https://dcc.onde.go.th/user/digitalskill/coursecategory/8",
            title: "ท่องเที่ยว",
          ),
        ),
      );
    } else if (param == 'booking') {
      widget.changePage!(1);
    } else if (param == 'job') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => FindJobPage()));
    } else if (param == 'fund') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => FundPage()));
    } else if (param == 'skill') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MyClassAllPage(
            title: 'ระบบส่งเสริม Re-skill',
          ),
        ),
      );
      // buildModalWaiting(context);
    } else if (param == 'knowledge') {
      // buildModalWaiting(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MyClassAllPage(
            title: 'คลังข้อมูล',
          ),
        ),
      );
    } else if (param == 'report') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReportProblemPage(),
        ),
      );
    } else if (param == 'chat') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatBotNoiPage(),
          // builder: (context) => ChatPage(),
        ),
      );
    }
  }

  _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          currentLocation = 'เปิดการเข้าถึงตำแหน่งเพื่อใช้บริการ';
        });
        return Future.error('Location Not Available');
      }
    } else if (permission == LocationPermission.always) {
    } else if (permission == LocationPermission.whileInUse) {
    } else if (permission == LocationPermission.unableToDetermine) {
    } else {
      throw Exception('Error');
    }
    _getLocation();
    // return await Geolocator.getCurrentPosition();
  }

  _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'th');

      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        currentLocation = (placemarks.first.subLocality ?? '') +
            ((placemarks.first.subLocality ?? '').isNotEmpty ? ', ' : '') +
            (placemarks.first.administrativeArea ?? '');
      });
    } catch (e) {}
  }

  buildModalSwitch(
    BuildContext context,
  ) {
    return showCupertinoModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter mSetState /*You can rename this!*/) {
            return Material(
              type: MaterialType.transparency,
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  height: 500,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).custom.w_b_b,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Text(
                        'ขนาดตัวหนังสือ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).custom.b_w_y,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      contentCard(context, "ปกติ", "1", "size"),
                      SizedBox(height: 10),
                      contentCard(context, "ปานกลาง", "2", "size"),
                      SizedBox(height: 10),
                      contentCard(context, "ใหญ่", "3", "size"),
                      SizedBox(height: 20),
                      Text(
                        'ความตัดกันของสี',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).custom.b_w_y,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      // contentCard(context, "ปกติ", "1", "color"),
                      // SizedBox(height: 10),
                      // contentCard(context, "ขาวดำ", "2", "color"),
                      // SizedBox(height: 10),
                      // contentCard(context, "ดำเหลือง", "3", "color"),
                      contentCardV2(context, mSetState),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  contentCard(BuildContext context, String title, String size, String type) {
    return InkWell(
      onTap: () {
        setState(
          (() {
            storage.write(
              key: 'switchSizeFont',
              value: title,
            );
            fontStorageValue = title;
            setState(
              () {
                if (title == "ปกติ") {
                  // MyApp.themeNotifier.value = ThemeModeThird.light;
                  MyApp.fontKanit.value = FontKanit.small;
                } else if (title == "ปานกลาง") {
                  MyApp.fontKanit.value = FontKanit.medium;
                } else {
                  MyApp.fontKanit.value = FontKanit.large;
                }
              },
            );
          }),
        );
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          height: 45,
          // width: 145,
          decoration: BoxDecoration(
            // border: Border.all(
            //   width: 1,
            //   style: BorderStyle.solid,
            //   color: MyApp.themeNotifier.value == ThemeModeThird.light
            //       ? (title == fontStorageValue ? Colors.white : Colors.black)
            //       : MyApp.themeNotifier.value == ThemeModeThird.dark
            //           ? (title == fontStorageValue
            //               ? Colors.black
            //               : Colors.white)
            //           : (title == fontStorageValue
            //               ? Colors.black
            //               : Color(0xFFFFFD57)),
            // ),
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? (title == fontStorageValue ? Color(0xFF7A4CB1) : Colors.white)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? (title == fontStorageValue
                        ? Colors.white
                        : Color(0xFF121212))
                    : (title == fontStorageValue
                        ? Color(0xFFFFFD57)
                        : Color(0xFF121212)),
            borderRadius: BorderRadius.circular(73),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  type == "color"
                      ? Image.asset(
                          title == "ปกติ"
                              ? 'assets/images/icon_rp.png'
                              : title == "ขาวดำ"
                                  ? 'assets/images/icon_wb.png'
                                  : "assets/images/icon_yb.png",
                          height: 35,
                          // width: 35,
                        )
                      : Container(),
                  SizedBox(width: 5),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? (title == fontStorageValue
                              ? Colors.white
                              : Colors.black)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? (title == fontStorageValue
                                  ? Colors.black
                                  : Colors.white)
                              : (title == fontStorageValue
                                  ? Colors.black
                                  : Color(0xFFFFFD57)),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                height: 25,
                width: 25,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? (title == fontStorageValue
                            ? Colors.white
                            : Color(0xFFDDDDDD))
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? (title == fontStorageValue
                                ? Colors.black
                                : Colors.white)
                            : (title == fontStorageValue
                                ? Colors.black
                                : Color(0xFFFFFD57)),
                  ),
                  shape: BoxShape.circle,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? (title == fontStorageValue
                          ? Colors.white
                          : Color(0xFFDDDDDD))
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? (title == fontStorageValue
                              ? Colors.black
                              : Color(0xFF1E1E1E))
                          : (title == fontStorageValue
                              ? Colors.black
                              : Colors.black),
                ),
                child: Container(
                  // height: 15,
                  // width: 15,
                  // padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? (title == fontStorageValue
                            ? Color(0xFF7A4CB1)
                            : Color(0xFFDDDDDD))
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? (title == fontStorageValue
                                ? Colors.white
                                : Color(0xFF1E1E1E))
                            : (title == fontStorageValue
                                ? Color(0xFFFFFD57)
                                : Colors.black),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 12,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? (title == fontStorageValue
                            ? Colors.white
                            : Color(0xFFDDDDDD))
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? (title == fontStorageValue
                                ? Colors.black
                                : Color(0xFF1E1E1E))
                            : (title == fontStorageValue
                                ? Colors.black
                                : Colors.black),
                  ),
                ),
                //   child:
                //   Image.asset(
                //   item['isSelected'] == true
                //       ? 'assets/images/icon_check.png'
                //       : "assets/images/icon_nocheck.png",

                // )
              ),
            ],
          )),
    );
  }

  contentCardV2(BuildContext context, StateSetter mSetState) {
    return Container(
      child: Wrap(
          children: _listSwitchColors
              .map(
                (item) => GestureDetector(
                  onTap: () {
                    setState(
                      (() async {
                        await storage.write(
                          key: 'switchColor',
                          value: item['title'],
                        );
                        setState(
                          () {
                            if (item['title'] == "ปกติ") {
                              MyApp.themeNotifier.value = ThemeModeThird.light;
                            } else if (item['title'] == "ขาวดำ") {
                              MyApp.themeNotifier.value = ThemeModeThird.dark;
                            } else {
                              MyApp.themeNotifier.value =
                                  ThemeModeThird.blindness;
                            }
                            for (int i = 0; i < _listSwitchColors.length; i++) {
                              if (_listSwitchColors[i]['code'] ==
                                  item['code']) {
                                item['isSelected'] = !item['isSelected'];
                              } else {
                                _listSwitchColors[i]['isSelected'] = false;
                              }
                            }
                          },
                        );
                      }),
                    );
                    // _callRead();
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      height: 45,
                      // width: 145,
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? (item['isSelected'] == true
                                ? Color(0xFF7A4CB1)
                                : Colors.white)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? (item['isSelected'] == true
                                    ? Colors.white
                                    : Color(0xFF121212))
                                : (item['isSelected'] == true
                                    ? Color(0xFFFFFD57)
                                    : Color(0xFF121212)),
                        // item['isSelected'] == true
                        //     ? Color(0xFF7A4CB1)
                        //     : Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(73),
                        // border: Border.all(
                        //   width: 1,
                        //   style: BorderStyle.solid,
                        //   color: MyApp.themeNotifier.value ==
                        //           ThemeModeThird.light
                        //       ? (item['isSelected'] == true
                        //           ? Color(0xFF7A4CB1)
                        //           : Colors.white)
                        //       : MyApp.themeNotifier.value ==
                        //               ThemeModeThird.dark
                        //           ? (item['isSelected'] == true
                        //               ? Colors.white
                        //               : Color(0xFF292929))
                        //           : (item['isSelected'] == true
                        //               ? Color(0xFFFFFD57)
                        //               : Color(0xFF292929)),
                        // )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                item['code'] == '1'
                                    ? 'assets/images/icon_rp.png'
                                    : item['code'] == '2'
                                        ? 'assets/images/icon_wb.png'
                                        : "assets/images/icon_yb.png",
                                height: 35,
                                // width: 35,
                              ),
                              SizedBox(width: 5),
                              Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 17,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? (item['isSelected'] == true
                                          ? Colors.white
                                          : Colors.black)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? (item['isSelected'] == true
                                              ? Colors.black
                                              : Colors.white)
                                          : (item['isSelected'] == true
                                              ? Colors.black
                                              : Color(0xFFFFFD57)),
                                  // color: item['isSelected'] == true
                                  //     ? Color(0xFFFFFFFF)
                                  //     : Color(0xFF000000),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? (item['isSelected'] == true
                                        ? Colors.white
                                        : Color(0xFFDDDDDD))
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? (item['isSelected'] == true
                                            ? Colors.black
                                            : Colors.white)
                                        : (item['isSelected'] == true
                                            ? Colors.black
                                            : Color(0xFFFFFD57)),
                              ),
                              shape: BoxShape.circle,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? (item['isSelected'] == true
                                      ? Colors.white
                                      : Color(0xFFDDDDDD))
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? (item['isSelected'] == true
                                          ? Colors.black
                                          : Color(0xFF1E1E1E))
                                      : (item['isSelected'] == true
                                          ? Colors.black
                                          : Colors.black),
                            ),
                            child: Container(
                              // height: 15,
                              // width: 15,
                              // padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? (item['isSelected'] == true
                                        ? Color(0xFF7A4CB1)
                                        : Color(0xFFDDDDDD))
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? (item['isSelected'] == true
                                            ? Colors.white
                                            : Color(0xFF1E1E1E))
                                        : (item['isSelected'] == true
                                            ? Color(0xFFFFFD57)
                                            : Colors.black),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 12,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? (item['isSelected'] == true
                                        ? Colors.white
                                        : Color(0xFFDDDDDD))
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? (item['isSelected'] == true
                                            ? Colors.black
                                            : Color(0xFF1E1E1E))
                                        : (item['isSelected'] == true
                                            ? Colors.black
                                            : Colors.black),
                              ),
                            ),
                            //   child:
                            //   Image.asset(
                            //   item['isSelected'] == true
                            //       ? 'assets/images/icon_check.png'
                            //       : "assets/images/icon_nocheck.png",

                            // )
                          ),
                        ],
                      )),
                ),
              )
              .toList()),
    );
  }

  _performActionOnNotification(Map<String, dynamic> message) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationListPage(),
      ),
    );
  }
}
