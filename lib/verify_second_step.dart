import 'package:des/verify_third_step.dart';
import 'package:des/verify_third_step_old.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class VerifySecondStepPage extends StatefulWidget with WidgetsBindingObserver {
  const VerifySecondStepPage({Key? key}) : super(key: key);

  @override
  State<VerifySecondStepPage> createState() => _VerifySecondStepPageState();
}

class _VerifySecondStepPageState extends State<VerifySecondStepPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtIdCard = TextEditingController();
  TextEditingController txtFullName = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtAge = TextEditingController();
  TextEditingController txtLaserId = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtAddress = TextEditingController();

  DateTime selectedDate = DateTime.now();
  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  int age = 0;
  bool loading = false;

  String profileCode = '';
  String sex = '';
  String email = '';
  String image = '';

  String result = '';

  List<String> _genderList = ['ชาย', 'หญิง', 'อื่น ๆ'];
  String _gender = 'ชาย';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: _buildHead(),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    TextFormField(
                      controller: txtIdCard,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(13),
                      ],
                      decoration: _decorationRegisterMember(
                        context,
                        hintText: 'เลขบัตรประชาชน',
                      ),
                      validator: (model) {
                        String pattern = r'(^[0-9]\d{12}$)';
                        RegExp regex = RegExp(pattern);
                        if (regex.hasMatch(model!)) {
                          if (model.length != 13) {
                            return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
                          } else {
                            var sum = 0.0;
                            for (var i = 0; i < 12; i++) {
                              sum += double.parse(model[i]) * (13 - i);
                            }
                            if ((11 - (sum % 11)) % 10 !=
                                double.parse(model[12])) {
                              return 'กรุณากรอกเลขบัตรประชาชนให้ถูกต้อง';
                            } else {
                              return null;
                            }
                          }
                        } else {
                          return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: txtFirstName,
                            // inputFormatters: InputFormatTemple.name(),
                            decoration: _decorationRegisterMember(
                              context,
                              hintText: 'ชื่อ',
                            ),
                            validator: (model) {
                              if (model!.isEmpty) {
                                return 'กรุณากรอกชื่อ';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: txtLastName,
                            // inputFormatters: InputFormatTemple.name(),
                            decoration: _decorationRegisterMember(
                              context,
                              hintText: 'นามสกุล',
                            ),
                            validator: (model) {
                              if (model!.isEmpty) {
                                return 'กรุณากรอกนามสกุล.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                                decoration: _decorationDate(
                                  context,
                                  hintText: 'วันเดือนปีเกิด',
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
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: txtAge,
                            decoration: _decorationRegisterMember(
                              context,
                              hintText: 'อายุ',
                            ),
                            validator: (model) {
                              if (model!.isEmpty) {
                                return 'กรุณากรอกอายุ.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: txtLaserId,
                      // inputFormatters: InputFormatTemple.laserid(),
                      keyboardType: TextInputType.name,
                      decoration: _decorationRegisterMember(
                        context,
                        hintText: 'เลข Laser ID',
                      ),
                      validator: (model) {
                        if (model!.isEmpty) {
                          return 'กรุณากรอกเลข Laser ID.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/thai_card_back.png',
                          height: 56,
                          width: 100,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'คำแนะนำ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'เลข Laser ID จะอยู่ด้านหลังของบัตรประชาชน',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF707070),
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'เพศ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 6),
                    SizedBox(
                      height: 20,
                      width: double.infinity,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (_, __) => SizedBox(width: 25),
                        itemBuilder: (_, index) =>
                            _radioGender(_genderList[index]),
                        itemCount: _genderList.length,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'การติดต่อ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'กรุณากรอกข้อมูลเบอร์ติดต่อและอีเมล เพื่อทำการรับรหัสยืนยัน OTP ต่อไป',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtPhone,
                      // inputFormatters: InputFormatTemple.laserid(),
                      keyboardType: TextInputType.name,
                      decoration: _decorationRegisterMember(
                        context,
                        hintText: 'หมายเลขโทรศัพท์',
                      ),
                      validator: (model) {
                        if (model!.isEmpty) {
                          return 'กรุณากรอกหมายเลขโทรศัพท์';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: txtAddress,
                      // inputFormatters: InputFormatTemple.laserid(),
                      keyboardType: TextInputType.name,
                      decoration: _decorationRegisterMember(
                        context,
                        hintText: 'ที่อยู่ของท่าน',
                      ),
                      validator: (model) {
                        if (model!.isEmpty) {
                          return 'กรุณากรอกที่อยู่ของท่าน';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                      child: Center(
                        child: Text(
                          result,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTap: () {
                          debugPrint('text');
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            form.save();

                            var birthday = DateFormat("yyyyMMdd").format(
                              DateTime(
                                _selectedYear,
                                _selectedMonth,
                                _selectedDay,
                              ),
                            );

                            dynamic model = {
                              'idcard': txtIdCard.text,
                              'age': txtAge.text,
                              'birthday': birthday,
                              'fullName':
                                  '${txtFirstName.text} ${txtLastName.text}',
                              'firstName': txtFirstName.text,
                              'lastName': txtLastName.text,
                              'laser': txtLaserId.text,
                              'phone': txtPhone.text,
                              'address': txtAddress.text,
                              'sex': _gender,
                            };

                            // _callLaser(model);

                            _requestOTP(model);
                          }
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF7A4CB1),
                          ),
                          child: const Text(
                            'ดำเนินการต่อ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                if (loading)
                  Positioned.fill(
                      child: Container(
                    color: Colors.white.withOpacity(0.4),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      height: 60 + MediaQuery.of(context).padding.top,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: MediaQuery.of(context).padding.top,
      ),
      color: Colors.white,
      child: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
                // Dio dio = Dio();
                // String laserUrl =
                //     'https://a6fe-101-108-244-151.ngrok.io/api/laser';
                // var response = await dio.post(
                //   laserUrl,
                //   data: {
                //     "pid": 1100800535208,
                //     "fname": "พรทวี",
                //     "lname": "จันทนิตย์",
                //     "dob": 25320426,
                //     "laser": "ME0113310347"
                //   },
                //   options: Options(headers: {'token': ''}),
                // );
                // print(response.data.toString());
              },
              child: Image.asset(
                'assets/images/arrow_back.png',
                height: 40,
                width: 40,
              ),
            ),
          ),
          const Center(
            child: Text(
              'ข้อมูลบัตรประชาชน',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  static InputDecoration _decorationRegisterMember(context,
          {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
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
          fontWeight: FontWeight.normal,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        suffixIcon: const Icon(Icons.calendar_today),
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
            //เดือนที่เลือกน้อยกว่าเท่ากับเดือนปัจจุบัน && วันที่เลือกน้อยกว่าเท่ากับวันปัจจุบัน
            if (_selectedMonth <= month && _selectedDay <= day) {
              age = year - _selectedYear;
              debugPrint('age1 $age');
            } //เดือนที่เลือกน้อยกว่าเท่ากับเดือนปัจจุบัน && วันที่เลือกมากกว่าวันปัจจุบัน
            else if (_selectedMonth <= month && _selectedDay > day) {
              age = year - _selectedYear - 1;
              debugPrint('age2 $age');
            } //เดือนที่เลือกมากกว่าเดือนปัจจุบัน && วันที่เลือกมากกว่าวันปัจจุบัน
            else if (_selectedMonth > month && _selectedDay > day) {
              age = year - _selectedYear - 1;
              debugPrint('age3 $age');
            } else {
              age = year - _selectedYear - 1;
              debugPrint('age4 $age');
            }
            txtAge.value = TextEditingValue(
              text: age.toString(),
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

  Widget _radioGender(String value) {
    Color border = _gender == value ? Color(0xFFA924F0) : Colors.grey;
    Color active = _gender == value ? Color(0xFFA924F0) : Colors.white;
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = value;
        });
      },
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active,
              ),
            ),
          ),
          SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    Intl.defaultLocale = "th";
    initializeDateFormatting();

    super.initState();
    var now = DateTime.now();
    setState(() {
      year = now.year + 543;
      month = now.month;
      day = now.day;
      _selectedYear = now.year + 543;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtIdCard.dispose();
    txtFullName.dispose();
    txtDate.dispose();
    txtAge.dispose();
    txtLaserId.dispose();
    super.dispose();
  }

  void _callLaser(param) async {
    setState(() {
      loading = true;
    });

    String loginUrl = 'https://f288-101-109-238-157.ngrok.io/api/jwt/login';
    Dio dio = Dio();
    var response = await dio.post(
      loginUrl,
      data: {
        "username": "bina@trial",
        "password": "bina!p@ss168",
      },
    );

    if (response.statusCode == 200) {
      // {
      //     "pid": 1100800535208,
      //     "fname": "พรทวี",
      //     "lname": "จันทนิตย์",
      //     "dob": 25320426,
      //     "laser": "ME0113310347"
      //   },

      // data: {
      //     "pid": int.parse(param['idcard']),
      //     "fname": param['firstName'],
      //     "lname": param['lastName'],
      //     "dob": int.parse(param['birthday']),
      //     "laser": param['laser'].toString().toUpperCase()
      //   },
      String token = response.data['token'].toString();
      String laserUrl = 'https://f288-101-109-238-157.ngrok.io/api/laser';
      response = await dio.post(
        laserUrl,
        data: {
          "pid": int.parse(param['idcard']),
          "fname": param['firstName'],
          "lname": param['lastName'],
          "dob": int.parse(param['birthday']),
          "laser": param['laser'].toString().toUpperCase()
        },
        options: Options(headers: {'token': token}),
      );
      // print(response.data.toString());

      setState(() {
        if (response.data['code'].toString() != '0') {
          setState(() {
            loading = false;
            result = response.data['desc'];
          });
        } else {
          loading = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyThirdStepPage(model: param),
            ),
          );
        }
      });
    } else {
      setState(() {
        loading = false;
        result = response.data['desc'];
      });
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _requestOTP(dynamic model) async {
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.headers["api_key"] = "db88c29e14b65c9db353c9385f6e5f28";
    dio.options.headers["secret_key"] = "XpM2EfFk7DKcyJzt";
    var response =
        await dio.post('https://portal-otp.smsmkt.com/api/otp-send', data: {
      "project_key": "XcvVbGHhAi",
      "phone": model['phone'].replaceAll('-', '').trim(),
      "ref_code": "xxx123"
    });

    var otp = response.data['result'];
    if (otp['token'] != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyThirdStepPage(
            token: otp['token'],
            refCode: otp['ref_code'],
            model: model,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }
}
