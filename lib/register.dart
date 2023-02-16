import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  List<String> _genderList = ['ชาย', 'หญิง', 'อื่น ๆ'];
  List<String> _ageRangeList = [
    '15-20 ปี',
    '21-30 ปี',
    '31-40 ปี',
    '41-50 ปี',
    '51-60 ปี',
    '60 ปีขึ้นไป',
  ];
  String _gender = 'ชาย';
  String _ageRange = '15-20 ปี';

  bool passwordVisibility = true;
  bool confirmPasswordVisibility = true;

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
              image: AssetImage("assets/images/bg_login_page.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 25, left: 20, right: 25, bottom: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สมัครสมาชิก',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'กรุณากรอกข้อมูลด้านล่างให้ครบเพื่อสมัครสมาชิก',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
                            validator: (model) {
                              String pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(model!)) {
                                return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
                              } else
                                return null;
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
                            validator: (model) {
                              if (model!.isEmpty) {
                                return 'กรุณากรอกรหัสผ่าน.';
                              } else
                                return null;
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
                            validator: (model) {
                              if (model!.isEmpty) {
                                return 'กรุณากรอกยืนยันรหัสผ่าน.';
                              } else if (txtPassword.text !=
                                  txtConPassword.text) {
                                return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: txtPhone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: _decorationRegisterMember(
                              context,
                              hintText: 'หมายเลขโทรศัพท์',
                            ),
                            validator: (model) {
                              String pattern = r'(^(?:[+0]9)?[0-9]{9,10}$)';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(model!)) {
                                return 'กรุณากรอกรูปแบบเบอร์ติดต่อให้ถูกต้อง.';
                              } else
                                return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: txtFirstName,
                            decoration: _decorationRegisterMember(
                              context,
                              hintText: 'ชื่อ',
                            ),
                            validator: (model) {
                              if (model!.isEmpty) {
                                return 'กรุณากรอกชื่อ.';
                              } else
                                return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: txtLastName,
                            decoration: _decorationRegisterMember(
                              context,
                              hintText: 'นามสกุล',
                            ),
                            validator: (model) {
                              if (model!.isEmpty) {
                                return 'กรุณากรอกนามสกุล.';
                              } else
                                return null;
                            },
                          ),
                          SizedBox(height: 10),
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
                          SizedBox(height: 10),
                          Text(
                            'ช่วงอายุ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 6),
                          SizedBox(
                            height: 20,
                            width: double.infinity,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              runSpacing: 11,
                              children: _ageRangeList
                                  .map<Widget>((String e) => _radioAgeRange(e))
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 40),
                          _buildButtonRegister(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRegister() {
    return InkWell(
      onTap: () {
        final form = _formKey.currentState;
        if (form!.validate()) {
          form.save();
          submitRegister();
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: Color(0xFF7A4CB1),
        ),
        child: Text(
          'สมัครสมาชิก',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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

  Widget _radioAgeRange(String value) {
    Color border = _ageRange == value ? Color(0xFFA924F0) : Colors.grey;
    Color active = _ageRange == value ? Color(0xFFA924F0) : Colors.white;
    return SizedBox(
      width: 100,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _ageRange = value;
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
      ),
    );
  }

  Future<dynamic> submitRegister() async {
    final result = await Dio()
        .post('http://122.155.223.63/td-des-api/m/Register/create', data: {
      'email': txtEmail.text,
      'password': txtPassword.text,
      'phone': txtPhone.text,
      'firstName': txtFirstName.text,
      'lastName': txtLastName.text,
      'sex': _gender,
      'age': _ageRange,
      'username': txtEmail.text,
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
    });
    if (result.statusCode == 200) {
      if (result.data['status'] == 'S') {
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: CupertinoAlertDialog(
                  title: new Text(
                    'ลงทะเบียนเรียบร้อยแล้ว',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Kanit',
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  content: Text(" "),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: new Text(
                        "ตกลง",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Kanit',
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            });
      } else {
        return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: CupertinoAlertDialog(
                title: new Text(
                  result.data['message'],
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kanit',
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                content: Text(" "),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: new Text(
                      "ตกลง",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
    } else {
      return Error();
    }
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

  static InputDecoration _decorationPasswordMember(
    context, {
    String labelText = '',
    String hintText = '',
    bool visibility = false,
    Function? suffixTap,
  }) =>
      InputDecoration(
        label: Text(labelText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 8,
        ),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    super.dispose();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }
//
}
