import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/fund_detail.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'shared/config.dart';

class FundPage extends StatefulWidget {
  const FundPage({super.key});

  @override
  State<FundPage> createState() => _FundPageState();
}

class _FundPageState extends State<FundPage> {
  dynamic _model = [];
  dynamic _tempModel = [];
  dynamic _categoryModel = [];
  dynamic _investor = [];

  int _typeSelected = 0;
  int i = 2;

  List<dynamic> cateFund = [
    'ค้นหาแหล่งทุน',
    'แหล่งทุนภายนอก',
    'ความรู้ด้านการเงินและการลงทุน',
  ];

  List<dynamic> _fundExternal = [
    {
      'code': '0',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/fund1.6ebd50eb.png',
      'title': 'สถาบันวัคซีนแห่งชาติ (NVI)',
      'linkUrl': 'https://nvi.go.th/funding-announce/',
    },
    {
      'code': '1',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/fund2.fdd45b33.png',
      'title': 'สำนักงานส่งเสริมเศรษฐกิจดิจิมัล (DEPA)',
      'linkUrl': 'https://www.depa.or.th/th/funds',
    },
    {
      'code': '2',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/fund3.763d9bd0.png',
      'title': 'สำนักงานวัตกรรมแห่งชาติ (องค์การมหาชน) (NIA)',
      'linkUrl': 'https://www.nia.or.th/service/financial-support',
    },
    {
      'code': '3',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/fund4.31286789.png',
      'title': 'สำนักงานพัฒนาการวิจัยการเกษตร (องค์การมหาชน) (ARDA)',
      'linkUrl': 'https://www.arda.or.th/',
    },
    {
      'code': '4',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/fund5.84504eb7.png',
      'title': 'สำนักงานการวิจัยแห่งชาติ (NRCT)',
      'linkUrl': 'https://www.arda.or.th/',
    },
    {
      'code': '5',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/fund6.3ef385b6.png',
      'title':
          'กองทุนพัฒนาผู้ประกอบการเทคโนฌลยีและนวัตกรรม กระทรวงอุดมศึกษา วิทยาศาสตร์ วิจัยและนวัตกรรม',
      'linkUrl': 'https://tedfund.mhesi.go.th/index.php#',
    },
  ];

  List<dynamic> _fundFinancial = [
    {
      'code': '0',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/knowledge1.b7467469.png',
      'title': 'SET',
      'linkUrl': 'https://www.set.or.th/th/education-research/education/main',
    },
    {
      'code': '1',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/knowledge2.c0b4bbcd.png',
      'title': 'กระทรวงพาณิชย์',
      'linkUrl': 'https://www.moc.go.th/th',
    },
    {
      'code': '2',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/knowledge3.7de4d4a3.png',
      'title': 'ธนาคารแห่งประเทศไทย',
      'linkUrl':
          'https://www.bot.or.th/th/satang-story/fin-d-we-can-do/teachingtool.bot-responsive.html',
    },
    {
      'code': '3',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/knowledge4.55b0beb0.png',
      'title': 'SMART TO INVEST',
      'linkUrl': 'https://www.smarttoinvest.com/pages/home.aspx',
    },
    {
      'code': '4',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/knowledge5.4b263873.png',
      'title': 'รู้เรื่องเงิน.com',
      'linkUrl': 'https://www.รู้เรื่องเงิน.com/home',
    },
    {
      'code': '5',
      'imageUrl':
          'https://dcc.onde.go.th/_next/static/media/knowledge6.fdfcdbf5.png',
      'title': 'กองทุนการออมแห่งชาติ',
      'linkUrl': 'https://www.nsf.or.th/',
    },
  ];

