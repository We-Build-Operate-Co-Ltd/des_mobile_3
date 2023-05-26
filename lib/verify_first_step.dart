import 'package:des/verify_second_step.dart';
import 'package:flutter/material.dart';

class VerifyFirstStepPage extends StatelessWidget {
  const VerifyFirstStepPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/bg_id_register.png',
              fit: BoxFit.fitWidth,
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
          color: Colors.white,
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
            const Text(
              'ยืนยันตัวตน',
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFF53327A),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'เพียงทำ 3 ขั้นตอน',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Image.asset(
                  'assets/images/check_purple.png',
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: const Text(
                    'สมัครใช้แอปฯ “DES ดิจิทัลชุมชน”',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset(
                  'assets/images/id_icon.png',
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: const Text(
                    'กรอกข้อมูลบัตรประชาชน',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset(
                  'assets/images/icon_email.png',
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 15),
                const Text(
                  'OTP ผ่านอีเมล',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset(
                  'assets/images/icon_phone.png',
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 15),
                const Text(
                  'OTP เบอร์โทรศัพท์',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset(
                  'assets/images/scan_icon.png',
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 15),
                const Text(
                  'สแกนใบหน้า',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'ประโยชน์ที่ได้รับ',
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFF53327A),
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
                    color: const Color(0xFF53327A),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: const Text(
                    'เพิ่มความปลอดภัยในการใช้บริการ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
                    color: const Color(0xFF53327A),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: const Text(
                    'อำนวยความสะดวกเมื่อเข้าใช้บริการที่ศูนย์ฯ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF7A4CB1),
                  ),
                  child: const Text(
                    'ดำเนินการต่อ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
        child: Image.asset(
          'assets/images/back.png',
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
