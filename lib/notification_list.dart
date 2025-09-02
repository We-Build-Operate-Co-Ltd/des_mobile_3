// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:des/detail.dart';
import 'package:des/shared/counterNotifier.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'shared/config.dart';
import 'main.dart';

class NotificationListPage extends StatefulWidget {
  NotificationListPage({super.key, this.changePage});
  late _NotificationListState notificationListState;
  Function? changePage;

  @override
  _NotificationListState createState() => _NotificationListState();

  getState() => notificationListState;
}

class _NotificationListState extends State<NotificationListPage> {
  // Constants
  static const String API_URL =
      'http://dcc.onde.go.th/dcc-api/api/Notify/me?take=10&onlyNotRead=false&IsPortal=true';

  final List<String> cateNoti = [
    'ทั้งหมด',
    'ยังไม่อ่าน',
    'สัปดาห์นี้',
    'เก่ากว่า 7 วัน'
  ];

  List<dynamic> allNotifications = [];
  List<dynamic> currentDisplayList = [];

  int _typeSelected = 0;
  bool _loadingWidget = true;

  int notiCountAll = 0;
  int notiCountNotRead = 0;
  int notiCountThisWeek = 0;
  int notiCountOver7Days = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _controller = ScrollController();
  final Dio dio = Dio();

  var _counter = CounterNotifier();

  @override
  void initState() {
    super.initState();
    widget.notificationListState = this;
    _loadNotifications();
  }

