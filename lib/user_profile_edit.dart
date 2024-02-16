import 'dart:convert';
import 'dart:io';
import 'package:des/menu.dart';
import 'package:des/shared/image_picker.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'shared/config.dart';
import 'main.dart';
import 'shared/dcc.dart';
import 'shared/extension.dart';

class UserProfileEditPage extends StatefulWidget {
  UserProfileEditPage({Key? key}) : super(key: key);

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  String _imageProfile = '';
  bool _loadingSubmit = false;
  XFile? _imageFile;

  final txtEmail = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  dynamic _model;
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    super.dispose();
  }

  Future<dynamic> submit() async {
    try {
      setState(() => _loadingSubmit = true);
      File? file;
      if ((_imageFile?.path ?? '') != '') {
        file = File(_imageFile!.path);
      }

      var accessToken = await ManageStorage.read('accessToken') ?? '';

      FormData formData = FormData.fromMap({
        'Userid': _model['userid'],
        'Phonenumber': txtPhone.text,
        'photo': file != null
            ? await MultipartFile.fromFile(file.path,
                filename: _imageFile!.name)
            : null,
        'Firstname': _model['firstnameTh'],
        'Lastname': _model['lastnameTh'],
        'Email': _model['email'],
        'Dob': _model['dob'],
        'Gender': _model['gender'],
        'JobName': _model?['jobName'] ?? '',
        'LmsCat': _model?['lmsCat'] ?? '',
      });

      Response response = await Dio().put(
        '$ondeURL/api/user/UpdateById',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        // return response.data;
        if (response.data) {
          var profileMe = await _getProfileMe(accessToken);

          await ManageStorage.createSecureStorage(
            value: json.encode(profileMe['data']),
            key: 'profileMe',
          );
          setState(() => _loadingSubmit = false);
          _dialog(text: 'อัพเดตข้อมูลเรียบร้อยแล้ว');
        } else {
          setState(() => _loadingSubmit = false);
          logE(response);
          _dialog(
            text: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
            error: true,
          );
        }
      } else {
        logE(response.data);
        setState(() => _loadingSubmit = false);
        _dialog(
          text: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
          error: true,
        );
      }
    } on DioError catch (e) {
      logE(e.error);
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data['title'].toString();
      }
      Fluttertoast.showToast(msg: err);
      return null;
    }
  }

  dynamic _getProfileMe(String token) async {
    try {
      // get info
      if (token.isEmpty) return null;
      Response response = await Dio().get(
        '$ondeURL/api/user/ProfileMe',
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.json,
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        logE(response.data);
        Fluttertoast.showToast(msg: response.data['title']);
        setState(() => _loadingSubmit = false);
        return null;
      }
    } on DioError catch (e) {
      setState(() => _loadingSubmit = false);
      String err = e.error.toString();
      if (e.response != null) {
        err = e.response!.data['title'].toString();
      }
      Fluttertoast.showToast(msg: err);
      return null;
    }
  }

  _callRead() async {
    var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';

    setState(() {
      _model = profileMe;
      txtFirstName.text = profileMe['firstnameTh'];
      txtLastName.text = profileMe['lastnameTh'];
      txtPhone.text = profileMe['phonenumber'];
      txtEmail.text = profileMe['email'];
    });
    var img = await DCCProvider.getImageProfile();
    setState(() => _imageProfile = img);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: _buildHead(),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _modalImagePicker();
              },
              child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: _imageFile != null
                            ? Image.file(
                                File(_imageFile!.path),
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              )
                            : Image.memory(
                                base64Decode(_imageProfile),
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                errorBuilder: (_, __, ___) => Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFFA924F0),
                                    ),
                                  ),
                                  child: Text(
                                    'เพิ่มรูปภาพ +',
                                    style: TextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            height: 25,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7A4CB1)
                                    : Colors.black,
                                border: Border.all(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Color(0xFF7A4CB1)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                )),
                            child: Image.asset(
                              'assets/images/camera.png',
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.white
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                              // height: 25,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            TextFormField(
              controller: txtFirstName,
              decoration: _decorationBase(
                context,
                hintText: 'ชื่อ',
                readOnly: true,
              ),
              style: TextStyle(color: Theme.of(context).custom.b_w_y),
              readOnly: true,
              cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF7A4CB1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: txtLastName,
              decoration: _decorationBase(
                context,
                hintText: 'สกุล',
                readOnly: true,
              ),
              readOnly: true,
              style: TextStyle(
                fontFamily: 'Kanit',
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF7A4CB1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
            SizedBox(height: 15),
            SizedBox(height: 30),
            Text(
              'การติดต่อ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Kanit',
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: txtPhone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: _decorationBase(context, hintText: 'เบอร์ติดต่อ'),
              style: TextStyle(
                color: Theme.of(context).custom.b_w_y,
              ),
              cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF7A4CB1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.black
                      : Color(0xFFFFFD57),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: txtEmail,
              readOnly: true,
              decoration: _decorationBase(
                context,
                hintText: 'อีเมล',
                readOnly: true,
              ),
              style: TextStyle(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              cursorColor: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFF7A4CB1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
            SizedBox(height: 40),
            Stack(
              children: [
                GestureDetector(
                  onTap: () => submit(),
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'บันทึกข้อมูล',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (_loadingSubmit)
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            )
          ],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
        ],
      ),
    );
  }

  _dialog({required String text, bool error = false}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: const Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text(
              "ตกลง",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (!error) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Menu(),
                  ),
                  (Route<dynamic> route) => false,
                );
                // Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
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

  void _modalImagePicker() {
    bool loading = false;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter mSetState /*You can rename this!*/) {
          return SafeArea(
            child: SizedBox(
              height: 120 + MediaQuery.of(context).padding.bottom,
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Photo Library'),
                          onTap: () async {
                            try {
                              mSetState(() {
                                loading = true;
                              });
                              XFile? image = await ImagePickerFrom.gallery();

                              setState(() {
                                _imageFile = image;
                              });
                            } catch (e) {
                              Fluttertoast.showToast(msg: 'ลอกงอีกครั้ง');
                            }
                            if (!mounted) return;
                            mSetState(() {
                              loading = false;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Camera'),
                        onTap: () async {
                          try {
                            mSetState(() {
                              loading = true;
                            });
                            XFile? image = await ImagePickerFrom.camera();

                            setState(() {
                              _imageFile = image;
                            });
                          } catch (e) {
                            Fluttertoast.showToast(msg: 'ลอกงอีกครั้ง');
                          }
                          if (!mounted) return;
                          mSetState(() {
                            loading = false;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  if (loading)
                    const Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
