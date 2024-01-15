import 'dart:convert';

import 'package:des/data_error.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/stack_tap.dart';
import 'package:des/verify_otp_phone.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'shared/config.dart';
import 'main.dart';

class VerifyInformationPage extends StatefulWidget with WidgetsBindingObserver {
  const VerifyInformationPage({Key? key}) : super(key: key);

  @override
  State<VerifyInformationPage> createState() => _VerifyInformationPageState();
}

class _VerifyInformationPageState extends State<VerifyInformationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtIdCard = TextEditingController();
  TextEditingController txtFullName = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtAge = TextEditingController();
  TextEditingController txtLaserId = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtAddress = TextEditingController();

  DateTime selectedDate = DateTime.now();
  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  int age = 0;
  int currentPage = 0;
  bool loading = false;
  bool _loadindSubmit = false;

  String profileCode = '';
  String sex = '';
  String email = '';
  String image = '';
  String result = '';
  String selectedCodeLv1 = '';
  String selectedCodeLv2 = '';
  String selectedCodeLv3 = '';
  String selectedCodeLv4 = '';
  String titleCategoryLv1 = '';
  String titleCategoryLv2 = '';
  String titleCategoryLv3 = '';
  String titleCategoryLv4 = '';
  dynamic categoryModel = {'provinceTitle': ''};

  List<String> _genderList = ['ชาย', 'หญิง'];
  String _gender = 'ชาย';
  PageController? pageController;

  Future<dynamic>? _futureShopLv1;
  Future<dynamic>? _futureShopLv2;
  Future<dynamic>? _futureShopLv3;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        appBar: AppBar(
          backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.white
              : Colors.black,
          systemOverlayStyle: MyApp.themeNotifier.value == ThemeModeThird.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          elevation: 0,
          flexibleSpace: _buildHead(),
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                children: [
                  TextFormField(
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
                    controller: txtIdCard,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(13),
                    ],
                    decoration: _decorationRegisterMember(
                      context,
                      hintText: 'เลขบัตรประชาชน',
                    ),
                    validator: (model) {
                      String pattern = r'(^[0-9]\d{12}$)';
                      RegExp regex = RegExp(pattern);
                      if (regex.hasMatch(model!)) {
                        if (model.length != 13) {
                          return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
                        } else {
                          var sum = 0.0;
                          for (var i = 0; i < 12; i++) {
                            sum += double.parse(model[i]) * (13 - i);
                          }
                          if ((11 - (sum % 11)) % 10 !=
                              double.parse(model[12])) {
                            return 'กรุณากรอกเลขบัตรประชาชนให้ถูกต้อง';
                          } else {
                            return null;
                          }
                        }
                      } else {
                        return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: txtFirstName,
                          // inputFormatters: InputFormatTemple.name(),
                          decoration: _decorationRegisterMember(
                            context,
                            hintText: 'ชื่อ',
                          ),
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.black
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          ),
                          cursorColor: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFF7A4CB1)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          validator: (model) {
                            if (model!.isEmpty) {
                              return 'กรุณากรอกชื่อ';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: txtLastName,
                          // inputFormatters: InputFormatTemple.name(),
                          decoration: _decorationRegisterMember(
                            context,
                            hintText: 'นามสกุล',
                          ),
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.black
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          ),
                          cursorColor: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFF7A4CB1)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          validator: (model) {
                            if (model!.isEmpty) {
                              return 'กรุณากรอกนามสกุล.';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Kanit',
                                fontSize: 15.0,
                              ),
                              decoration: _decorationDate(
                                context,
                                hintText: 'วันเดือนปีเกิด',
                              ),
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
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: txtAge,
                          decoration: _decorationRegisterMember(
                            context,
                            hintText: 'อายุ',
                          ),
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.black
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          ),
                          cursorColor: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFF7A4CB1)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          validator: (model) {
                            if (model!.isEmpty) {
                              return 'กรุณากรอกอายุ.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: txtLaserId,
                    // inputFormatters: InputFormatTemple.laserid(),
                    keyboardType: TextInputType.name,
                    decoration: _decorationRegisterMember(
                      context,
                      hintText: 'เลข Laser ID',
                    ),
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
                    validator: (model) {
                      if (model!.isEmpty) {
                        return 'กรุณากรอกเลข Laser ID.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/thai_card_back.png',
                        height: 56,
                        width: 100,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'คำแนะนำ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.black
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                            ),
                            Text(
                              'เลข Laser ID จะอยู่ด้านหลังของบัตรประชาชน',
                              style: TextStyle(
                                fontSize: 11,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF707070)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Color(0xFF707070)
                                        : Color(0xFFFFFD57),
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'เพศ',
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
                  SizedBox(height: 6),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (_, __) => SizedBox(width: 25),
                      itemBuilder: (_, index) =>
                          _radioGender(_genderList[index]),
                      itemCount: _genderList.length,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'การติดต่อ',
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
                  Text(
                    'กรุณากรอกข้อมูลเบอร์ติดต่อและอีเมล เพื่อทำการรับรหัสยืนยัน OTP ต่อไป',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: txtPhone,
                    // inputFormatters: InputFormatTemple.laserid(),
                    keyboardType: TextInputType.number,
                    decoration: _decorationRegisterMember(
                      context,
                      hintText: 'หมายเลขโทรศัพท์',
                    ),
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
                    validator: (model) {
                      if (model!.isEmpty) {
                        return 'กรุณากรอกหมายเลขโทรศัพท์';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: txtAddress,
                    // inputFormatters: InputFormatTemple.laserid(),
                    keyboardType: TextInputType.name,
                    decoration: _decorationRegisterMember(
                      context,
                      hintText: 'ที่อยู่ บ้านเลขที่ ซอย หมู่ ถนน',
                    ),
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
                    validator: (model) {
                      if (model!.isEmpty) {
                        return 'กรุณากรอกที่อยู่ของท่าน';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'จังหวัด / อำเภอ/เขต / ตำบล/แขวง / รหัสไปรษณีย์',
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
                  SizedBox(height: 20),
                  _buildColumn(),
                  SizedBox(
                    height: 20,
                    child: Center(
                      child: Text(
                        result,
                        style: const TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () {
                        logD(_loadindSubmit);
                        final form = _formKey.currentState;
                        if (form!.validate() && !_loadindSubmit) {
                          setState(() {
                            _loadindSubmit = true;
                          });
                          form.save();

                          var birthday = DateFormat("yyyyMMdd").format(
                            DateTime(
                              _selectedYear,
                              _selectedMonth,
                              _selectedDay,
                            ),
                          );

                          dynamic model = {
                            'idcard': txtIdCard.text,
                            'age': txtAge.text,
                            'birthday': birthday,
                            'fullName':
                                '${txtFirstName.text} ${txtLastName.text}',
                            'firstName': txtFirstName.text,
                            'lastName': txtLastName.text,
                            'laser': txtLaserId.text,
                            'phone': txtPhone.text,
                            'address': txtAddress.text,
                            'sex': _gender,
                            'provinceCode': selectedCodeLv1,
                            'province': titleCategoryLv1,
                            'amphoeCode': selectedCodeLv2,
                            'amphoe': titleCategoryLv2,
                            'tambonCode': selectedCodeLv3,
                            'tambon': titleCategoryLv3,
                            'postnoCode': selectedCodeLv4,
                            'postno': titleCategoryLv4,
                          };
                          // _callLaser(model);
                          _requestOTP(model);
                        }
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.5),
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFF7A4CB1)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                        child: Text(
                          'ดำเนินการต่อ',
                          style: TextStyle(
                              fontSize: 16,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              if (loading)
                Positioned.fill(
                    child: Container(
                  color: Colors.white.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _sheetBottom();
          },
          child: Container(
            padding: EdgeInsets.only(left: 10.0),
            constraints: BoxConstraints(
              minHeight: 40,
            ),
            // height: 40,
            decoration: new BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                width: 1,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  titleCategoryLv1 != ""
                      ? (titleCategoryLv1) +
                          " / " +
                          (titleCategoryLv2) +
                          " / " +
                          (titleCategoryLv3) +
                          " / " +
                          (selectedCodeLv4)
                      : 'จังหวัด / อำเภอ/เขต / ตำบล/แขวง / รหัสไปรษณีย์',
                  style: TextStyle(
                    color: Color(0xFF000000).withOpacity(0.9),
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    // letterSpacing: 0.23,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  textCategory(page) {
    String text = '';
    if (page == 1) {
      if (titleCategoryLv1 != "" && titleCategoryLv1 != "กรุงเทพมหานคร") {
        text = "จังหวัด" + titleCategoryLv1;
      } else if (titleCategoryLv1 == "กรุงเทพมหานคร") {
        text = titleCategoryLv1;
      } else {
        text = 'เลือกจังหวัด';
      }
    }
    if (page == 2) {
      if (titleCategoryLv2 != "") {
        text = titleCategoryLv2;
      } else {
        text = 'เลือกอำเภอ/เขต';
      }
    }
    if (page == 3) {
      if (titleCategoryLv3 != "" && titleCategoryLv1 != "กรุงเทพมหานคร") {
        text = "ตำบล" + titleCategoryLv3;
      } else if (titleCategoryLv1 == "กรุงเทพมหานคร") {
        text = titleCategoryLv3;
      } else {
        text = 'เลือกตำบล/แขวง';
      }
    }
    if (page == 4) {
      if (selectedCodeLv4 != "") {
        text = selectedCodeLv4;
      } else {
        text = 'เลือกรหัสไปรษณีย์';
      }
      // text = titleCategoryLv4;
    }

    return text;
  }

  StackTap _buildItem(item, page, StateSetter setStateModal) {
    Color colorItem = Colors.black;
    if (page == 1 && selectedCodeLv1 == item['code']) colorItem = Colors.red;
    if (page == 2 && selectedCodeLv2 == item['code']) colorItem = Colors.red;
    if (page == 3 && selectedCodeLv3 == item['code']) colorItem = Colors.red;
    // if (page == 4 && selectedCodeLv4 == item['postCode']) colorItem = Colors.red;
    return StackTap(
      onTap: () async => {
        setStateModal(() {
          currentPage = page;
        }),
        if (page == 1)
          {
            setStateModal(() {
              selectedCodeLv1 = item['code'];
              selectedCodeLv2 = '';
              selectedCodeLv3 = '';
              selectedCodeLv4 = '';
              titleCategoryLv1 = item['title'];
              titleCategoryLv2 = '';
              titleCategoryLv3 = '';
              titleCategoryLv4 = '';
              getCategory(page, setStateModal);
              pageController!.animateToPage(page,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            })
          },
        if (page == 2)
          {
            setStateModal(() => {
                  selectedCodeLv2 = item['code'],
                  selectedCodeLv3 = '',
                  selectedCodeLv4 = '',
                  titleCategoryLv2 = item['title'],
                  getCategory(page, setStateModal),
                  pageController!.animateToPage(page,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease),
                })
          },
        if (page == 3)
          {
            setStateModal(() => {
                  selectedCodeLv3 = item['code'],
                  titleCategoryLv3 = item['title'],
                  selectedCodeLv4 = item['postCode'],
                  titleCategoryLv4 = item['postCode'],
                  getCategory(page, setStateModal),
                  // pageController.animateToPage(page,
                  //     duration: Duration(milliseconds: 500), curve: Curves.ease)
                }),
            Navigator.pop(context, 'success')
          },
        if (page == 4)
          {
            setStateModal(() => {
                  selectedCodeLv4 = item['postCode'],
                  titleCategoryLv4 = item['postCode'],
                  getCategory(page, setStateModal),
                  // pageController.animateToPage(page,
                  //     duration: Duration(milliseconds: 500), curve: Curves.ease)
                }),
            Navigator.pop(context, 'success')
          },
        setState(() {}),
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item['title'] != null ? item['title'] : item['title'],
              style: TextStyle(
                  fontFamily: 'Kanit', fontSize: 14, color: colorItem),
            ),
            Icon(
              colorItem == Colors.red
                  ? Icons.check
                  : page != 4
                      ? Icons.arrow_forward_ios_rounded
                      : null,
              size: colorItem == Colors.red ? 20 : 15,
              color: colorItem,
            ),
          ],
        ),
      ),
    );
  }

  getCategory(lv, StateSetter setStateModal) async {
    // var model = await get(server + 'provinces/' );
    Dio dio = Dio();
    var districtData;
    var tambonData;
    if (lv == 1) {
      var response = await dio.post('${server}route/district/read',
          data: {'province': selectedCodeLv1});
      districtData = response.data['objectData'];
    }
    if (lv == 2) {
      var response = await dio.post('${server}route/tambon/read',
          data: {'district': selectedCodeLv2});
      tambonData = response.data['objectData'];
    }
    setStateModal(
      () {
        if (lv == 1) {
          _futureShopLv2 = Future.value(districtData);
        }
        if (lv == 2) {
          _futureShopLv3 = Future.value(tambonData);
        }
      },
    );
  }

  _buildPageLv(_future, lv, StateSetter setStateModal) {
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data.length,
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Theme.of(context).colorScheme.background,
            ),
            itemBuilder: (context, index) =>
                _buildItem(snapshot.data[index], lv, setStateModal),
          );
        } else if (snapshot.hasError) {
          return DataError(onTap: () => _callReadProvince(''));
        } else {
          return ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Theme.of(context).colorScheme.background,
            ),
            itemBuilder: (context, index) => Container(
              height: 50,
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
            ),
          );
        }
      },
    );
  }

  _titleCategory(lv, StateSetter setStateModal) {
    return GestureDetector(
      onTap: () => setStateModal(() {
        currentPage = lv - 1;
        pageController!.animateToPage(lv - 1,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: currentPage == lv - 1 ? Colors.red : Colors.white,
            ),
          ),
        ),
        child: Text(
          textCategory(lv),
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  _sheetBottom() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setStateModal /*You can rename this!*/) {
          return Container(
            // height: 300,
            color: Color(0xFFFFFFFF),
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'เลือกที่อยู่',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _titleCategory(1, setStateModal),
                      if (selectedCodeLv1 != '')
                        _titleCategory(2, setStateModal),
                      if (selectedCodeLv2 != '')
                        _titleCategory(3, setStateModal),
                      // if (selectedCodeLv3 != '')
                      //   _titleCategory(4, setStateModal),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: new NeverScrollableScrollPhysics(),
                    children: [
                      _buildPageLv(_futureShopLv1, 1, setStateModal),
                      if (selectedCodeLv1 != '')
                        _buildPageLv(_futureShopLv2, 2, setStateModal),
                      if (selectedCodeLv2 != '')
                        _buildPageLv(_futureShopLv3, 3, setStateModal),
                      // if (selectedCodeLv3 != '')
                      //   _buildPageLv(_futureShopLv4, 4, setStateModal),
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
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
      child: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
                // Dio dio = Dio();
                // String laserUrl =
                //     'https://a6fe-101-108-244-151.ngrok.io/api/laser';
                // var response = await dio.post(
                //   laserUrl,
                //   data: {
                //     "pid": 1100800535208,
                //     "fname": "พรทวี",
                //     "lname": "จันทนิตย์",
                //     "dob": 25320426,
                //     "laser": "ME0113310347"
                //   },
                //   options: Options(headers: {'token': ''}),
                // );
                // print(response.data.toString());
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
              'ข้อมูลบัตรประชาชน',
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
          )
        ],
      ),
    );
  }

  static InputDecoration _decorationRegisterMember(context,
          {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          // fontSize: 12,
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
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
          fontWeight: FontWeight.normal,
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
          // fontSize: 12,
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

  dynamic dialogOpenPickerDate() {
    DatePicker.showDatePicker(
      context,
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
      minTime: DateTime(2400, 1, 1),
      maxTime: DateTime(year, month, day),
      onConfirm: (date) {
        setState(
          () {
            _selectedYear = date.year;
            _selectedMonth = date.month;
            _selectedDay = date.day;
            txtDate.value = TextEditingValue(
              text: DateFormat("dd-MM-yyyy").format(date),
            );
            //เดือนที่เลือกน้อยกว่าเท่ากับเดือนปัจจุบัน && วันที่เลือกน้อยกว่าเท่ากับวันปัจจุบัน
            if (_selectedMonth <= month && _selectedDay <= day) {
              age = year - _selectedYear;
              debugPrint('age1 $age');
            } //เดือนที่เลือกน้อยกว่าเท่ากับเดือนปัจจุบัน && วันที่เลือกมากกว่าวันปัจจุบัน
            else if (_selectedMonth <= month && _selectedDay > day) {
              age = year - _selectedYear - 1;
              debugPrint('age2 $age');
            } //เดือนที่เลือกมากกว่าเดือนปัจจุบัน && วันที่เลือกมากกว่าวันปัจจุบัน
            else if (_selectedMonth > month && _selectedDay > day) {
              age = year - _selectedYear - 1;
              debugPrint('age3 $age');
            } else {
              age = year - _selectedYear - 1;
              debugPrint('age4 $age');
            }
            txtAge.value = TextEditingValue(
              text: age.toString(),
            );
          },
        );
      },
      currentTime: DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
      locale: LocaleType.th,
    );
  }

  Widget _radioGender(String value) {
    // Color border = _gender == value ? Color(0xFFA924F0) : Colors.grey;
    // Color active = _gender == value ? Color(0xFFA924F0) : Colors.white;
    Color border;
    Color active;
    if (_gender == value) {
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = value;
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
            value,
            style: TextStyle(
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    pageController = new PageController(initialPage: currentPage);
    _callReadProvince(categoryModel);
    Intl.defaultLocale = "th";
    initializeDateFormatting();

    super.initState();
    var now = DateTime.now();
    setState(() {
      year = now.year + 543;
      month = now.month;
      day = now.day;
      _selectedYear = now.year + 543;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // txtIdCard.dispose();
    pageController!.dispose();
    txtFullName.dispose();
    txtDate.dispose();
    txtAge.dispose();
    txtLaserId.dispose();
    super.dispose();
  }

  _callReadProvince(param) async {
    Dio dio = Dio();
    var response = await dio.post('${server}route/province/read', data: {});
    var provinceData = response.data['objectData'];
    setState(() {
      _futureShopLv1 = Future.value(provinceData);
    });
  }

  // ignore: unused_element
  void _callLaser(param) async {
    setState(() {
      loading = true;
    });

    String loginUrl = 'https://f288-101-109-238-157.ngrok.io/api/jwt/login';
    Dio dio = Dio();
    var response = await dio.post(
      loginUrl,
      data: {
        "username": "bina@trial",
        "password": "bina!p@ss168",
      },
    );

    if (response.statusCode == 200) {
      // {
      //     "pid": 1100800535208,
      //     "fname": "พรทวี",
      //     "lname": "จันทนิตย์",
      //     "dob": 25320426,
      //     "laser": "ME0113310347"
      //   },

      // data: {
      //     "pid": int.parse(param['idcard']),
      //     "fname": param['firstName'],
      //     "lname": param['lastName'],
      //     "dob": int.parse(param['birthday']),
      //     "laser": param['laser'].toString().toUpperCase()
      //   },
      String token = response.data['token'].toString();
      String laserUrl = 'https://f288-101-109-238-157.ngrok.io/api/laser';
      response = await dio.post(
        laserUrl,
        data: {
          "pid": int.parse(param['idcard']),
          "fname": param['firstName'],
          "lname": param['lastName'],
          "dob": int.parse(param['birthday']),
          "laser": param['laser'].toString().toUpperCase()
        },
        options: Options(headers: {'token': token}),
      );
      // print(response.data.toString());

      setState(() {
        if (response.data['code'].toString() != '0') {
          setState(() {
            loading = false;
            result = response.data['desc'];
          });
        } else {
          loading = false;
        }
      });
    } else {
      setState(() {
        loading = false;
        result = response.data['desc'];
      });
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _requestOTP(dynamic model) async {
    try {
      Dio dio = Dio();
      dio.options.contentType = Headers.formUrlEncodedContentType;
      dio.options.headers["api_key"] = "db88c29e14b65c9db353c9385f6e5f28";
      dio.options.headers["secret_key"] = "XpM2EfFk7DKcyJzt";
      var response =
          await dio.post('https://portal-otp.smsmkt.com/api/otp-send', data: {
        "project_key": "XcvVbGHhAi",
        "phone": model['phone'].replaceAll('-', '').trim(),
        "ref_code": "xxx123"
      });

      var otp = response.data['result'];
      if (otp['token'] != null) {
        setState(() {
          _loadindSubmit = false;
        });

        await ManageStorage.createSecureStorage(
          key: 'verifyTemp',
          value: jsonEncode(model),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOTPPhonePage(
              token: otp['token'],
              refCode: otp['ref_code'],
            ),
          ),
        );
      } else {
        setState(() {
          _loadindSubmit = false;
        });
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      setState(() {
        _loadindSubmit = false;
      });
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }
}
