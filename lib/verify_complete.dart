import 'package:des/login_first.dart';
import 'package:des/menu.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyCompletePage extends StatefulWidget {
  const VerifyCompletePage({super.key, this.action = 'create'});

  final String action;

  @override
  State<VerifyCompletePage> createState() => _VerifyCompletePageState();
}

class _VerifyCompletePageState extends State<VerifyCompletePage> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {});
    _clearData();
    super.initState();
  }

  _clearData() async {
    ManageStorage.deleteStorage('tempRegister');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('thaiDCode');
    await prefs.remove('thaiDState');
    await prefs.remove('thaiDAction');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF4FF),
        body: Center(
          child: SizedBox(
            height: 330,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/like_success.png',
                  height: 150,
                  width: 150,
                ),
                Text(
                  'ลงทะเบียนสมาชิก\nและยืนยันตัวตนสำเร็จ!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.action == 'create') {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginFirstPage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const Menu(),
                          ),
                          (Route<dynamic> route) => false,
                        );
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
                        'OK',
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
        ),
      ),
    );
  }
}
