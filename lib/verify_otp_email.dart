import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/verify_last_step.dart';
import 'package:des/verify_thai_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: library_prefixes
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class VerifyOTPEmailPage extends StatefulWidget {
  const VerifyOTPEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyOTPEmailPage> createState() => _VerifyOTPEmailPageState();
}

class _VerifyOTPEmailPageState extends State<VerifyOTPEmailPage> {
  final txtNumber1 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loadindSubmit = false;
  bool loading = false;
  String image = '';
  String _email = '';

  // face recognition start
  var image1 = Regula.MatchFacesImage();
  var image2 = Regula.MatchFacesImage();
  var img1 = Image.asset('logo.png');
  var img2 = Image.asset('logo.png');
  // ignore: unused_field
  String _liveness = "nil";

  @override
  initState() {
    super.initState();
    _getEmail();
  }

  _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailTemp = prefs.getString('emailTemp') ?? '';
    setState(() {
      _email = emailTemp;
    });
  }

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'กรุณากรอกรหัสที่ท่านได้รับผ่านอีเมล์',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.all(20),
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : Colors.black,
                        border: Border.all(
                          width: 1,
                          style: BorderStyle.solid,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFF7A4CB1)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        )),
                    child: Image.asset(
                      'assets/images/letter.png',
                    ),
                  ),
                ],
              ),
              // Container(
              //   alignment: Alignment.center,
              //   child: Image.asset(
              //     'assets/images/letter.png',
              //     height: 100,
              //     width: 100,
              //   ),
              // ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: PinCodeTextField(
                  appContext: context,
                  controller: txtNumber1,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  length: 6,
                  obscureText: false,
                  obscuringCharacter: '*',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 6) {
                      return "";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    inactiveColor: Colors.transparent,
                    activeColor: Colors.transparent,
                    selectedColor: Theme.of(context).primaryColor,
                    // disabledColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Color(0xFFEEEEEE),
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(15),
                    fieldHeight: 45.2,
                    fieldWidth: 45.2,
                    activeFillColor: Color(0xFFEEEEEE),
                  ),
                  backgroundColor: Colors.white,
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  // controller: textEditingController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) async {
                    if (await _validateOTP()) {
                      // _faceRecognition();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VerifyLastStepPage(),
                        ),
                      );
                    }
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      // currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => _requestOTP(),
                  child: Text(
                    'ท่านต้องการรับรหัสใหม่',
                    style: TextStyle(
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Expanded(child: SizedBox()),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (txtNumber1.text.length == 6) {
                        if (await _validateOTP()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VerifyLastStepPage(),
                            ),
                          );
                        }
                      } else {
                        Fluttertoast.showToast(msg: 'OTP ไม่ครบ');
                      }
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.5),
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                      child: Text(
                        'ดำเนินการต่อ',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  if (_loadindSubmit)
                    Positioned.fill(
                      left: 15,
                      right: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(22.5),
                        ),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _buildHead() {
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
              'กรอกรหัส OTP',
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

  _requestOTP() async {
    try {
      setState(() {
        _loadindSubmit = true;
      });
      Dio dio = Dio();
      var responseEmail = await dio.post(
        'https://des.we-builds.com/de-api/m/register/otp/request',
        data: {"email": _email},
      );
      var result = responseEmail.data;
      setState(() {
        _loadindSubmit = false;
      });
      if (result['status'] == "E") {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (ex) {
      setState(() {
        _loadindSubmit = false;
      });
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _validateOTP() async {
    try {
      setState(() {
        _loadindSubmit = true;
      });
      Dio dio = Dio();
      var responseEmail = await dio.post(
        'https://des.we-builds.com/de-api/m/register/otp/validate',
        data: {"email": _email, "title": txtNumber1.text},
      );

      var result = responseEmail.data;
      setState(() {
        _loadindSubmit = false;
      });
      if (result['status'] == "S") {
        // TO DO Success.
        return true;
      } else if (result['status'] == "E") {
        Fluttertoast.showToast(msg: '${result['message']}');
      } else {
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
      return false;
    } catch (e) {
      setState(() {
        _loadindSubmit = false;
      });
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      return false;
    }
  }

  _faceRecognition() {
    Regula.FaceSDK.presentFaceCaptureActivityWithConfig(
      {
        "cameraId": Regula.CameraPosition.Front,
        "cameraSwitchEnabled": true,
      },
    ).then((result) async {
      Uint8List imageFile = await setImage(
        true,
        base64Decode(Regula.FaceCaptureResponse.fromJson(json.decode(result))!
            .image!
            .bitmap!
            .replaceAll("\n", "")),
        Regula.ImageType.LIVE,
      );
      // await updateSaveBase64(imageFile);

      //save image on device.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String s = String.fromCharCodes(imageFile);
      await prefs.setString('imageTemp', s);

      // _register();
    });
  }

  setImage(bool first, Uint8List imageFile, int type) {
    image1.bitmap = base64Encode(imageFile);
    image1.imageType = type;
    setState(() {
      img1 = Image.memory(imageFile);
      _liveness = "nil";
      loading = true;
    });
    return imageFile;
  }
}
