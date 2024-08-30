import 'dart:convert';
import 'dart:io';
import 'package:des/policy_web.dart';
import 'package:des/register_link_account.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/facebook_firebase.dart';
import 'package:des/shared/google_firebase.dart';
import 'package:des/shared/line.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/register_verify_thai_id.dart';
import 'package:dio/dio.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared/config.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.model, this.category = ''});
  final dynamic model;
  final String category;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String _passwordStringValidate = '';

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPrefixName = TextEditingController();

  bool _loading = false;

  late ScrollController _scrollController;

  dynamic configRegister = 0;

  List<dynamic> _genderList = [
    {'key': 'male', 'value': 'ชาย'},
    {'key': 'female', 'value': 'หญิง'},
    {'key': 'LGBTQ+', 'value': 'LGBTQ+'},
  ];
  List<dynamic> _ageRangeList = [
    {'code': '1', 'title': 'ต่ำกว่า 15 ปี', 'value': 'ต่ำกว่า 15 ปี'},
    {'code': '2', 'title': '18 - 24 ปี', 'value': '18 - 24 ปี'},
    {'code': '3', 'title': '25 - 54 ปี', 'value': '25 - 54 ปี'},
    {'code': '4', 'title': '55 - 64 ปี', 'value': '55 - 64 ปี'},
    {'code': '5', 'title': '65 ปีขึ้นไป', 'value': '65 ปีขึ้นไป'},
  ];

  List<dynamic> _careerList = [
    {
      'key': '',
      'value': 'เลือกอาชีพ',
    },
    {
      'key': '1',
      'value':
          'ข้าราชการ พนักงาน เจ้าหน้าที่ หรือผู้ปฏิบัติงานอื่นของส่วนราชการวิสาหกิจ/องค์กรอิสระ/องค์กรมหาชน/หน่วยงานของรัฐอื่นๆ',
    },
    {
      'key': '2',
      'value': 'พนักงาน/ลูกจ้างเอกชน',
    },
    {
      'key': '3',
      'value': 'เจ้าของกิจการ/ประกอบธุรกิจส่วนตัว',
    },
    {
      'key': '4',
      'value': 'อาชีพอิสระ/ฟรีแลนซ์',
    },
    {
      'key': '5',
      'value': 'รับจ้างทั่วไป/ขับรถรับจ้าง/กรรมกร',
    },
    {
      'key': '6',
      'value': 'นักเรียน/นักศึกษา',
    },
    {
      'key': '7',
      'value': 'พ่อบ้าน/แม่บ้าน',
    },
    {
      'key': '8',
      'value': 'เกษียณจากการทำงาน/ข้าราชการบำนาญ',
    },
    {
      'key': '9',
      'value': 'เกษตรกร',
    },
    {
      'key': '10',
      'value': 'ว่างงาน/ไม่มีงานทำ',
    },
    {
      'key': '11',
      'value': 'อื่นๆ',
    },
  ];
  List<dynamic> _favoriteList = [
    {
      'selected': false,
      'key': '1',
      'value': 'การเกษตรสมัยใหม่',
    },
    {
      'selected': false,
      'key': '2',
      'value': 'การพัฒนาผลิตภัณฑ์และการสื่อสารทางการตลาด',
    },
    {
      'selected': false,
      'key': '3',
      'value': 'การจัดการธุรกิจชุมชน',
    },
    {
      'selected': false,
      'key': '4',
      'value': 'การท่องเที่ยวเชิงแพทย์ และสุขภาพ',
    },
    {
      'selected': false,
      'key': '5',
      'value': 'Digital Literacy',
    },
    {
      'selected': false,
      'key': '6',
      'value': 'การดูแลผู้สูงอายุ',
    },
    {
      'selected': false,
      'key': '7',
      'value': 'coding',
    },
    {
      'selected': false,
      'key': '8',
      'value': 'practice lab',
    },
  ];

  String _gender = 'ชาย';
  String _ageRange = '15-20 ปี';
  String _careerSelected = '';
  String _favoriteSelected = '';

  bool passwordVisibility = true;
  bool confirmPasswordVisibility = true;
  bool chbAcceptPDPA = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _setDataFromThridParty();
    _callReadConfigRegister();
    super.initState();
    _clearData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _scrollController.dispose();
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtPhone.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    switch (widget.category) {
      case 'facebook':
        logoutFacebook();
        break;
      case 'google':
        logoutGoogle();
        break;
      case 'line':
        logoutLine();
        break;
      default:
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                MyApp.themeNotifier.value == ThemeModeThird.light
                    ? "assets/images/BG.png"
                    : "",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Card(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.white
                  : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Container(
                padding:
                    EdgeInsets.only(top: 25, left: 20, right: 25, bottom: 20),
                decoration: BoxDecoration(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: 559,
                  child: FadingEdgeScrollView.fromScrollView(
                    gradientFractionOnEnd: 1.0,
                    gradientFractionOnStart: 0.3,
                    child: ListView(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      physics: ClampingScrollPhysics(),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'สมัครสมาชิก',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.black
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/images/close_noti_list.png',
                                  height: 18.52,
                                  width: 18.52,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Colors.black
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'กรุณากรอกข้อมูลด้านล่างให้ครบเพื่อสมัครสมาชิก',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).custom.b_w_y,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              TextFormField(
                                readOnly: (widget.model?['email'] ?? '') != ''
                                    ? true
                                    : false,
                                controller: txtEmail,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9a-zA-Z@!#$%?*~^<>._.-]'))
                                ],
                                decoration: _decorationRegisterMember(
                                  context,
                                  hintText: 'อีเมล',
                                ),
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  color: Theme.of(context).custom.b_w_y,
                                ),
                                cursorColor:
                                    Theme.of(context).custom.b325f8_w_fffd57,
                                validator: (model) {
                                  String pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (model!.isEmpty) {
                                    return 'กรุณากรอกชื่อ.';
                                  } else if (!regex.hasMatch(model)) {
                                    return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              if (widget.category.isEmpty) SizedBox(height: 10),
                              if (widget.category.isEmpty)
                                TextFormField(
                                  controller: txtPassword,
                                  obscureText: passwordVisibility,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9a-zA-Z@!#$%?*~^<>._.-]')),
                                  ],
                                  decoration: _decorationPasswordMember(
                                    context,
                                    labelText: 'รหัสผ่าน',
                                    hintText:
                                        'รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร',
                                    visibility: passwordVisibility,
                                    suffixTap: () => setState(() =>
                                        passwordVisibility =
                                            !passwordVisibility),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    color: Theme.of(context).custom.b_w_y,
                                  ),
                                  cursorColor:
                                      Theme.of(context).custom.b325f8_w_fffd57,
                                  validator: (value) {
                                    var result = ValidateForm.password(value!);
                                    return result == null ? null : result;
                                  },
                                ),
                              if (widget.category.isEmpty) SizedBox(height: 10),
                              if (widget.category.isEmpty)
                                TextFormField(
                                  controller: txtConPassword,
                                  obscureText: confirmPasswordVisibility,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9a-zA-Z@!#$%?*~^<>._.-]')),
                                  ],
                                  decoration: _decorationPasswordMember(
                                    context,
                                    labelText: 'ยืนยันรหัสผ่าน',
                                    hintText:
                                        'รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร',
                                    visibility: confirmPasswordVisibility,
                                    suffixTap: () => setState(() =>
                                        confirmPasswordVisibility =
                                            !confirmPasswordVisibility),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    color: Theme.of(context).custom.b_W_fffd57,
                                  ),
                                  cursorColor:
                                      Theme.of(context).custom.b325f8_w_fffd57,
                                  validator: (model) {
                                    if (model!.isEmpty) {
                                      return 'กรุณากรอกยืนยันรหัสผ่าน.';
                                    } else if (txtPassword.text !=
                                        txtConPassword.text) {
                                      return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: txtPhone,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: _decorationRegisterMember(
                                  context,
                                  hintText: 'หมายเลขโทรศัพท์',
                                ),
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  color: Theme.of(context).custom.b_W_fffd57,
                                ),
                                cursorColor:
                                    Theme.of(context).custom.b325f8_w_fffd57,
                                validator: (model) {
                                  String pattern = r'(^(?:[+0]9)?[0-9]{9,10}$)';
                                  RegExp regex = new RegExp(pattern);
                                  if (model!.isEmpty) {
                                    return 'กรุณากรอกชื่อ.';
                                  } else if (!regex.hasMatch(model)) {
                                    return 'กรุณากรอกรูปแบบเบอร์ติดต่อให้ถูกต้อง.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              // TextFormField(
                              //   controller: txtFirstName,
                              //   decoration: _decorationRegisterMember(
                              //     context,
                              //     hintText: 'ชื่อ',
                              //   ),
                              //   style: TextStyle(
                              //     fontFamily: 'Kanit',
                              //     color: Theme.of(context).custom.b_W_fffd57,
                              //   ),
                              //   cursorColor:
                              //       Theme.of(context).custom.b325f8_w_fffd57,
                              //   validator: (model) {
                              //     if (model!.isEmpty) {
                              //       return 'กรุณากรอกชื่อ.';
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              // ),
                              // SizedBox(height: 10),
                              // TextFormField(
                              //   controller: txtLastName,
                              //   decoration: _decorationRegisterMember(
                              //     context,
                              //     hintText: 'นามสกุล',
                              //   ),
                              //   style: TextStyle(
                              //     fontFamily: 'Kanit',
                              //     color: Theme.of(context).custom.b_W_fffd57,
                              //   ),
                              //   cursorColor:
                              //       Theme.of(context).custom.b325f8_w_fffd57,
                              //   validator: (model) {
                              //     if (model!.isEmpty) {
                              //       return 'กรุณากรอกนามสกุล.';
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              // ),
                              // SizedBox(height: 10),
                              if (configRegister.toString() == "1")
                                Text(
                                  'เพศ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).custom.b_W_fffd57,
                                  ),
                                ),
                              if (configRegister.toString() == "1")
                                SizedBox(height: 6),
                              if (configRegister.toString() == "1")
                                SizedBox(
                                  height: 20,
                                  width: double.infinity,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: 25),
                                    itemBuilder: (_, index) =>
                                        _radioGender(_genderList[index]),
                                    itemCount: _genderList.length,
                                  ),
                                ),
                              if (configRegister.toString() == "1")
                                SizedBox(height: 20),
                              if (configRegister.toString() == "1")
                                Text(
                                  'ช่วงอายุ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).custom.b_W_fffd57,
                                  ),
                                ),
                              if (configRegister.toString() == "1")
                                SizedBox(height: 6),
                              if (configRegister.toString() == "1")
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    runSpacing: 11,
                                    spacing: 8,
                                    children: _ageRangeList
                                        .map<Widget>(
                                            (dynamic e) => _radioAgeRange(e))
                                        .toList(),
                                  ),
                                ),
                              if (configRegister.toString() == "1")
                                SizedBox(height: 10),
                              if (configRegister.toString() == "1")
                                Text(
                                  'อาชีพ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).custom.b_W_fffd57,
                                  ),
                                ),
                              if (configRegister.toString() == "1")
                                SizedBox(height: 10),
                              if (configRegister.toString() == "1")
                                _dropdown(
                                  data: _careerList,
                                  value: _careerSelected,
                                  onChanged: (String value) {
                                    setState(() {
                                      _careerSelected = value;
                                    });
                                  },
                                ),
                              SizedBox(height: 10),
                              Text(
                                'สิ่งที่สนใจ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).custom.b_W_fffd57,
                                ),
                              ),
                              SizedBox(height: 10),
                              _buildFavorites(),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              'ฉันยอมรับการให้ข้อมูล',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).custom.b_W_fffd57,
                              ),
                            ),
                            subtitle: Text(
                              'ยอมรับการให้ข้อมูลเพื่อสมัครสมาชิก เพื่อให้เป็นไปตามหลักข้อกำหนดในการเก็บข้อมูลส่วนบุคคล',
                              style: TextStyle(
                                color: Theme.of(context).custom.f70f70_y,
                              ),
                            ),
                            activeColor:
                                Theme.of(context).custom.b325f8_w_fffd57,
                            side: BorderSide(
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                            ),
                            enabled: true,
                            checkColor: Theme.of(context).custom.w_292929,
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            value: chbAcceptPDPA,
                            onChanged: (p0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PolicyWebPage(),
                                ),
                              ).then((value) {
                                if (value) {
                                  setState(() {
                                    chbAcceptPDPA = true;
                                  });
                                }
                              });
                            }),
                        SizedBox(height: 40),
                        _buildButtonRegister(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavorites() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      itemCount: _favoriteList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => GestureDetector(
        onTap: () {
          setState(() {
            _favoriteList[__]['selected'] = !_favoriteList[__]['selected'];
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).custom.b325f8_w_fffd57,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: _favoriteList[__]['selected']
                          ? Theme.of(context).custom.b325f8_w_fffd57
                          : Theme.of(context).custom.w_b_b),
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${_favoriteList[__]['value']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).custom.b_W_fffd57,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRegister() {
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            if (chbAcceptPDPA) {
              final form = _formKey.currentState;
              if (form!.validate()) {
                form.save();

                if (configRegister.toString() == "0") {
                  setState(() {
                    _gender = 'male';
                    _ageRange = '3';
                    _careerSelected = '10';
                    // favorites = '';
                  });
                }

                if (_careerSelected == '') {
                  Fluttertoast.showToast(msg: 'กรุณาเลือกอาชีพ');
                  return;
                }
                if (_favoriteList.any((element) => element['selected'])) {
                  _submitRegister();
                } else {
                  Fluttertoast.showToast(msg: 'กรุณาเลือกสิ่งที่สนใจ');
                  return;
                }
              }
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                color: chbAcceptPDPA
                    ? Theme.of(context).custom.A4CB1_w_fffd57
                    : Color(0xFF707070)),
            child: Text(
              'สมัครสมาชิก',
              style: TextStyle(
                fontSize: 15,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (_loading)
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25),
              ),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _radioGender(dynamic value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = value['key'];
        });
      },
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: Theme.of(context).custom.b325f8_w_fffd57),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _gender == value['key']
                      ? Theme.of(context).custom.b325f8_w_fffd57
                      : Theme.of(context).custom.w_b_b),
            ),
          ),
          SizedBox(width: 6),
          Text(
            value['value'],
            style: TextStyle(
              fontSize: 13,
              height: 1,
              color: Theme.of(context).custom.b_W_fffd57,
            ),
          )
        ],
      ),
    );
  }

  Widget _radioAgeRange(dynamic value) {
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _ageRange = value['code'];
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).custom.b325f8_w_fffd57,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _ageRange == value['code']
                        ? Theme.of(context).custom.b325f8_w_fffd57
                        : Theme.of(context).custom.w_b_b),
              ),
            ),
            SizedBox(width: 6),
            Text(
              value['value'],
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).custom.b_W_fffd57,
              ),
            )
          ],
        ),
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
        decoration: _decorationRegisterMember(context),
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

  Future<StatusDuplicate> _checkDuplicateEmail() async {
    try {
      Response<bool?> response = await Dio().get(
        'http://dcc-portal.webview.co/dcc-api/api/user/verify/duplicate/${txtEmail.text}',
      );
      print(response.data);
      return response.data! ? StatusDuplicate.fail : StatusDuplicate.pass;
    } catch (e) {
      return StatusDuplicate.error;
    }
  }

  Future<String> _checkDuplicateUser() async {
    try {
      Response<String> response = await Dio().get(
        '$server/dcc-api/m/register/guest/duplicate/${txtEmail.text}/${txtEmail.text}',
      );
      // if (response.data == 'username') {
      //   return 'ชื่อผู้ใช้งานนี้ถูกใช้งานไปแล้ว';
      // }
      // if (response.data == 'idcard') {
      //   return 'เลขบัตรประชาชนนี้ถูกใช้งานไปแล้ว';
      // }
      if (response.data == 'email') {
        return 'อีเมลนี้ถูกใช้งานไปแล้ว';
      }
      if (response.data == 'server') {
        return 'internal server error';
      }

      return '';
    } catch (e) {
      logE(e);
      return 'เกิดข้อผิดพลาด';
    }
  }

  Future<dynamic> _submitRegister() async {
    try {
      logD('start register');
      setState(() => _loading = true);

      // // check duplicate email.
      // StatusDuplicate emailDup = await _checkDuplicateEmail();
      // // logWTF(emailDup);
      // if (emailDup == StatusDuplicate.fail) {
      //   setState(() => _loading = false);
      //   Fluttertoast.showToast(msg: 'อีเมลนี้ถูกใช้งานไปแล้ว');
      //   return;
      // } else if (emailDup == StatusDuplicate.error) {
      //   setState(() => _loading = false);
      //   Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      //   return;
      // }
      // setState(() => _loading = false);

      String usernameDup = await _checkDuplicateUser();
      // logWTF(usernameDup);
      if (usernameDup.isNotEmpty) {
        if (usernameDup == 'อีเมลนี้ถูกใช้งานไปแล้ว' && widget.category != '') {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegisterLinkAccountPage(
                email: txtEmail.text,
                category: widget.category,
                model: widget.model,
              ),
            ),
          );
          return;
        }
        Fluttertoast.showToast(msg: usernameDup);
        setState(() => _loading = false);
        return;
      }

      var favorites = '';
      _favoriteList.forEach((e) {
        if (e['selected']) {
          if (favorites.isEmpty) {
            favorites = favorites + e['key'];
          } else {
            favorites = favorites + ',' + e['key'];
          }
        }
      });

      var criteria = {
        'email': txtEmail.text,
        'password': txtPassword.text,
        'phone': txtPhone.text,
        'firstName': txtFirstName.text,
        'lastName': txtLastName.text,
        'sex': _gender,
        'age': int.parse(_ageRange),
        'ageRange': _ageRangeList
            .firstWhere((element) => element['code'] == _ageRange)['title'],
        'username': widget.category.isNotEmpty
            ? widget.model['username']
            : txtEmail.text,
        'career': _careerSelected,
        'favorites': favorites,
        'facebookID': widget.model?['facebookID'] ?? '',
        'appleID': "",
        'lineID': widget.model?['lineID'] ?? '',
        'googleID': widget.model?['googleID'] ?? '',
        'xID': widget.model?['xID'] ?? '',
        'imageUrl': "",
        'category': "guest",
        'birthDay': "",
        'status': "N",
        'platform': Platform.operatingSystem.toString(),
        'countUnit': "[]"
      };

      logWTF(criteria);

      setState(() => _loading = false);
      await ManageStorage.createSecureStorage(
        key: 'tempRegister',
        value: json.encode(criteria),
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterVerifyThaiIDPage(),
        ),
      );
    } catch (e) {
      logE(e);
      setState(() => _loading = false);
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  static InputDecoration _decorationRegisterMember(context,
          {String hintText = ''}) =>
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
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
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
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  static InputDecoration _decorationPasswordMember(
    context, {
    String labelText = '',
    String hintText = '',
    bool visibility = false,
    Function? suffixTap,
  }) =>
      InputDecoration(
        label: Text(labelText),
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
          fontSize: 8,
          fontWeight: FontWeight.normal,
        ),
        hintText: hintText,
        suffixIcon: GestureDetector(
          onTap: () {
            suffixTap!();
          },
          child: visibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
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
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  _clearData() async {
    ManageStorage.deleteStorage('tempRegister');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('thaiDCode');
    await prefs.remove('thaiDState');
    await prefs.remove('thaiDAction');
  }

  _setDataFromThridParty() {
    if (widget.category.isNotEmpty) {
      logWTF(widget.model);
      setState(() {
        txtEmail.text = widget.model?['email'] ?? '';
        txtUsername.text = widget.model?['username'] ?? '';
        txtPassword.text = widget.category;
        txtConPassword.text = widget.category;
        txtFirstName.text = widget.model?['firstName'] ?? '';
      });
    }
  }

  _checkDataSocial() async {
    String usernameDup = await _checkDuplicateUser();
    logWTF(usernameDup);
    if (usernameDup.isNotEmpty) {
      if (usernameDup == 'อีเมลนี้ถูกใช้งานไปแล้ว' && widget.category != '') {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RegisterLinkAccountPage(
              email: txtEmail.text,
              category: 'google',
              model: widget.model,
            ),
          ),
        );
        return;
      }
      Fluttertoast.showToast(msg: usernameDup);
      return;
    }
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  void _callReadConfigRegister() async {
    var response = await Dio()
        .get('$server/py-api/dcc/config/register/' + versionNumber.toString());
    // print(response);
    setState(() {
      configRegister = response;
    });
  }

//
}

enum StatusDuplicate { pass, fail, error }
