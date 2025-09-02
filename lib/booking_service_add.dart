import 'dart:convert';

import 'package:des/booking_service.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dtpp;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:des/booking_service_confirm.dart';

import 'main.dart';

class BookingServiceAddPage extends StatefulWidget {
  const BookingServiceAddPage({
    Key? key,
    required this.model,
    required this.mode,
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
  final String mode;
  final bool repeat;
  final bool repeatCurrentDay;
  final bool edit;

  final String date;
  final String startTime;
  final String endTime;
  final String? phone;
  final String? remark;

  @override
  State<BookingServiceAddPage> createState() => _BookingServiceAddPageState();
}

class _BookingServiceAddPageState extends State<BookingServiceAddPage> {
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
  TextEditingController txtOther = TextEditingController();
  late List<dynamic> _modelBookingCategory;
  late List<dynamic> _modelBookingSubCategory;

  dynamic _model;
  String title = 'จองศูนย์';
  String titleSubmit = 'จองใช้บริการ';
  String _bookingTypeRefNo = '';
  int _selectSubCategory = 99999;
  String _bookingTypeTitle = '';
  late List<dynamic> _modelType;
  bool _loadingDropdownType = false;
  bool _loadingSubmit = false;
  int stepValue = 1;

  List<dynamic> titleList = [
    {"title": "ขั้นที่ 1 เลือกศูนย์ดิจิทัลชุมชน\nที่ต้องการจอง", "value": 1},
    {
      "title": "ขั้นที่ 2 เลือกวันเวลาที่ใช้บริการ\nและรูปแบบการจอง",
      "value": 2
    },
    {"title": "ขั้นที่ 3 ยืนยันข้อมูลการจอง", "value": 3},
  ];

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
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).custom.b325f8_w_fffd57,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildStep(),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: _detailContent(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget backWidget(title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (stepValue == 1) {
              Navigator.pop(context);
            } else if (stepValue > 1) {
              setState(() {
                stepValue--;
              });
            }
          },
          child: Image.asset(
            // 'assets/images/back_arrow.png',
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
          title,
          style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontWeight: FontWeight.w500),
        )),
      ],
    );
  }

  Widget _buildStep() {
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < titleList.length; i++)
              Expanded(
                  child: Padding(
                padding: i == 0
                    ? EdgeInsets.only(right: 4.0, left: 2.0)
                    : EdgeInsets.symmetric(horizontal: 4.0),
                child: stepWizardWidget(
                    stepValue >= titleList[i]['value'] ? true : false),
              )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        backWidget(titleList[stepValue - 1]['title'])
      ],
    );
  }

  Widget stepWizardWidget(active) {
    return Container(
      height: 10,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: active
              ? Theme.of(context).custom.b325f8_w_fffd57
              : Theme.of(context).custom.DDDDDD_b_b,
          border: Border.all(
            color: active
                ? Theme.of(context).custom.b325f8_w_fffd57
                : Theme.of(context).custom.DDD_w_fffd57,
          )),
    );
  }

  _detailContent() {
    return Stack(
      children: [
        if (stepValue == 1)
          Stack(
            children: [
              SizedBox(
                height: double.infinity,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.mode == '1'
                        ? MyApp.themeNotifier.value == ThemeModeThird.light
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: (widget.model['photoBase64'] ?? '') != ''
                                    ? Image.memory(
                                        base64Decode(
                                            widget.model['photoBase64']),
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/banner_mock.jpg',
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                    Colors.grey, BlendMode.saturation),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child:
                                      (widget.model['photoBase64'] ?? '') != ''
                                          ? Image.memory(
                                              base64Decode(
                                                  widget.model['photoBase64']),
                                              height: 180,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/banner_mock.jpg',
                                              height: 180,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                ),
                              )
                        : MyApp.themeNotifier.value == ThemeModeThird.light
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: (widget.model['photo'] ?? '') != ''
                                    ? Image.memory(
                                        base64Decode(widget.model['photo']),
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/banner_mock.jpg',
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                    Colors.grey, BlendMode.saturation),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: (widget.model['photo'] ?? '') != ''
                                      ? Image.memory(
                                          base64Decode(widget.model['photo']),
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/banner_mock.jpg',
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                    SizedBox(height: 16),
                    textForm(
                      label: 'คุณกำลังจอง:',
                      detail:
                          '${widget.mode == '1' ? (widget.model['centerName'] ?? '') : (widget.model['center_Name'] ?? '')}',
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              // const Spacer(),
              Positioned(
                bottom: 0,
                child: Container(
                  // alignment: Alignment.center,
                  // height: 60,
                  width: MediaQuery.of(context).size.width - (24 * 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        stepValue = 2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: Theme.of(context).custom.b325f8_w_fffd57,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ถัดไป',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).custom.w_b_b,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (stepValue == 2)
          Stack(
            children: [
              _buildBookingForm(),
              // const Spacer(),
              Positioned(
                bottom: 0,
                child: Container(
                  // alignment: Alignment.center,
                  // height: 60,
                  width: MediaQuery.of(context).size.width - (24 * 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: GestureDetector(
                    // onTap: () async {
                    //   setState(() {
                    //     stepValue = 3;
                    //   });
                    // },
                    onTap: () {
                      if (txtDate.text.isEmpty ||
                          txtStartTime.text.isEmpty ||
                          txtEndTime.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'เลือกวันเวลาที่ต้องการจอง');
                      } else {
                        if (_bookingTypeRefNo.isEmpty && !widget.edit) {
                          Fluttertoast.showToast(msg: 'เลือกรูปแบบการจอง');
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
                        setState(() {
                          stepValue = 3;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: Theme.of(context).custom.b325f8_w_fffd57,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ถัดไป',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).custom.w_b_b,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (stepValue == 3)
          Stack(
            children: [
              SizedBox(
                height: double.infinity,
                child: ListView(
                  shrinkWrap: false,
                  padding: EdgeInsets.zero,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textForm2(
                      label: 'ศูนย์ดิจิทัลชุมชนที่จอง',
                      detail:
                          '${widget.mode == '1' ? (widget.model['centerName'] ?? '') : (widget.model['center_Name'] ?? '')}',
                    ),
                    SizedBox(height: 16),
                    textForm2(label: 'วันที่ใช้บริการ', detail: txtDate.text),
                    SizedBox(height: 16),
                    textForm2(
                        label: 'เวลาที่จอง',
                        detail: '${txtStartTime.text} - ${txtEndTime.text} น.'),
                    SizedBox(height: 16),
                    textForm2(label: 'รูปแบบการจอง', detail: _bookingTypeTitle
                        // detail: widget.model.toString()
                        ),
                  ],
                ),
              ),
              // const Spacer(),
              Positioned(
                bottom: 0,
                child: Container(
                  // alignment: Alignment.center,
                  // height: 60,
                  width: MediaQuery.of(context).size.width - (24 * 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        // stepValue = 2;
                        _send();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: Theme.of(context).custom.b325f8_w_fffd57,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ยืนยัน',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).custom.w_b_b,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
              child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  color: Theme.of(context).custom.b325f8_w_fffd57,
                ),
              ),
            ),
          ),
      ],
    );
  }

  _dialogCancelBooking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              // height: 127,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/warning.png',
                    width: 77.5,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'ยกเลิกการจอง',
                    style: TextStyle(
                      color: Theme.of(context).custom.b_w_y,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'คุณยืนยันที่จะยกเลิกการจองในวันที่\n${widget.date.split(' ').join()} (${widget.model['startTime']}-${widget.model['endTime']} น.) ใช่หรือไม่',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).custom.b_w_y,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _cancelBooking();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: Theme.of(context).custom.b325f8_w_fffd57,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'ยืนยัน',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).custom.w_b_b,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Theme.of(context)
                                  .custom
                                  .b325f8_w_fffd57_OVF50,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'ย้อนกลับ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                              fontWeight: FontWeight.w500,
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
        );
      },
    );
  }

  _dialogCancelSuccess() {
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
                children: [
                  Image.asset(
                    'assets/images/check.png',
                    width: 77.5,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'จองสำเร็จ!',
                    style: TextStyle(
                      color: Theme.of(context).custom.C19AA6A_w_fffd57,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'โปรดมาก่อนเวลา 10 นาทีเพื่อทำการเช็คอิน',
                    style: TextStyle(
                      color: Theme.of(context).custom.b_W_fffd57,
                      fontSize: 15,
                      // fontWeight: FontWeight.w500,
                    ),
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
                      print('---------------catSelectedWidget-----------------')
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

  _cancelBooking() async {
    // cancel
    try {
      if (widget.model['bookingno'] == null) {
        return;
      }
      setState(() => _loadingSubmit = true);
      final String baseUrl = 'https://dcc.onde.go.th/dcc-api';
      var response = await Dio().put(
          '${baseUrl}/api/Booking/Cancel?bookingNo=${widget.model['bookingno']}');
      setState(() => _loadingSubmit = false);

      if (response.data['success']) {
        _dialogCancelSuccess();
      } else {
        Fluttertoast.showToast(msg: response.data['errorMessage']);
      }
    } on DioError catch (e) {
      setState(() => _loadingSubmit = false);
      var err = e.toString();
      if (e.response!.statusCode != 200) {
        err = e.response!.data['message'];
      }
      Fluttertoast.showToast(msg: err);
    }
  }

  _buildBookingForm() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 100),
      children: [
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => dialogOpenPickerDate(),
          child: AbsorbPointer(
            child: TextFormField(
              controller: txtDate,
              style: TextStyle(
                color: Theme.of(context).custom.b325f8_w_fffd57,
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
                  return 'กรุณากรอกวันที่ใช้บริการ';
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
                      color: Theme.of(context).custom.b325f8_w_fffd57,
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
                      color: Theme.of(context).custom.b325f8_w_fffd57,
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
            color: Theme.of(context).custom.b325f8_w_fffd57,
          ),
          cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF7A4CB1)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.black
                  : Color(0xFFFFFD57),
        ),
        SizedBox(height: 15),
        if (!widget.edit)
          _dropdown(
            data: _modelType,
            value: _bookingTypeRefNo,
            id: 'refNo',
            name: 'typeName',
            onChanged: (dynamic value) {
              setState(() {
                _bookingTypeRefNo = value;
                _bookingTypeTitle = _modelType
                    .firstWhereOrNull((e) => e['refNo'] == value)['typeName'];
                print(
                    '--------------_bookingTypeRefNo--------------------> ${_bookingTypeRefNo}');
                print(
                    '--------------_bookingTypeTitle--------------------> ${_bookingTypeTitle}');
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
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFBD4BF7)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildBookingCategory(),
      ],
    );
  }

  Widget textForm({label, detail}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toString(),
          style: TextStyle(
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 3),
        Text(
          detail.toString(),
          style: TextStyle(
            color: Theme.of(context).custom.b_w_y,
            fontSize: 15,
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget textForm2({label, detail}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toString(),
          style: TextStyle(
            color: Theme.of(context).custom.f70f70_w_fffd57,
            fontSize: 13,
          ),
        ),
        SizedBox(height: 3),
        Text(
          detail.toString(),
          style: TextStyle(
              color: Theme.of(context).custom.b_W_fffd57,
              fontSize: 15,
              fontWeight: FontWeight.w500),
          maxLines: 3,
        ),
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
              // logWTF(widget.model);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => BookingServiceRepeatPage(
              //       model: widget.model,
              //       date: txtDate.text,
              //       startTime: txtStartTime.text,
              //       endTime: txtEndTime.text,
              //     ),
              //   ),
              // );
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
            height: 350,
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
            child: ListView(
              shrinkWrap: true,
              children: [
                GestureDetector(
                  onTap: () => dialogOpenPickerDate(),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: txtDate,
                      style: TextStyle(
                        color: Theme.of(context).custom.b325f8_w_fffd57,
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
                              color: Theme.of(context).custom.b325f8_w_fffd57,
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
                              color: Theme.of(context).custom.b325f8_w_fffd57,
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
                    color: Theme.of(context).custom.b325f8_w_fffd57,
                  ),
                  cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFF7A4CB1)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.black
                          : Color(0xFFFFFD57),
                ),
                SizedBox(height: 15),
                if (!widget.edit)
                  _dropdown(
                    data: _modelType,
                    value: _bookingTypeRefNo,
                    id: 'refNo',
                    name: 'typeName',
                    onChanged: (dynamic value) {
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
                    ),
                  ),
                ),
                SizedBox(height: 10),
                _buildBookingCategory(),
                SizedBox(height: 10),
                Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    if (txtDate.text.isEmpty ||
                        txtStartTime.text.isEmpty ||
                        txtEndTime.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'เลือกวันเวลาที่ต้องการจอง');
                    } else {
                      if (_bookingTypeRefNo.isEmpty && !widget.edit) {
                        Fluttertoast.showToast(msg: 'เลือกรูปแบบการจอง');
                        return;
                      }

                      int bookingNo = 0;
                      if (widget.edit) {
                        bookingNo = widget.model?['bookingno'] ?? 0;
                      }

                      if (widget.repeat) {
                        bookingNo = 0;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingServiceConfirmPage(
                            centerId: widget.model['centerId'],
                            centerName: widget.model['centerName'],
                            edit: widget.edit,
                            date: txtDate.text,
                            startTime: txtStartTime.text,
                            endTime: txtEndTime.text,
                            bookingTypeRefNo: _bookingTypeRefNo,
                            bookingno: bookingNo,
                            phone: txtPhone.text,
                            remark: _modelBookingCategory,
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
            )),
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
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
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
                              ? MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Color(0xFFBD4BF7)
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57)
                              : MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.white
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
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
                  ),
                ],
              ),

              // อื่นๆ
              SizedBox(height: 6),
              _modelBookingCategory[__]['selected'] == true &&
                      _modelBookingCategory[__]['bookingCatId'] == 8
                  ? TextFormField(
                      controller: txtOther,
                      decoration: _decorationBase(context, hintText: 'ระบุเอง'),
                      style: TextStyle(
                        color: Theme.of(context).custom.b325f8_w_fffd57,
                      ),
                      cursorColor:
                          MyApp.themeNotifier.value == ThemeModeThird.light
                              ? Color(0xFF7A4CB1)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.black
                                  : Color(0xFFFFFD57),
                    )
                  : SizedBox(),

              // อบรม
              _modelBookingCategory[__]['selected'] == true &&
                      _modelBookingCategory[__]['bookingCatId'] == 3
                  ? _dropdown(
                      data: _modelBookingSubCategory,
                      value: _selectSubCategory,
                      id: 'bookingSubcatId',
                      name: 'subcatNameTh',
                      onChanged: (dynamic newValue) {
                        setState(() {
                          _selectSubCategory = newValue;

                          print(
                              '-------------------------> Selected SubCategory: $_selectSubCategory');
                        });
                      },
                    )
                  // ? Text('${_modelBookingSubCategory}')
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _dropdown({
    required List<dynamic> data,
    required dynamic value,
    required String id,
    required String name,
    required Function(dynamic) onChanged,
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
              onChanged(newValue);
            },
            items: data.map((item) {
              return DropdownMenuItem(
                value: item[id],
                child: Text(
                  '${item[name]}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).custom.b325f8_w_fffd57,
                    fontFamily: 'Kanit',
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
          borderSide: BorderSide(
            color: Theme.of(context).custom.b325f8_w_fffd57,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Theme.of(context).custom.b325f8_w_fffd57,
          ),
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
          borderSide: BorderSide(
            color: Theme.of(context).custom.b325f8_w_fffd57,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Theme.of(context).custom.b325f8_w_fffd57,
          ),
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
          borderSide: BorderSide(
            color: Theme.of(context).custom.b325f8_w_fffd57,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Theme.of(context).custom.b325f8_w_fffd57,
          ),
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

  dtpp.DatePickerTheme datepickerTheme = dtpp.DatePickerTheme(
    containerHeight: 210.0,
    itemStyle: TextStyle(
      fontSize: 16.0,
      color: Color(0xFFb325f8),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
    ),
    doneStyle: TextStyle(
      fontSize: 16.0,
      color: Color(0xFFb325f8),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
    ),
    cancelStyle: TextStyle(
      fontSize: 16.0,
      color: Color(0xFFb325f8),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
    ),
  );

  dynamic dialogOpenPickerDate() {
    var now = DateTime.now();
    dtpp.DatePicker.showDatePicker(
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
      locale: dtpp.LocaleType.th,
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
            color: Theme.of(context).custom.b325f8_w_fffd57,
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
    dtpp.DatePicker.showTimePicker(
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
      locale: dtpp.LocaleType.th,
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
      dynamic response =
          await Dio().get('${ondeURL}/api/masterdata/book/slotType');

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
      logWTF(_modelType);
    } catch (e) {
      logE(e);
      setState(() => _loadingDropdownType = false);
    }
  }

  _callReadBookingCategory() async {
    try {
      setState(() => _loadingDropdownType = true);
      const ondeURL = 'https://dcc.onde.go.th/dcc-api';
      var response =
          await Dio().get('$ondeURL/api/masterdata/bookingcategories');

      setState(() => _loadingDropdownType = false);
      setState(() {
        _modelBookingCategory = response.data;
        _modelBookingSubCategory = [
          {
            "bookingSubcatId": 99999,
            "bookingCatId": null,
            "subcatNameTh": "หมวดหมูการใช้งานย่อย",
            "subcatNameEn": "SubCategories",
            "isFreetext": false
          },
          ..._modelBookingCategory[0]['bookingSubCategories']
        ];

        logWTF(_modelBookingSubCategory);

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

  _send() async {
    try {
      if (_bookingTypeRefNo.isEmpty && !widget.edit) {
        Fluttertoast.showToast(msg: 'เลือกรูปแบบการจอง');
        return;
      }
      // setState(() => _loadingSubmit = true);

      var subDate = txtDate.text.replaceAll(' ', '').split('/');
      String yearStr = (int.parse(subDate[2]) - 543).toString();

      String tempDate = '$yearStr-${subDate[1]}-${subDate[0]}T00:00:00';
      var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
      var accessToken = await ManageStorage.read('accessToken') ?? '';
      var recordId = _modelType
          .firstWhere((e) => e['refNo'] == _bookingTypeRefNo)['recordId'];

      // var bookingCategory = '';
      // _modelBookingCategory.forEach((e) {
      //   if (e['selected']) {
      //     if (bookingCategory.isEmpty) {
      //       bookingCategory = bookingCategory + e['bookingCatId'].toString();
      //     } else {
      //       bookingCategory =
      //           bookingCategory + ',' + e['bookingCatId'].toString();
      //     }
      //   }
      // });
      var bookingCategory = '';
      List<Map<String, dynamic>> bookingCat = []; // สำหรับเก็บข้อมูล bookingCat

      _modelBookingCategory.forEach((e) {
        if (e['selected']) {
          // สร้าง bookingCategory เป็น String
          if (bookingCategory.isEmpty) {
            bookingCategory = bookingCategory + e['bookingCatId'].toString();
          } else {
            bookingCategory =
                bookingCategory + ',' + e['bookingCatId'].toString();
          }

          // เพิ่มข้อมูลใน bookingCat พร้อมตรวจสอบ bookingCatId
          // เพิ่มข้อมูลใน bookingCat ตามเงื่อนไข
          bookingCat.add({
            "bookingCatId": e['bookingCatId'],
            "bookingSubCatId": e['bookingCatId'] == 3
                ? _selectSubCategory
                : null, // เฉพาะ bookingCatId == 3
            "freeTextValue": e['bookingCatId'] == 8
                ? txtOther.text ?? ""
                : "", // ใช้ "" เป็นค่าเริ่มต้น
          });
        }
      });

      var data = {
        "bookingDate": tempDate,
        "bookingSlotType": recordId,
        "centerId":
            '${widget.mode == '1' ? (widget.model?['centerId'] ?? '') : (widget.model?['center_Id'] ?? '')}',
        "startTime": txtStartTime.text,
        "endTime": txtEndTime.text,
        "userEmail": profileMe['email'],
        "userid": 0, // for test = 0; waiting API.
        "phone": txtPhone.text,
        "desc": "",
        "remark": bookingCategory,
        "bookingCat": bookingCat, // ใช้ข้อมูลที่สร้างจากลูปด้านบน
      };

      // logWTF(data);

      var response = await Dio().post(
        '$ondeURL/api/Booking/Booking/mobile',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      setState(() => _loadingSubmit = false);
      if (response.data['status'] == 200) {
        // _sendNotification(title: 'booking', date: tempDate);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => BookingServiceSuccessPage(success: true),
        //   ),
        // );
        _dialogCancelSuccess();
      } else {
        Fluttertoast.showToast(msg: response.data['message']);
      }
    } on DioError catch (e) {
      var err = e.toString();
      logE(e);
      setState(() => _loadingSubmit = false);
      if (e.response!.statusCode != 200) {
        err = e.response!.data['message'];
      }
      Fluttertoast.showToast(msg: err);
    }
  }
}