  @override
  void initState() {
    _callRead();
    _category();
    _callReadInvestor();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Card(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.white
                  : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              elevation: 5,
              child: Container(
                padding:
                    EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    children: [
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
                            'สรรหาแหล่งทุน',
                            style: TextStyle(
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
                      SizedBox(height: 20),
                      _buildListFundCategory(),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          cateFund[_typeSelected],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFFB325F8),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (_typeSelected == 0)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              // width: double.infinity,
                              child: TextField(
                                onChanged: (text) {
                                  print("First text field: $text");
                                  setState(() {
                                    _filtter(text);
                                  });
                                },
                                style: TextStyle(
                                  color: const Color(0xff020202),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xfff1f1f1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'พิมพ์คำค้นหา',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                    decorationThickness: 6,
                                  ),
                                  prefixIcon: const Icon(Icons.search),
                                  prefixIconColor: Colors.black,
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        _showModelBottonSheetFund(context);
                                      },
                                      child: Image.asset(
                                          'assets/images/filter.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFFB325F8),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Color(0x40F3D2FF),
                                      offset: Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: const Text(
                                  'ค้นหาแหล่งทุน',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 2,
                              color: Color(0xFFDDDDDD),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'แหล่งทุนทั้งหมด',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFFB325F8),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _buildListInvestor(),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  i += 5;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Color(0xFFB325F8),
                                  ),
                                ),
                                child: const Text(
                                  'ดูเพิ่มเติ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFB325F8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),

                      // if (_typeSelected == 0) _buildList(),
                      if (_typeSelected == 1) _buildListExternal(),
                      if (_typeSelected == 2) _buildListFinancial(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Scaffold(
    //     backgroundColor: Theme.of(context).custom.w_b_b,
    //     appBar: AppBar(
    //       backgroundColor: Theme.of(context).custom.w_b_b,
    //       automaticallyImplyLeading: false,
    //       flexibleSpace: Container(
    //         width: double.infinity,
    //         padding: EdgeInsets.only(
    //           top: MediaQuery.of(context).padding.top + 10,
    //           left: 15,
    //           right: 15,
    //         ),
    //         child: Row(
    //           children: [
    //             InkWell(
    //               onTap: () {
    //                 Navigator.pop(context);
    //               },
    //               child: Image.asset(
    //                 'assets/images/back.png',
    //                 height: 40,
    //                 width: 40,
    //               ),
    //             ),
    //             Expanded(
    //               child: Text(
    //                 'ค้นหาแหล่งทุน',
    //                 style: TextStyle(
    //                   fontSize: 20,
    //                   fontWeight: FontWeight.w500,
    //                   color: Theme.of(context).custom.b_w_y,
    //                 ),
    //                 textAlign: TextAlign.center,
    //               ),
    //             ),
    //             SizedBox(width: 40),
    //           ],
    //         ),
    //       ),
    //     ),
    //     body: ListView(
    //       physics: BouncingScrollPhysics(),
    //       children: [
    //         SizedBox(height: 20),
    //         _buildListFundCategory(),
    //         SizedBox(height: 20),
    //         if (_typeSelected == 0)
    //           Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 15),
    //             child: SizedBox(
    //               height: 45,
    //               width: 360,
    //               child:
    //                TextField(
    //                 onChanged: (text) {
    //                   print("First text field: $text");
    //                   setState(() {
    //                     _filtter(text);
    //                   });
    //                 },
    //                 style: TextStyle(
    //                   color: const Color(0xff020202),
    //                   fontSize: 14,
    //                   fontWeight: FontWeight.w400,
    //                   letterSpacing: 0.5,
    //                 ),
    //                 decoration: InputDecoration(
    //                   filled: true,
    //                   fillColor: const Color(0xfff1f1f1),
    //                   border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(8),
    //                     borderSide: BorderSide.none,
    //                   ),
    //                   hintStyle: TextStyle(
    //                       color: const Color(0xffb2b2b2),
    //                       fontSize: 13,
    //                       fontWeight: FontWeight.w400,
    //                       letterSpacing: 0.5,
    //                       decorationThickness: 6),
    //                   prefixIcon: const Icon(Icons.search),
    //                   prefixIconColor: Colors.black,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         SizedBox(height: 20),
    //         if (_typeSelected == 0) _buildList(),
    //         if (_typeSelected == 1) _buildListExternal(),
    //         if (_typeSelected == 2) _buildListFinancial(),
    //       ],
    //     ));
  }

  Future<dynamic> _showModelBottonSheetFund(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              ListTile(
                leading: Text(''),
                title: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'กรองแหล่งทุน',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFB325F8)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
                trailing: GestureDetector(
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
                        'assets/images/back-x.png',
                        // color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  onChanged: (text) {
                    print("First text field: $text");
                    setState(() {
                      _filtter(text);
                    });
                  },
                  style: TextStyle(
                    color: const Color(0xff020202),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xfff1f1f1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'พิมพ์คำค้นหา',
                    hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        decorationThickness: 6),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'หมวดหมู่แหล่งทุน',
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 12),
              _buildCategory(),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFB325F8),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x40F3D2FF),
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Text(
                    'ค้นหาแหล่งทุน',
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
      ),
      backgroundColor: Colors.transparent, // ทำให้พื้นหลังโปร่งใส
    );
  }

  _buildList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemBuilder: (context, index) => _buildItem(_model[index]),
      itemCount: _model.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
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
                child: Image.asset(
                  'assets/icon.png',
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
                        data['annoucement'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).custom.b_w_y,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data['target'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).custom.f70f70_w_fffd57,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['announceDate']
                                .toString()
                                .replaceAll('T00:00:00', ''),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'สนใจเข้าร่วม',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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

  _buildListExternal() {
    return ListView.separated(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemBuilder: (context, index) => _buildItemExternal(_fundExternal[index]),
      itemCount: _fundExternal.length,
      separatorBuilder: (_, __) => const Divider(
        color: Color(0xFFDDDDDD),
      ),
    );
  }

  _buildItemExternal(dynamic data) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(data['linkUrl']),
            mode: LaunchMode.externalApplication);
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).custom.w_b_b,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 160.8,
                    height: 95,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFDDDDDD),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      // color: Color(0xFFDDDDDD),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: data['imageUrl'],
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
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
                              overflow: TextOverflow.ellipsis),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildListFinancial() {
    return ListView.separated(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemBuilder: (context, index) =>
          _buildItemFinancial(_fundFinancial[index]),
      itemCount: _fundFinancial.length,
      separatorBuilder: (_, __) => const Divider(
        color: Color(0xFFDDDDDD),
      ),
    );
  }

  _buildItemFinancial(dynamic data) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(data['linkUrl']),
            mode: LaunchMode.externalApplication);
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).custom.w_b_b,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 160.8,
                    height: 95,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFDDDDDD),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      // color: Color(0xFFDDDDDD),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: data['imageUrl'],
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildListFundCategory() {
    return Container(
      height: 25,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => GestureDetector(
          onTap: () {
            setState(() => _typeSelected = __);
            // _model = [];
            // _callReadByJobCategory(_typeSelected, '');
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: __ == _typeSelected
                  ? Color(0xFFB325F8)
                  : Color(0xFFB325F8).withOpacity(0.1),
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Text(
              cateFund[__],
              style: TextStyle(
                color: __ == _typeSelected
                    ? Colors.white
                    : Color(0xFFB325F8).withOpacity(0.5),
              ),
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemCount: cateFund.length,
      ),
    );
  }

  _buildCategory() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      itemCount: _categoryModel.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => GestureDetector(
        onTap: () {
          setState(() {
            _categoryModel[__]['selected'] = !(_categoryModel[__]['selected']);
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).custom.b325f8_w_fffd57,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: _categoryModel[__]['selected']
                          ? Theme.of(context).custom.b325f8_w_fffd57
                          : Theme.of(context).custom.w_b_b),
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${_categoryModel[__]['nameTh']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).custom.b_W_fffd57,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildListInvestor() {
    return ListView.separated(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) =>
          _buildItemInvestor(_investor[index], index),
      itemCount: i > _investor.length ? _investor.length : i,
      separatorBuilder: (_, __) => const Divider(
        color: Color(0xFFDDDDDD),
      ),
    );
  }

  String? _indexRank = '';

  _buildItemInvestor(dynamic data, index) {
    return InkWell(
      onTap: () async {
        setState(() {
          _indexRank = data.toString();
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => FundDetailPage(
                    indexRank: _indexRank!,
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: 320,
              decoration: BoxDecoration(
                // color: Color(0xFFB325F8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.asset('assets/images/03.png'),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              data['annoucement'],
              style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFB325F8)),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Color(0xFFB325F8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset('assets/images/work.png'),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  data['companyName'],
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Color(0xFFB325F8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset('assets/images/calendar_menu.png'),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(data['announceDate']),
                        ),
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Color(0xFFB325F8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset('assets/images/eye.png'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '120',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _callRead() async {
    Dio dio = new Dio();
    var response = await dio
        .get('http://dcc-portal.webview.co/dcc-api/api/InvestorAnnoucement/');

    setState(() {
      _model = response.data;
      _tempModel = response.data;
    });
  }

  _callReadInvestor() async {
    Dio dio = new Dio();
    var response = await dio
        .get('https://dcc.onde.go.th/dcc-api/api/InvestorAnnoucement/portal');

    setState(() {
      _investor = response.data;
    });
  }

  _category() async {
    Dio dio = new Dio();
    var response = await dio.get(
        'https://dcc.onde.go.th/dcc-api/api/masterdata/announcement/category');

    setState(() {
      // Map the API response and add a 'selected' field initialized to false
      _categoryModel = (response.data as List).map((item) {
        return {
          ...item,
          'selected':
              false, // Adding the 'selected' field with a default value of false
        };
      }).toList();
    });
  }

  _filtter(param) async {
    var temp = _tempModel
        .where((dynamic e) => e['annoucement']
            .toString()
            .toUpperCase()
            .contains(param.toString().toUpperCase()))
        .toList();

    setState(() {
      _model = temp;
    });
  }
}
