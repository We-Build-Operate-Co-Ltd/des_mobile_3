import 'dart:math';

import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/widget/input_decoration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'forgot_password_complete.dart';
import 'menu.dart';

class ForgotPasswordNewPasswordPage extends StatefulWidget {
  const ForgotPasswordNewPasswordPage({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<ForgotPasswordNewPasswordPage> createState() =>
      _ForgotPasswordNewPasswordPageState();
}

class _ForgotPasswordNewPasswordPageState
    extends State<ForgotPasswordNewPasswordPage> {
  late TextEditingController _passwordController;
  late TextEditingController _conPasswordController;
  final _formKey = GlobalKey<FormState>();
  bool _loadingSubmit = false;
  String _passwordStringValidate = '';
  bool _visibilityPassword = true;

  @override
  void initState() {
    _passwordController = TextEditingController(text: '');
    _conPasswordController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _conPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF4FF),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom + 40,
              left: 20,
              right: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 55,
                    width: 55,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'รีเซ็ตรหัสผ่าน',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 58),
                  AutofillGroup(
                    child: Column(
                      children: [
                        _buildFeildPassword(
                          controller: _passwordController,
                          hint: 'รหัสผ่านใหม่',
                          inputFormatters: InputFormatTemple.password(),
                          validateString: _passwordStringValidate,
                          visibility: _visibilityPassword,
                          suffixTap: () {
                            setState(() {
                              _visibilityPassword = !_visibilityPassword;
                            });
                          },
                          validator: (value) {
                            var result = ValidateForm.password(value!);
                            setState(() {
                              _passwordStringValidate = result ?? '';
                            });
                            return result == null ? null : '';
                          },
                        ),
                        const SizedBox(height: 30),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                final form = _formKey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  _send();
                                }
                              },
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
                                  'ยืนยัน',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            if (_loadingSubmit)
                              const Positioned.fill(
                                child: Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeildPassword({
    required TextEditingController controller,
    String hint = '',
    Function(String?)? validator,
    String validateString = '',
    bool visibility = false,
    List<TextInputFormatter>? inputFormatters,
    Function? suffixTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.only(top: 12),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x40F3D2FF),
                offset: Offset(0, 4),
              )
            ],
          ),
          child: TextFormField(
            obscureText: visibility,
            controller: controller,
            style: const TextStyle(fontSize: 14),
            onEditingComplete: () => FocusScope.of(context).unfocus(),
            decoration: CusInpuDecoration.password(
              context,
              hintText: hint,
              visibility: visibility,
              suffixTap: suffixTap,
            ),
            inputFormatters: inputFormatters,
            validator: (String? value) => validator!(value),
          ),
        ),
        if (validateString.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 3),
            child: Text(
              validateString,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.red,
              ),
            ),
          )
      ],
    );
  }

  _send() async {
    try {
      setState(() => _loadingSubmit = true);
      // update password
      Response response = await Dio().post(
        '$ondeURL/api/user/resetpassword',
        data: {
          'email': widget.email,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        logWTF(response.data);
        if (response.data) {
          logWTF('success');
          await Dio().post(
            '$server/de-api/m/register/reset/password',
            data: {
              'email': widget.email,
              'password': _passwordController.text,
            },
          );

          setState(() => _loadingSubmit = false);
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ForgotPasswordCompletePage(),
            ),
          );
          return;
        }
      }
      setState(() => _loadingSubmit = false);
      logE(response.data);
      Fluttertoast.showToast(msg: response.data?['title'] ?? 'ลองใหม่อีกครั้ง');
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
}
