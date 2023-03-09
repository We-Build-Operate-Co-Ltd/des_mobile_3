import 'package:des/booking_service_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class BookingServiceConfirmPage extends StatefulWidget {
  const BookingServiceConfirmPage({super.key});

  @override
  State<BookingServiceConfirmPage> createState() =>
      _BookingServiceConfirmPageState();
}

class _BookingServiceConfirmPageState extends State<BookingServiceConfirmPage> {
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
                  'ยืนยันข้อมูล',
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
            Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingServiceSuccessPage(),
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
                  'จองใช้บริการ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
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
              text: DateFormat("dd-MM-yyyy").format(date),
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
    super.initState();
    var now = DateTime.now();
    year = now.year + 543;
    month = now.month;
    day = now.day;
    _selectedYear = now.year + 543;
    _selectedMonth = now.month;
    _selectedDay = now.day;
  }
}
