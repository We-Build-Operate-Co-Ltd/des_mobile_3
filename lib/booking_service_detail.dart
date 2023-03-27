import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/booking_service_confirm.dart';
import 'package:des/models/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class BookingServiceDetailPage extends StatefulWidget {
  const BookingServiceDetailPage({
    super.key,
    required this.code,
    this.repeat = false,
    this.edit = false,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  final String code;
  final bool repeat;
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

  dynamic model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  widget.repeat ? 'ประวัติ' : 'รายละเอียด',
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: double.infinity,
                      height: 194,
                      child: CachedNetworkImage(
                        imageUrl: model['imageUrl'] ?? '',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  widget.repeat
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
                            '${model['count']} เครื่อง',
                            style: TextStyle(
                              color: Color(0xFFB325F8),
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
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
                    children: [
                      _itemContact(
                        image: 'assets/images/vector.png',
                        title: 'แสดงแผนที่',
                      ),
                      SizedBox(width: 50),
                      _itemContact(
                        image: 'assets/images/call_phone.png',
                        title: 'เบอร์ติดต่อ',
                      ),
                      SizedBox(width: 50),
                      _itemContact(
                        image: 'assets/images/facebook.png',
                        title: 'Facebook',
                        color: Color(0xFF227BEF),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 235,
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
              child: ListView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                  SizedBox(height: 35),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingServiceConfirmPage(
                          edit: widget.edit,
                          date: txtDate.text,
                          startTime: txtStartTime.text,
                          endTime: txtEndTime.text,
                        ),
                      ),
                    ),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFF7A4CB1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.edit ? 'แก้ไขการจอง' : 'จองใช้บริการ',
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
          )
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

  Widget _itemContact(
      {String image = '',
      String title = '',
      Color color = const Color(0xFF7A4CB1)}) {
    return Column(
      children: [
        Container(
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
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 15),
        )
      ],
    );
  }

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
    DatePicker.showDatePicker(
      context,
      theme: datepickerTheme,
      showTitleActions: true,
      minTime: DateTime(2560, 1, 1),
      maxTime: DateTime(year + 1, month, day),
      onConfirm: (date) {
        setState(
          () {
            _selectedYear = date.year;
            _selectedMonth = date.month;
            _selectedDay = date.day;
            txtDate.value = TextEditingValue(
              text: DateFormat("dd / MM / yyyy").format(date),
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

  dynamic dialogOpenPickerTime(String type) {
    DatePicker.showTimePicker(
      context,
      theme: datepickerTheme,
      showTitleActions: true,
      onChanged: (date) {},
      onConfirm: (date) {
        setState(
          () {
            if (type == 'start') {
              txtStartTime.value = TextEditingValue(
                text: DateFormat("HH:mm").format(date),
              );
            } else {
              txtEndTime.value = TextEditingValue(
                text: DateFormat("HH:mm").format(date),
              );
            }
          },
        );
      },
      currentTime: DateTime.now(),
      locale: LocaleType.th,
    );
  }

  @override
  void initState() {
    txtDate.text = widget.date;
    txtStartTime.text = widget.startTime;
    txtEndTime.text = widget.endTime;
    super.initState();
    _callRead();
    var now = DateTime.now();
    year = now.year + 543;
    month = now.month;
    day = now.day;
    _selectedYear = now.year + 543;
    _selectedMonth = now.month;
    _selectedDay = now.day;
  }

  _callRead() {
    List<dynamic> listData = MockBookingData.center();
    dynamic result = listData.firstWhere((e) => e['code'] == widget.code);
    setState(() {
      model = result;
    });
  }
}
