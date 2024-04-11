import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int _typeSelected = 0;

  List<dynamic> cateFund = [
    'ทั้งหมด',
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
    // _callCategoryRead();
    _callRead();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                    'ค้นหาแหล่งทุน',
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
            SizedBox(height: 20),
            _buildListFundCategory(),
            SizedBox(height: 20),
            if (_typeSelected == 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: 45,
                  width: 360,
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
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: TextStyle(
                          color: const Color(0xffb2b2b2),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          decorationThickness: 6),
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.black,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
            if (_typeSelected == 0) _buildList(),
            if (_typeSelected == 1) _buildListExternal(),
            if (_typeSelected == 2) _buildListFinancial(),
          ],
        ));
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
      separatorBuilder: (_, __) => const SizedBox(height: 10),
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
                  child: CachedNetworkImage(
                    imageUrl: data['imageUrl'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
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

    _buildListFinancial() {
    return ListView.separated(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemBuilder: (context, index) => _buildItemFinancial(_fundFinancial[index]),
      itemCount: _fundFinancial.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
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
                  child: CachedNetworkImage(
                    imageUrl: data['imageUrl'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
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

  Widget _buildListFundCategory() {
    return Container(
      height: 35,
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
              color: __ == _typeSelected ? Color(0xFF7A4CB1) : Colors.white,
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Text(
              cateFund[__],
              style: TextStyle(
                color: __ == _typeSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemCount: cateFund.length,
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
    logWTF(_model);

    // print(_model.toString());
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
