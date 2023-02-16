import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/history_of_service_reservations.dart';
import 'package:des/detail.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/user_profile_edit.dart';
import 'package:des/user_profile_setting.dart';
import 'package:des/verify_first_step.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    Key? key,
  }) : super(key: key);
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final storage = const FlutterSecureStorage();
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
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 15,
            bottom: MediaQuery.of(context).padding.bottom + 25,
            right: 15,
            left: 15,
          ),
          children: [
            _buildUserDetail(),
            const SizedBox(height: 15),
            _buildVerifyYourIdentity(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'คลาสเรียนของฉัน',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'ดูทั้งหมด',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF53327A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMyClass('สกัดสมุนไพร เพื่อผลิตภัณฑ์เสริมความงาม', 50,
                    'assets/images/01.png', 'class1'),
                _buildMyClass('ผลิตยาหม่องมณีพฤกษา ง่ายๆ ด้วยตัวเอง', 80,
                    'assets/images/02.png', 'class2'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'คลาสที่ชอบ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'ดูทั้งหมด',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF53327A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _readNews(),
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
            const SizedBox(height: 5),
            _buildHistoryOfServiceReservations(
                'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน',
                'อำเภอบางใหญ่ นนทบุรี',
                3,
                _dateStringToDateSlashBuddhistShort('20220911'),
                '11.00'),
            const SizedBox(height: 10),
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
      height: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  title2,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/calendar_check.png',
                      height: 10,
                      width: 10,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF53327A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/time_user_profile_page.png',
                      height: 10,
                      width: 10,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$time น.',
                      style: const TextStyle(
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
          const SizedBox(width: 10),
          Text(
            '$hour ชั่วโมง',
            style: const TextStyle(
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
            slug: 'news',
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
                imageUrl: model['imageUrl'],
                fit: BoxFit.fill,
                height: 92,
                width: screenSize,
              ),
            ),
            SizedBox(
              width: screenSize,
              child: Text(
                model['title'],
                style: const TextStyle(
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

  Widget _buildMyClass(String title, double study, String image, String code) {
    var screenSize = (45.07 * MediaQuery.of(context).size.width) / 100;
    return InkWell(
      onTap: () {
        if (code == 'class1') {
        } else if (code == 'class2') {}
      },
      child: SizedBox(
        height: screenSize,
        width: screenSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                fit: BoxFit.fill,
                height: 95,
                width: screenSize,
              ),
            ),
            SizedBox(
              width: 170,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 10),
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
                      padding: const EdgeInsets.all(10.0),
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
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          _firstName ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Text(' '),
                        Text(
                          _lastName ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const UserProfileSettingPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          "assets/images/settings.png",
                          height: 16,
                          width: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'แก้ไขข้อมูล',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffFEF7FF),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Text(
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFFAE2FD),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/check_rounded.png', height: 60, width: 60),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'กรุณายืนยันตัวตน',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'เพื่อเข้าใช้งานคลาสเรียน จองใช้บริการ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const VerifyFirstStepPage()),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: const Text(
                    'รอยืนยันตัวตน',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB325F8),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var data = await ManageStorage.read('profileData') ?? '';
      var result = json.decode(data);
      setState(() {
        _imageUrl = result['imageUrl'];
        _firstName = result['firstName'];
        _lastName = result['lastName'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
    } on DioError catch (e) {
      print(e.toString());
    }
    return [];
  }

  void _onRefresh() async {
    _readNews();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
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