  @override
  void dispose() {
    _controller.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  // Main data loading method
  Future<void> _loadNotifications() async {
    try {
      setState(() => _loadingWidget = true);

      var accessToken = await ManageStorage.read('accessToken') ?? '';
      if (accessToken.isEmpty) {
        _handleEmptyData();
        return;
      }

      var headers = {'Authorization': 'Bearer $accessToken'};
      var response = await dio.get(API_URL, options: Options(headers: headers));

      if (response.statusCode == 200 && response.data['success'] == true) {
        var dataList = response.data['data'] ?? [];

        _processNotifications(dataList);
      } else {
        print('API Error: ${response.data['errorMessage'] ?? 'Unknown error'}');
        _handleEmptyData();
      }
    } catch (e) {
      print('Error loading notifications: $e');
      _handleEmptyData();
    } finally {
      await Future.delayed(Duration(milliseconds: 300));
      if (mounted) {
        setState(() => _loadingWidget = false);
      }
    }
  }

  void _processNotifications(List<dynamic> dataList) {
    allNotifications = dataList.map((item) {
      DateTime created = DateTime.parse(item['notiDate']);
      int daysDiff = DateTime.now().difference(created).inDays;

      return {
        'id': item['id'],
        'message': item['message'],
        'notiDate': item['notiDate'],
        'isRead': item['isRead'],
        'path': item['path'],
        'daysDiff': daysDiff,
      };
    }).toList();
    print('object: $allNotifications');

    _updateCounts();
    _updateDisplayList();

    _logNotificationStats();
  }

  void _handleEmptyData() {
    allNotifications = [];
    _updateCounts();
    _updateDisplayList();
  }

  void _updateCounts() {
    notiCountAll = allNotifications.length;
    notiCountNotRead = allNotifications.where((x) => x['isRead'] == 0).length;
    notiCountThisWeek =
        allNotifications.where((x) => x['daysDiff'] <= 7).length;
    notiCountOver7Days =
        allNotifications.where((x) => x['daysDiff'] > 7).length;
  }

  void _updateDisplayList() {
    switch (_typeSelected) {
      case 0:
        currentDisplayList = List.from(allNotifications);
        break;
      case 1:
        currentDisplayList =
            allNotifications.where((x) => x['isRead'] == 0).toList();
        break;
      case 2:
        currentDisplayList =
            allNotifications.where((x) => x['daysDiff'] <= 7).toList();
        break;
      case 3:
        currentDisplayList =
            allNotifications.where((x) => x['daysDiff'] > 7).toList();
        break;
      default:
        currentDisplayList = List.from(allNotifications);
    }
  }

  void _onCategoryTap(int index) {
    setState(() {
      _typeSelected = index;
      _updateDisplayList();
    });
  }

  int _getCategoryCount(int index) {
    switch (index) {
      case 0:
        return notiCountAll;
      case 1:
        return notiCountNotRead;
      case 2:
        return notiCountThisWeek;
      case 3:
        return notiCountOver7Days;
      default:
        return 0;
    }
  }

  void _logNotificationStats() {
    print('-------------Notification Stats---------------');
    print('ทั้งหมด: $notiCountAll');
    print('ยังไม่อ่าน: $notiCountNotRead');
    print('สัปดาห์นี้: $notiCountThisWeek');
    print('เก่ากว่า 7 วัน: $notiCountOver7Days');
    print('Current display: ${currentDisplayList.length} items');
  }

  // Utility methods
  String formatDateDMY(String? rawDateTime) {
    if (rawDateTime == null || rawDateTime.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(rawDateTime);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  String formatTime(String? rawDateTime) {
    if (rawDateTime == null || rawDateTime.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(rawDateTime);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  Color _getThemeColor() {
    return MyApp.themeNotifier.value == ThemeModeThird.light
        ? Color(0xFFB325F8)
        : MyApp.themeNotifier.value == ThemeModeThird.dark
            ? Colors.white
            : Color(0xFFFFFD57);
  }

  Color _getBackgroundColor() {
    return MyApp.themeNotifier.value == ThemeModeThird.light
        ? Colors.white
        : Colors.black;
  }

  // UI Build Methods
  @override
  Widget build(BuildContext context) {
    _counter = Provider.of<CounterNotifier>(context, listen: false);

    return Stack(
      children: <Widget>[
        _buildBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowIndicator();
              return false;
            },
            child: Column(
              children: [
                _buildTopSpacer(),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(top: 24),
                    decoration: _buildContainerDecoration(),
                    child: GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      child: Column(
                        children: [
                          _buildHead(),
                          SizedBox(height: 20),
                          _buildListNotiCategory(),
                          Expanded(
                            child: SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: false,
                              header: WaterDropHeader(),
                              controller: _refreshController,
                              onRefresh: () async {
                                await _loadNotifications();
                                _refreshController.refreshCompleted();
                              },
                              child: _buildBody(),
                            ),
                          ),
                          _buildBottomSpacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return MyApp.themeNotifier.value == ThemeModeThird.light
        ? Image.asset(
            "assets/images/BG.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          )
        : ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
            child: Image.asset(
              "assets/images/BG.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          );
  }

  Widget _buildTopSpacer() {
    return Container(
      height: 100,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        right: 15,
        left: 15,
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: _getBackgroundColor(),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.10),
          spreadRadius: 0,
          blurRadius: 10,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  Widget _buildBottomSpacer() {
    return SizedBox(height: 20 + MediaQuery.of(context).padding.bottom);
  }

  Widget _buildHead() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      color: _getBackgroundColor(),
      child: Row(
        children: [
          InkWell(
            onTap: () => widget.changePage!(0),
            child: Container(
              height: 40,
              width: 40,
              child: Image.asset(
                MyApp.themeNotifier.value == ThemeModeThird.light
                    ? 'assets/images/back_arrow.png'
                    : "assets/images/2024/back_balckwhite.png",
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'แจ้งเตือน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: _getThemeColor(),
                  ),
                ),
                SizedBox(width: 15),
                if (notiCountNotRead > 0)
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFFDD2A00),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      notiCountNotRead.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
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

  Widget _buildListNotiCategory() {
    return Container(
      height: MyApp.fontKanit.value == FontKanit.small
          ? 35
          : MyApp.fontKanit.value == FontKanit.medium
              ? 45
              : 55,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: cateNoti.length,
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemBuilder: (_, index) => GestureDetector(
          onTap: () => _onCategoryTap(index),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: index == _typeSelected
                  ? (MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFBD4BF7)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57))
                  : (MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : Colors.black),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              '${cateNoti[index]} (${_getCategoryCount(index)})',
              style: TextStyle(
                color: index == _typeSelected
                    ? (MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.white
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.black
                            : Colors.black)
                    : (MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFB325F8).withOpacity(0.5)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57)),
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                letterSpacing: 1.2,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loadingWidget) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_getThemeColor()),
        ),
      );
    }

    if (currentDisplayList.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      child: FadingEdgeScrollView.fromScrollView(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          controller: _controller,
          itemCount: currentDisplayList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildSectionHeader();
            }
            return _buildNotificationCard(currentDisplayList[index - 1]);
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      margin: EdgeInsets.only(left: 30),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        cateNoti[_typeSelected],
        style: TextStyle(
          color: _getThemeColor(),
          fontFamily: 'Kanit',
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        _buildSectionHeader(),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Image.asset(
                        'assets/images/logo_noti_list.png',
                        width: 180,
                        height: 160,
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.matrix(<double>[
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0,
                          0,
                          0,
                          1,
                          0,
                        ]),
                        child: Image.asset(
                          'assets/images/logo_noti_list.png',
                          width: 180,
                          height: 160,
                        ),
                      ),
                SizedBox(height: 11),
                Text(
                  "ไม่มีการแจ้งเตือนในหมวดนี้",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _getThemeColor(),
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(dynamic model) {
    return InkWell(
      onTap: () => _handleNotificationTap(model),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0x40F3D2FF),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: model['isRead'] == 1
                      ? Colors.transparent
                      : (MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFBD4BF7)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.black
                              : Color(0xFFFFFD57)),
                ),
                height: 10,
                width: 10,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'แจ้งเตือนระบบ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                        fontFamily: 'Kanit',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      model['message'] ?? '',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Color(0xFF999999),
                        ),
                        SizedBox(width: 4),
                        Text(
                          formatDateDMY(model['notiDate']),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF999999),
                            fontFamily: 'Kanit',
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF999999),
                        ),
                        SizedBox(width: 4),
                        Text(
                          formatTime(model['notiDate']),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF999999),
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('${model['daysDiff']} วันที่แล้ว',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: (MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFBD4BF7)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.black
                                  : Color(0xFFFFFD57)),
                          fontFamily: 'Kanit',
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(dynamic model) {
    print('Notification tapped: ${model['id']}');
    _dialogRead(model);
    if (model['isRead'] == 1) {
      _markAsRead(model);
    }
  }

  Future<void> _markAsRead(dynamic model) async {
    var accessToken = await ManageStorage.read('accessToken') ?? '';
    var headers = {
      'Authorization': 'Bearer $accessToken',
    };
    var data;
    var dio = Dio();
    var response = await dio.request(
      '$ondeURL/api/notify/read/${model['id']}',
      options: Options(
        method: 'PUT',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      // _loadNotifications();
      print(json.encode(response.data));
    } else {
      print(response.statusMessage);
    }
  }

  _dialogRead(model) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: (MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFBD4BF7)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.black
                      : Color(0xFFFFFD57)),
              size: 30,
            ),
            SizedBox(width: 12),
            Text(
              'แจ้งเตือนระบบ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          constraints: BoxConstraints(
            minHeight: 60,
            maxHeight: 200,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['message']}',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    text: 'วันที่: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: formatDateDMY(model['notiDate']),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    (MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFBD4BF7)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.black
                            : Color(0xFFFFFD57)),
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 24),
        titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 16),
        contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 20),
      ),
    );
  }
}
