import 'package:des/booking_service_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BookingServiceRepeatPage extends StatefulWidget {
  const BookingServiceRepeatPage({
    super.key,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  final String date;
  final String startTime;
  final String endTime;

  @override
  State<BookingServiceRepeatPage> createState() =>
      _BookingServiceRepeatPageState();
}

class _BookingServiceRepeatPageState extends State<BookingServiceRepeatPage> {
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

  String title = 'จองใช้บริการ';

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
            _btnConfirm(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _btnConfirm() {
    return GestureDetector(
      onTap: () {
        if (txtDate.text.isEmpty ||
            txtStartTime.text.isEmpty ||
            txtEndTime.text.isEmpty) {
          Fluttertoast.showToast(msg: 'เลือกวันเวลาที่ต้องการจอง');
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingServiceConfirmPage(
                date: txtDate.text,
                startTime: txtStartTime.text,
                endTime: txtEndTime.text,
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
    super.initState();
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
