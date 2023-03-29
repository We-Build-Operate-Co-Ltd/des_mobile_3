import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/detail.dart';
import 'package:des/menu.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingServiceSuccessPage extends StatefulWidget {
  const BookingServiceSuccessPage({super.key});

  @override
  State<BookingServiceSuccessPage> createState() =>
      _BookingServiceSuccessPageState();
}

class _BookingServiceSuccessPageState extends State<BookingServiceSuccessPage> {
  DateTime? currentBackPressTime;
  late int random;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () => Future.value(false),
          child: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/logo_2o.png',
                  fit: BoxFit.fitWidth,
                  width: 290,
                  alignment: Alignment.topRight,
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 150),
                      if (random == 0) ..._buildSuccess(),
                      if (random == 1) ..._buildFail(),
                      SizedBox(height: 45),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'คลาสแนะนำ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder(
                        future: _readNews(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.length > 0) {
                              return SizedBox(
                                height: 240,
                                width: double.infinity,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 15),
                                  itemBuilder: (context, index) =>
                                      containerRecommendedClass(
                                          snapshot.data![index]),
                                ),
                              );
                            }
                          }
                          return const SizedBox();
                        },
                      ),
                      Expanded(child: SizedBox()),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const Menu(),
                          ),
                          (Route<dynamic> route) => false,
                        ),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(0xFF7A4CB1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'กลับหน้าหลัก',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSuccess() {
    return <Widget>[
      Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFF19AA6A),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.asset(
          'assets/images/check_success.png',
          height: 60,
        ),
      ),
      SizedBox(height: 17),
      Text(
        'จองสำเร็จ',
        style: TextStyle(
          color: Color(0xFF19AA6A),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        'การเรียนรู้สามารถทำได้ตลอดชีวิต เราจะรอท่านมาใช้บริการ ',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    ];
  }

  List<Widget> _buildFail() {
    return <Widget>[
      Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFF7D930),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.asset(
          'assets/images/alert_fail.png',
          height: 60,
        ),
      ),
      SizedBox(height: 17),
      Text(
        'จองไม่สำเร็จ',
        style: TextStyle(
          color: Color(0xFF707070),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        'ขออภัยการจองใช้ไม่สำเร็จ โปรดติดต่อเจ้าหน้าที่\nหรือทำการจองใหม่ การเรียนรู้สามารถทำได้ตลอดชีวิต\nเราจะรอท่านมาใช้บริการ',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Color(0xFF707070),
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    debugPrint('current ${currentBackPressTime.toString()}');
    debugPrint('now ${now.toString()}');
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'กดอีกครั้งเพื่อออก');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget containerRecommendedClass(dynamic model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              slug: 'news',
              model: model,
            ),
          ),
        );
      },
      child: Container(
        width: 165,
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
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
    );
  }

  @override
  void initState() {
    random = Random().nextInt(2);
    super.initState();
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
}
