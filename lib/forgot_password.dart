import 'package:des/otp_email_forgot_password.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:des/login_first.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final txtEmail = TextEditingController();

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
                  padding: EdgeInsets.all(20),
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
                            'กรุณากรอกอีเมลเพื่อทำการรับรหัสเพื่อรีเซ็ตข้อมูลใหม่',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          // textFormField(
                          //   txtEmail,
                          //   null,
                          //   'อีเมล',
                          //   'อีเมล',
                          //   true,
                          //   false,
                          //   true,
                          // ),
                          TextFormField(
                            controller: txtEmail,
                            decoration: _decorationRegisterMember(
                              context,
                              hintText: 'อีเมล',
                            ),
                            validator: (txtEmail) {
                              if (txtEmail!.isEmpty) {
                                return 'กรุณากรอก' + 'อีเมล' + '.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () async {
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                submitForgotPassword();
                                await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OtpEmailForgotPasswordPage(),
                                  ),
                                );
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
                                "รับรหัส",
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
    Dio().post('http://122.155.223.63/td-des-api/m/Register/forgot/password',
        data: {
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

    // if (result['status'] == 'S') {
    //   return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: Text(result['message'].toString()),
    //       );
    //     },
    //   );
    // } else {
    //   return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: Text(result['message'].toString()),
    //       );
    //     },
    //   );
    // }
  }

  void goBack() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginFirstPage(),
      ),
    );
  }
}
