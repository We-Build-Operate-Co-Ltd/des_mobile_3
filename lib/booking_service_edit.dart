import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/booking_service.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:des/booking_service_confirm.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class BookingServiceEditPage extends StatefulWidget {
  const BookingServiceEditPage({
    Key? key,
    required this.model,
    this.repeat = false,
    this.repeatCurrentDay = false,
    this.edit = false,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.phone,
    this.remark,
  }) : super(key: key);

  final dynamic model;
  final bool repeat;
  final bool repeatCurrentDay;
  final bool edit;

  final String date;
  final String startTime;
  final String endTime;
  final String? phone;
  final String? remark;

  @override
  State<BookingServiceEditPage> createState() => _BookingServiceEditPageState();
}

class _BookingServiceEditPageState extends State<BookingServiceEditPage> {
  DateTime selectedDate = DateTime.now();
  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  int age = 0;
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtStartTime = TextEditingController();
  TextEditingController txtEndTime = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  late List<dynamic> _modelBookingCategory;

  dynamic _model;
  String title = 'รายละเอียด';
  String titleSubmit = 'จองใช้บริการ';
  String _bookingTypeRefNo = '';
  late List<dynamic> _modelType;
  bool _loadingDropdownType = false;
  bool _loadingSubmit = false;
  String oldStartTime = '';
  String oldEndTime = '';
  String oldDate = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          // backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          //     ? Colors.white
          //     : Colors.black,
          body: Container(
            padding: EdgeInsets.only(top: 130),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/BG.png"),
                fit: BoxFit.cover,
                colorFilter: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? null
                    : ColorFilter.mode(Colors.grey, BlendMode.saturation),
              ),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.black
                          : Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          MyApp.themeNotifier.value == ThemeModeThird.light
                              ? 'assets/images/back_arrow.png'
                              : "assets/images/2024/back_balckwhite.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Text(
                        "เลื่อนการจอง",
                        style: TextStyle(
                            fontSize: 24,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFFBD4BF7)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                            fontWeight: FontWeight.w500),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                      child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: _buildBookingForm(),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (txtDate.text.isEmpty ||
                                  txtStartTime.text.isEmpty ||
                                  txtEndTime.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'เลือกวันเวลาที่ต้องการจอง');
                              } else {
                                if (_bookingTypeRefNo.isEmpty && !widget.edit) {
                                  Fluttertoast.showToast(
                                      msg: 'เลือกรูปแบบการจอง');
                                  return;
                                }

                                int bookingNo = 0;
                                if (widget.edit) {
                                  bookingNo = widget.model?['bookingno'] ?? 0;
                                }

                                if (widget.repeat) {
                                  bookingNo = 0;
                                }

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => BookingServiceConfirmPage(
                                //       centerId: widget.model['centerId'],
                                //       centerName: widget.model['centerName'],
                                //       edit: widget.edit,
                                //       date: txtDate.text,
                                //       startTime: txtStartTime.text,
                                //       endTime: txtEndTime.text,
                                //       bookingTypeRefNo: _bookingTypeRefNo,
                                //       bookingno: bookingNo,
                                //       phone: txtPhone.text,
                                //       remark: _modelBookingCategory,
                                //     ),
                                //   ),
                                // );
                                _postpone();
                              }
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Theme.of(context).custom.b325f8_w_fffd57,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'ยืนยัน',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Colors.white
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.black
                                          : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_loadingSubmit)
                        Positioned.fill(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const SizedBox(
                              height: 60,
                              width: 60,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ));
  }

  _buildBookingForm() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 16),
      children: [
        GestureDetector(
          onTap: () => dialogOpenPickerDate(),
          child: AbsorbPointer(
            child: TextFormField(
              controller: txtDate,
              style: TextStyle(
                color: Theme.of(context).custom.b_w_y,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
                fontSize: 15.0,
              ),
              decoration: _decorationDate(
                context,
                hintText: 'วันที่ใช้บริการ',
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
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => dialogOpenPickerTime('start'),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: txtStartTime,
                    style: TextStyle(
                      color: Theme.of(context).custom.b_w_y,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 15.0,
                    ),
                    decoration: _decorationTime(
                      context,
                      hintText: 'เวลาเริ่ม',
                    ),
                    validator: (model) {
                      if (model!.isEmpty) {
                        return 'กรุณาเลือกเวลาเริ่ม';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: GestureDetector(
                onTap: () => dialogOpenPickerTime('end'),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: txtEndTime,
                    style: TextStyle(
                      color: Theme.of(context).custom.b_w_y,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 15.0,
                    ),
                    decoration: _decorationTime(
                      context,
                      hintText: 'เวลาเลิก',
                    ),
                    validator: (model) {
                      if (model!.isEmpty) {
                        return 'กรุณาเลือกเวลาเลิก';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: txtPhone,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: _decorationBase(context, hintText: 'เบอร์ติดต่อ'),
          style: TextStyle(
            color: Theme.of(context).custom.b_w_y,
          ),
          cursorColor: Theme.of(context).custom.b_w_y,
        ),
        SizedBox(height: 15),
        if (!widget.edit)
          _dropdown(
            data: _modelType,
            value: _bookingTypeRefNo,
            onChanged: (String value) {
              setState(() {
                _bookingTypeRefNo = value;
              });
            },
          ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'หมวดหมู่การใช้งาน',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).custom.b325f8_w_fffd57,
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildBookingCategory(),
        SizedBox(height: 10),

        // Spacer(),
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Image.asset(
        'assets/images/back.png',
        height: 40,
        width: 40,
      ),
    );
  }

  Widget _buildBookingCategory() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      itemCount: _modelBookingCategory.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => GestureDetector(
        onTap: () {
          setState(() {
            _modelBookingCategory[__]['selected'] =
                !_modelBookingCategory[__]['selected'];
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Container(
                  height: 20,
                  width: 20,
                  // padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFBD4BF7)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Icon(Icons.check,
                      size: 16,
                      color: _modelBookingCategory[__]['selected']
                          ? MyApp.themeNotifier.value == ThemeModeThird.light
                              ? Color(0xFFBD4BF7)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57)
                          : MyApp.themeNotifier.value == ThemeModeThird.light
                              ? Colors.white
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.black
                                  : Colors.black)
                  // Container(
                  //   margin: EdgeInsets.all(2),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(2),
                  //       color: _modelBookingCategory[__]['selected']
                  //           ? Color(0xFFA06CD5)
                  //           : Color(0xFFFFFFFF)),
                  // ),
                  ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${_modelBookingCategory[__]['catNameTh']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF707070),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _dropdown({
    required List<dynamic> data,
    required String value,
    Function(String)? onChanged,
  }) {
    return Stack(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).custom.w_b_b,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x40F3D2FF),
                offset: Offset(0, 4),
              )
            ],
          ),
          child: DropdownButtonFormField(
            icon: Image.asset(
              'assets/images/arrow_down.png',
              width: 16,
              height: 8,
              color: Theme.of(context).custom.b325f8_w_fffd57,
            ),
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).custom.b_W_fffd57,
            ),
            decoration: _decorationDropdown(context),
            isExpanded: true,
            value: value,
            dropdownColor: Theme.of(context).custom.w_b_b,
            // validator: (value) =>
            //     value == '' || value == null ? 'กรุณาเลือก' : null,
            onChanged: (dynamic newValue) {
              onChanged!(newValue);
            },
            items: data.map((item) {
              return DropdownMenuItem(
                value: item['refNo'],
                child: Text(
                  '${item['typeName']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).custom.b_W_fffd57,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (_loadingDropdownType)
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.only(right: 50),
              alignment: Alignment.centerRight,
              child: const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  static InputDecoration _decorationDropdown(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFE6B82C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
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
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        suffixIcon: const Icon(Icons.calendar_today, size: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFE6B82C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );

  static InputDecoration _decorationTime(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        suffixIcon: const Icon(Icons.access_time_rounded, size: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFE6B82C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );

  DatePickerTheme datepickerTheme = DatePickerTheme(
    containerHeight: 210.0,
    itemStyle: TextStyle(
      fontSize: 16.0,
      color: Color(0xFF53327A),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
    ),
    doneStyle: TextStyle(
      fontSize: 16.0,
      color: Color(0xFF53327A),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
    ),
    cancelStyle: TextStyle(
      fontSize: 16.0,
      color: Color(0xFF53327A),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
    ),
  );

  dynamic dialogOpenPickerDate() {
    var now = DateTime.now();
    DatePicker.showDatePicker(
      context,
      theme: datepickerTheme,
      showTitleActions: true,
      minTime:
          DateTime(now.year + 543, now.month, now.day, now.hour, now.minute),
      maxTime: DateTime(year + 1, month, day),
      onChanged: (time) {},
      onConfirm: (date) {
        int difDate = DateTime(now.year + 543, now.month, now.day)
            .compareTo(DateTime(date.year, date.month, date.day));

        TimeOfDay timeStart = TimeOfDay(hour: 00, minute: 00);
        if (txtStartTime.text.isNotEmpty) {
          timeStart = TimeOfDay(
            hour: int.parse(txtStartTime.text.substring(0, 2)),
            minute: int.parse(txtStartTime.text.substring(3, 5)),
          );
        }
        bool timeSelectMoreThenCurrent = true;
        timeSelectMoreThenCurrent = _getTime(
          TimeOfDay(hour: now.hour, minute: now.minute),
          TimeOfDay(hour: timeStart.hour, minute: timeStart.minute),
        );

        setState(
          () {
            oldDate = widget.date;
            _selectedYear = date.year;
            _selectedMonth = date.month;
            _selectedDay = date.day;
            txtDate.value = TextEditingValue(
              text: DateFormat("dd / MM / yyyy").format(date),
            );
            // reset time if time selected less then current time.
            if (!timeSelectMoreThenCurrent && difDate == 0) {
              txtStartTime.value = TextEditingValue(text: '');
              txtEndTime.value = TextEditingValue(text: '');
            }
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
        fillColor: readOnly
            ? Colors.black.withOpacity(0.2)
            : Theme.of(context).custom.w_b_b,
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

  dynamic dialogOpenPickerTime(String type) {
    var now = DateTime.now();

    TimeOfDay timeStart;
    late TimeOfDay timeEnd;

    DateTime initCurrentTime = DateTime.now();
    DatePicker.showTimePicker(
      context,
      theme: datepickerTheme,
      showTitleActions: true,
      onChanged: (date) {},
      onConfirm: (date) {
        // ----> ตรวจสอบวันที่เลือกเป็นเวลาปัจจุบันหรือไม่.
        DateTime dateSet =
            DateTime(_selectedYear, _selectedMonth, _selectedDay);
        DateTime selectedDate = DateTime(date.year + 543, date.month, date.day);
        int diffDate = -1;
        var difDate = dateSet.compareTo(selectedDate);
        if (difDate == 0) {
          diffDate = 0;
        } else if (difDate > 0) {
          diffDate = 1;
        }
        // <----

        // ตรวจสอบวันที่เลือกเป็นเวลาปัจจุบันหรือไม่.
        if (diffDate >= 0) {
          // ตรวจสอบเวลาที่เลือกไม่น้อยกว่าเวลาปัจจุบัน.
          //  + เพิ่ม 1 ซม ไหม.
          bool timeSelectMoreThenCurrent = true;
          if (diffDate == 0)
            timeSelectMoreThenCurrent = _getTime(
              TimeOfDay(hour: now.hour, minute: now.minute),
              TimeOfDay(hour: date.hour, minute: date.minute),
            );
          setState(
            () {
              bool endMoreThenStart = false;
              if (type == 'start' && timeSelectMoreThenCurrent) {
                oldStartTime = widget.startTime;
                timeStart = TimeOfDay(hour: date.hour, minute: date.minute);
                if (txtEndTime.text.isNotEmpty) {
                  timeEnd = TimeOfDay(
                    hour: int.parse(txtEndTime.text.substring(0, 2)),
                    minute: int.parse(txtEndTime.text.substring(3, 5)),
                  );
                  endMoreThenStart = _getTime(timeStart, timeEnd);
                  if (endMoreThenStart == false) {
                    txtEndTime.value = TextEditingValue(
                      text: '',
                    );
                  }
                }
                txtStartTime.value = TextEditingValue(
                  text: DateFormat("HH:mm").format(date),
                );
              } else if (type == 'end' && timeSelectMoreThenCurrent) {
                oldEndTime = widget.endTime;
                timeEnd = TimeOfDay(hour: date.hour, minute: date.minute);
                if (txtStartTime.text.isNotEmpty) {
                  timeStart = TimeOfDay(
                    hour: int.parse(txtStartTime.text.substring(0, 2)),
                    minute: int.parse(txtStartTime.text.substring(3, 5)),
                  );
                  endMoreThenStart = _getTime(timeStart, timeEnd);
                  if (endMoreThenStart == false) {
                    txtStartTime.value = TextEditingValue(
                      text: '',
                    );
                  }
                }
                txtEndTime.value = TextEditingValue(
                  text: DateFormat("HH:mm").format(date),
                );
              } else {
                Fluttertoast.showToast(msg: 'เวลาไม่ถูกต้อง');
              }
            },
          );
        } else {
          Fluttertoast.showToast(msg: 'เวลาไม่ถูกต้อง');
        }
      },
      currentTime: initCurrentTime,
      showSecondsColumn: false,
      locale: LocaleType.th,
    );
  }

  @override
  void initState() {
    title = widget.repeat ? 'ประวัติ' : title;
    title = widget.repeatCurrentDay ? 'ประวัติ' : title;

    titleSubmit = widget.edit ? 'แก้ไขการจอง' : titleSubmit;
    titleSubmit = widget.repeat ? 'จองใช้บริการ' : titleSubmit;
    titleSubmit = widget.repeatCurrentDay ? 'จองใช้บริการ' : titleSubmit;

    txtDate.text = widget.date;
    txtStartTime.text = widget.startTime;
    txtEndTime.text = widget.endTime;
    oldStartTime = widget.startTime;
    oldEndTime = widget.endTime;
    oldDate = widget.date;
    txtPhone.text = widget.phone ?? '';
    var now = DateTime.now();
    year = now.year + 543;
    month = now.month;
    day = now.day;
    _selectedYear = now.year + 543;
    _selectedMonth = now.month;
    _selectedDay = now.day;

    _model = widget.model;
    _modelBookingCategory = [];
    _modelType = [
      {
        "recordId": 99999,
        "typeName": "เลือกรูปแบบการจอง",
        "remark": null,
        "refNo": ""
      }
    ];

    super.initState();
    _callReadType();
    _callReadBookingCategory();
  }

  _callReadType() async {
    try {
      setState(() => _loadingDropdownType = true);
      final String baseUrl = 'https://dcc.onde.go.th/dcc-api';
      dynamic response =
          await Dio().get('${baseUrl}/api/masterdata/book/slotType');

      setState(() => _loadingDropdownType = false);
      setState(() {
        _modelType = [
          {
            "recordId": 99999,
            "typeName": "โปรดเลือกประเภทการจอง",
            "remark": null,
            "refNo": ""
          },
          ...response.data
        ];
      });
      // logWTF(_modelType);
    } catch (e) {
      logE(e);
      setState(() => _loadingDropdownType = false);
    }
  }

  _callReadBookingCategory() async {
    try {
      setState(() => _loadingDropdownType = true);
      Response response =
          await Dio().get('$ondeURL/api/masterdata/bookingcategories');

      setState(() => _loadingDropdownType = false);
      setState(() {
        _modelBookingCategory = response.data;
        // logWTF(_modelBookingCategory);

        _modelBookingCategory.forEach((e) {
          e['selected'] = false;
        });

        if (widget.remark != "" && widget.remark != null) {
          var remark = widget.remark ?? "";
          final split = remark.split(',');

          // logWTF(split);

          _modelBookingCategory.forEach((x) {
            split.forEach((i) {
              if (x['bookingCatId'].toString() == i.toString()) {
                x['selected'] = true;
              }
            });
          });
        }
      });
      // logWTF(_modelBookingCategory);
    } catch (e) {
      logE(e);
      setState(() => _loadingDropdownType = false);
    }
  }

  _getTime(TimeOfDay startTime, TimeOfDay endTime) {
    bool result = false;
    int startTimeInt = (startTime.hour * 60 + startTime.minute) * 60;
    int EndTimeInt = (endTime.hour * 60 + endTime.minute) * 60;

    if (EndTimeInt > startTimeInt) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  _postpone() async {
    // postpone
    try {
      if (widget.model['bookingno'] == null) {
        return;
      }
      var subDate = txtDate.text.replaceAll(' ', '').split('/');
      String yearStr = (int.parse(subDate[2]) - 543).toString();
      String tempDate = '$yearStr-${subDate[1]}-${subDate[0]}T00:00:00';
      var accessToken = await ManageStorage.read('accessToken') ?? '';
      var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';

      // ignore: unused_local_variable
      var recordId = _modelType
          .firstWhere((e) => e['refNo'] == _bookingTypeRefNo)['recordId'];

      var bookingCategory = '';
      _modelBookingCategory.forEach((e) {
        if (e['selected']) {
          if (bookingCategory.isEmpty) {
            bookingCategory = bookingCategory + e['bookingCatId'].toString();
          } else {
            bookingCategory =
                bookingCategory + ',' + e['bookingCatId'].toString();
          }
        }
      });

      var data = {
        "bookingDate": tempDate.toString(),
        "bookingNo": widget.model['bookingno'],
        "centerId": widget.model['centerId'],
        "startTime": txtStartTime.text,
        "endTime": txtEndTime.text,
        "phone": widget.phone,
        "desc": "",
        "remark": bookingCategory
      };

      setState(() => _loadingSubmit = true);
      print(data);
      // logWTF('model');
      // // ignore: unused_local_variable
      var response = await Dio().put(
        '$ondeURL/api/Booking/PostponeBooking',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      print('>>>>>>>>>>> $response');
      if (response.data['status'] == 200) {
        _sendNotification(title: 'postpone', date: tempDate);
        // logWTF(response);
        _dialogPostpone();
      }

      setState(() => _loadingSubmit = false);
    } on DioError catch (e) {
      setState(() => _loadingSubmit = false);
      print('>>>>>>345>>>>> ${e.response!}');
      Fluttertoast.showToast(msg: e.response!.data['message']);
    }
  }

  _sendNotification({required String title, required String date}) async {
    var profile = await ManageStorage.readDynamic('profileMe');
    var recordName = _modelType
            .firstWhere((e) => e['refNo'] == _bookingTypeRefNo)['typeName'] ??
        '';
    var param = {
      "bookingDate": date,
      "category": title,
      "bookingSlotType": recordName,
      "bookingno": widget.model['bookingno'].toString(),
      "centerId": widget.model['centerId'].toString(),
      "centerName": widget.model['centerName'],
      "startTime": txtStartTime.text,
      "endTime": txtEndTime.text,
      "phone": profile?['phone'] ?? '',
      "firstName": profile?['firstnameTh'] ?? '',
      "lastName": profile?['lastnameTh'] ?? '',
      "email": profile?['email'] ?? '',
      "desc": "",
      "remark": ""
    };

    try {
      logWTF(param);
      Response res = await Dio().post(
        '$server/dcc-api/m/v2/notificationbooking/create',
        data: param,
      );
      logWTF(res);
    } catch (e) {
      logE(e);
    }
  }

  _dialogPostpone() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Theme.of(context).custom.w_b_b,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              // height: 127,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/check.png',
                    width: 77.5,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'เลื่อนการจองสำเร็จ!!',
                    style: TextStyle(
                      color: Theme.of(context).custom.C19AA6A_w_fffd57,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 10),
                  Text(
                    'คุณได้เลื่อนการจองจากวันที่\n$oldDate ($oldStartTime-$oldEndTime)\nเป็นวันที่${txtDate.text} (${txtStartTime.text}-${txtEndTime.text})',
                    style: TextStyle(
                      color: Theme.of(context).custom.b_W_fffd57,
                      fontSize: 15,
                      // fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => {
                      // Navigator.of(context).pushAndRemoveUntil(
                      //   MaterialPageRoute(
                      //     builder: (context) => const Menu(),
                      //   ),
                      //   (Route<dynamic> route) => false,
                      // ),
                      Navigator.pop(context),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingServicePage(
                            catSelectedWidget: '1',
                          ),
                        ),
                      ),
                      // BookingServicePage(catSelectedWidget: '0',)._callRead()
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: Theme.of(context).custom.b325f8_w_fffd57,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ดูรายการจอง',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).custom.w_b_b,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
