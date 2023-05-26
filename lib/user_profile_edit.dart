import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/menu.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserProfileEditPage extends StatefulWidget {
  UserProfileEditPage({Key? key}) : super(key: key);

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final storage = new FlutterSecureStorage();

  String _imageUrl = '';
  String? _code;

  String? _selectedPrefixName;

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtAge = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();
  dynamic rubberFarmer;
  Future<dynamic>? futureModel;

  ScrollController scrollController = new ScrollController();

  XFile? _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  String farmerIdCard = "";
  String farmerRubberTree = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtEmail.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    txtDate.dispose();
    super.dispose();
  }

  List<String> _genderList = ['ชาย', 'หญิง', 'อื่น ๆ'];
  String _gender = '';
  DateTime? now;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: _buildHead(),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
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
                _showPicker(context);
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
                        child: _imageUrl != ''
                            ? CachedNetworkImage(
                                imageUrl: _imageUrl,
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              )
                            : Container(
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
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Image.asset(
                          'assets/images/camera_circle_purple.png',
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            TextFormField(
              controller: txtFirstName,
              decoration: _decorationBase(context, hintText: 'ชื่อ'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: txtLastName,
              decoration: _decorationBase(context, hintText: 'สกุล'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => dialogOpenPickerDate(),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: txtDate,
                        style: TextStyle(
                          color: Color(0xFF7A4CB1),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 15.0,
                        ),
                        decoration: _decorationDate(context,
                            hintText: 'วันเดือนปีเกิด'),
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
                SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: txtAge,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9a-zA-Z.]')),
                    ],
                    decoration: _decorationBase(context, hintText: 'อายุ'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: txtPhone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: _decorationBase(context, hintText: 'เบอร์ติดต่อ'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: txtEmail,
              decoration: _decorationBase(context, hintText: 'อีเมล'),
            ),
            SizedBox(height: 20),
            Text(
              'เพศ',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(height: 4),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                separatorBuilder: (_, __) => SizedBox(width: 10),
                itemBuilder: (_, index) => _radioGender(_genderList[index]),
                itemCount: _genderList.length,
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () => submitUpdateUser(),
              child: Container(
                margin: EdgeInsets.only(top: 20),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xff7A4CB1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'บันทึกข้อมูล',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
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
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/images/arrow_back.png',
              height: 40,
              width: 40,
            ),
          ),
          // GestureDetector(
          //   onTap: () => submitUpdateUser(),
          //   child: Icon(
          //     Icons.check,
          //     color: Color(
          //       0xFFA924F0,
          //     ),
          //     size: 35,
          //   ),
          // )
        ],
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

  dialogOpenPickerDate() {
    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
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
        minTime: DateTime(1800, 1, 1),
        maxTime: DateTime(year, month, day), onConfirm: (date) {
      setState(
        () {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          txtDate.value = TextEditingValue(
            text: DateFormat("dd / MM / yyyy").format(date),
          );
          txtAge.text = (now!.year - date.year).toString();
        },
      );
    },
        currentTime: DateTime(
          _selectedYear,
          _selectedMonth,
          _selectedDay,
        ),
        locale: LocaleType.th);
  }

  static InputDecoration _decorationBase(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
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
        labelStyle: TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
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

  @override
  void initState() {
    readStorage();
    super.initState();
    now = new DateTime.now();
    setState(() {
      year = now!.year;
      month = now!.month;
      day = now!.day;
      _selectedYear = now!.year;
      _selectedMonth = now!.month;
      _selectedDay = now!.day;
    });
  }

  Future<dynamic> readUser() async {
    final response = await Dio().post("m/Register/read", data: {
      'code': _code,
    });

    var result = response.data;

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataUserLoginSSO',
        value: jsonEncode(result['objectData'][0]),
      );

      if (result['objectData'][0]['birthDay'] != '') {
        var date = result['objectData'][0]['birthDay'];
        var year = date.substring(0, 4);
        var month = date.substring(4, 6);
        var day = date.substring(6, 8);
        DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);

        // DateTime todayDate =
        //     DateTime.parse(todayDateBase);
        setState(() {
          _selectedYear = todayDate.year;
          _selectedMonth = todayDate.month;
          _selectedDay = todayDate.day;
          txtDate.text = DateFormat("dd / MM / yyyy").format(todayDate);
        });
      }

      setState(() {
        _imageUrl = result['objectData'][0]['imageUrl'] ?? '';
        txtFirstName.text = result['objectData'][0]['firstName'] ?? '';
        txtLastName.text = result['objectData'][0]['lastName'] ?? '';
        txtEmail.text = result['objectData'][0]['email'] ?? '';
        txtPhone.text = result['objectData'][0]['phone'] ?? '';
        _selectedPrefixName = result['objectData'][0]['prefixName'] ?? '';
        _code = result['objectData'][0]['code'] ?? '';
      });
    }
  }

  Future<dynamic> submitUpdateUser() async {
    var value = await ManageStorage.read('profileData') ?? '';
    var user = json.decode(value);
    user['imageUrl'] = _imageUrl;
    user['firstName'] = txtFirstName.text;
    user['lastName'] = txtLastName.text;
    user['email'] = txtEmail.text;
    user['phone'] = txtPhone.text;
    user['prefixName'] = _selectedPrefixName;
    user['birthDay'] = DateFormat("yyyyMMdd").format(
      DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
    );

    final response = await Dio()
        .post('http://122.155.223.63/td-des-api/m/Register/update', data: user);
    var result = response.data;
    if (result['status'] == 'S') {
      await ManageStorage.createProfile(
        key: result['objectData']['category'],
        value: result['objectData'],
      );
      setState(() {
        readStorage();
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
      );

      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'อัพเดตข้อมูลเรียบร้อยแล้ว',
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
                  color: Color(0xFF005C9E),
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
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'อัพเดตข้อมูลไม่สำเร็จ',
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
                  color: Color(0xFF005C9E),
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
    }
  }

  readStorage() async {
    var value = await ManageStorage.read('profileData') ?? '';
    var user = json.decode(value);

    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        txtFirstName.text = user['firstName'] ?? '';
        txtLastName.text = user['lastName'] ?? '';
        txtEmail.text = user['email'] ?? '';
        txtPhone.text = user['phone'] ?? '';
        _selectedPrefixName = user['prefixName'];
        _code = user['code'];
      });

      if (user['birthDay'] != '') {
        var date = user['birthDay'];
        var year = date.substring(0, 4);
        var month = date.substring(4, 6);
        var day = date.substring(6, 8);
        DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
        // DateTime todayDate = DateTime.parse(user['birthDay']);

        setState(() {
          _selectedYear = todayDate.year;
          _selectedMonth = todayDate.month;
          _selectedDay = todayDate.day;
          txtDate.text = DateFormat("dd / MM / yyyy").format(todayDate);
        });
      }
      readUser();
    }
  }

  _imgFromCamera() async {
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.camera, imageQuality: 1);

    // setState(() {
    //   _image = image;
    // });
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 1);

    setState(() {
      _image = image;
    });
    _upload();
  }

  _imgFromGallery() async {
    // File image = await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 1);

//  maxHeight: 240.0,
//     maxWidth: 240.0,

    // setState(() {
    //   _image = image;
    // });
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 1);

    setState(() {
      _image = image;
    });
    _upload();
  }

  void _upload() async {
    if (_image == null) return;

    _uploadImage(_image!).then((res) {
      setState(() {
        _imageUrl = res;
      });
    }).catchError((err) {
      print(err);
    });
  }

//upload with dio
  Future<String> _uploadImage(XFile file) async {
    Dio dio = new Dio();

    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "ImageCaption": "flutter",
      "Image": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    var response = await dio.post(
        'https://raot.we-builds.com/raot-document/upload',
        data: formData);
    return response.data['imageUrl'];
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
