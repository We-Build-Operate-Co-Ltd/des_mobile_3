import 'package:des/shared/theme_data.dart';
import 'package:des/verify_second_step.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class VerifyFirstStepPage extends StatelessWidget {
  const VerifyFirstStepPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.only(top: 40),
              child: Image.asset(
                MyApp.themeNotifier.value == ThemeModeThird.light
                    ? 'assets/images/bg_id_register_1.png'
                    : 'assets/images/bg_id_register-d.png',
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          _center(context),
          _backButton(context),
        ],
      ),
    );
  }

  Widget _center(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        constraints: const BoxConstraints(minHeight: 500),
        decoration: BoxDecoration(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.white
              : Color(0xFF292929),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ยืนยันตัวตน',
              style: TextStyle(
                fontSize: 25,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFF53327A)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'เพียงทำ 3 ขั้นตอน',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Container(
                    height: 30,
                    width: 30,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFB325F8)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 15,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFB325F8)
                          : Colors.white,
                      ),
                    )
                    // Image.asset(
                    //   'assets/images/check_purple.png',
                    //   height: 30,
                    //   width: 30,
                    // ),
                    ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'สมัครใช้แอปฯ “DES ดิจิทัลชุมชน”',
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
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                iconStep('assets/images/id_icon.png'),
                // Image.asset(
                //   'assets/images/id_icon.png',
                //   height: 30,
                //   width: 30,
                // ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'กรอกข้อมูลบัตรประชาชน',
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
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                iconStep('assets/images/icon_email.png'),
                // Image.asset(
                //   'assets/images/icon_email.png',
                //   height: 30,
                //   width: 30,
                // ),
                const SizedBox(width: 15),
                Text(
                  'OTP ผ่านอีเมล',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                iconStep('assets/images/icon_phone.png'),
                // Image.asset(
                //   'assets/images/icon_phone.png',
                //   height: 30,
                //   width: 30,
                // ),
                const SizedBox(width: 15),
                Text(
                  'OTP เบอร์โทรศัพท์',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                iconStep('assets/images/scan_icon.png'),
                // Image.asset(
                //   'assets/images/scan_icon.png',
                //   height: 30,
                //   width: 30,
                // ),
                const SizedBox(width: 15),
                Text(
                  'สแกนใบหน้า',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'ประโยชน์ที่ได้รับ',
              style: TextStyle(
                fontSize: 25,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFF53327A)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF53327A)
                        : Color(0xFF707070),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'เพิ่มความปลอดภัยในการใช้บริการ',
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
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF53327A)
                        : Color(0xFF707070),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'อำนวยความสะดวกเมื่อเข้าใช้บริการที่ศูนย์ฯ',
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
                )
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => const VerifySecondStepPage(),
                  ),
                ),
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.5),
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF7A4CB1)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  child: Text(
                    'ดำเนินการต่อ',
                    style: TextStyle(
                      fontSize: 16,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 15,
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
    );
  }

  Widget iconStep(String asset) {
    return Container(
      height: 30,
      width: 30,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFFEEEEEE)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Color(0xFF121212)
                  : Color(0xFF121212),
          border: Border.all(
            width: 1,
            style: BorderStyle.solid,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFEEEEEE)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          )),
      child: Image.asset(
        asset,
        color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : Colors.white,
        // height: 30,
        // width: 30,
      ),
    );
  }
}
