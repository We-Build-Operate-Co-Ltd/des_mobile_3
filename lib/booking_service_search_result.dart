import 'dart:convert';

import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'booking_service_add.dart';
import 'main.dart';

class BookingServiceSearchResultPage extends StatefulWidget {
  const BookingServiceSearchResultPage({
    super.key,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.search,
    required this.filter,
    required this.mode,
  });

  final String date;
  final String startTime;
  final String endTime;
  final String search;
  final dynamic filter;
  final String mode;

  @override
  State<BookingServiceSearchResultPage> createState() =>
      _BookingServiceSearchResultPageState();
}

class _BookingServiceSearchResultPageState
    extends State<BookingServiceSearchResultPage> {
  List<dynamic> _filterModelCenter = [];
  LoadingBookingStatus _loadingBookingStatus = LoadingBookingStatus.loading;
  String latitude = "";
  String longitude = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : MyApp.themeNotifier.value == ThemeModeThird.dark
              ? Colors.black
              : Colors.black,
      appBar: AppBar(
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : MyApp.themeNotifier.value == ThemeModeThird.dark
                ? Colors.black
                : Colors.black,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              _backButton(context),
              Expanded(
                child: Text(
                  'ผลการค้นหา',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFBD4BF7)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              // textAlign: textAlign,
              text: TextSpan(
                text: widget.mode == '1' ? 'ผลการค้นหา: ' : 'ศูนย์ใกล้ฉัน: ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Theme.of(context).custom.b325f8_w_fffd57,
                  fontFamily: 'Kanit',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'พบ ${_filterModelCenter.length} ศูนย์',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFBD4BF7)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      fontFamily: 'Kanit',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // widget.mode == '1'
          //     ? widget.filter['provinceSelected'] != ''
          //         ? SizedBox(
          //             height: 5,
          //           )
          //         : Container()
          //     : widget.filter['latitude'] != ''
          //         ? SizedBox(
          //             height: 5,
          //           )
          //         : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // child: Text(
            //   widget.mode == '1'
            //       ? '(${widget.filter['provinceTitleSelected']}, ${widget.filter['districtTitleSelected']})'
            //       : 'รัศมีไม่เกิน 30 กิโลเมตร',
            //   style: TextStyle(
            //     fontWeight: FontWeight.w400,
            //     fontSize: 15,
            //     color: Theme.of(context).custom.b_w_y,
            //     fontFamily: 'Kanit',
            //   ),
            // ),
            child: Text(
              widget.mode == '1'
                  ? [
                      widget.filter['provinceTitleSelected'],
                      widget.filter['districtTitleSelected']
                    ].where((value) => value?.isNotEmpty == true).join(', ')
                  : 'รัศมีไม่เกิน 30 กิโลเมตร',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Theme.of(context).custom.b_w_y,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Divider(
              color: Theme.of(context).custom.DDD_w_fffd57,
              height: 1,
            ),
          ),
          Expanded(
            child: _list() ?? '',
          ),
        ],
      ),
    );
  }

  _list() {
    if (_loadingBookingStatus == LoadingBookingStatus.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).custom.b325f8_w_fffd57,
            ),
            SizedBox(height: 12),
            Text(
              'กรุณารอสักครู่\n ระบบอยู่ระหว่างการค้นหาศูนย์',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).custom.b325f8_w_fffd57,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      );
    } else if (_loadingBookingStatus == LoadingBookingStatus.success) {
      if (_filterModelCenter.length == 0) {
        return Center(
          child: Text(
            'ไม่พบข้อมูล',
            style: TextStyle(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFBD4BF7)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        );
      }
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemBuilder: (context, index) =>
            _item(_filterModelCenter[index], index),
        separatorBuilder: (context, index) => Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(
            color: Theme.of(context).custom.DDD_w_fffd57,
            height: 1,
          ),
        ),
        itemCount: _filterModelCenter.length,
      );
    } else {
      return Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _loadingBookingStatus = LoadingBookingStatus.loading;
            });
            _callRead();
          },
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                Icon(Icons.refresh),
                Text('โหลดใหม่'),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _item(model, index) {
    return GestureDetector(
      onTap: () {
        logWTF(model);
      },
      child: Container(
        color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : MyApp.themeNotifier.value == ThemeModeThird.dark
                ? Colors.black
                : Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyApp.themeNotifier.value == ThemeModeThird.light
                ? widget.mode == '1'
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: (model['photoBase64'] ?? '') != ''
                            ? Image.memory(
                                base64Decode(model['photoBase64']),
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/banner_mock.jpg',
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: (model['photo'] ?? '') != ''
                            ? Image.memory(
                                base64Decode(model['photo']),
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/banner_mock.jpg',
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      )
                : ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.grey, BlendMode.saturation),
                    child: widget.mode == '1'
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: (model['photoBase64'] ?? '') != ''
                                ? Image.memory(
                                    base64Decode(model['photoBase64']),
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/banner_mock.jpg',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: (model['photo'] ?? '') != ''
                                ? Image.memory(
                                    base64Decode(model['photo']),
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/banner_mock.jpg',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          )),
            SizedBox(height: 16),
            Text(
              '${index + 1}. ${widget.mode == '1' ? (model?['centerName'] ?? '') : (model?['center_Name'] ?? '')}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).custom.b325f8_w_fffd57,
              ),
              // maxLines: 2,
              // overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            Text(
              '${widget.mode == '1' ? (model?['centerAdd'] ?? '') : (model?['center_Add'] ?? '')}',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).custom.f70f70_w_fffd57,
              ),
              // maxLines: 2,
              // overflow: TextOverflow.ellipsis,
            ),
            // Text(model.toString()),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: Wrap(
                  children: [
                    Image.asset(
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? 'assets/images/time.png'
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? "assets/images/2024/time _w.png"
                              : "assets/images/2024/time _y.png",
                      height: 22,
                      width: 22,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'เปิดทำการ วันจันทร์ - วันศุกร์ ${trimTime(model?['startTime'] ?? '')} - ${trimTime(model?['startTime'] ?? 'endTime')} น.',
                      style: TextStyle(
                        color: Theme.of(context).custom.b_W_fffd57,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Image.asset(
                      // 'assets/images/computer.png',
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? 'assets/images/computer.png'
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? "assets/images/2024/computer_w.png"
                              : "assets/images/2024/computer_y.png",
                      height: 22,
                      width: 22,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${model?['computer'] ?? ''} เครื่อง',
                      style: TextStyle(
                        color: Theme.of(context).custom.b_W_fffd57,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )),
                Expanded(
                    child: Row(
                  children: [
                    Image.asset(
                      // 'assets/images/meeting room.png',
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? 'assets/images/meeting room.png'
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? "assets/images/2024/meet-room-w.png"
                              : "assets/images/2024/meet-room-y.png",
                      height: 22,
                      width: 22,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${model?['meeting_Room'] ?? ''} ห้องประชุม',
                      style: TextStyle(
                        color: Theme.of(context).custom.b_W_fffd57,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      openMap(model['latitude'], model['longitude']);
                    },
                    child: Container(
                      // height: 30,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        // horizontal: 80,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.white
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.black
                                : Colors.black,
                        border: Border.all(
                          color: Theme.of(context).custom.b325f8_w_fffd57_OVF50,
                        ),
                        //     ? Color(0xFF7A4CB1)
                        //     : MyApp.themeNotifier.value == ThemeModeThird.dark
                        //         ? Colors.white
                        //         : Color(0xFFFFFD57),
                        borderRadius: BorderRadius.circular(22.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/navigation.png'
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? "assets/images/2024/navigation-w.png"
                                    : "assets/images/2024/navigation-y.png",
                            height: 16,
                            width: 16,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'ดูเส้นทาง',
                            style: TextStyle(
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                              // MyApp.themeNotifier.value == ThemeModeThird.light
                              //     ? Colors.white
                              //     : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingServiceAddPage(
                            model: model,
                            mode: widget.mode,
                            date: widget.date,
                            startTime: widget.startTime,
                            endTime: widget.endTime,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      // height: 30,
                      padding: EdgeInsets.symmetric(
                        // horizontal: 15,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).custom.b325f8_w_fffd57,
                        // MyApp.themeNotifier.value == ThemeModeThird.light
                        //     ? Color(0xFF7A4CB1)
                        //     : MyApp.themeNotifier.value == ThemeModeThird.dark
                        //         ? Colors.white
                        //         : Color(0xFFFFFD57),
                        borderRadius: BorderRadius.circular(22.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/calendar.png'
                                : "assets/images/2024/calendar-b.png",
                            height: 16,
                            width: 16,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'จองศูนย์',
                            style: TextStyle(
                              color: Theme.of(context).custom.w_b_b,
                              // MyApp.themeNotifier.value == ThemeModeThird.light
                              //     ? Colors.white
                              //     : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Image.asset(
        MyApp.themeNotifier.value == ThemeModeThird.light
            ? 'assets/images/back_arrow.png'
            : "assets/images/2024/back_balckwhite.png",
        height: 40,
        width: 40,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _callRead();
  }

  _callRead() async {
    var url = '';
    // print('------------moade-------------------------${widget.mode}');
    // print('------------search------------------------${widget.search}');
    // print(
    //     '------------provinceSelected--------------${widget.filter['provinceSelected']}');
    // print(
    //     '------------districtTitleSelected---------${widget.filter['districtTitleSelected']}');
    // print(
    //     '------------bookingType-------------------${widget.filter['bookingType']}');
    // print(
    //     '=======filter provinceSelected===== 1 ======> ${widget.filter['provinceSelected']}');
    // print(
    //     '=======filter provinceSelected===== 2 ======> ${widget.filter['provinceSelected']}');
    if (widget.mode == '1') {
      url =
          'GetSearchCenterLocation?textSearch=${widget.search ?? ''}&chId=${widget.filter['provinceSelected'] == '0' ? '' : widget.filter['provinceSelected']}&assetType=${widget.filter['bookingType'] ?? ''}&amName=${widget.filter['districtTitleSelected'] ?? ''}';
      print('--------------mode-1---------');
    } else {
      print('--------------mode-2--------');
      await getLocation();
      url = 'GetCenterLocation?latitude=$latitude&longitude=$longitude';
    }

    try {
      print('=============url================>    url : $url');
      Response response = await Dio().get('$ondeURL/api/DataManagement/$url');
      if (response.data != null && response.data['data'] != null) {
        setState(() {
          _filterModelCenter = response.data['data'];
          print('>>>>>>>>>>>>> response ${response.data['data']}');
          // logWTF(response.data['data']);
        });
      }
      setState(() => _loadingBookingStatus = LoadingBookingStatus.success);
    } on DioError catch (e) {
      print('======================222333=======>>>>>>>>    url >>>>>> ');
      setState(() => _loadingBookingStatus = LoadingBookingStatus.fail);
      Fluttertoast.showToast(msg: e.response!.data['message']);
    } finally {
      setState(() => _loadingBookingStatus = LoadingBookingStatus.success);
    }
  }

  // _callRead() async {
  //   var url = '';
  //   print('------------moade-------------------------${widget.mode}');
  //   print('------------search------------------------${widget.search}');
  //   print(
  //       '------------provinceSelected--------------${widget.filter['provinceSelected']}');
  //   print(
  //       '------------districtTitleSelected---------${widget.filter['districtTitleSelected']}');
  //   if (widget.mode == '1' &&
  //       (widget.search.isNotEmpty ||
  //           (widget.filter['provinceSelected'] != null &&
  //               widget.filter['provinceSelected'] != '' &&
  //               widget.filter['provinceSelected'] != '0') ||
  //           (widget.filter['districtTitleSelected'] != null &&
  //               widget.filter['districtTitleSelected'] != ''))) {
  //     url =
  //         'GetSearchCenterLocation?textSearch=${widget.search}&chId=${widget.filter['provinceSelected']}&assetType=${widget.filter['bookingType']}&amName=${widget.filter['districtTitleSelected']}';
  //     print('---------------1------มีข้อมูล-----');
  //   } else {
  //     print('---------------2-----ไม่มีข้อมูล---');
  //     await getLocation();
  //     url = 'GetCenterLocation?latitude=$latitude&longitude=$longitude';
  //   }
  //   print('=============================>>>>>>>>    url >>>>>> $url');
  //   try {
  //     Response response = await Dio().get('$ondeURL/api/DataManagement/$url');
  //     if (response.data != null && response.data['data'] != null) {
  //       setState(() {
  //         _filterModelCenter = response.data['data'];
  //         print('>>>>>>>>>>>>> response ${response.data['data']}');
  //         logWTF(response.data['data']);
  //       });
  //     }
  //     setState(() => _loadingBookingStatus = LoadingBookingStatus.success);
  //   } on DioError catch (e) {
  //     setState(() => _loadingBookingStatus = LoadingBookingStatus.fail);
  //     Fluttertoast.showToast(msg: e.response!.data['message']);
  //   } finally {
  //     setState(() => _loadingBookingStatus = LoadingBookingStatus.success);
  //   }
  // }

  getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unable to fetch location: $e');
    }
  }

  trimTime(time) {
    List<String> tileModel = time.split(':');
    String newTime;
    if (tileModel.length > 2) {
      tileModel.removeLast();
      newTime = tileModel.join(':');
    } else if (tileModel.length == 2) {
      newTime = tileModel.join(':');
    } else {
      newTime = '';
    }
    return newTime;
  }

  static Future<void> openMap(latitude, longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}
