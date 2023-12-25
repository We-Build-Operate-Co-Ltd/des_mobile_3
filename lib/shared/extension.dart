import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';

unfocus(context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

String getRandomString({int length = 10}) {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))),
  );
}

// convert html to string
parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}

moneyFormat(String price) {
  if (price.length > 2) {
    var value = price;
    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    return value;
  }
}

String checkSalary(start, end) {
  var formatCompact = NumberFormat.compact();
  if (start == end) {
    return formatCompact.format(start);
  } else {
    return formatCompact.format(start) + ' - ' + formatCompact.format(end);
  }
}

String checkSalaryNoNumber(start, end) {
  if (start == end) {
    return start;
  } else {
    return start + ' - ' + end;
  }
}

dateStringToDate(String date, {String separate = '-'}) {
  if (date == 'null') return '';
  if (date == '') {
    return '-';
  } else {
    var year = date.substring(0, 4);
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
    // var onlyBuddhistYear = todayDate.yearInBuddhistCalendar;
    // var formatter = DateFormat.yMMMMd();
    // var dateInBuddhistCalendarFormat =
    //     formatter.formatInBuddhistCalendarThai(todayDate);
    return day + separate + month + separate + year;
  }
}

dateStringToDateBirthDay(String date) {
  var year = date.substring(0, 4);
  var month = date.substring(4, 6);
  var day = date.substring(6, 8);
  DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);

  return (todayDate);
}

dateStringToDateStringFormat(String date, {String type = '/'}) {
  String result = '';
  if (date != '') {
    String yearString = date.substring(0, 4);
    var yearInt = int.parse(yearString);
    var year = yearInt + 543;
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    result = day + type + month + type + year.toString();
  }

  return result;
}

dateStringToDateStringFormatDot(String date, {String type = '.'}) {
  String result = '';
  if (date != '') {
    String yearString = date.substring(0, 4);
    var yearInt = int.parse(yearString);
    var year = yearInt + 543;
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    result = day + type + month + type + year.toString();
  }

  return result;
}

differenceCurrentDate(String date) {
  String result = '';
  if (date != '') {
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));
    final birthday = DateTime(year, month, day);
    final currentDate = DateTime.now();
    final difDate = currentDate.difference(birthday).inDays;

    if (difDate == 0) {
      result = 'วันนี้';
    } else if (difDate < 7) {
      result = difDate.toString() + ' วันก่อน';
    } else if (difDate < 30) {
      result = (difDate / 7).round().toString() + ' อาทิตย์ก่อน';
    } else if (difDate < 365) {
      result = (difDate / 30).round().toString() + ' เดือนก่อน';
    } else {
      result = (difDate / 365).round().toString() + ' ปีที่แล้ว';
    }
  }
  return result;
}

image64(param) {
  List<int> bytesList = base64.decode(param);
  return bytesList;
}

timeString(String time) {
  var hh = time.substring(0, 2);
  var mm = time.substring(3, 5);
  return hh + '.' + mm;
}

dateStringToDateStringFormatV2(String date, {String type = '/'}) {
  String result = '';
  if (date != '') {
    String yearString = date.substring(0, 4);
    var yearInt = int.parse(yearString);
    var year = yearInt + 543;
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    var monthTH = "";
    if (month == "01")
      monthTH = "ม.ค.";
    else if (month == "02")
      monthTH = "ก.พ.";
    else if (month == "03")
      monthTH = "มี.ค.";
    else if (month == "04")
      monthTH = "เม.ย.";
    else if (month == "05")
      monthTH = "พ.ค.";
    else if (month == "06")
      monthTH = "มิ.ย.";
    else if (month == "07")
      monthTH = "ก.ค.";
    else if (month == "08")
      monthTH = "ส.ค.";
    else if (month == "09")
      monthTH = "ก.ย.";
    else if (month == "10")
      monthTH = "ต.ค.";
    else if (month == "11")
      monthTH = "พ.ย.";
    else if (month == "12") monthTH = "ธ.ค.";

    result = day + ' ' + monthTH;
  }

  return result;
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

launchURL(String url) async {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

logD(dynamic model) {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  return logger.d(model);
}

logWTF(dynamic model) {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  return logger.wtf(model);
}

logE(dynamic model) {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  return logger.e(model);
}

class InputFormatTemple {
  static username() => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z.]')),
      ];
  static name() => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z .]')),
      ];
  static password() => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z@!_.]')),
        LengthLimitingTextInputFormatter(20),
      ];
  static phone() => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(10),
      ];

  static otp() => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(1),
      ];
  static email() => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z@!_.-]')),
      ];
  static idcard() => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(13),
      ];
  static laserid() => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
        LengthLimitingTextInputFormatter(12),
      ];
}

