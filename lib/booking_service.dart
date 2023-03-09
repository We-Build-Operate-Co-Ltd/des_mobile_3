import 'package:des/booking_service_detail.dart';
import 'package:des/booking_service_search_result.dart';
import 'package:des/models/mock_data.dart';
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
  TextEditingController txtStartTime = TextEditingController();
  TextEditingController txtEndTime = TextEditingController();
  int _currentPage = 0;
  dynamic modelCenter;
  dynamic modelBooking;
  dynamic modelCategory;

  String _selectedCategory = '0';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: -42,
              right: 0,
              child: Image.asset(
                'assets/images/logo_2o.png',
                fit: BoxFit.fitWidth,
                width: 290,
                alignment: Alignment.topRight,
              ),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  SizedBox(height: 20 + MediaQuery.of(context).padding.top),
                  Text(
                    'จองบริการ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
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
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BookingServiceSearchResultPage(),
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
                                'ค้นหา',
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
                  // history
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: FutureBuilder<dynamic>(
                      future: Future.value(modelCategory),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            height: 25,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, __) =>
                                  _itemCategory(snapshot.data[__]),
                              separatorBuilder: (_, __) => SizedBox(width: 10),
                              itemCount: snapshot.data!.length,
                            ),
                          );
                        }
                        return SizedBox(height: 25);
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: FutureBuilder<dynamic>(
                      future: _readData(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.separated(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 20,
                            ),
                            itemCount: snapshot.data!.length,
                            separatorBuilder: (_, __) => SizedBox(height: 15),
                            itemBuilder: (_, __) =>
                                _itemBooking(snapshot.data[__]),
                          );
                        }
                        return SizedBox();
                      },
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

  Widget _itemCategory(model) {
    return GestureDetector(
      onTap: () => setState(() {
        _selectedCategory = model['code'].toString();
      }),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: _selectedCategory == model['code']
              ? Color(0xFFB325F8)
              : Color(0xFFB325F8).withOpacity(.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          '${model['title']}',
          style: TextStyle(
            color: _selectedCategory == model['code']
                ? Colors.white
                : Color(0xFFB325F8).withOpacity(.4),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _itemBooking(model) {
    return GestureDetector(
      onTap: () {
        if (_selectedCategory == '1' && model['checkIn']) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingServiceDetailPage(
                code: model['center'],
                repeat: true,
              ),
            ),
          );
        }
        if (_selectedCategory == '0' && !model['checkIn']) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingServiceDetailPage(
                code: model['center'],
                edit: true,
              ),
            ),
          );
        }
      },
      child: Container(
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFB325F8).withOpacity(.1),
              ),
              child: Image.asset(
                'assets/images/computer.png',
                width: 17,
                color: Color(0xFF53327A),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${model['title']}',
                          style: TextStyle(
                            color: Color(0xFF7A4CB1),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Color(0xFF7A4CB1),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  if (_checkCurrentDate(model['dateTime']) == 0)
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF7A4CB1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'เช็คอิน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  if (model['checkIn'] && _selectedCategory == '1')
                    Container(
                      height: 30,
                      width: 120,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF7A4CB1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'เช็คอินแล้ว',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xFF53327A),
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        _setDate(model['dateTime']),
                        style: TextStyle(
                          color: Color(0xFF53327A),
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFF53327A),
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        _setTime(model['dateTime']),
                        style: TextStyle(
                          color: Color(0xFF53327A),
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        _setDifferentTime(model['dateTime']),
                        style: TextStyle(
                          color: Color(0xFF53327A),
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Color(0xFF707070).withOpacity(.5),
                  )
                ],
              ),
            )
          ],
        ),
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
    super.initState();
    modelCategory = MockBookingData.category();
    modelBooking = MockBookingData.booking();
    modelCenter = MockBookingData.center();
    _readData();
    var now = DateTime.now();
    year = now.year + 543;
    month = now.month;
    day = now.day;
    _selectedYear = now.year + 543;
    _selectedMonth = now.month;
    _selectedDay = now.day;
  }

  Future<List<dynamic>> _readData() async {
    bool morethan = int.parse(_selectedCategory) == 0;
    var result;
    if (morethan) {
      result = await modelBooking
          .where((dynamic e) => _checkCurrentDate(e['dateTime']!) >= 0)
          .toList();
    } else {
      result = await modelBooking
          .where((dynamic e) => _checkCurrentDate(e['dateTime']!) < 0)
          .toList();
    }
    return Future.value(result);
  }

  String _setDate(String? date) {
    if (date!.isEmpty) return '';
    String year = date.substring(0, 4);
    int yearIntTh = int.parse(year) + 543;
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    return day + '/' + month + '/' + yearIntTh.toString().substring(2, 4);
  }

  String _setTime(String? date) {
    if (date!.isEmpty) return '';
    var hr = date.substring(8, 10);
    var minute = date.substring(10, 12);
    return hr + ':' + minute + ' น.';
  }

  String _setDifferentTime(String? dateStr) {
    if (dateStr!.isNotEmpty) {
      int year = int.parse(dateStr.substring(0, 4));
      int month = int.parse(dateStr.substring(4, 6));
      int day = int.parse(dateStr.substring(6, 8));
      int hour = int.parse(dateStr.substring(8, 10));
      int minute = int.parse(dateStr.substring(10, 12));
      final date = DateTime(year, month, day);
      final now = DateTime.now();
      final currentDate = DateTime(now.year, now.month, now.day);
      final difDate = currentDate.compareTo(date);
      if (difDate == 0) {
        if (hour > DateTime.now().hour) {
          if (hour == DateTime.now().hour + 1 &&
              (minute + 60) > DateTime.now().minute)
            return ((minute + 60) - DateTime.now().minute).toString() + ' นาที';
          return (hour - DateTime.now().hour).toString() + ' ชั่วโมง';
        } else if (hour == DateTime.now().hour) {
          return (minute - DateTime.now().minute).toString() + ' นาที';
        }
      }
    }
    return '';
  }

  int _checkCurrentDate(String? dateStr) {
    if (dateStr!.isNotEmpty) {
      int year = int.parse(dateStr.substring(0, 4));
      int month = int.parse(dateStr.substring(4, 6));
      int day = int.parse(dateStr.substring(6, 8));
      int hour = int.parse(dateStr.substring(8, 10));
      // int minute = int.parse(dateStr.substring(10, 12));
      final date = DateTime(year, month, day, hour);
      final now = DateTime.now();
      final currentDate = DateTime(now.year, now.month, now.day, hour);
      final difDate = date.compareTo(currentDate);
      if (difDate == 0) {
        return 0;
      } else if (difDate > 0) {
        return 1;
      }
    }
    return -1;
  }
}
