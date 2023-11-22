import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/menu.dart';
import 'package:des/shared/image_picker.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'shared/config.dart';
import 'main.dart';
import 'shared/extension.dart';

class UserProfileEditPage extends StatefulWidget {
  UserProfileEditPage({Key? key}) : super(key: key);

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final storage = new FlutterSecureStorage();

  String _imageUrl = '';
  String? _code;
  bool _loadingSubmit = false;
  XFile? _imageFile;

  String? _selectedPrefixName;

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtAge = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();
  dynamic rubberFarmer;
  Future<dynamic>? futureModel;

  ScrollController scrollController = new ScrollController();

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  String farmerIdCard = "";
  String farmerRubberTree = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtEmail.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    txtDate.dispose();
    super.dispose();
  }

  List<dynamic> _genderList = [
    {'key': 'male', 'value': 'ชาย'},
    {'key': 'female', 'value': 'หญิง'},
    {'key': 'other', 'value': 'อื่น ๆ'},
  ];
  String _gender = '';
  DateTime? now;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
        //     ? Colors.white
        //     : Colors.black,
        elevation: 0,
        flexibleSpace: _buildHead(),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _modalImagePicker();
              },
              child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: _imageFile != null
                              ? Image.file(
                                  File(_imageFile!.path),
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: 120,
                                )
                              : CachedNetworkImage(
                                  imageUrl: _imageUrl,
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: 120,
                                  errorWidget: (_, __, ___) => Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xFFA924F0),
                                      ),
                                    ),
                                    child: Text(
                                      'เพิ่มรูปภาพ +',
                                      style: TextStyle(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                      Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            height: 25,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7A4CB1)
                                    : Colors.black,
                                border: Border.all(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Color(0xFF7A4CB1)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                )),
                            child: Image.asset(
                              'assets/images/camera.png',
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.white
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                              // height: 25,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            TextFormField(
              controller: txtFirstName,
              decoration: _decorationBase(context, hintText: 'ชื่อ'),
              style: TextStyle(
                fontFamily: 'Kanit',
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF7A4CB1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: txtLastName,
              decoration: _decorationBase(context, hintText: 'สกุล'),
              style: TextStyle(
                fontFamily: 'Kanit',
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF7A4CB1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => dialogOpenPickerDate(),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: txtDate,
                        style: TextStyle(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.black
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 15.0,
                        ),
                        decoration: _decorationDate(context,
                            hintText: 'วันเดือนปีเกิด'),
                        validator: (model) {
                          if (model!.isEmpty) {
                            return 'กรุณากรอกวันเดือนปีเกิด.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: txtAge,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9a-zA-Z.]')),
                    ],
                    decoration: _decorationBase(context, hintText: 'อายุ'),
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                    cursorColor:
                        MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'การติดต่อ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Kanit',
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: txtPhone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: _decorationBase(context, hintText: 'เบอร์ติดต่อ'),
              style: TextStyle(
                fontFamily: 'Kanit',
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF7A4CB1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: txtEmail,
              readOnly: true,
              decoration: _decorationBase(
                context,
                hintText: 'อีเมล',
                readOnly: true,
              ),
              style: TextStyle(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF7A4CB1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
            SizedBox(height: 30),
            Text(
              'เพศ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Kanit',
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
            SizedBox(height: 4),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                separatorBuilder: (_, __) => SizedBox(width: 10),
                itemBuilder: (_, index) => _radioGender(_genderList[index]),
                itemCount: _genderList.length,
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () => submitUpdateUser(),
              child: Container(
                margin: EdgeInsets.only(top: 20),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFF7A4CB1)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'บันทึกข้อมูล',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      height: 60 + MediaQuery.of(context).padding.top,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: MediaQuery.of(context).padding.top,
      ),
      color: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
          // GestureDetector(
          //   onTap: () => submitUpdateUser(),
          //   child: Icon(
          //     Icons.check,
          //     color: Color(
          //       0xFFA924F0,
          //     ),
          //     size: 35,
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _radioGender(dynamic value) {
    Color border;
    Color active;
    if (_gender == value['key']) {
      if (MyApp.themeNotifier.value == ThemeModeThird.light) {
        border = Color(0xFFB325F8);
        active = Color(0xFFB325F8);
      } else if (MyApp.themeNotifier.value == ThemeModeThird.dark) {
        border = Colors.white;
        active = Colors.white;
      } else {
        border = Color(0xFFFFFD57);
        active = Color(0xFFFFFD57);
      }
    } else {
      if (MyApp.themeNotifier.value == ThemeModeThird.light) {
        border = Color(0xFFB325F8);
        active = Colors.white;
      } else if (MyApp.themeNotifier.value == ThemeModeThird.dark) {
        border = Colors.white;
        active = Colors.black;
      } else {
        border = Color(0xFFFFFD57);
        active = Colors.black;
      }
    }
    // border = _gender == value ? Color(0xFFA924F0) : Colors.grey;
    // active = _gender == value ? Color(0xFFA924F0) : Colors.white;
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = value['key'];
        });
      },
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active,
              ),
            ),
          ),
          SizedBox(width: 6),
          Text(
            value['value'],
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Kanit',
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF7A4CB1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          )
        ],
      ),
    );
  }

  dialogOpenPickerDate() {
    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
          backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.white
              : Color(0xFF292929),
          containerHeight: 210.0,
          itemStyle: TextStyle(
            fontSize: 16.0,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
          doneStyle: TextStyle(
            fontSize: 16.0,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
          cancelStyle: TextStyle(
            fontSize: 16.0,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
        ),
        showTitleActions: true,
        minTime: DateTime(1800, 1, 1),
        maxTime: DateTime(year, month, day), onConfirm: (date) {
      setState(
        () {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          txtDate.value = TextEditingValue(
            text: DateFormat("dd / MM / yyyy").format(date),
          );
          txtAge.text = (now!.year - date.year).toString();
        },
      );
    },
        currentTime: DateTime(
          _selectedYear,
          _selectedMonth,
          _selectedDay,
        ),
        locale: LocaleType.th);
  }

  static InputDecoration _decorationBase(
    context, {
    String hintText = '',
    bool readOnly = false,
  }) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: readOnly ? Colors.black.withOpacity(0.2) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black.withOpacity(0.2)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Color(0xFF707070)
                    : Color(0xFFFFFD57),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );

  static InputDecoration _decorationDate(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        suffixIcon: Icon(Icons.calendar_today),
        suffixIconColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.black
            : MyApp.themeNotifier.value == ThemeModeThird.dark
                ? Colors.white
                : Color(0xFFFFFD57),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black.withOpacity(0.2)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Color(0xFF707070)
                    : Color(0xFFFFFD57),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );

  @override
  void initState() {
    readStorage();
    super.initState();
    now = new DateTime.now();
    setState(() {
      year = now!.year;
      month = now!.month;
      day = now!.day;
      _selectedYear = now!.year;
      _selectedMonth = now!.month;
      _selectedDay = now!.day;
    });
  }

  Future<dynamic> readUser() async {
    try {
      final response =
          await Dio().post("$server/de-api/m/Register/read", data: {
        'code': _code,
      });

      var result = response.data;
      if (result['status'] == 'S') {
        await storage.write(
          key: 'dataUserLoginSSO',
          value: jsonEncode(result['objectData'][0]),
        );

        if (result['objectData'][0]?['birthDay'] != null) {
          var date = result['objectData'][0]['birthDay'];
          var year = date.substring(0, 4);
          var month = date.substring(4, 6);
          var day = date.substring(6, 8);
          DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);

          // DateTime todayDate =
          //     DateTime.parse(todayDateBase);
          setState(() {
            _selectedYear = todayDate.year;
            _selectedMonth = todayDate.month;
            _selectedDay = todayDate.day;
            txtDate.text = DateFormat("dd / MM / yyyy").format(todayDate);
          });
        }

        setState(() {
          _imageUrl = result['objectData'][0]['imageUrl'] ?? '';
          txtFirstName.text = result['objectData'][0]['firstName'] ?? '';
          txtLastName.text = result['objectData'][0]['lastName'] ?? '';
          txtEmail.text = result['objectData'][0]['email'] ?? '';
          txtPhone.text = result['objectData'][0]['phone'] ?? '';
          _selectedPrefixName = result['objectData'][0]['prefixName'] ?? '';
          _code = result['objectData'][0]['code'] ?? '';
          txtAge.text = result['objectData'][0]['age'];
          _gender = result['objectData'][0]['sex'];
        });
        logWTF(_gender);
      }
    } catch (e) {
      logE(e);
    }
  }

  Future<dynamic> submitUpdateUser() async {
    try {
      var value = await ManageStorage.read('profileData') ?? '';
      var user = json.decode(value);

      setState(() => _loadingSubmit = true);
      if (_imageFile?.path != null) {
        await _uploadImage(_imageFile!);
      }

      user['imageUrl'] = _imageUrl;
      user['firstName'] = txtFirstName.text;
      user['lastName'] = txtLastName.text;
      user['email'] = txtEmail.text;
      user['age'] = txtAge.text;
      user['phone'] = txtPhone.text;
      user['prefixName'] = _selectedPrefixName;
      user['birthDay'] = DateFormat("yyyyMMdd").format(
        DateTime(
          _selectedYear,
          _selectedMonth,
          _selectedDay,
        ),
      );

      final response =
          await Dio().post('$server/de-api/m/Register/update', data: user);
      var result = response.data;
      setState(() => _loadingSubmit = false);
      if (result['status'] == 'S') {
        await ManageStorage.createProfile(
          key: result['objectData']['category'],
          value: result['objectData'],
        );
        setState(() {
          readStorage();
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
        );

        return showDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(
              'อัพเดตข้อมูลเรียบร้อยแล้ว',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Kanit',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: Text(" "),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Color(0xFF005C9E),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        return showDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(
              'อัพเดตข้อมูลไม่สำเร็จ',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Kanit',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: Text(" "),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Color(0xFF005C9E),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      logE(e);
      setState(() => _loadingSubmit = false);
    }
  }

  readStorage() async {
    try {
      var value = await ManageStorage.read('profileData') ?? '';
      var user = json.decode(value);

      if (user['code'] != '') {
        setState(() {
          _imageUrl = user['imageUrl'] ?? '';
          txtFirstName.text = user['firstName'] ?? '';
          txtLastName.text = user['lastName'] ?? '';
          txtEmail.text = user['email'] ?? '';
          txtPhone.text = user['phone'] ?? '';
          _selectedPrefixName = user['prefixName'];
          _code = user['code'];
        });

        logWTF(user['birthDay']);

        // if (user['birthDay'] != '') {
        //   var date = user['birthDay'];
        //   var year = date.substring(0, 4);
        //   var month = date.substring(4, 6);
        //   var day = date.substring(6, 8);
        //   DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
        //   // DateTime todayDate = DateTime.parse(user['birthDay']);

        //   setState(() {
        //     _selectedYear = todayDate.year;
        //     _selectedMonth = todayDate.month;
        //     _selectedDay = todayDate.day;
        //     txtDate.text = DateFormat("dd / MM / yyyy").format(todayDate);
        //   });
        // }
        readUser();
      }
    } catch (e) {
      logE(e);
    }
  }

  void _modalImagePicker() {
    bool loading = false;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter mSetState /*You can rename this!*/) {
          return SafeArea(
            child: SizedBox(
              height: 120 + MediaQuery.of(context).padding.bottom,
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Photo Library'),
                          onTap: () async {
                            try {
                              mSetState(() {
                                loading = true;
                              });
                              XFile? image = await ImagePickerFrom.gallery();

                              setState(() {
                                _imageFile = image;
                              });
                            } catch (e) {
                              Fluttertoast.showToast(msg: 'ลอกงอีกครั้ง');
                            }
                            if (!mounted) return;
                            mSetState(() {
                              loading = false;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Camera'),
                        onTap: () async {
                          try {
                            mSetState(() {
                              loading = true;
                            });
                            XFile? image = await ImagePickerFrom.camera();

                            setState(() {
                              _imageFile = image;
                            });
                          } catch (e) {
                            Fluttertoast.showToast(msg: 'ลอกงอีกครั้ง');
                          }
                          if (!mounted) return;
                          mSetState(() {
                            loading = false;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  if (loading)
                    const Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  _uploadImage(XFile file) async {
    var serverUpload = '$server/de-document/upload';
    try {
      Dio dio = Dio();
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "ImageCaption": "de_profile",
        "Image": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      var response = await dio.post(serverUpload, data: formData);
      _imageUrl = response.data?['imageUrl'];
    } catch (e) {
      setState(() => _loadingSubmit = false);
      logE(e);
      // throw Exception(e);
      //return empty list (you can also return custom error to be handled by Future Builder)
    }
  }
}
