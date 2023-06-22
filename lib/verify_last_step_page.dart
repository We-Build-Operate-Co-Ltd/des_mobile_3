import 'dart:convert';

import 'package:des/menu.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class VerifyLastStepPage extends StatefulWidget {
  const VerifyLastStepPage({
    Key? key,
    this.model,
  }) : super(key: key);
  final dynamic model;

  @override
  State<VerifyLastStepPage> createState() => _VerifyLastStepPageState();
}

class _VerifyLastStepPageState extends State<VerifyLastStepPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      body: Column(
        children: [
          _buildHead(),
          SizedBox(height: 20),
          _box(),
          GestureDetector(
            onTap: () {
              _save();
            },
            child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.5),
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7A4CB1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                  ),
                  child: Text(
                    'ส่งข้อมูล',
                    style: TextStyle(
                      fontSize: 16,
                      color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.white
                                    : Colors.black,
                    ),
                  ),
                ),
          ),
          SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget _buildHead() {
    return SafeArea(
      child: Container(
        height: 60,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        child: Stack(
          children: [
            // Container(
            //   height: double.infinity,
            //   width: double.infinity,
            // ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : Colors.black,
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      )),
                  child: Image.asset(
                    'assets/images/back_arrow.png',
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'ตรวจสอบข้อมูล',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box() {
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 300),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFF6E6FE)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ข้อมูลบัตรประชาชน',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black.withOpacity(0.5)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  height: 1,
                ),
                SizedBox(height: 17),
                _text('ชื่อสกุล', widget.model['fullName'] ?? ''),
                _text('เลขบัตรประชาชน', widget.model['idcard'] ?? ''),
                _text(
                    'วันเดือนปีเกิด',
                    _dateStringToDateSlashBuddhistShort(
                        widget.model['birthday'] ?? '')),
                _text('อีเมล', widget.model['email'] ?? ''),
                _text('เพศ', widget.model['sex'] ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _text(String title, String value) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF707070),
            ),
          ),
          Text(
            '${value}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            ),
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
    print(widget.model);
  }

  _save() async {
    var value = await ManageStorage.read('profileData') ?? '';
    var user = json.decode(value);

    user['firstName'] = widget.model['firstName'];
    user['lastName'] = widget.model['lastName'];
    user['email'] = widget.model['email'];
    user['phone'] = widget.model['phone'];
    user['sex'] = widget.model['sex'];
    user['address'] = widget.model['address'];
    user['status'] = "A";
    user['isActive'] = true;

    final response = await Dio()
        .post('https://des.we-builds.com/de-api/m/Register/update', data: user);

    var result = response.data;
    if (result['status'] == 'S') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
      );
    }
  }

  _dateStringToDateSlashBuddhistShort(String date) {
    if (date.isEmpty) return '';
    var year = date.substring(0, 4);
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    var yearBuddhist = int.parse(year) + 543;
    var yearBuddhistString = yearBuddhist.toString();
    var yearBuddhistStringShort = yearBuddhistString.substring(2, 4);
    return day + '/' + month + '/' + yearBuddhistStringShort;
  }
}