class ValidateForm {
  static const emptyText = '**ช่องนี้ไม่สามารถเว้นว่างได้';
  static empty(String value) {
    if (value.isEmpty) {
      return 'กรุณากรอกข้อมูล ';
    }

    if (value.length < 3) {
      return 'short ';
    } else {
      return null;
    }
  }

  static firstName(String value) {
    if (value.isEmpty) {
      return emptyText;
    }
    return null;
  }

  static lastName(String value) {
    if (value.isEmpty) {
      return emptyText;
    }
    return null;
  }

  static phone(String value) {
    if (value.isEmpty) {
      return emptyText;
    }
    return null;
  }

  static email(String value) {
    if (value.isEmpty) {
      return emptyText;
    }
    if (!value.isValidEmail()) {
      return '**ตรวจสอบรูปแบบอีเมล';
    }
    return null;
  }

  static username(String value) {
    if (value.isEmpty) {
      return emptyText;
    }
    return null;
  }

  static password(String value) {
    if (value.isEmpty) {
      return emptyText;
    }
    if (value.length < 6) {
      return '**รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร';
    }
    return null;
  }

  static confirmPassword(String value, String password) {
    if (value.isEmpty) {
      return emptyText;
    }
    if (value != password) {
      return '**รหัสผ่านไม่ตรงกัน';
    }
    return null;
  }

  static occupation(int value) {
    if (value == 0 || value == null) {
      return '**กรุณาเลือกอาชีพ';
    }
    return null;
  }

  static String idcard(String? value) {
    if (value!.isEmpty) {
      return 'กรุณากรอกเลขที่บัตรประชาชน.';
    }

    String pattern = r'(^[0-9]\d{12}$)';
    RegExp regex = RegExp(pattern);

    if (regex.hasMatch(value)) {
      if (value.length != 13) {
        return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
      } else {
        var sum = 0.0;
        for (var i = 0; i < 12; i++) {
          sum += double.parse(value[i]) * (13 - i);
        }
        if ((11 - (sum % 11)) % 10 != double.parse(value[12])) {
          return 'กรุณากรอกเลขบัตรประชาชนให้ถูกต้อง';
        } else {
          return '';
        }
      }
    }
    return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
  }
}

// List<Identity> toListModel(List<dynamic> model) {
//   var list = new List<Identity>();
//   model.forEach((element) {
//     var m = new Identity();
//     m.code = element['code'] != null ? element['code'] : '';
//     m.title = element['title'] != null ? element['title'] : '';
//     m.description =
//         element['description'] != null ? element['description'] : '';
//     m.imageUrl = element['imageUrl'] != null ? element['imageUrl'] : '';
//     m.createBy = element['createBy'] != null ? element['createBy'] : '';
//     m.createDate = element['createDate'] != null ? element['createDate'] : '';
//     m.imageUrlCreateBy = element['imageUrlCreateBy'] != null ? element['imageUrlCreateBy'] : '';
//     list.add(m);
//   });

//   return list;
// }

// Identity toModel(dynamic model) {
//   var m = new Identity();
//   m.code = model['code'] != null ? model['code'] : '';
//   m.title = model['title'] != null ? model['title'] : '';
//   m.description = model['description'] != null ? model['description'] : '';
//   m.imageUrl = model['imageUrl'] != null ? model['imageUrl'] : '';
//   m.createBy = model['createBy'] != null ? model['createBy'] : '';
//   m.createDate = model['createDate'] != null ? model['createDate'] : '';
//   m.imageUrlCreateBy = model['imageUrlCreateBy'] != null ? model['imageUrlCreateBy'] : '';

//   return m;
// }
