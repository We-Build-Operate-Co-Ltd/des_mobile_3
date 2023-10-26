import 'dart:convert';
import 'dart:io';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/verify_thai_id.dart';
import 'package:dio/dio.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

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

  List<String> _genderList = ['ชาย', 'หญิง'];
  List<dynamic> _ageRangeList = [
    {'key': '15-20', 'value': '15-20 ปี'},
    {'key': '21-30', 'value': '21-30 ปี'},
    {'key': '31-40', 'value': '31-40 ปี'},
    {'key': '41-50', 'value': '41-50 ปี'},
    {'key': '51-60', 'value': '51-60 ปี'},
    {'key': '60+', 'value': '60 ปีขึ้นไป'},
  ];
  List<dynamic> _careerList = [
    {
      'key': '',
      'value': 'เลือกอาชีพ',
    },
    {
      'key': 'ประชาชนทั่วไป',
      'value': 'ประชาชนทั่วไป',
    },
    {
      'key': 'นักเรียน',
      'value': 'นักเรียน',
    },
    {
      'key': 'นักศึกษา',
      'value': 'นักศึกษา',
    },
    {
      'key': 'เกษตรกร',
      'value': 'เกษตรกร',
    },
  ];
  List<dynamic> _favoriteList = [
    {
      'selected': false,
      'value': 'สิ่งที่สนใจ',
    },
    {
      'selected': false,
      'value': 'การเกษตรสมัยใหม่',
    },
    {
      'selected': false,
      'value': 'การพัฒนาผลิตภัณฑ์และการสื่อสารทางการตลาด',
    },
    {
      'selected': false,
      'value': 'การจัดการธุรกิจชุมชน',
    },
    {
      'selected': false,
      'value': 'การท่องเที่ยวเชิงแพทย์ และสุขภาพ',
    },
    {
      'selected': false,
      'value': 'Digital Literacy',
    },
    {
      'selected': false,
      'value': 'การดูแลผู้สูงอายุ',
    },
    {
      'selected': false,
      'value': 'coding',
    },
    {
      'selected': false,
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
                    ? "assets/images/bg_login_page.png"
                    : "assets/images/bg_login_page-dark.png",
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
                                controller: txtEmail,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9a-zA-Z@!_.-]'))
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
                              SizedBox(height: 10),
                              TextFormField(
                                controller: txtPassword,
                                obscureText: passwordVisibility,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9a-zA-Z@!_.]')),
                                ],
                                decoration: _decorationPasswordMember(
                                  context,
                                  labelText: 'รหัสผ่าน',
                                  hintText:
                                      'รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร',
                                  visibility: passwordVisibility,
                                  suffixTap: () => setState(() =>
                                      passwordVisibility = !passwordVisibility),
                                ),
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  color: Theme.of(context).custom.b_w_y,
                                ),
                                cursorColor:
                                    Theme.of(context).custom.b325f8_w_fffd57,
                                validator: (model) {
                                  if (model!.isEmpty) {
                                    return 'กรุณากรอกรหัสผ่าน.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: txtConPassword,
                                obscureText: confirmPasswordVisibility,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9a-zA-Z@!_.]')),
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
                              TextFormField(
                                controller: txtFirstName,
                                decoration: _decorationRegisterMember(
                                  context,
                                  hintText: 'ชื่อ',
                                ),
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  color: Theme.of(context).custom.b_W_fffd57,
                                ),
                                cursorColor:
                                    Theme.of(context).custom.b325f8_w_fffd57,
                                validator: (model) {
                                  if (model!.isEmpty) {
                                    return 'กรุณากรอกชื่อ.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: txtLastName,
                                decoration: _decorationRegisterMember(
                                  context,
                                  hintText: 'นามสกุล',
                                ),
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  color: Theme.of(context).custom.b_W_fffd57,
                                ),
                                cursorColor:
                                    Theme.of(context).custom.b325f8_w_fffd57,
                                validator: (model) {
                                  if (model!.isEmpty) {
                                    return 'กรุณากรอกนามสกุล.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              Text(
                                'เพศ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).custom.b_W_fffd57,
                                ),
                              ),
                              SizedBox(height: 6),
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
                              SizedBox(height: 20),
                              Text(
                                'ช่วงอายุ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).custom.b_W_fffd57,
                                ),
                              ),
                              SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                child: Wrap(
                                  runSpacing: 11,
                                  children: _ageRangeList
                                      .map<Widget>(
                                          (dynamic e) => _radioAgeRange(e))
                                      .toList(),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'อาชีพ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).custom.b_W_fffd57,
                                ),
                              ),
                              SizedBox(height: 10),
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
                            onChanged: (p0) => {
                                  setState(() {
                                    chbAcceptPDPA = p0!;
                                  })
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
          onTap: () {
            if (chbAcceptPDPA) {
              final form = _formKey.currentState;
              if (form!.validate()) {
                form.save();
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

  Widget _radioGender(String value) {
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
              border: Border.all(
                  width: 1, color: Theme.of(context).custom.b325f8_w_fffd57),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _gender == value
                      ? Theme.of(context).custom.b325f8_w_fffd57
                      : Theme.of(context).custom.w_b_b),
            ),
          ),
          SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).custom.b_W_fffd57,
            ),
          )
        ],
      ),
    );
  }

  Widget _radioAgeRange(dynamic value) {
    return SizedBox(
      width: 100,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _ageRange = value['key'];
          });
        },
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _ageRange == value['key']
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

  Future<bool?> _checkDuplicateEmail() async {
    try {
      print(txtEmail.text);
      Response<bool> response = await Dio().get(
        'http://dcc-portal.webview.co/dcc-api/api/user/verify/duplicate/${txtEmail.text}',
      );
      print(response.data);
      return response.data;
    } catch (e) {
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
    return null;
  }

  Future<dynamic> _submitRegister() async {
    try {
      logD('start register');
      setState(() => _loading = true);
      // check duplicate email.
      var emailDup = await _checkDuplicateEmail();
      if (emailDup!) {
        setState(() => _loading = false);
        Fluttertoast.showToast(
          msg: 'อีเมลนี้ถูกใช้งานไปแล้ว',
        );
        return;
      }
      setState(() => _loading = false);

      var favorites = '';
      _favoriteList.forEach((e) {
        if (e['selected']) {
          if (favorites.isEmpty) {
            favorites = favorites + e['value'];
          } else {
            favorites = favorites + ',' + e['value'];
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
        'age': _ageRange,
        'username': txtEmail.text,
        'career': _careerSelected,
        'favorites': favorites,
        'facebookID': "",
        'appleID': "",
        'googleID': "",
        'lineID': "",
        'imageUrl': "",
        'category': "guest",
        'birthDay': "",
        'status': "N",
        'platform': Platform.operatingSystem.toString(),
        'countUnit': "[]"
      };

      logD(criteria);

      await ManageStorage.createSecureStorage(
        key: 'tempRegister',
        value: json.encode(criteria),
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyThaiIDPage(),
        ),
      );
    } catch (e) {
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

  @override
  void initState() {
    _scrollController = ScrollController();
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
    super.dispose();
  }

  _clearData() async {
    ManageStorage.deleteStorage('tempRegister');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('thaiDCode');
    await prefs.remove('thaiDState');
    await prefs.remove('thaiDAction');
  }

  void goBack() async {
    Navigator.pop(context, false);
  }
//
}
