import 'package:des/verify_fouth_step.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyThirdStepPage extends StatefulWidget {
  const VerifyThirdStepPage({Key? key, this.model}) : super(key: key);
  final dynamic model;

  @override
  State<VerifyThirdStepPage> createState() => _VerifyThirdStepPageState();
}

class _VerifyThirdStepPageState extends State<VerifyThirdStepPage> {
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                const Text(
                  'กรุณากรอกเบอร์โทรศัพท์ของท่าน เพื่อทำการรับรหัสสำหรับยืนยัน',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration:
                      _decorationBase(context, hintText: 'เบอร์โทรศัพท์'),
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
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'กรุณากรอกอีเมล์ของท่าน เพื่อทำการรับรหัสสำหรับยืนยัน',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9a-zA-Z@!_.-]')),
                  ],
                  decoration: _decorationBase(context, hintText: 'อีเมล์'),
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
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF7A4CB1),
                    ),
                    child: const Text(
                      'รับรหัส',
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
              'OTP ผ่านเบอร์โทรศัพท์',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  static InputDecoration _decorationBase(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: const TextStyle(
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
          borderSide: const BorderSide(color: Color(0xFFA924F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFA924F0)),
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
    _phoneController = TextEditingController();
    super.initState();
  }

  _requestOTP() async {
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.headers["api_key"] = "db88c29e14b65c9db353c9385f6e5f28";
    dio.options.headers["secret_key"] = "XpM2EfFk7DKcyJzt";
    var response =
        await dio.post('https://portal-otp.smsmkt.com/api/otp-send', data: {
      "project_key": "XcvVbGHhAi",
      "phone": _phoneController!.text.replaceAll('-', '').trim(),
      "ref_code": "xxx123"
    });

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

    var otp = response.data['result'];
    if (otp['token'] != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyFourthStepPage(
            token: otp['token'],
            refCode: otp['ref_code'],
            model: widget.model,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }
}
