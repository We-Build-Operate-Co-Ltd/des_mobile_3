import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:des/menu.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/verify_complete.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class VerifyLastStepPage extends StatefulWidget {
  const VerifyLastStepPage({Key? key}) : super(key: key);

  @override
  State<VerifyLastStepPage> createState() => _VerifyLastStepPageState();
}

class _VerifyLastStepPageState extends State<VerifyLastStepPage> {
  bool _loadindSubmit = false;
  late Uint8List imageUint8List;
  dynamic _userData = {};
  String _email = '';
  String _image = '';
  dynamic thaiDData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      body: Column(
        children: [
          _buildHead(),
          SizedBox(height: 20),
          _box(),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _save();
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
                    'ส่งข้อมูล',
                    style: TextStyle(
                      fontSize: 16,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              if (_loadindSubmit)
                Positioned.fill(
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
          SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget _buildHead() {
    return SafeArea(
      child: Container(
        height: 60,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        child: Stack(
          children: [
            // Container(
            //   height: double.infinity,
            //   width: double.infinity,
            // ),
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
                'ตรวจสอบข้อมูล',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _box() {
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 300),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFF6E6FE)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ข้อมูลบัตรประชาชน',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black.withOpacity(0.5)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                  height: 1,
                ),
                SizedBox(height: 17),
                _text(
                    'ชื่อสกุล',
                    thaiDData['given_name'] ??
                        '' + ' ' + thaiDData['family_name'] ??
                        ''),
                _text('เลขบัตรประชาชน', thaiDData['pid'] ?? ''),
                _text('วันเดือนปีเกิด', thaiDData['birthdate'] ?? ''),
                // _text('อีเมล', _userData['email'] ?? ''),
                _text('เพศ', thaiDData['gender'] == 'male' ? 'ชาย' : 'หญิง'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _text(String title, String value) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF707070),
            ),
          ),
          Text(
            '${value}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.black
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
    _getThaiD();
  }

  _getThaiD() async {
    var value = await ManageStorage.read('profileData') ?? '';
    var user = json.decode(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String thaiDToken = await prefs.getString('thaiDToken') ?? '';
    Map<String, dynamic> idData = JwtDecoder.decode(thaiDToken);
    setState(() {
      _userData = user;
      thaiDData = {
        'pid': idData['pid'],
        'name': '',
        'name_th': '',
        'birthdate': idData['birthdate'],
        'address': idData['address']['formatted'],
        'given_name': idData['given_name'],
        'middle_name': '',
        'family_name': idData['family_name'],
        'given_name_en': '',
        'middle_name_en': '',
        'family_name_en': '',
        'gender': idData['gender'],
      };
    });
  }

  _getImageUnit8List() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? action = prefs.getString('imageTemp');
    setState(() {
      imageUint8List = Uint8List.fromList(action!.codeUnits);
    });
  }

  updateSaveBase64(Uint8List imageFile) async {
    final tempDir = await getTemporaryDirectory();
    Random random = Random();
    final file =
        await File('${tempDir.path}/${random.nextInt(10000).toString()}.jpg')
            .create();
    file.writeAsBytesSync(imageFile);
    XFile xFile = XFile(file.path);

    await uploadImageId(xFile, _userData['idcard']).then((res) {
      setState(() {
        _image = res;
      });
    }).catchError((err) {
      Fluttertoast.showToast(msg: 'ลองใหม่อีกครั้ง');
      debugPrint(err);
    });
  }

  Future<String> uploadImageId(XFile file, String id) async {
    Dio dio = Dio();
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "ImageCaption": id,
      "Image": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    var response = await dio
        .post('https://des.we-builds.com/de-document/upload', data: formData);
    return response.data['imageUrl'];
  }

  _save() async {
    try {
      setState(() {
        _loadindSubmit = true;
      });

      // await updateSaveBase64(imageUint8List);
      // _userData['imageUrl'] = _image;

      var value = await ManageStorage.read('profileData') ?? '';
      var user = json.decode(value);

      // user['firstName'] = _userData['fullName'].split(' ')[0];
      // user['lastName'] = _userData['fullName'].split(' ')[1];
      // user['fullName'] = _userData['fullName'];
      // user['age'] = _userData['age'];
      // user['email'] = _email;
      // user['imageUrl'] = _image;
      // user['idcard'] = _userData['idcard'];
      // user['birthday'] = _userData['birthday'];
      // user['phone'] = _userData['phone'];
      // user['category'] = "guest";
      // user['address'] = _userData['address'];
      // user['provinceCode'] = _userData['provinceCode'];
      // user['province'] = _userData['province'];
      // user['amphoeCode'] = _userData['amphoeCode'];
      // user['amphoe'] = _userData['amphoe'];
      // user['tambonCode'] = _userData['tambonCode'];
      // user['tambon'] = _userData['tambon'];
      // user['postnoCode'] = _userData['postnoCode'];
      // user['postno'] = _userData['postno'];
      user['status'] = "A";
      user['isActive'] = true;
      user['hasThaiD'] = true;
      user['thaiID'] = thaiDData;
      logWTF(user);

      final response = await Dio().post(
          'https://des.we-builds.com/de-api/m/Register/user/verify/update',
          data: user);

      var result = response.data;
      setState(() => _loadindSubmit = false);
      if (result['status'] == 'S') {
        await ManageStorage.createProfile(
          value: user,
          key: 'guest',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCompletePage(action: 'update'),
          ),
        );
      } else {
        setState(() => _loadindSubmit = false);
        debugPrint(result['message']);
        Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      setState(() => _loadindSubmit = false);
      debugPrint(e.toString());
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _dateStringToDateSlashBuddhistShort(String date) {
    if (date.isEmpty) return '';
    var year = date.substring(0, 4);
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    var yearBuddhist = int.parse(year) + 543;
    var yearBuddhistString = yearBuddhist.toString();
    var yearBuddhistStringShort = yearBuddhistString.substring(2, 4);
    return day + '/' + month + '/' + yearBuddhistStringShort;
  }
}
