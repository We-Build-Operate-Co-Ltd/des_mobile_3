import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:des/login_first.dart';

class OtpEmailForgotPasswordPage extends StatefulWidget {
  @override
  _OtpEmailForgotPasswordPageState createState() =>
      _OtpEmailForgotPasswordPageState();
}

class _OtpEmailForgotPasswordPageState
    extends State<OtpEmailForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final txtEmail = TextEditingController();
  String text = '';

  @override
  void dispose() {
    txtEmail.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> submitForgotPassword() async {
    Dio().post('m/Register/forgot/password', data: {
      'email': txtEmail.text,
    });
    // final result = await postObjectData('m/Register/forgot/password', {
    //   'email': txtEmail.text,
    // });

    setState(() {
      txtEmail.text = '';
    });
    return showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(
          'รหัสผ่านที่ใช้ยืนยันตัวตนได้ส่งไปในอีเมลเรียบร้อยแล้ว',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ยกเลิก",
              style: TextStyle(
                fontSize: 13,
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

  void goBack() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginFirstPage(),
      ),
    );
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xFFF1B435), width: 0),
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFFF7F7F7),
        ),
        child: Center(
          child: Text(
            text[position],
            style: TextStyle(
              color: Color(0xFF7A4CB1),
              fontSize: 30,
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          // border: Border.all(color: Color(0xFFF1B435), width: 0),
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFFF7F7F7),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_login_page.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        // appBar: header(context, goBack),
        backgroundColor: Colors.transparent,
        body: ListView(
          children: <Widget>[
            SizedBox(height: 120),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ลืมรหัสผ่าน',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  'assets/images/close_noti_list.png',
                                  height: 18.52,
                                  width: 18.52,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'กรุณากรอกรหัสที่ท่านได้รับผ่านอีเมล',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            // constraints: const BoxConstraints(maxWidth: 500),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                otpNumberWidget(0),
                                otpNumberWidget(1),
                                otpNumberWidget(2),
                                otpNumberWidget(3),
                                otpNumberWidget(4),
                                // otpNumberWidget(5),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'ท่านต้องการรับรหัสใหม่',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          InkWell(
                            onTap: () {
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                submitForgotPassword();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                color: Color(0xFF7A4CB1),
                              ),
                              child: Text(
                                "ดำเนินการต่อ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
