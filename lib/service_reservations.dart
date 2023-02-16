import 'package:flutter/material.dart';
import 'models/user.dart';
import 'news_service_reservations.dart';

class ServiceReservationsPage extends StatefulWidget {
  const ServiceReservationsPage({Key? key, this.userData}) : super(key: key);
  final User? userData;

  @override
  State<ServiceReservationsPage> createState() => _ServiceReservationsState();
}

class _ServiceReservationsState extends State<ServiceReservationsPage> {
  dynamic model = {
    "title": 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน',
    "description": 'หมู่ที่ 5 99/99 ตำบล เสาธงหิน อำเภอบางใหญ่ นนทบุรี 11140',
    "time": '11:00:00',
    "date": '20220911110000',
    "timeOfUse": '3',
  };

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
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'เรียงตาม',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF53327A),
                ),
              ),
              Row(
                children: [
                  const Text(
                    'วันใช้งาน',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFB325F8),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Image.asset(
                    'assets/images/arrow_down.png',
                    width: 11,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NewsServiceReservationsPage(),
          ),
        );
      },
      child: Container(
        // color: Colors.red,
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/notebook_rounded.png',
                  width: 35,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model['title']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7A4CB1),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        '${model['description']}',
                        style: const TextStyle(
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
            const SizedBox(height: 17),
            Row(
              children: [
                const SizedBox(width: 50),
                Image.asset(
                  'assets/images/calendar_check.png',
                  width: 10,
                ),
                const SizedBox(width: 5),
                Text(
                  _dateStringToDateSlashBuddhistShort(model['date']),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF53327A),
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/images/time_user_profile_page.png',
                  width: 10,
                ),
                const SizedBox(width: 5),
                Text(
                  '${model['time']} น.',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF53327A),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${model['timeOfUse']} ชั่วโมง',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF53327A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const SizedBox(width: 50),
                Expanded(
                  child: Container(
                    height: 1,
                    color: const Color(0xFF707070),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      color: Colors.white,
      child: const Center(
        child: Text(
          'จองบริการ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  _dateStringToDateSlashBuddhistShort(String date) {
    if (date.isEmpty) return '';
    var year = date.substring(0, 4);
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    var yearBuddhist = int.parse(year) + 543;
    var yearBuddhistString = yearBuddhist.toString();
    var yearBuddhistStringShort = yearBuddhistString.substring(2, 4);
    return '$day/$month/$yearBuddhistStringShort';
  }
}
