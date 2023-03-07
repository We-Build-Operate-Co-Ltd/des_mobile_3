import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class BookingServicePage extends StatefulWidget {
  const BookingServicePage({super.key});

  @override
  State<BookingServicePage> createState() => _BookingServicePageState();
}

class _BookingServicePageState extends State<BookingServicePage> {
  DateTime selectedDate = DateTime.now();
  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  int age = 0;
  TextEditingController txtDate = TextEditingController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: -30,
              right: 0,
              child: Image.asset(
                'assets/images/logo_2o.png',
                fit: BoxFit.fitWidth,
                width: 290,
                alignment: Alignment.topRight,
              ),
            ),
            Positioned.fill(
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      _backButton(context),
                      Expanded(
                        child: Text(
                          'จองบริการ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 60),
                    ],
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _currentPage = 0;
                                  }),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _currentPage == 0
                                          ? Color(0xFF7A4CB1)
                                          : Color(0xFFDDDDDD),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'จองใช้บริการ',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _currentPage = 1;
                                  }),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _currentPage == 1
                                          ? Color(0xFF7A4CB1)
                                          : Color(0xFFDDDDDD),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'เลือกศูนย์ฯ',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          if (_currentPage == 0) ..._pageOne(),
                          if (_currentPage == 1) ..._pageTwo(),
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Color(0xFF7A4CB1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'ค้นหา',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _pageOne() {
    return <Widget>[
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
          )
        ],
      ),
      SizedBox(height: 15),
      SizedBox(
        height: 35,
        child: TextFormField(
          decoration: _decorationSearch(
            context,
            hintText: 'สถานที่',
          ),
        ),
      ),
      SizedBox(height: 65),
    ];
  }

  List<Widget> _pageTwo() {
    return <Widget>[
      SizedBox(
        height: 35,
        child: TextFormField(
          decoration: _decorationSearch(
            context,
            hintText: 'สถานที่',
          ),
        ),
      ),
      SizedBox(height: 15),
      Text(
        'ศูนย์ฯ ใกล้ฉัน',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Image.asset('assets/images/vector.png', height: 15),
          SizedBox(width: 10),
          Text(
            'ศูนย์ฯ จังหวัดนนทบุรี',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Image.asset('assets/images/vector.png', height: 15),
          SizedBox(width: 10),
          Text(
            'ศูนย์ฯ อำเภอเมืองนนทบุรี',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      SizedBox(height: 50),
    ];
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

  static InputDecoration _decorationSearch(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: Container(
          padding: EdgeInsets.all(9),
          child: Image.asset(
            'assets/images/search.png',
            color: Color(0xFF707070),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(15.0, 2.0, 2.0, 2.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
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

  dynamic dialogOpenPickerDate() {
    DatePicker.showDatePicker(
      context,
      theme: const DatePickerTheme(
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
}
