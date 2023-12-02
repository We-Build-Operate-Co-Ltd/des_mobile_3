import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/booking_service_repeat.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:des/booking_service_confirm.dart';
import 'package:des/models/mock_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingServiceDetailPage extends StatefulWidget {
  const BookingServiceDetailPage({
    Key? key,
    required this.model,
    this.repeat = false,
    this.repeatCurrentDay = false,
    this.edit = false,
    required this.date,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  final dynamic model;
  final bool repeat;
  final bool repeatCurrentDay;
  final bool edit;

  final String date;
  final String startTime;
  final String endTime;

  @override
  State<BookingServiceDetailPage> createState() =>
      _BookingServiceDetailPageState();
}

class _BookingServiceDetailPageState extends State<BookingServiceDetailPage> {
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

  dynamic _model;
  String title = 'รายละเอียด';
  String titleSubmit = 'จองใช้บริการ';
  String _bookingTypeRefNo = '';
  late List<dynamic> _modelType;
  bool _loadingDropdownType = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              _backButton(context),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            right: 0,
            child: Image.asset(
              'assets/images/logo_2o.png',
              width: 290,
            ),
          ),
          Positioned.fill(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 194,
                    child: CachedNetworkImage(
                      imageUrl: _model['imageUrl'] ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  '${_model?['centerName'] ?? '-'}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: widget.repeat
                      ? Container(
                          width: 153,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: Color(0xFF707070),
                                size: 15,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'ใช้บริการล่าสุดเมื่อ 15/01/66',
                                style: TextStyle(
                                  color: Color(0xFF707070),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color(0xFFB325F8).withOpacity(.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${_model['slotCount']} เครื่อง',
                            style: TextStyle(
                              color: Color(0xFFB325F8),
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 20),
                Text(
                  'การติดต่อ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _itemContact(
                      image: 'assets/images/vector.png',
                      title: 'แสดงแผนที่',
                    ),
                    _itemContact(
                      image: 'assets/images/call_phone.png',
                      title: 'เบอร์ติดต่อ',
                      onTap: () async {
                        launchUrl(
                          Uri(scheme: 'tel', path: _model?['centerTel'] ?? ''),
                        );
                      },
                    ),
                    _itemContact(
                      image: 'assets/images/facebook.png',
                      title: 'Facebook',
                      color: Color(0xFF227BEF),
                      onTap: () async {
                        launchUrl(
                          Uri.parse(_model?['centerFacebook'] ?? ''),
                        );
                      },
                    )
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  _model['centerAdd'],
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                _buildWhiteSpace(),
              ],
            ),
          ),
          _buildSubmitContainer(),
        ],
      ),
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

  Widget _itemContact({
    String image = '',
    String title = '',
    Color color = const Color(0xFF7A4CB1),
    Function()? onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap!(),
          child: Container(
            height: 45,
            width: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Image.asset(
              image,
              height: 23,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 15),
        )
      ],
    );
  }

  Widget _buildSubmitContainer() {
    if (widget.repeatCurrentDay)
      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 38, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 6,
                offset: Offset(1, 0),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingServiceRepeatPage(
                    model: widget.model,
                    date: txtDate.text,
                    startTime: txtStartTime.text,
                    endTime: txtEndTime.text,
                  ),
                ),
              );
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xFF7A4CB1),
                borderRadius: BorderRadius.circular(25),
              ),
              alignment: Alignment.center,
              child: Text(
                'จองซ้ำ',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    else
      return Positioned(
        left: 0,
        right: 0,
        bottom: MediaQuery.of(context).padding.bottom,
        child: Container(
          height: 296,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 6,
                offset: Offset(1, 0),
              ),
            ],
          ),
          child: Column(
            // physics: ClampingScrollPhysics(),
            children: [
              GestureDetector(
                onTap: () => dialogOpenPickerDate(),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: txtDate,
                    style: const TextStyle(
                      color: Color(0xFF7A4CB1),
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 15.0,
                    ),
                    decoration: _decorationDate(
                      context,
                      hintText: 'วันใช้บริการ',
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
                          style: const TextStyle(
                            color: Color(0xFF7A4CB1),
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
                          style: const TextStyle(
                            color: Color(0xFF7A4CB1),
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
              Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  if (txtDate.text.isEmpty ||
                      txtStartTime.text.isEmpty ||
                      txtEndTime.text.isEmpty) {
                    Fluttertoast.showToast(msg: 'เลือกวันเวลาที่ต้องการจอง');
                  } else {
                    logWTF(widget.model['centerId']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingServiceConfirmPage(
                          centerId: widget.model['centerId'],
                          edit: widget.edit,
                          date: txtDate.text,
                          startTime: txtStartTime.text,
                          endTime: txtEndTime.text,
                          bookingTypeRefNo: _bookingTypeRefNo,
                          bookingno: widget.model?['bookingno'] ?? 0,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFF7A4CB1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    titleSubmit,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }

  Widget _buildWhiteSpace() {
    double height = 245 + MediaQuery.of(context).padding.bottom;
    if (widget.repeatCurrentDay) {
      height = 95 + MediaQuery.of(context).padding.bottom;
    }
    return SizedBox(
      height: height,
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
    var now = DateTime.now();
    year = now.year + 543;
    month = now.month;
    day = now.day;
    _selectedYear = now.year + 543;
    _selectedMonth = now.month;
    _selectedDay = now.day;

    _model = widget.model;
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
  }

  _callReadType() async {
    try {
      setState(() => _loadingDropdownType = true);
      final String baseUrl = 'http://dcc-portal.webview.co/dcc-api';
      dynamic response =
          await Dio().get('${baseUrl}/api/masterdata/book/slotType');

      setState(() => _loadingDropdownType = false);
      setState(() {
        _modelType = [
          {
            "recordId": 99999,
            "typeName": "เลือกรูปแบบการจอง",
            "remark": null,
            "refNo": ""
          },
          ...response.data
        ];
      });
      logWTF(_modelType);
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
}
