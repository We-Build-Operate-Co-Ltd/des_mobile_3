import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:des/detail.dart';
import 'package:des/new-detail.dart';
import 'package:des/notification_list.dart';
import 'package:des/shared/counterNotifier.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
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
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:ui' as ui show ImageFilter;
import 'chat_botnoi.dart';
import 'widget/blinking_icon.dart';
import 'shared/config.dart';
import 'main.dart';
import 'shared/notification_service.dart';
import 'webview_inapp.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    this.changePage,
  });
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
  Dio dio = Dio();

  dynamic futureNotificationTire;
  List<dynamic>? dataCharts1;
  int? notificationCount = 0;

  int notiCount = 0;
  int currentTabIndex = 0;
  int viewAdd = 4;
  double _hight = 30.0;
  double _width = 30.0;

  String? profileCode = "";
  String? profileUserName = "";
  String? userCode = '';
  String? $imageUrl = '';
  String? priceToday = '';
  String? selectedSize = "";

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

  // Future<dynamic>? _futureNews;
  Future<dynamic>? _futureBanner;
  String? fontStorageValue;
  String? colorStorageValue;

  String _api_key = '19f072f9e4b14a19f72229719d2016d1';
  String service = 'https://lms.dcc.onde.go.th/api/';

  List<dynamic> _lmsCategoryList = [];
  String cateCourseSearch = '';
  List<dynamic> _tempModelRecommend = [];
  Future<dynamic>? _modelRecommend;
  int _listFilterLenght = 0;
  String textSearch = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    NotificationService.instance.start(context);

    // _notificationSubscription = NotificationsBloc.instance.notificationStream
    //     .listen(_performActionOnNotification);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _determinePosition();
    });
    _get_LmsCategory();
    _callReadRecomment();
    _callRead();
    // _callReadGetCourse();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _get_LmsCategory() async {
    var response = await dio.get('${ondeURL}/api/Lms/GetCategory');
    setState(() {
      _lmsCategoryList.addAll(response.data['data']);
    });
  }

  _callReadRecomment() async {
    // var response = await Dio().get('$server/py-api/dcc/lms/recomend');
    var response =
        await Dio().get('$serverPlatform/api/Lms/GetRecommendCourse');
    if (!mounted) return;
    setState(() {
      _modelRecommend = Future.value(response.data);
      _tempModelRecommend.addAll(response.data);
    });
  }

  _filter() async {
    var temp = _tempModelRecommend.where((item) {
      final courseName = item['course_Name'].toString().toLowerCase();
      final searchText = textSearch.toString().toLowerCase();

      return courseName.contains(searchText) &&
          (cateCourseSearch.isEmpty ||
              item['course_Cat_Id'] == cateCourseSearch);
    }).toList();

    setState(() {
      _listFilterLenght = temp.length;
      _modelRecommend = Future.value(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MyApp.themeNotifier.value == ThemeModeThird.light
            ? Image.asset(
                "assets/images/BG.png",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )
            : ColorFiltered(
                colorFilter:
                    ColorFilter.mode(Colors.grey, BlendMode.saturation),
                child: Image.asset(
                  "assets/images/BG.png",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              IntrinsicHeight(
                child: Container(
                  height: MyApp.fontKanit.value == FontKanit.small
                      ? 125
                      : MyApp.fontKanit.value == FontKanit.medium
                          ? 150
                          : 170,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    right: 15,
                    left: 15,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          MyApp.themeNotifier.value == ThemeModeThird.light
                              ? 'assets/images/Owl-10.png'
                              : "assets/images/2024/Owl-10_blackwhite.png",
                          height: 40,
                          width: 50,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              direction: Axis.horizontal,
                              spacing: 8.0, // ระยะห่างระหว่าง widget
                              runSpacing: 4.0,
                              children: [
                                Text(
                                  'ศูนย์ดิจิทัลชุมชน',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Colors.white
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  // overflow:
                                  //     TextOverflow.visible, // ป้องกันการตัดคำ
                                  maxLines: 2,
                                ),
                                Text(
                                  'Digital Community Center',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Colors.white
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  // maxLines: 1,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 10.0, // ระยะห่างระหว่าง widget
                            runSpacing: 4.0,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  buildModalSwitch(context);
                                },
                                child: Image.asset(
                                  MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? 'assets/images/icon_blind.png'
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? 'assets/images/icon_blind_d.png'
                                          : 'assets/images/icon_blind_d-y.png',
                                  height:
                                      MyApp.fontKanit.value == FontKanit.small
                                          ? 30
                                          : MyApp.fontKanit.value ==
                                                  FontKanit.medium
                                              ? 35
                                              : 40,
                                  width:
                                      MyApp.fontKanit.value == FontKanit.small
                                          ? 30
                                          : MyApp.fontKanit.value ==
                                                  FontKanit.medium
                                              ? 35
                                              : 40,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.changePage!(3);
                                },
                                child: Consumer<CounterNotifier>(
                                  builder: (context, counterNotifier, child) {
                                    return notiCount > 0
                                        ? badges.Badge(
                                            badgeContent: Text(
                                              notiCount.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: Image.asset(
                                              MyApp.themeNotifier.value ==
                                                      ThemeModeThird.light
                                                  ? 'assets/images/notification.png'
                                                  : MyApp.themeNotifier.value ==
                                                          ThemeModeThird.dark
                                                      ? 'assets/images/notification_d.png'
                                                      : 'assets/images/notification_d-y.png',
                                              height: _hight,
                                              width: _width,
                                            ),
                                          )
                                        : Image.asset(
                                            MyApp.themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? 'assets/images/notification.png'
                                                : MyApp.themeNotifier.value ==
                                                        ThemeModeThird.dark
                                                    ? 'assets/images/notification_d.png'
                                                    : 'assets/images/notification_d-y.png',
                                            height: MyApp.fontKanit.value ==
                                                    FontKanit.small
                                                ? 30
                                                : MyApp.fontKanit.value ==
                                                        FontKanit.medium
                                                    ? 35
                                                    : 40,
                                            width: MyApp.fontKanit.value ==
                                                    FontKanit.small
                                                ? 30
                                                : MyApp.fontKanit.value ==
                                                        FontKanit.medium
                                                    ? 35
                                                    : 40,
                                          );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // child: Row(
                  //   children: [
                  //     Image.asset(
                  //       MyApp.themeNotifier.value == ThemeModeThird.light
                  //           ? 'assets/images/Owl-10.png'
                  //           : "assets/images/2024/Owl-10_blackwhite.png",
                  //       height: 39,
                  //       width: 48,
                  //     ),
                  //     const SizedBox(width: 5),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'ศูนย์ดิจิทัลชุมชน',
                  //           style: TextStyle(
                  //             fontSize: 18,
                  //             color: MyApp.themeNotifier.value ==
                  //                     ThemeModeThird.light
                  //                 ? Colors.white
                  //                 : MyApp.themeNotifier.value ==
                  //                         ThemeModeThird.dark
                  //                     ? Colors.white
                  //                     : Color(0xFFFFFD57),
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //         Text(
                  //           'Digital Community Center',
                  //           style: TextStyle(
                  //             fontSize: 11,
                  //             color: MyApp.themeNotifier.value ==
                  //                     ThemeModeThird.light
                  //                 ? Colors.white
                  //                 : MyApp.themeNotifier.value ==
                  //                         ThemeModeThird.dark
                  //                     ? Colors.white
                  //                     : Color(0xFFFFFD57),
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     const Expanded(child: SizedBox()),
                  //     const SizedBox(width: 10),
                  //     GestureDetector(
                  //       onTap: () {
                  //         buildModalSwitch(context);
                  //       },
                  //       child: Image.asset(
                  //         MyApp.themeNotifier.value == ThemeModeThird.light
                  //             ? 'assets/images/icon_blind.png'
                  //             : MyApp.themeNotifier.value == ThemeModeThird.dark
                  //                 ? 'assets/images/icon_blind_d.png'
                  //                 : 'assets/images/icon_blind_d-y.png',
                  //         height: 35,
                  //         width: 35,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     GestureDetector(
                  //       onTap: () {
                  //         // Fluttertoast.showToast(
                  //         //     msg: '''ยังไม่เปิดให้ใช้บริการ''');
                  //         widget.changePage!(3);
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(
                  //         //     builder: (context) => NotificationBookingPage(),
                  //         //   ),
                  //         // );
                  //       },
                  //       child: Consumer<CounterNotifier>(
                  //         builder: (context, counterNotifier, child) {
                  //           return notiCount > 0
                  //               ? badges.Badge(
                  //                   badgeContent: Text(
                  //                     counterNotifier.counter.toString(),
                  //                     style: TextStyle(color: Colors.white),
                  //                   ),
                  //                   child: Image.asset(
                  //                     MyApp.themeNotifier.value ==
                  //                             ThemeModeThird.light
                  //                         ? 'assets/images/notification.png'
                  //                         : MyApp.themeNotifier.value ==
                  //                                 ThemeModeThird.dark
                  //                             ? 'assets/images/notification_d.png'
                  //                             : 'assets/images/notification_d-y.png',
                  //                     height: 35,
                  //                     width: 35,
                  //                   ),
                  //                 )
                  //               : Image.asset(
                  //                   MyApp.themeNotifier.value ==
                  //                           ThemeModeThird.light
                  //                       ? 'assets/images/notification.png'
                  //                       : MyApp.themeNotifier.value ==
                  //                               ThemeModeThird.dark
                  //                           ? 'assets/images/notification_d.png'
                  //                           : 'assets/images/notification_d-y.png',
                  //                   height: 35,
                  //                   width: 35,
                  //                 );
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.white
                        : Colors.black,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.10),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: _refreshController,
                    onRefresh: onRefresh,
                    child: ListView(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 5,
                        right: 15,
                        left: 15,
                      ),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        FutureBuilder(
                          future: _futureBanner,
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.length == 0)
                                return const SizedBox(height: 200);
                              return Container(
                                height: 200,
                                child: Column(
                                  children: [
                                    // SizedBox(
                                    //   height: 180,
                                    //   child: CarouselSlider(
                                    //     options: CarouselOptions(
                                    //       aspectRatio: 4,
                                    //       enlargeCenterPage: true,
                                    //       scrollDirection: Axis.horizontal,
                                    //       viewportFraction: 0.9,
                                    //       autoPlay: true,
                                    //       enlargeFactor: 0.4,
                                    //       enlargeStrategy:
                                    //           CenterPageEnlargeStrategy.zoom,
                                    //       onPageChanged: (index, reason) {
                                    //         setState(() {
                                    //           _currentBanner = index;
                                    //         });
                                    //       },
                                    //     ),
                                    //     items: snapshot.data.map<Widget>(
                                    //       (item) {
                                    //         int index =
                                    //             snapshot.data.indexOf(item);
                                    //         return GestureDetector(
                                    //           onTap: () {
                                    //             if (snapshot.data[
                                    //                         _currentBanner]
                                    //                     ['action'] ==
                                    //                 'out') {
                                    //               if (snapshot
                                    //                       .data[_currentBanner]
                                    //                   ['isPostHeader']) {
                                    //                 var path = snapshot.data[
                                    //                         _currentBanner]
                                    //                     ['linkUrl'];
                                    //                 if (profileCode != '') {
                                    //                   var splitCheck = path
                                    //                       .split('')
                                    //                       .reversed
                                    //                       .join();
                                    //                   if (splitCheck[0] !=
                                    //                       "/") {
                                    //                     path = path + "/";
                                    //                   }
                                    //                   var codeReplae = "B" +
                                    //                       profileCode!
                                    //                           .replaceAll(
                                    //                               '-', '') +
                                    //                       snapshot.data[
                                    //                               _currentBanner]
                                    //                               ['code']
                                    //                           .replaceAll(
                                    //                               '-', '');
                                    //                   // launchUrl(Uri.parse('$path$codeReplae'),
                                    //                   //     mode:
                                    //                   //         LaunchMode.externalApplication);
                                    //                   Navigator.push(
                                    //                     context,
                                    //                     MaterialPageRoute(
                                    //                       builder: (_) =>
                                    //                           WebViewInAppPage(
                                    //                         url:
                                    //                             "$path$codeReplae",
                                    //                         title: snapshot
                                    //                                     .data[
                                    //                                 _currentBanner]
                                    //                             ['title'],
                                    //                       ),
                                    //                     ),
                                    //                   );
                                    //                 }
                                    //               } else
                                    //                 // launchUrl(
                                    //                 //     Uri.parse(snapshot
                                    //                 //         .data[_currentBanner]['linkUrl']),
                                    //                 //     mode: LaunchMode.externalApplication);
                                    //                 Navigator.push(
                                    //                   context,
                                    //                   MaterialPageRoute(
                                    //                     builder: (_) =>
                                    //                         WebViewInAppPage(
                                    //                       url: snapshot.data[
                                    //                               _currentBanner]
                                    //                           ['linkUrl'],
                                    //                       title: snapshot.data[
                                    //                               _currentBanner]
                                    //                           ['title'],
                                    //                     ),
                                    //                   ),
                                    //                 );
                                    //             } else if (snapshot.data[
                                    //                         _currentBanner]
                                    //                     ['action'] ==
                                    //                 'in') {
                                    //               Navigator.push(
                                    //                 context,
                                    //                 MaterialPageRoute(
                                    //                   builder: (context) =>
                                    //                       DetailPage(
                                    //                     slug: 'mock',
                                    //                     model: snapshot.data[
                                    //                         _currentBanner],
                                    //                   ),
                                    //                 ),
                                    //               );
                                    //             }
                                    //           },
                                    //           child: ClipRRect(
                                    //             borderRadius: _currentBanner ==
                                    //                     index
                                    //                 ? BorderRadius.all(
                                    //                     Radius.circular(20))
                                    //                 : BorderRadius.circular(0),
                                    //             child: CachedNetworkImage(
                                    //               imageUrl: item['imageUrl'],
                                    //               fit: BoxFit.cover,
                                    //               width: double.infinity,
                                    //               height: double.infinity,
                                    //             ),
                                    //           ),
                                    //         );
                                    //       },
                                    //     ).toList(),
                                    //   ),
                                    // ),
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
                                          enlargeStrategy:
                                              CenterPageEnlargeStrategy.zoom,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _currentBanner = index;
                                            });
                                          },
                                        ),
                                        items:
                                            snapshot.data.map<Widget>((item) {
                                          int index =
                                              snapshot.data.indexOf(item);
                                          return GestureDetector(
                                            // onTap: () {
                                            //   print(
                                            //       '=============================');
                                            //   // ตรวจสอบ action ถ้าเป็นค่าว่างหรือ null ให้ถือว่าเป็น 'out' (เปิดลิ้งภายนอก)
                                            //   String action =
                                            //       snapshot.data[_currentBanner]
                                            //               ['action'] ??
                                            //           '';
                                            //   // ถ้า action เป็นค่าว่าง ให้ default เป็น 'out'
                                            //   if (action.isEmpty) {
                                            //     action = 'out';
                                            //   }
                                            //   if (action == 'out') {
                                            //     // ตรวจสอบว่ามี linkUrl หรือไม่
                                            //     String? linkUrl = snapshot
                                            //             .data[_currentBanner]
                                            //         ['linkUrl'];
                                            //     if (linkUrl != null &&
                                            //         linkUrl.isNotEmpty) {
                                            //       if (snapshot.data[
                                            //                   _currentBanner]
                                            //               ['isPostHeader'] ==
                                            //           true) {
                                            //         var path = linkUrl;
                                            //         if (profileCode != null &&
                                            //             profileCode!
                                            //                 .isNotEmpty) {
                                            //           var splitCheck = path
                                            //               .split('')
                                            //               .reversed
                                            //               .join();
                                            //           if (splitCheck[0] !=
                                            //               "/") {
                                            //             path = path + "/";
                                            //           }
                                            //           var codeReplace = "B" +
                                            //               profileCode!
                                            //                   .replaceAll(
                                            //                       '-', '') +
                                            //               snapshot.data[
                                            //                       _currentBanner]
                                            //                       ['ç']
                                            //                   .replaceAll(
                                            //                       '-', '');
                                            //           Navigator.push(
                                            //             context,
                                            //             MaterialPageRoute(
                                            //               builder: (_) =>
                                            //                   WebViewInAppPage(
                                            //                 url:
                                            //                     "$path$codeReplace",
                                            //                 title: snapshot.data[
                                            //                             _currentBanner]
                                            //                         ['title'] ??
                                            //                     '',
                                            //               ),
                                            //             ),
                                            //           );
                                            //         } else {
                                            //           // ถ้าไม่มี profileCode ให้เปิดลิ้งตรงๆ
                                            //           Navigator.push(
                                            //             context,
                                            //             MaterialPageRoute(
                                            //               builder: (_) =>
                                            //                   WebViewInAppPage(
                                            //                 url: linkUrl,
                                            //                 title: snapshot.data[
                                            //                             _currentBanner]
                                            //                         ['title'] ??
                                            //                     '',
                                            //               ),
                                            //             ),
                                            //           );
                                            //         }
                                            //       } else {
                                            //         Navigator.push(
                                            //           context,
                                            //           MaterialPageRoute(
                                            //             builder: (_) =>
                                            //                 WebViewInAppPage(
                                            //               url: linkUrl,
                                            //               title: snapshot.data[
                                            //                           _currentBanner]
                                            //                       ['title'] ??
                                            //                   '',
                                            //             ),
                                            //           ),
                                            //         );
                                            //       }
                                            //     } else {
                                            //       print('No linkUrl provided');
                                            //       // อาจจะแสดง Snackbar หรือ Alert บอกผู้ใช้
                                            //       ScaffoldMessenger.of(context)
                                            //           .showSnackBar(
                                            //         SnackBar(
                                            //           backgroundColor:
                                            //               Theme.of(context)
                                            //                   .custom
                                            //                   .b325f8_w_fffd57,
                                            //           content: Text(
                                            //               'ไม่พบลิงก์ที่จะเปิด'),
                                            //         ),
                                            //       );
                                            //     }
                                            //   } else if (action == 'in') {
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             DetailPage(
                                            //           slug: 'mock',
                                            //           model: snapshot
                                            //               .data[_currentBanner],
                                            //         ),
                                            //       ),
                                            //     );
                                            //   } else {
                                            //     print(
                                            //         'Unknown action: $action');
                                            //     ScaffoldMessenger.of(context)
                                            //         .showSnackBar(
                                            //       SnackBar(
                                            //           content: Text(
                                            //               'ประเภทการทำงานไม่รองรับ: $action')),
                                            //     );
                                            //   }
                                            // },
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewsDetailPage(
                                                    model: item,
                                                  ),
                                                ),
                                              );
                                            },

                                            child: ClipRRect(
                                              borderRadius: _currentBanner ==
                                                      index
                                                  ? BorderRadius.all(
                                                      Radius.circular(20))
                                                  : BorderRadius.circular(0),
                                              child: MyApp.themeNotifier
                                                          .value ==
                                                      ThemeModeThird.light
                                                  ? Image.network(
                                                      item['imageUrl'],
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return BlinkingIcon();
                                                      },
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.asset(
                                                            'assets/icon.png');
                                                      },
                                                    )
                                                  : ColorFiltered(
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        Colors.grey,
                                                        BlendMode.saturation,
                                                      ),
                                                      child: Image.network(
                                                        item['imageUrl'],
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return BlinkingIcon();
                                                        },
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Icon(
                                                              Icons.error);
                                                        },
                                                      ),
                                                    ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),

                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          snapshot.data.map<Widget>((url) {
                                        int index = snapshot.data.indexOf(url);
                                        return Container(
                                          width: _currentBanner == index
                                              ? 17.5
                                              : 7.0,
                                          height: 7.0,
                                          margin: EdgeInsets.all(2.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: _currentBanner == index
                                                ? MyApp.themeNotifier.value ==
                                                        ThemeModeThird.light
                                                    ? Color(0xFFBD4BF7)
                                                    : MyApp.themeNotifier
                                                                .value ==
                                                            ThemeModeThird.dark
                                                        ? Colors.white
                                                        : Color(0xFFFFFD57)
                                                : Color(0XFFDDDDDD),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox(height: 200);
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'บริการสำหรับคุณ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Row 1
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: columnButton(
                                    MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? 'assets/images/chat2.png'
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? 'assets/images/chat2_d.png'
                                            : 'assets/images/chat2_d-y.png',
                                    'สนทนา',
                                    type: 'serviceforyou',
                                    code: 'chat',
                                  ),
                                ),
                                Expanded(
                                  child: columnButton(
                                    MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? 'assets/images/reserve_service.png'
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? 'assets/images/reserve_service_d.png'
                                            : 'assets/images/reserve_service_d-y.png',
                                    'จองใช้บริการ',
                                    type: 'serviceforyou',
                                    code: 'booking',
                                  ),
                                ),
                                Expanded(
                                  child: columnButton(
                                    MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? 'assets/images/find_job.png'
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? 'assets/images/find_job_d.png'
                                            : 'assets/images/find_job_d-y.png',
                                    'จับคู่งาน',
                                    type: 'serviceforyou',
                                    code: 'job',
                                  ),
                                ),
                                Expanded(
                                  child: columnButton(
                                    MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? 'assets/images/reskill.png'
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? 'assets/images/reskill_d.png'
                                            : 'assets/images/reskill_d-y.png',
                                    'ระบบส่งเสริม\nRe-skill',
                                    type: 'serviceforyou',
                                    code: 'skill',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    16.0), // ระยะห่างระหว่าง Row 1 และ Row 2

                            // Row 2
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: columnButton(
                                    MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? 'assets/images/funding_source.png'
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? 'assets/images/funding_source_d.png'
                                            : 'assets/images/funding_source_d-y.png',
                                    'สรรหา\nแหล่งทุน',
                                    type: 'serviceforyou',
                                    code: 'fund',
                                  ),
                                ),
                                Expanded(
                                  child: columnButton(
                                    MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? 'assets/images/report_problem.png'
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? 'assets/images/report_problem_d.png'
                                            : 'assets/images/report_problem_d-y.png',
                                    'แจ้งปัญหา',
                                    type: 'serviceforyou',
                                    code: 'report',
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'หลักสูตรฝึกอบรม ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).custom.b325f8_w_fffd57,
                          ),
                        ),
                        Text(
                          'ไม่หยุดที่จะเรียนรู้ คอร์สหลากหลาย เรียนได้ทุกที่ทุกเวลา',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).custom.b325f8_w_fffd57,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 45,
                          width: 360,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (text) {
                              setState(() {
                                textSearch = text;
                                _filter();
                              });
                            },
                            style: TextStyle(
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.black
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.black
                                      : Color(0xFFFFFD57),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.white
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Colors.grey.withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "ค้นหาคอร์สเรียน",
                              hintStyle: TextStyle(
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? const Color(0xffb2b2b2)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.black
                                          : Color(0xFFFFFD57),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                  decorationThickness: 6),
                              prefixIcon: const Icon(Icons.search),
                              prefixIconColor: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.black
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.black
                                      : Color(0xFFFFFD57),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _lmsCategory(),
                        const SizedBox(height: 10),
                        _buildRecomment(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              viewAdd += 4;
                            });
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.white
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Theme.of(context).custom.b325f8_w_fffd57
                                    : Colors.black,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'ดูเพิ่มเติม',
                              style: TextStyle(
                                fontSize: 15,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Theme.of(context).custom.b325f8_w_fffd57
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 20 + MediaQuery.of(context).padding.bottom),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget containerRecommendedClass(dynamic model) {
  //   return GestureDetector(
  //     onTap: () {
  //       var data = {
  //         'course_id': model?['id'] ?? '',
  //         "course_name": model?['name'] ?? '',
  //         "course_cat_id": model?['course_cat_id'] ?? '',
  //         "cover_image": model?['docs'] ?? '',
  //         "description": model['details'] ?? '',
  //         "created_at": model['created_at'] ?? '',
  //         "category_name": model['cat_name'] ?? '',
  //         "certificate": model['certificate'] ?? '',
  //       };
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CourseDetailPage(
  //             model: data,
  //           ),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       // elevation: 4,
  //       color: Theme.of(context).custom.primary,
  //       child: Container(
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).custom.primary,
  //           // border: Border.all(
  //           //   color: Theme.of(context).custom.b_w_y,
  //           // ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color.fromARGB(0, 0, 0, 0).withOpacity(0.15),
  //               offset: const Offset(
  //                 3.0,
  //                 3.0,
  //               ),
  //               blurRadius: 10.0,
  //               spreadRadius: 0.0,
  //             ),
  //           ],
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Column(
  //           children: [
  //             ClipRRect(
  //                 borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(10),
  //                   topRight: Radius.circular(10),
  //                 ),
  //                 child: MyApp.themeNotifier.value == ThemeModeThird.light
  //                     ? (model?['docs'] ?? '') != ''
  //                         ? Image.network(
  //                             'https://lms.dcc.onde.go.th/uploads/course/${model?['docs']}',
  //                             height: 120,
  //                             width: double.infinity,
  //                             fit: BoxFit.cover,
  //                           )
  //                         : Image.asset(
  //                             'assets/icon.png',
  //                             height: 120,
  //                             width: double.infinity,
  //                             fit: BoxFit.cover,
  //                           )
  //                     : ColorFiltered(
  //                         colorFilter: ColorFilter.mode(
  //                             Colors.grey, BlendMode.saturation),
  //                         child: Image.network(
  //                           'https://lms.dcc.onde.go.th/uploads/course/${model?['docs']}',
  //                           height: 120,
  //                           width: double.infinity,
  //                           fit: BoxFit.cover,
  //                         ),
  //                       )),
  //             const SizedBox(height: 9),
  //             Expanded(
  //               child: Container(
  //                 alignment: Alignment.topLeft,
  //                 padding: const EdgeInsets.symmetric(horizontal: 8),
  //                 child: Text(
  //                   model?['name'] ?? '',
  //                   style: TextStyle(
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w400,
  //                     color: Theme.of(context).custom.b_w_y,
  //                   ),
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8),
  //               child: Row(
  //                 children: [
  //                   Image.asset(
  //                       MyApp.themeNotifier.value == ThemeModeThird.light
  //                           ? 'assets/images/course_time.png'
  //                           : "assets/images/2024/time_home_page_blackwhite.png",
  //                       height: 24,
  //                       width: 24),
  //                   const SizedBox(width: 8),
  //                   Text(
  //                     formatDuration(model?['course_duration']),
  //                     style: TextStyle(
  //                       fontSize: 9,
  //                       fontWeight: FontWeight.w400,
  //                       color: Theme.of(context).custom.b_w_y,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // const SizedBox(height: 20),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
    return Container(
      constraints: type == 'serviceforyou'
          ? BoxConstraints(minWidth: 80, maxWidth: 100)
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _callOpenPage(code);
            },
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                height: type == 'serviceforyou' ? 45 : 30,
                width: type == 'serviceforyou' ? 45 : 30,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
              height: type == 'serviceforyou'
                  ? 8
                  : 6), // ระยะห่างระหว่างไอคอนกับข้อความ
          Container(
            height: MyApp.fontKanit.value == FontKanit.small
                ? 40
                : MyApp.fontKanit.value == FontKanit.medium
                    ? 85
                    : 120,
            alignment: Alignment.topCenter, // จัดข้อความให้อยู่ด้านบนเสมอ
            child: Text(
              title,
              style: TextStyle(
                fontSize: type == 'serviceforyou' ? 14 : 11,
                fontWeight: FontWeight.w400,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              // overflow: TextOverflow.ellipsis, // ตัดข้อความถ้ายาวเกิน
            ),
          ),
        ],
      ),
    );
  }

  Widget rowButton(String image, String title, {String code = ''}) {
    return InkWell(
      onTap: () {
        _callOpenPage(code);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              image,
              height: 45,
              width: 45,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 20),
          SizedBox(
            height: 40,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                // height: 0.5,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
                // Theme.of(context).custom.bwy,
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  String formatDuration(String? duration) {
    if (duration == null || duration.isEmpty)
      return '0 นาที'; // ตรวจสอบค่าว่างหรือ null

    // แยกเวลาโดยใช้ ':' เป็นตัวแบ่ง
    final parts = duration.split(':');
    if (parts.length != 3) return 'รูปแบบเวลาไม่ถูกต้อง';

    // แปลงเวลาเป็นตัวเลข
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    // สร้างข้อความที่มีหน่วยเวลา
    final buffer = StringBuffer();
    if (hours >= 0) buffer.write('$hours ชั่วโมง ');
    if (minutes > 0) buffer.write('$minutes นาที ');

    return buffer.toString().trim();
  }

  void _callRead() async {
    fontStorageValue = await storage.read(key: 'switchSizeFont') ?? 'ปกติ';
    colorStorageValue = await storage.read(key: 'switchColor') ?? 'ปกติ';
    FirebaseMessaging.instance.getToken().then((token) async {
      print('token: $token');
    });
    _readNotiCount();
    setState(() {
      _futureBanner = _readBanner();
      // _futureNews = _readGetCourse();
    });
    var sizeName = await storage.read(key: 'switchSize');
    selectedSize = sizeName;
  }

  // void _callReadGetCourse() async {
  //   dynamic response = await Dio().get('$server/py-api/dcc/lms/recomend');

  //   setState(() {
  //     _futureNews = Future.value(response.data);
  //   });

  //   // return Future.value(response);
  // }

  Future<dynamic> _readNotiCount() async {
    var accessToken = await ManageStorage.read('accessToken') ?? '';
    var headers = {'Authorization': 'Bearer $accessToken'};
    try {
      var dio = Dio();
      var response = await dio.request(
        '$serverPlatform/api/Notify/me?take=10&onlyNotRead=false&IsPortal=true',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        var modelNotiCount = response.data['objectData'] ?? [];
        setState(() {
          notiCount = modelNotiCount.where((x) => x['isRead'] == "0").length;
        });
      }
      // }
    } catch (e) {
      logE(e);
    }
    return [];
  }

  // Future<List<dynamic>> _readBanner() async {
  //   Dio dio = Dio();
  //   Response<dynamic> response;
  //   try {
  //     response = await dio.post(
  //       'https://decms.dcc.onde.go.th/dcc-api/m/eventCalendar/read',
  //       data: {
  //         "permission": "all",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       if (response.data['status'] == 'S') {
  //         List<dynamic> allData = response.data['objectData'];

  //         return allData;
  //       }
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  //   return [];
  // }
  Future<List<dynamic>> _readBanner() async {
    Dio dio = Dio();
    Response<dynamic> response;
    try {
      response = await dio.post(
        '$server/dcc-api/m/eventCalendar/read',
        data: {
          "permission": "all",
        },
      );

      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          List<dynamic> allData = response.data['objectData'];

          // กรองเฉพาะข้อมูลที่มีรูปภาพที่ใช้งานได้
          List<dynamic> validData = [];

          for (var item in allData) {
            String imageUrl = item['imageUrl'] ?? '';
            if (imageUrl.isNotEmpty && await _isImageValid(imageUrl)) {
              validData.add(item);
            }
          }

          return validData;
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }

// ฟังก์ชันตรวจสอบรูปภาพ
  Future<bool> _isImageValid(String imageUrl) async {
    try {
      final response = await dio.head(imageUrl);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void onRefresh() async {
    _determinePosition();
    _callRead();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
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

  _buildRecomment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textSearch != '' ? _search() : Container(),
        Text(
          'คอร์​สแนะนำ',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFB325F8)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _buildListModel(),
        const SizedBox(height: 30),
      ],
    );
  }

  _buildListModel() {
    return FutureBuilder(
      future: _modelRecommend,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MyApp.fontKanit.value == FontKanit.small
                      ? 10 / 12.5
                      : MyApp.fontKanit.value == FontKanit.medium
                          ? 10 / 13
                          : 10 / 14,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              physics: const ClampingScrollPhysics(),
              itemCount: [...snapshot.data].take(viewAdd).length,
              itemBuilder: (context, index) =>
                  containerRecommendedClass(snapshot.data![index]),
            );
          } else {
            return Center(
              child: Text(
                'ไม่พบคอร์สเรียนที่ตรงกับการค้นหา',
                style: TextStyle(
                  fontSize: 14,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget containerRecommendedClass(dynamic model) {
    return GestureDetector(
      onTap: () async {
        var loginData = await ManageStorage.readDynamic('loginData');
        var accessToken = await ManageStorage.read('accessToken');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewInAppPage(
              url:
                  'https://lms.dcc.onde.go.th/user/user/lesson_details/${model['course_Id']}?sso_key=${loginData['sub']}&access_token=${accessToken}',
              title: model?['course_Name'] ?? '',
            ),
          ),
        );

        // var data = {
        //   'course_id': model?['id'] ?? '',
        //   "course_name": model?['name'] ?? '',
        //   "course_cat_id": model?['course_cat_id'] ?? '',
        //   "cover_image": model?['docs'] ?? '',
        //   "description": model['details'] ?? '',
        //   "created_at": model['created_at'] ?? '',
        //   "category_name": model['cat_name'] ?? '',
        //   "certificate": model['certificate'] ?? '',
        //   "course_duration": model['course_duration'] ?? '',
        // };
        // logWTF(data);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CourseDetailPage(
        //       model: model,
        //     ),
        //   ),
        // );
      },
      child: Container(
        color: Theme.of(context).custom.primary,
        child: Container(
          padding: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).custom.primary,
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
                child: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? (model?['course_Thumbnail_Url'] ?? '') != ''
                        ? Image.network(
                            model?['course_Thumbnail_Url'],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/icon.png',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                        child: Image.network(
                          model?['course_Thumbnail_Url'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 9),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    model?['course_Name'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).custom.b_w_y,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Image.asset(
                        MyApp.themeNotifier.value == ThemeModeThird.light
                            ? 'assets/images/course_time.png'
                            : "assets/images/2024/time_home_page_blackwhite.png",
                        height: 24,
                        width: 24),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                    Text(
                      formatDuration(model?['course_Duration']),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _search() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'ผลการค้นหา "${textSearch}"',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'พบข้อมูลที่ตรงกัน ${_listFilterLenght} คอร์สเรียน',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _lmsCategory() {
    return Container(
      height: 220,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 0,
          direction: Axis.vertical,
          children: _lmsCategoryList
              .map(
                (element) => Container(
                  width: 250,
                  height: MyApp.fontKanit.value == FontKanit.small
                      ? 67
                      : MyApp.fontKanit.value == FontKanit.medium
                          ? 94
                          : 118,
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (cateCourseSearch != element['id']) {
                          cateCourseSearch = element['id'];
                        } else {
                          cateCourseSearch = '';
                        }
                        _filter();
                      });
                    },
                    child: rowContactInformation(
                        element['cat_Thai'], element['img_Url'], element['id']),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget rowContactInformation(String title, String image, String id) {
    return Row(
      children: [
        MyApp.themeNotifier.value == ThemeModeThird.light
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  image,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              )
            : ClipRRect(
                // เพิ่ม ClipRRect ตรงนี้
                borderRadius: BorderRadius.circular(15),
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  child: Image.network(
                    image,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                  decoration: cateCourseSearch == id
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor:
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

////////////////////////////////////////////////////////////////////////////////

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
      // Navigator.push(context, MaterialPageRoute(builder: (_) => FindJobPage()));
      widget.changePage!(8);
    } else if (param == 'fund') {
      // Navigator.push(context, MaterialPageRoute(builder: (_) => FundPage()));
      widget.changePage!(5);
    } else if (param == 'report') {
      widget.changePage!(6);
    } else if (param == 'skill') {
      widget.changePage!(2);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => MyClassAllPage(
      //       title: 'ระบบส่งเสริม Re-skill',
      //     ),
      //   ),
      // );
    }
    // else if (param == 'knowledge') {
    //   widget.changePage!(2);

    //   // buildModalWaiting(context);
    //   // Navigator.push(
    //   //   context,
    //   //   MaterialPageRoute(
    //   //     builder: (_) => MyClassAllPage(
    //   //       title: 'คลังข้อมูล',
    //   //     ),
    //   //   ),
    //   // );
    // }
    else if (param == 'report') {
      widget.changePage!(6);
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => ReportProblemPage(),
      //   ),
      // );
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
                  MyApp.fontKanit.value = FontKanit.small; // ขนาดเล็ก
                  _hight = 30.0;
                  _width = 30.0;
                } else if (title == "ปานกลาง") {
                  MyApp.fontKanit.value = FontKanit.medium; // ขนาดกลาง
                  _hight = 35.0;
                  _width = 35.0;
                } else {
                  MyApp.fontKanit.value = FontKanit.large; // ขนาดใหญ่
                  _hight = 40.0;
                  _width = 40.0;
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
                  onTap: () async {
                    // ย้าย async operation ออกมาข้างนอก setState()
                    await storage.write(
                      key: 'switchColor',
                      value: item['title'],
                    );

                    // เรียก setState() หลังจาก async operation เสร็จแล้ว
                    setState(() {
                      if (item['title'] == "ปกติ") {
                        MyApp.themeNotifier.value = ThemeModeThird.light;
                      } else if (item['title'] == "ขาวดำ") {
                        MyApp.themeNotifier.value = ThemeModeThird.dark;
                      } else {
                        MyApp.themeNotifier.value = ThemeModeThird.blindness;
                      }

                      for (int i = 0; i < _listSwitchColors.length; i++) {
                        if (_listSwitchColors[i]['code'] == item['code']) {
                          item['isSelected'] = !item['isSelected'];
                        } else {
                          _listSwitchColors[i]['isSelected'] = false;
                        }
                      }
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      height: 45,
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
                        borderRadius: BorderRadius.circular(73),
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
