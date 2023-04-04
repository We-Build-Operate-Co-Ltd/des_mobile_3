import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:des/build_modal_connection_in_progress.dart';
import 'package:des/detail.dart';
import 'package:des/models/mock_data.dart';
import 'package:des/notification_list.dart';
import 'package:des/chat.dart';
import 'package:des/report_problem.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:des/poi.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  bool hiddenMainPopUp = false;
  String percentPrice = '';
  bool moreThen = false;

  String dateNow = DateFormat('dd/MM/yyyy').format(DateTime.now());
  LatLng? latLng;
  String? currentLocation = 'ตำแหน่งปัจจุบัน';
  int? _currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: onRefresh,
        onLoading: _onLoading,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                right: 15,
                left: 15,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          const Text(
                            'ดิจิทัลชุมชน',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF7A4CB1),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          // Image.asset(
                          //   'assets/images/scale_font_size.png',
                          //   height: 36,
                          //   width: 35,
                          // ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              // Fluttertoast.showToast(
                              //     msg: '''ยังไม่เปิดให้ใช้บริการ''');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationListPage(),
                                ),
                              );
                            },
                            child: Image.asset(
                              'assets/images/notification.png',
                              height: 35,
                              width: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  // height: 138,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x967A4CB1),
                        blurRadius: 10,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/card_purple.png',
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 22),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => SearchPage(),
                          //   ),
                          // );
                        },
                        child: Container(
                          // alignment: Alignment.centerLeft,
                          height: 35,
                          width: MediaQuery.of(context).size.width - 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(46),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              Image.asset(
                                'assets/images/search.png',
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 15),
                              const Expanded(
                                child: Text(
                                  'ค้นหาคลาสเรียน',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF7A4CB1),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          columnButton(
                            'assets/images/modern_farmer.png',
                            'เกษตรกรสมัยใหม่',
                            code: 'btn1',
                          ),
                          columnButton(
                            'assets/images/community_business.png',
                            'ธุรกิจชุมชน',
                            code: 'btn2',
                          ),
                          columnButton(
                            'assets/images/care_old.png',
                            'ดูแลผู้สูงอายุ',
                            code: 'btn3',
                          ),
                          columnButton(
                            'assets/images/more.png',
                            'เพิ่มเติม',
                            code: 'btn4',
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'บริการสำหรับคุณ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
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
                        'assets/images/reserve_service.png',
                        'จองใช้บริการ',
                        type: 'serviceforyou',
                        code: 'booking',
                      ),
                      columnButton(
                        'assets/images/find_job.png',
                        'หางาน',
                        type: 'serviceforyou',
                        code: 'job',
                      ),
                      columnButton(
                        'assets/images/funding_source.png',
                        'หาแหล่งทุน',
                        type: 'serviceforyou',
                        code: 'fund',
                      ),
                      columnButton(
                        'assets/images/reskill.png',
                        'ส่งเสริมทักษะ',
                        type: 'serviceforyou',
                        code: 'skill',
                      ),
                      columnButton(
                        'assets/images/chat2.png',
                        'สนทนา',
                        type: 'serviceforyou',
                        code: 'chat',
                      ),
                      columnButton(
                        'assets/images/data_warehouse.png',
                        'คลังข้อมูล',
                        type: 'serviceforyou',
                        code: 'knowledge',
                      ),
                      columnButton(
                        'assets/images/report_problem.png',
                        'แจ้งปัญหา',
                        type: 'serviceforyou',
                        code: 'report',
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'คลาสกำลังเรียน',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // Text(
                    //   'ดูทั้งหมด',
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                  ],
                ),
                FutureBuilder(
                  future: Future.value(mockDataList),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          containerStudy(snapshot.data![0], 50),
                          const SizedBox(height: 10),
                          containerStudy(snapshot.data![1], 80),
                          const SizedBox(height: 24),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                Stack(
                  children: [
                    Container(
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
                        items: mockBannerList.map(
                          (item) {
                            int index = mockBannerList.indexOf(item);
                            return ClipRRect(
                              borderRadius: _currentBanner == index
                                  ? BorderRadius.all(Radius.circular(20))
                                  : BorderRadius.circular(0),
                              child: CachedNetworkImage(
                                imageUrl: item,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
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
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'คลาสแนะนำ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: _readNews(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        return GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 9 / 12,
                            crossAxisSpacing: 5,
                          ),
                          physics: const ClampingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) =>
                              containerRecommendedClass(snapshot.data![index]),
                        );
                      }
                    }
                    return const SizedBox();
                  },
                ),
                SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget containerRecommendedClass(dynamic model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              slug: 'eventcalendar',
              model: model,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: model['imageUrl'],
                  height: 93,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 9),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    model['title'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Image.asset('assets/images/time_home_page.png',
                        height: 24, width: 24),
                    const SizedBox(width: 8),
                    const Text(
                      '3 ชั่วโมง',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
              child: CachedNetworkImage(
                imageUrl: model['imageUrl'] ?? '',
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
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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
                                  color: const Color(0x80B325F8),
                                ),
                              ),
                            ),
                            Container(
                              width: 80 * study / 100,
                              height: 9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                color: const Color(0xFFB325F8),
                                border: Border.all(
                                  color: const Color(0xFFB325F8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'เรียนแล้ว $study%',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w300,
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
          ? BoxConstraints(minWidth: 80, maxWidth: 90)
          : null,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _callOpenPage(code);
            },
            child: type == 'serviceforyou'
                ? Image.asset(
                    image,
                    height: 45,
                    width: 45,
                  )
                : Image.asset(image, height: 30, width: 30),
          ),
          SizedBox(height: type == 'serviceforyou' ? 7 : 5),
          type == 'serviceforyou'
              ? SizedBox(
                  height: 40,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    // _callOpenPage(code);
                  },
                  child: SizedBox(
                    height: 31,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFFFFFFF),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _determinePosition();
    });
    _callRead();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _callRead() async {
    _readNews();
  }

  Future<List<dynamic>> _readNews() async {
    Dio dio = Dio();
    Response<dynamic> response;
    try {
      response = await dio.post(
          'http://122.155.223.63/td-des-api/m/eventcalendar/read',
          data: {'skip': 0, 'limit': 2});
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
    if (param == 'btn1') {
      buildModalConnectionInProgress(context);
    } else if (param == 'btn2') {
      buildModalConnectionInProgress(context);
    } else if (param == 'btn3') {
      buildModalConnectionInProgress(context);
    } else if (param == 'btn4') {
      buildModalConnectionInProgress(context);
    } else if (param == 'booking') {
      widget.changePage!(1);
    } else if (param == 'job') {
      buildModalConnectionInProgress(context);
    } else if (param == 'fund') {
      buildModalConnectionInProgress(context);
    } else if (param == 'skill') {
      buildModalConnectionInProgress(context);
    } else if (param == 'knowledge') {
      buildModalConnectionInProgress(context);
    } else if (param == 'report') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReportProblemPage(),
        ),
      );
    } else if (param == 'chat') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPage(),
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
}
