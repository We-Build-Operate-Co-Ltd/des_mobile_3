import 'package:des/shared/config.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:des/login_first.dart';

import 'main.dart';

class ForgotPasswordCompletePage extends StatefulWidget {
  const ForgotPasswordCompletePage({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPasswordCompletePageState createState() =>
      _ForgotPasswordCompletePageState();
}

class _ForgotPasswordCompletePageState
    extends State<ForgotPasswordCompletePage> {
  final _formKey = GlobalKey<FormState>();

  String text = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF4FF),
        extendBody: true,
        body: ListView(
          children: [
            const SizedBox(height: 100),
            Image.asset(
              'assets/images/lock.png',
              height: 162.57,
              width: 96.58,
            ),
            const SizedBox(height: 15),
            Text(
              'ได้ทำการส่งรหัสผ่านใหม่ไปยังอีเมลของคุณแล้ว',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () async {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginFirstPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x40F3D2FF),
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Text(
                    'ปิด',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
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
