import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:des/menu.dart';
import 'package:des/verify_fourth_step.dart';
import 'package:des/verify_last_step_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: library_prefixes
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class VerifyThirdStepPage extends StatefulWidget {
  const VerifyThirdStepPage(
      {Key? key, @required this.token, @required this.refCode, this.model})
      : super(key: key);
  final String? token;
  final String? refCode;
  final dynamic model;

  @override
  State<VerifyThirdStepPage> createState() => _VerifyThirdStepPageState();
}

class _VerifyThirdStepPageState extends State<VerifyThirdStepPage> {
  final txtNumber1 = TextEditingController();
  final txtNumber2 = TextEditingController();
  final txtNumber3 = TextEditingController();
  final txtNumber4 = TextEditingController();
  final txtNumber5 = TextEditingController();
  final txtNumber6 = TextEditingController();

  final txtEmailNumber1 = TextEditingController();
  final txtEmailNumber2 = TextEditingController();
  final txtEmailNumber3 = TextEditingController();
  final txtEmailNumber4 = TextEditingController();
  final txtEmailNumber5 = TextEditingController();
  final txtEmailNumber6 = TextEditingController();
  bool loading = false;
  String image = '';

  // face recognition start
  var image1 = Regula.MatchFacesImage();
  var image2 = Regula.MatchFacesImage();
  var img1 = Image.asset('logo.png');
  var img2 = Image.asset('logo.png');
  // ignore: unused_field
  String _liveness = "nil";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
              const Text(
                'กรุณากรอกรหัสที่ท่านได้รับผ่านเบอร์โทรศัพท์',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/noti_phone.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _textFieldOTP(txtNumber1, first: true),
                  _textFieldOTP(txtNumber2),
                  _textFieldOTP(txtNumber3),
                  _textFieldOTP(txtNumber4),
                  _textFieldOTP(txtNumber5),
                  _textFieldOTP(txtNumber6, last: true),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'ท่านต้องการรับรหัสใหม่',
                    style: TextStyle(
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  if (_checkEmpty()) {
                    _validateOTP();
                  } else {
                    Fluttertoast.showToast(msg: 'OTP ไม่ครบ');
                  }
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
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
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/images/back.png',
                height: 40,
                width: 40,
              ),
            ),
          ),
          const Center(
            child: Text(
              'กรอกรหัส OTP',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  Widget _textFieldOTP(TextEditingController model,
      {bool first = false, bool last = false}) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: true,
        onChanged: (String value) async {
          if (value.isNotEmpty && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
          if (last && value.isNotEmpty) {
            FocusScope.of(context).unfocus();
            if (await _validateOTP()) {
              // _faceRecognition();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VerifyFourthStepPage(
                    model: widget.model,
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(msg: 'OTP ไม่ถูกต้อง');
            }
          }
        },
        showCursor: false,
        readOnly: false,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        // keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          // LengthLimitingTextInputFormatter(13),
        ],
        maxLength: 1,
        decoration: InputDecoration(
          counter: const Offstage(),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Color(0xFFA924F0)),
              borderRadius: BorderRadius.circular(12)),
        ),
        controller: model,
      ),
    );
  }

  _checkEmpty() {
    if (txtNumber1.text != '' &&
        txtNumber2.text != '' &&
        txtNumber3.text != '' &&
        txtNumber4.text != '' &&
        txtNumber5.text != '' &&
        txtNumber6.text != '') {
      return true;
    }
    return false;
  }

  _validateOTP() async {
    debugPrint('otp phone');
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.headers["api_key"] = "db88c29e14b65c9db353c9385f6e5f28";
    dio.options.headers["secret_key"] = "XpM2EfFk7DKcyJzt";
    var response =
        await dio.post('https://portal-otp.smsmkt.com/api/otp-validate', data: {
      "token": widget.token,
      "otp_code":
          '${txtNumber1.text}${txtNumber2.text}${txtNumber3.text}${txtNumber4.text}${txtNumber5.text}${txtNumber6.text}',
      "refCode": widget.refCode
    });
    var validate = response.data['result'];
    if (validate != null && validate['status']) {
      debugPrint(validate['status'].toString());
      return true;
    } else {
      debugPrint(validate['status'].toString());
      return false;
    }
  }

  _faceRecognition() {
    Regula.FaceSDK.presentFaceCaptureActivityWithConfig(
      {
        "cameraId": Regula.CameraPosition.Front,
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
      await updateSaveBase64(imageFile);
      // ------------- test
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VerifyFourthStepPage(
            model: widget.model,
          ),
        ),
      );
      // ------------- test
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

  updateSaveBase64(Uint8List imageFile) async {
    final tempDir = await getTemporaryDirectory();
    Random random = Random();
    final file =
        await File('${tempDir.path}/${random.nextInt(10000).toString()}.jpg')
            .create();
    file.writeAsBytesSync(imageFile);
    XFile xFile = XFile(file.path);

    await uploadImageId(xFile, widget.model['idcard']).then((res) {
      setState(() {
        image = res;
      });
    }).catchError((err) {
      debugPrint(err);
    });
  }

  _register() async {
    Dio dio = Dio();
    var response = await dio
        .post('http://122.155.223.63/td-des-api/m/Register/update', data: {
      'firstName': widget.model['fullName'].split(' ')[0],
      'lastName': widget.model['fullName'].split(' ')[1],
      'fullName': widget.model['fullName'],
      'age': widget.model['age'],
      'idcard': widget.model['idcard'],
      'birthDay': widget.model['birthday'],
      'imageUrl': image,
      // 'category': "face",
      'status': "N",
      'platform': Platform.operatingSystem.toString(),
    });

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      if (response.data['status'] == 'S') {
        Fluttertoast.showToast(msg: 'สำเร็จ');
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Menu(),
            ),
            (Route<dynamic> route) => false,
          );
        });
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: response.data['message'] ?? 'เกิดข้อผิดพลาด');
      }
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  Future<String> uploadImageId(XFile file, String id) async {
    Dio dio = Dio();

    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "ImageCaption": id,
      "Image": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    var response = await dio
        .post('https://raot.we-builds.com/des-document/upload', data: formData);
    return response.data['imageUrl'];
  }
}
