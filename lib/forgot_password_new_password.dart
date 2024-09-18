import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/widget/input_decoration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'forgot_password_complete.dart';
import 'login_first.dart';
import 'main.dart';

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
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  MyApp.themeNotifier.value == ThemeModeThird.light
                      ? "assets/images/BG.png"
                      : "",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 700,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 35.0,
                                  height: 35.0,
                                  margin: EdgeInsets.all(5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      'assets/images/back_profile.png',
                                      // color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'รีเซ็ตรหัสผ่าน',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Color(0xFFB325F8)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 55),
                            child: Text(
                              'กรุณากรอกข้อมูลเพื่อรีเซ็ตข้อมูลใหม่',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.black
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.50,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                                    height: 45,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFB325F8),
                                      borderRadius: BorderRadius.circular(23),
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
                              ],
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
                    ),
                  ),
                ),
              ],
            ),
          )

          //  SingleChildScrollView(
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //       top: MediaQuery.of(context).padding.top,
          //       bottom: MediaQuery.of(context).padding.bottom + 40,
          //       left: 20,
          //       right: 20,
          //     ),
          //     child: Form(
          //       key: _formKey,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const SizedBox(height: 20),
          //           Image.asset(
          //             'assets/images/logo.png',
          //             height: 55,
          //             width: 55,
          //           ),
          //           const SizedBox(height: 12),
          //           Text(
          //             'รีเซ็ตรหัสผ่าน',
          //             style: TextStyle(
          //               fontSize: 30,
          //               fontWeight: FontWeight.w700,
          //               color: Theme.of(context).primaryColor,
          //             ),
          //           ),
          //           const SizedBox(height: 58),
          //           AutofillGroup(
          //             child: Column(
          //               children: [
          //                 _buildFeildPassword(
          //                   controller: _passwordController,
          //                   hint: 'รหัสผ่านใหม่',
          //                   inputFormatters: InputFormatTemple.password(),
          //                   validateString: _passwordStringValidate,
          //                   visibility: _visibilityPassword,
          //                   suffixTap: () {
          //                     setState(() {
          //                       _visibilityPassword = !_visibilityPassword;
          //                     });
          //                   },
          //                   validator: (value) {
          //                     var result = ValidateForm.password(value!);
          //                     setState(() {
          //                       _passwordStringValidate = result ?? '';
          //                     });
          //                     return result == null ? null : '';
          //                   },
          //                 ),
          //                 const SizedBox(height: 30),
          //                 Stack(
          //                   children: [
          //                     GestureDetector(
          //                       onTap: () async {
          //                         FocusScope.of(context).unfocus();
          //                         final form = _formKey.currentState;
          //                         if (form!.validate()) {
          //                           form.save();
          //                           _send();
          //                         }
          //                       },
          //                       child: Container(
          //                         height: 50,
          //                         width: double.infinity,
          //                         alignment: Alignment.center,
          //                         decoration: BoxDecoration(
          //                           color: Theme.of(context).primaryColor,
          //                           borderRadius: BorderRadius.circular(7),
          //                           boxShadow: const [
          //                             BoxShadow(
          //                               blurRadius: 4,
          //                               color: Color(0x40F3D2FF),
          //                               offset: Offset(0, 4),
          //                             )
          //                           ],
          //                         ),
          //                         child: const Text(
          //                           'ยืนยัน',
          //                           style: TextStyle(
          //                             fontSize: 16,
          //                             fontWeight: FontWeight.w400,
          //                             color: Colors.white,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     if (_loadingSubmit)
          //                       const Positioned.fill(
          //                         child: Center(
          //                           child: SizedBox(
          //                             height: 20,
          //                             width: 20,
          //                             child: CircularProgressIndicator(),
          //                           ),
          //                         ),
          //                       ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

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
          height: 60,
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
            '$server/dcc-api/m/register/reset/password',
            data: {
              'email': widget.email,
              'password': _passwordController.text,
            },
          );

          setState(() => _loadingSubmit = false);
          if (!mounted) return;
          showSuccessDialog(context);

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => const ForgotPasswordCompletePage(),
          //   ),
          // );
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

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.5),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Color(0xFF19AA6A),
                size: 80,
              ),
              SizedBox(height: 12),
              Text(
                'รีเช็ทสำเร็จ!',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF19AA6A),
                ),
              ),
              Text(
                'รีเช็ทรหัสผ่านใหม่เรียบร้อยแล้ว',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
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
                // onTap: () async {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    color: Color(0xFFB325F8),
                  ),
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 15,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.purple,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //   ),
              //   child: Text(
              //     'ตกลง',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
