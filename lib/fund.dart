import 'package:des/shared/theme_data.dart';
import 'package:flutter/material.dart';

import 'shared/config.dart';

class FundPage extends StatefulWidget {
  const FundPage({super.key});

  @override
  State<FundPage> createState() => _FundPageState();
}

class _FundPageState extends State<FundPage> {
  final List<dynamic> _model = [
    {
      'title': 'สินเชื่อ SME ยอดขายต่อปี  ไม่เกิน 20 ล้านบาท',
      'imageUrl': '$server/de-document/images/event/event_233702565.png',
      'description': '',
    },
    {
      'title': 'สินเชื่อที่ใช้ เงินฝาก/สลาก/กรมธรรม์ ค้ำประกัน',
      'imageUrl': '$server/de-document/images/event/event_234017074.png',
      'description': 'อิสระทุกการใช้จ่าย ง่ายทุกความต้องการ ',
    },
    {
      'title': 'สินเชื่อเพื่อการค้าระหว่างประเทศ',
      'imageUrl': '$server/de-document/images/event/event_234248716.jpg',
      'description': '',
    },
    {
      'title': 'สินเชื่อเคหะ',
      'imageUrl': '$server/de-document/images/event/event_234610362.jpg',
      'description': 'ช่วยสานฝันให้เป็นจริงด้วยเงื่อนไขสบายๆ และไม่ยุ่งยาก',
    },
    {
      'title': 'สินเชื่อบุคคล',
      'imageUrl': '$server/de-document/images/event/event_234500235.jpg',
      'description': 'ให้ทุกความต้องการของคุณเป็นจริง',
    },
    {
      'title': 'สินเชื่อจำนำทะเบียนรถ',
      'imageUrl': '$server/de-document/images/event/event_235056315.jpg',
      'description':
          'อนุมัติไว ผ่อนอยู่ ก็กู้ได้ รีไฟแนนซ์ง่าย ไม่ต้องโอนเล่ม ไม่เช็กประวัติทางการเงิน',
    },
    {
      'title': 'บริการสินเชื่อเพื่อการนำเข้า',
      'imageUrl': '$server/de-document/images/event/event_235414876.jpg',
      'description':
          'เงินทุนหมุนเวียนเพื่อผู้นำเข้าสำหรับชำระค่าสินค้าและบริการ ให้ธุรกิจไม่หยุดชะงัก',
    },
  ];
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
                  'หาแหล่งทุน',
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
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemBuilder: (context, index) => _buildItem(_model[index]),
        itemCount: _model.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
      ),
    );
  }

  _buildItem(dynamic data) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).custom.w_b_b,
        borderRadius: BorderRadius.circular(4),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  data['imageUrl'],
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).custom.b_w_y,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data['description'],
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).custom.f70f70_w_fffd57,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'อ่านเพิ่มเติม',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).custom.b325f8_w_fffd57,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
