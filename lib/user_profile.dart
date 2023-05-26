import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/detail.dart';
import 'package:des/favorite_class_all.dart';
import 'package:des/history_of_service_reservations.dart';
import 'package:des/models/mock_data.dart';
import 'package:des/my_class_all.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/user_profile_edit.dart';
import 'package:des/user_profile_setting.dart';
import 'package:des/verify_first_step.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
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
  final storage = FlutterSecureStorage();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String? _imageUrl = '';
  String? _firstName = '';
  String? _lastName = '';
  String? profileCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            _buildVerifyYourIdentity(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'คลาสเรียนของฉัน',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyClassAllPage(model: mockDataList),
                    ),
                  ),
                  child: Text(
                    'ดูทั้งหมด',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF53327A),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: Future.value(mockDataList),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMyClass(snapshot.data![0], 50),
                      _buildMyClass(snapshot.data![1], 80),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'คลาสที่ชอบ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FavoriteClassAllPage(),
                    ),
                  ),
                  child: Text(
                    'ดูทั้งหมด',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF53327A),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _readEventcalendar(),
              builder: (context, snapshot) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: snapshot.data!
                    .map<Widget>((e) => _buildFavoriteClass(e))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ประวัติการจองใช้บริการ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryOfServiceReservationsPage(),
                    ),
                  ),
                  child: Text(
                    'ดูทั้งหมด',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF53327A),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            _buildHistoryOfServiceReservations(
                'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน',
                'อำเภอบางใหญ่ นนทบุรี',
                3,
                _dateStringToDateSlashBuddhistShort('20220911'),
                '11.00'),
            SizedBox(height: 10),
            _buildHistoryOfServiceReservations(
                'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน',
                'อำเภอบางใหญ่ นนทบุรี',
                3,
                _dateStringToDateSlashBuddhistShort('20220911'),
                '11.00'),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryOfServiceReservations(
      String title, String title2, int hour, String date, String time) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFFEF7FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  title2,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 7),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/calendar_check.png',
                      height: 10,
                      width: 10,
                    ),
                    SizedBox(width: 5),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF53327A),
                      ),
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      'assets/images/time_user_profile_page.png',
                      height: 10,
                      width: 10,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '$time น.',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF53327A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Text(
            '$hour ชั่วโมง',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFFB325F8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteClass(dynamic model) {
    var screenSize = (44 * MediaQuery.of(context).size.width) / 100;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(
            slug: 'eventcalendar',
            model: model,
          ),
        ),
      ),
      child: SizedBox(
        height: screenSize,
        width: screenSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: '${model['imageUrl']}',
                fit: BoxFit.fill,
                height: 92,
                width: screenSize,
              ),
            ),
            SizedBox(
              width: screenSize,
              child: Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyClass(dynamic model, double study) {
    var screenSize = (45.07 * MediaQuery.of(context).size.width) / 100;
    return InkWell(
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
              child: CachedNetworkImage(
                imageUrl: model['imageUrl'],
                fit: BoxFit.fill,
                height: 95,
                width: screenSize,
              ),
            ),
            SizedBox(
              width: 170,
              child: Text(
                model['title'],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: Color(0x80B325F8),
                    ),
                  ),
                ),
                Container(
                  width: 80 * study / 100,
                  height: 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: Color(0xFFB325F8),
                    border: Border.all(
                      color: Color(0xFFB325F8),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'เรียนแล้ว $study%',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w300,
              ),
            ),
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
            child: InkWell(
              child: _imageUrl!.isNotEmpty && _imageUrl != ''
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: _imageUrl!,
                        fit: BoxFit.fill,
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
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
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
                          color: Color(0xFF000000),
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
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 73,
                      height: 19,
                      decoration: BoxDecoration(
                        color: Color(0xffFEF7FF),
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      child: Text(
                        'รอยืนยันตัวตน',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffB325F8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyYourIdentity() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (builder) => VerifyFirstStepPage()),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0x1AB325F8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/announce_user_profile.png',
                height: 55, width: 55),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'กรุณายืนยันตัวตน',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'เพื่อเข้าใช้งานคลาสเรียน จองใช้บริการ และบริการอื่นๆ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 32,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Color(0xFF7A4CB1),
                      borderRadius: BorderRadius.circular(94),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/next_user_profile.png',
                            height: 16, width: 16),
                        SizedBox(width: 5),
                        Text(
                          'ยืนยันตัวตน',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<dynamic>> _readEventcalendar() async {
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
    } on DioError catch (e) {
      print(e.toString());
    }
    return [];
  }

  void _onRefresh() async {
    _getUser();
    _readEventcalendar();
    _refreshController.refreshCompleted();
  }

  void _getUser() async {
    var data = await ManageStorage.read('profileData') ?? '';
    var result = json.decode(data);
    setState(() {
      _imageUrl = result['imageUrl'];
      _firstName = result['firstName'];
      _lastName = result['lastName'];
    });
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
}
