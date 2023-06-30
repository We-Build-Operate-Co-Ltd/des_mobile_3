import 'dart:math';

import 'package:des/main.dart';
import 'package:des/shared/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FindJobPage extends StatefulWidget {
  const FindJobPage({super.key});

  @override
  State<FindJobPage> createState() => _FindJobPageState();
}

class _FindJobPageState extends State<FindJobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).custom.w_b_b,
      appBar: AppBar(
        backgroundColor: Theme.of(context).custom.w_b_b,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/images/back.png',
                  height: 40,
                  width: 40,
                ),
              ),
              Expanded(
                child: Text(
                  'หางาน',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).custom.b_w_y,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 15),
          _buildListCategory(),
          _buildListJob(),
        ],
      ),
    );
  }

  Widget _buildListCategory() {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => _buildItemCategory(MockFindJob.category[__]),
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemCount: MockFindJob.category.length,
      ),
    );
  }

  Widget _buildItemCategory(dynamic data) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 236, 233, 233),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                data['imageUrl'],
                height: 30,
                width: 30,
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 130,
              child: Text(
                data['title'],
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).custom.b_w_y,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              data['count'],
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).custom.f70f70_w_fffd57,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListJob() {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemBuilder: (_, __) => _buildItemJob(MockFindJob.data[__]),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: MockFindJob.data.length,
    );
  }

  _buildItemJob(dynamic data) {
    return Container(
      height: 180,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).custom.w_b_b,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  data['imageUrl'],
                  height: 80,
                  width: 80,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).custom.b325f8_w_fffd57,
                      ),
                    ),
                    Text(
                      data['organize'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).custom.b325f8_w_fffd57,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: Theme.of(context).custom.b_w_y,
                        ),
                        Text(
                          data['location'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).custom.b_w_y,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 13,
                          color: Theme.of(context).custom.b_w_y,
                        ),
                        Text(
                          data['type'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).custom.b_w_y,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data['description'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).custom.f70f70_w_fffd57,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(child: const SizedBox()),
                    Text(
                      'ค่าจ้าง ${data['salary']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).custom.b325f8_w_g,
              ),
              child: Text(
                'สมัครงานนี้',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).custom.w_b_y,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MockFindJob {
  static List<dynamic> category = [
    {
      'code': '0',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'โรงงาน/ผลิต/ควบคุมคุณภาพ',
      'count': '69,030'
    },
    {
      'code': '1',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'การขาย/การตลาด',
      'count': '60,132'
    },
    {
      'code': '2',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'ส่งเอกสาร/ขับรถ/แม่บ้าน/รปภ.',
      'count': '44,435'
    },
    {
      'code': '3',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'บัญชี/การเงิน',
      'count': '34,324'
    },
    {
      'code': '4',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'ช่าง/โฟร์แมน',
      'count': '30,450'
    },
    {
      'code': '5',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'ผู้บริหาร/ผู้จัดการ/ผู้อำนวยการ',
      'count': '28,130'
    },
  ];

  static List<dynamic> data = [
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'พนักงานฝ่ายผลิต ',
      'description': '-',
      'category': '0',
      'organize': 'บริษัท  แชมป์กบินทร์  จำกัด',
      'location': ' กบินทร์บุรี ปราจีนบุรี',
      'type': 'งานประจำ',
      'salary': '15,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'พนักงานฝ่ายผลิต',
      'description': 'ทำงานเป็นกะ',
      'category': '0',
      'organize': 'บริษัท จี-เทคคุโตะ (ประเทศไทย) จำกัด',
      'location': 'กทม',
      'type': 'งานประจำ',
      'salary': '12,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'พนักงานขับรถส่งสินค้า',
      'description': '-',
      'category': '0',
      'organize': 'บริษัท อินชา บีฟ จำกัด',
      'location': 'ชลบุรี',
      'type': 'งานประจำ',
      'salary': '450'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'พนักงานฝ่ายผลิต',
      'description': 'ทำงานเป็นกะ',
      'category': '0',
      'organize': 'บริษัท จี-เทคคุโตะ (ประเทศไทย) จำกัด',
      'location': 'อ่างทอง',
      'type': 'งานประจำ',
      'salary': '15,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'คอมพิวเตอร์ กราฟฟิค',
      'description':
          'สามารถใช้โปรแกรม Photoshop ได้ หรืิโปรแกรมเกี่ยวกับ การแต่งภาพ ตัดต่อวิดีโอ ได้ สามารถดูแลซ่อม บำรุง ระบบคอมพิวเตอร์เบื้องต้นได้',
      'category': '0',
      'organize': 'บริษัท ไทยพิพัฒน์ทูล แอนด์ โฮมมาร์ท จำกัด',
      'location': 'เมืองอุดรธานี อุดรธานี',
      'type': 'งานประจำ',
      'salary': '25,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'Sales E -commerce',
      'description': '-',
      'category': '1',
      'organize': 'บ.ทีแม็กซ์ คอร์ปอเรชั่น จำกัด',
      'location': 'เมืองชลบุรี ชลบุรี',
      'type': 'งานประจำ',
      'salary': '14,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'QC ไลน์ผลิต',
      'description': 'ประกันสังคม',
      'category': '0',
      'organize': 'บริษัท สานิตแอนด์ซันส์ จำกัด (สาขานครนายก)',
      'location': 'เมืองชลบุรี ชลบุรี',
      'type': 'งานประจำ',
      'salary': '11,500'
    },
  ];
}
