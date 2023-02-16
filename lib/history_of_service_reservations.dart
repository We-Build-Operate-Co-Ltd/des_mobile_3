import 'package:flutter/material.dart';

class HistoryOfServiceReservationsPage extends StatefulWidget {
  HistoryOfServiceReservationsPage({
    Key? key,
  }) : super(key: key);
  @override
  _HistoryOfServiceReservationsState createState() =>
      _HistoryOfServiceReservationsState();
}

class _HistoryOfServiceReservationsState
    extends State<HistoryOfServiceReservationsPage> {
  dynamic model = {
    "title": 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน',
    "description": 'หมู่ที่ 5 99/99 ตำบล เสาธงหิน อำเภอบางใหญ่ นนทบุรี 11140',
    "time": '11:00:00',
    "date": '20220911110000',
    "timeOfUse": '3',
  };

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 25,
          right: 15,
          left: 15,
        ),
        children: [
          _buildHead(),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เรียงตาม',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF53327A),
                ),
              ),
              Row(
                children: [
                  Text(
                    'วันใช้งาน',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFB325F8),
                    ),
                  ),
                  SizedBox(width: 6),
                  Image.asset(
                    'assets/images/arrow_down.png',
                    width: 11,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 25),
          ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: 25),
            itemBuilder: (context, _) {
              return _buildHistoryOfServiceReservations(model);
            },
          )
          //
        ],
      ),
    );
  }

  Widget _buildHistoryOfServiceReservations(model) {
    // String title, String title2, int hour, String date, String time
    return Container(
      // color: Colors.red,
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/notebook_rounded.png',
                width: 35,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A4CB1),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      '${model['description']}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF707070),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 17),
          Row(
            children: [
              SizedBox(width: 50),
              Image.asset(
                'assets/images/calendar_check.png',
                width: 10,
              ),
              SizedBox(width: 5),
              Text(
                _dateStringToDateSlashBuddhistShort(model['date']),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF53327A),
                ),
              ),
              SizedBox(width: 10),
              Image.asset(
                'assets/images/time_user_profile_page.png',
                width: 10,
              ),
              SizedBox(width: 5),
              Text(
                '${model['time']} น.',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF53327A),
                ),
              ),
              SizedBox(width: 10),
              Text(
                '${model['timeOfUse']} ชั่วโมง',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF53327A),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              SizedBox(width: 50),
              Expanded(
                child: Container(
                  height: 1,
                  color: Color(0xFF707070),
                ),
              ),
            ],
          ),
          // SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 13),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset('assets/images/back.png',
                    height: 40, width: 40),
              ),
              SizedBox(width: 34),
              Text(
                'ประวัติการจองใช้บริการ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
//
}
