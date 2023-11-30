import 'dart:convert';

import 'package:des/booking_service_success.dart';
import 'package:des/menu.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BookingServiceConfirmPage extends StatefulWidget {
  const BookingServiceConfirmPage({
    super.key,
    this.repeat = false,
    this.edit = false,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.centerId,
    required this.bookingSlotType,
  });

  final bool repeat;
  final bool edit;

  final String date;
  final String startTime;
  final String endTime;
  final String centerId;
  final String bookingSlotType;

  @override
  State<BookingServiceConfirmPage> createState() =>
      _BookingServiceConfirmPageState();
}

class _BookingServiceConfirmPageState extends State<BookingServiceConfirmPage> {
  DateTime selectedDate = DateTime.now();
  int year = 0;
  int month = 0;
  int day = 0;
  int age = 0;
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  String title = 'ยืนยันข้อมูล';
  String _bookingSlotType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _startTimeController,
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
                    onTap: () {},
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _endTimeController,
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
            GestureDetector(
              onTap: () {},
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateTimeController,
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
            _dropdown(
              data: [
                {
                  'key': '',
                  'value': 'เลือกรูปแบบการจอง',
                }
              ],
              value: '',
              onChanged: (String value) {
                setState(() {
                  _bookingSlotType = value;
                });
              },
            ),
            Expanded(child: SizedBox()),
            widget.edit ? _btnEdit() : _btnConfirm(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _btnConfirm() {
    return GestureDetector(
      onTap: () async => _send(),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xFF7A4CB1),
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          'จองใช้บริการ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _btnEdit() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => WillPopScope(
                onWillPop: () => Future.value(false),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: 127,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'เลื่อนจองสำเร็จ',
                            style: TextStyle(
                              color: Color(0xFF7A4CB1),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'ทำการเลื่อนการจองใช้บริการเรียบร้อย',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const Menu(),
                              ),
                              (Route<dynamic> route) => false,
                            ),
                            child: Container(
                              height: 40,
                              width: 95,
                              decoration: BoxDecoration(
                                color: Color(0xFF7A4CB1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'ตกลง',
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
                  ),
                ),
              ),
            ),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF7A4CB1),
                borderRadius: BorderRadius.circular(25),
              ),
              alignment: Alignment.center,
              child: Text(
                'เลื่อนจอง',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
            child: GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 127,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Text(
                        'ยกเลิกการจอง',
                        style: TextStyle(
                          color: Color(0xFF7A4CB1),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'ท่านยืนยันที่จะทำการยกเลิกการจองใช้บริการในวันที่ 31/03/66 ใช่หรือไม่',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFF7A4CB1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'ย้อนกลับ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const Menu(),
                                ),
                                (Route<dynamic> route) => false,
                              ),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFF707070),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'ยืนยัน',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              'ยกเลิก',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ))
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

  _dropdown({
    required List<dynamic> data,
    required String value,
    Function(String)? onChanged,
  }) {
    return Container(
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
            value: item['key'],
            child: Text(
              '${item['value']}',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).custom.b_W_fffd57,
              ),
            ),
          );
        }).toList(),
      ),
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

  @override
  void initState() {
    title = widget.edit ? 'ข้อมูลการจอง' : title;

    _dateTimeController.text = widget.date;
    _startTimeController.text = widget.startTime;
    _endTimeController.text = widget.endTime;
    var now = DateTime.now();
    year = now.year + 543;
    month = now.month;
    day = now.day;
    super.initState();
  }

  _send() async {
    try {
      var subDate = _dateTimeController.text.replaceAll(' ', '').split('/');
      String yearStr = (int.parse(subDate[2]) - 543).toString();
      String tempDate = '$yearStr-${subDate[1]}-${subDate[0]}T00:00:00';

      logWTF(tempDate);
      var value = await ManageStorage.read('profileData') ?? '';
      var profileData = json.decode(value);
      var data = {
        "bookingDate": tempDate,
        "bookingSlotType": "2",
        "centerId": widget.centerId,
        "endTime": _startTimeController.text,
        "startTime": _endTimeController.text,
        "userid": profileData['code'],
        "phone": profileData['phone'],
        "desc": "",
        "remark": ""
      };
      logWTF(data);

      final String baseUrl = 'https://dcc-portal.webview.co/dcc-api';
      dynamic response =
          await Dio().get('${baseUrl}/api/Booking/Booking/mobile');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingServiceSuccessPage(),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
