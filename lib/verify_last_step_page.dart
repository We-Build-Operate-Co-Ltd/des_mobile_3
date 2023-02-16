import 'package:des/menu.dart';
import 'package:flutter/material.dart';

class VerifyLastStepPage extends StatefulWidget {
  const VerifyLastStepPage({
    Key? key,
    this.model,
  }) : super(key: key);
  final dynamic model;

  @override
  State<VerifyLastStepPage> createState() => _VerifyLastStepPageState();
}

class _VerifyLastStepPageState extends State<VerifyLastStepPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHead(),
          SizedBox(height: 20),
          _box(),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Menu(),
              ),
            ),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF7A4CB1),
              ),
              child: Text(
                'ส่งข้อมูล',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget _buildHead() {
    return SafeArea(
      child: Container(
        height: 60,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        child: Stack(
          children: [
            // Container(
            //   height: double.infinity,
            //   width: double.infinity,
            // ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/images/arrow_back.png',
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            Center(
              child: Text(
                'ตรวจสอบข้อมูล',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 300),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: Color(0xFFF6E6FE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ข้อมูลบัตรประชาชน',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 7),
                Container(
                  color: Colors.grey.withOpacity(0.4),
                  height: 1,
                ),
                SizedBox(height: 7),
                _text('ชื่อสกุล', widget.model['fullName']),
                _text('เลขบัตรประชาชน', widget.model['idcard']),
                _text(
                    'วันเดือนปีเกิด',
                    _dateStringToDateSlashBuddhistShort(
                        widget.model['birthday'])),
                _text('อายุ', widget.model['age']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _text(String title, String value) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF707070),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
    print(widget.model);
  }

  _dateStringToDateSlashBuddhistShort(String date) {
    if (date.isEmpty) return '';
    var year = date.substring(0, 4);
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    var yearBuddhist = int.parse(year) + 543;
    var yearBuddhistString = yearBuddhist.toString();
    var yearBuddhistStringShort = yearBuddhistString.substring(2, 4);
    return day + '/' + month + '/' + yearBuddhistStringShort;
  }
}
