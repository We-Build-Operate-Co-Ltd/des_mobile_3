import 'dart:convert';

import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/verify_fifth_step.dart';
import 'package:des/verify_fouth_step_old.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';

class VerifyFourthStepPage extends StatefulWidget {
  const VerifyFourthStepPage({Key? key, this.model}) : super(key: key);
  final dynamic model;

  @override
  State<VerifyFourthStepPage> createState() => _VerifyFourthStepPageState();
}

class _VerifyFourthStepPageState extends State<VerifyFourthStepPage> {
  TextEditingController? _phoneController;
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        appBar: AppBar(
          backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
          elevation: 0,
          flexibleSpace: _buildHead(),
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'กรุณากรอกอีเมลของท่าน เพื่อทำการรับรหัสสำหรับยืนยัน',
                  style: TextStyle(
                    fontSize: 15,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9a-zA-Z@!_.-]')),
                  ],
                  decoration: _decorationBase(context, hintText: 'อีเมล'),
                  style: TextStyle(
                      fontFamily: 'Kanit',
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'กรุณากรอกข้อมูล ';
                    }

                    if (value.length < 3) {
                      return 'short ';
                    } else {
                      return null;
                    }
                  },
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                GestureDetector(
                  onTap: () async {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      _requestOTP();
                    }
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.5),
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7A4CB1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                    ),
                    child: Text(
                      'ดำเนินการต่อ',
                      style: TextStyle(
                        fontSize: 16,
                        color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.white
                                    : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
      color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
      child: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF7A4CB1)
                        : Colors.black,
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    )),
                child: Image.asset(
                  'assets/images/back_arrow.png',
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'OTP ผ่านอีเมล',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
          )
        ],
      ),
    );
  }

  static InputDecoration _decorationBase(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          // fontSize: 12,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFA924F0)),
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
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );

  @override
  void initState() {
    _phoneController = TextEditingController();
    super.initState();
  }

  _requestOTP() async {
    var value = await ManageStorage.read('profileData') ?? '';
    var user = json.decode(value);

    user['email'] = _emailController.text;
    var response = await Dio()
        .post('http://122.155.223.63/td-des-api/m/Register/update', data: user);
   
    

    Dio dioEmail = Dio();
    var responseEmail = await dioEmail.post(
      'https://core148.we-builds.com/email-api/Email/Create',
      data: {
        "email": [(_emailController.text)],
        "title": "DES ดิจิทัลชุมชน",
        "description": "รหัส OTP ของคุณคือ 234156",
        "subject": "DES ดิจิทัลชุมชน รับรหัส OTP"
      },
    );

    var result = responseEmail.data;
    if (result['status'] == "S") {
      widget.model['email'] = _emailController.text;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyFifthStepPage(
            model: widget.model,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }
}
