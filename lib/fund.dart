import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/fund_detail.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class FundPage extends StatefulWidget {
  FundPage({super.key, this.changePage});
  Function? changePage;

  @override
  _FundPageState createState() => _FundPageState();

  getState() => _FundPageState;

  // @override
  // State<FundPage> createState() => _FundPageState();
}

class _FundPageState extends State<FundPage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchFilterController = TextEditingController();

  dynamic _model = [];
  dynamic _tempModel = [];
  dynamic _investor = [];
  dynamic _investorTemp = [];
  List<dynamic> listCat = [];
  int _typeSelected = 0;
  bool _loadingWidget = true;
  int i = 2;
  List<dynamic> _fundExternal = [];
  List<dynamic> _fundFinancial = [];
  List<dynamic> cateFund = [
    'ค้นหาแหล่งทุน',
    'แหล่งทุนภายนอก',
    'ความรู้ด้านการเงินและการลงทุน',
  ];

  void _handleSearch(String input) {
    _investor = [..._investorTemp]
        .where((element) => element['annoucement'].contains(input))
        .toList();
  }

  @override
  void initState() {
    _category();
    _callReadInvestor();
    _callReadExternalLink();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/BG.png"),
              fit: BoxFit.cover,
              colorFilter: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? null
                  : ColorFilter.mode(Colors.grey, BlendMode.saturation),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.white
                        : Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      children: [
                        SizedBox(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                      widget.changePage!(0),
                                    },
                                    child: Container(
                                      width: 35.0,
                                      height: 35.0,
                                      margin: EdgeInsets.all(5),
                                      child: Image.asset(MyApp
                                                  .themeNotifier.value ==
                                              ThemeModeThird.light
                                          ? 'assets/images/back_profile.png'
                                          : "assets/images/2024/back_balckwhite.png"),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'สรรหาแหล่งทุน',
                                      style: TextStyle(
                                        fontSize: MyApp.fontKanit.value ==
                                                FontKanit.small
                                            ? 24
                                            : 22,
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
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              _buildListFundCategory(),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: ClampingScrollPhysics(),
                            children: [
                              Text(
                                cateFund[_typeSelected],
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFFBD4BF7)
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57)),
                              ),
                              SizedBox(height: 20),
                              if (_typeSelected == 0)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: _searchController,
                                      onChanged: (text) {},
                                      style: TextStyle(
                                        color: MyApp.themeNotifier.value ==
                                                ThemeModeThird.light
                                            ? Colors.black
                                            : MyApp.themeNotifier.value ==
                                                    ThemeModeThird.dark
                                                ? Colors.white
                                                : Color(0xFFFFFD57),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.5,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        isDense: true,
                                        fillColor: MyApp.themeNotifier.value ==
                                                ThemeModeThird.light
                                            ? Colors.white
                                            : MyApp.themeNotifier.value ==
                                                    ThemeModeThird.dark
                                                ? Colors.black
                                                : Colors.black,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: MyApp.themeNotifier
                                                          .value ==
                                                      ThemeModeThird.light
                                                  ? Color(0xFFBD4BF7)
                                                  : MyApp.themeNotifier.value ==
                                                          ThemeModeThird.dark
                                                      ? Colors.white
                                                      : Color(0xFFFFFD57),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: MyApp.themeNotifier
                                                          .value ==
                                                      ThemeModeThird.light
                                                  ? Color(0xFFBD4BF7)
                                                  : MyApp.themeNotifier.value ==
                                                          ThemeModeThird.dark
                                                      ? Colors.white
                                                      : Color(0xFFFFFD57),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Color(0xFFDDDDDD)),
                                        ),
                                        hintText: 'พิมพ์คำค้นหา',
                                        hintStyle: TextStyle(
                                          color: MyApp.themeNotifier.value ==
                                                  ThemeModeThird.light
                                              ? Color(0xFFBD4BF7)
                                              : MyApp.themeNotifier.value ==
                                                      ThemeModeThird.dark
                                                  ? Colors.white
                                                  : Color(0xFFFFFD57),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.5,
                                          decorationThickness: 6,
                                        ),
                                        prefixIcon: const Icon(Icons.search),
                                        prefixIconColor:
                                            MyApp.themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? Color(0xFFBD4BF7)
                                                : MyApp.themeNotifier.value ==
                                                        ThemeModeThird.dark
                                                    ? Colors.white
                                                    : Color(0xFFFFFD57),
                                        suffixIcon: Align(
                                          widthFactor: 1.0,
                                          heightFactor: 1.0,
                                          child: GestureDetector(
                                            onTap: () {
                                              _showModelBottonSheetFund(
                                                  context);
                                            },
                                            child: Image.asset(MyApp
                                                        .themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? 'assets/images/filter.png'
                                                : MyApp.themeNotifier.value ==
                                                        ThemeModeThird.dark
                                                    ? "assets/images/2024/filter_w.png"
                                                    : "assets/images/2024/filter_y.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      splashColor: Colors.red,
                                      onTap: () {
                                        setState(() {
                                          _handleSearch(_searchController.text);
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color:
                                              // ? Color(0xFFB325F8)
                                              MyApp.themeNotifier.value ==
                                                      ThemeModeThird.light
                                                  ? Color(0xFFBD4BF7)
                                                  : MyApp.themeNotifier.value ==
                                                          ThemeModeThird.dark
                                                      ? Colors.white
                                                      : Color(0xFFFFFD57),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x40F3D2FF),
                                              offset: Offset(0, 4),
                                            )
                                          ],
                                        ),
                                        child: Text(
                                          'ค้นหาแหล่งทุน ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: MyApp.themeNotifier
                                                          .value ==
                                                      ThemeModeThird.light
                                                  ? Colors.white
                                                  : MyApp.themeNotifier.value ==
                                                          ThemeModeThird.dark
                                                      ? Colors.black
                                                      : Colors.black),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                        height: 2, color: Color(0xFFDDDDDD)),
                                    SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'แหล่งทุนทั้งหมด ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: MyApp.themeNotifier.value ==
                                                  ThemeModeThird.light
                                              ? Color(0xFFBD4BF7)
                                              : MyApp.themeNotifier.value ==
                                                      ThemeModeThird.dark
                                                  ? Colors.white
                                                  : Color(0xFFFFFD57),
                                        ),
                                      ),
                                    ),
                                    if (_loadingWidget)
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: MyApp.themeNotifier.value ==
                                                  ThemeModeThird.light
                                              ? Color(0xFFBD4BF7)
                                              : MyApp.themeNotifier.value ==
                                                      ThemeModeThird.dark
                                                  ? Colors.white
                                                  : Color(0xFFFFFD57),
                                        ),
                                      )
                                    else
                                      _investor.length != 0
                                          ? _buildListInvestor()
                                          : Center(
                                              child: Text(
                                                'ไม่พบข้อมูล',
                                                style: TextStyle(
                                                  color: MyApp.themeNotifier
                                                              .value ==
                                                          ThemeModeThird.light
                                                      ? Color(0xFFBD4BF7)
                                                      : MyApp.themeNotifier
                                                                  .value ==
                                                              ThemeModeThird
                                                                  .dark
                                                          ? Colors.white
                                                          : Color(0xFFFFFD57),
                                                ),
                                              ),
                                            ),
                                    SizedBox(height: 20),
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
                                          color: MyApp.themeNotifier.value ==
                                                  ThemeModeThird.light
                                              ? Color(0xFFBD4BF7)
                                              : MyApp.themeNotifier.value ==
                                                      ThemeModeThird.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          border: Border.all(
                                            width: 1.0,
                                            color: MyApp.themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? Color(0xFFBD4BF7)
                                                : MyApp.themeNotifier.value ==
                                                        ThemeModeThird.dark
                                                    ? Colors.white
                                                    : Color(0xFFFFFD57),
                                          ),
                                        ),
                                        child: Text(
                                          'ดูเพิ่มเติม',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: MyApp.themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? Colors.white
                                                : MyApp.themeNotifier.value ==
                                                        ThemeModeThird.dark
                                                    ? Colors.black
                                                    : Color(0xFFFFFD57),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                ),
                              if (_typeSelected == 1) _buildListExternal(),
                              // Center(child: Text("ไม่พบการค้นหา")),
                              if (_typeSelected == 2) _buildListFinancial(),
                              // Center(child: Text("ไม่พบการค้นหา"))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<dynamic> _showModelBottonSheetFund(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.white
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.black
                        : Colors.black,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(24.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.045),
                  ListTile(
                    leading: Text(''),
                    title: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'กรองแหล่งทุน',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
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
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? 'assets/images/back-x.png'
                                  : "assets/images/2024/exit_new.png"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (value) {},
                    controller: _searchFilterController,
                    style: TextStyle(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0), // ปรับความสูงให้เหมาะสม
                      isDense: true,
                      fillColor:
                          MyApp.themeNotifier.value == ThemeModeThird.light
                              ? Colors.white
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.black
                                  : Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1.0,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFBD4BF7)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFBD4BF7)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                      ),
                      hintText: 'พิมพ์คำค้นหา',
                      hintStyle: TextStyle(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.black
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        decorationThickness: 6,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.black
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'หมวดหมู่แหล่งทุน',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFBD4BF7)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        StatefulBuilder(
                          builder: (context, MysetState) {
                            return _buildCategory(MysetState);
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _investor = [..._investorTemp]
                            .where((element) =>
                                element['annoucement']
                                    .contains(_searchFilterController.text) &&
                                listCat
                                    .where((e) => e['selected'])
                                    .map((m) => m['cateId'])
                                    .contains(element['category']))
                            .toList();
                      });
                      Navigator.pop(context);
                      _searchFilterController.clear();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFBD4BF7)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x40F3D2FF),
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'ค้นหาแหล่งทุน',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.white
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.black
                                  : Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -1), // เลื่อนลงมาจากข้างบน
            end: Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }

  _buildListInvestor() {
    return ListView.separated(
      padding: EdgeInsets.zero,
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

  _buildItemInvestor(dynamic data, index) {
    return InkWell(
      onTap: () async {
        setState(() {
          // _indexRank = data;
          data['catName'] = listCat.firstWhereOrNull(
              (x) => x['cateId'] == data['category'])['nameTh'];
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FundDetailPage(model: data!),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ColorFiltered(
                  key: ValueKey(MyApp.themeNotifier.value),
                  colorFilter: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? const ColorFilter.mode(
                          Colors.transparent, BlendMode.multiply)
                      : const ColorFilter.mode(
                          Colors.grey, BlendMode.saturation),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/Owl-10.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
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
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFBD4BF7)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
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
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFBD4BF7)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                        MyApp.themeNotifier.value == ThemeModeThird.light
                            ? 'assets/images/work.png'
                            : 'assets/images/2024/work.png'),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Text(
                    data['companyName'],
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFBD4BF7)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
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
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFBD4BF7)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? 'assets/images/calendar_menu.png'
                                  : 'assets/images/2024/calendar-b.png'),
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
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFBD4BF7)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
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
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFBD4BF7)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? 'assets/images/eye.png'
                                  : 'assets/images/2024/eye_black.png'),
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
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFBD4BF7)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
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
        launchUrl(Uri.parse(data['linkUrl'] ?? ''),
            mode: LaunchMode.externalApplication);
      },
      child: Container(
        height: MyApp.fontKanit.value == FontKanit.small
            ? 120
            : MyApp.fontKanit.value == FontKanit.medium
                ? 150
                : 180,
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
                    child: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? CachedNetworkImage(
                            imageUrl: data['imageUrl'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/Owl-10.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          )
                        : ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                            child: CachedNetworkImage(
                              imageUrl: data['imageUrl'],
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/Owl-10.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
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
                        Flexible(
                          child: Text(
                            data['linkName'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).custom.b_w_y,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
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
                    ),
                    child: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? CachedNetworkImage(
                            imageUrl: data['imageUrl'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/Owl-10.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          )
                        : ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                            child: CachedNetworkImage(
                              imageUrl: data['imageUrl'],
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/Owl-10.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
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
                          data['linkName'],
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
        height: MyApp.fontKanit.value == FontKanit.small
            ? 25
            : MyApp.fontKanit.value == FontKanit.medium
                ? 35
                : 45,
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
                    // ? Color(0xFFB325F8)
                    ? MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFBD4BF7)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57)
                    : Color(0xFFB325F8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(17.5),
              ),
              child: Text(
                cateFund[__],
                style: TextStyle(
                    color: __ == _typeSelected
                        ? MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.white
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.black
                                : Colors.black
                        // : Color(0xFFB325F8).withOpacity(0.5),
                        : MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFB325F8).withOpacity(0.5)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57)),
              ),
            ),
          ),
          separatorBuilder: (_, __) => const SizedBox(width: 5),
          itemCount: cateFund.length,
        ));
  }

  _buildCategory(StateSetter MysetState) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      itemCount: listCat.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => GestureDetector(
        onTap: () {
          MysetState(() {
            listCat[__]['selected'] = !(listCat[__]['selected']);
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
                      color: listCat[__]['selected']
                          ? Theme.of(context).custom.b325f8_w_fffd57
                          : Theme.of(context).custom.w_b_b),
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${listCat[__]['nameTh']}',
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

  _callReadExternalLink() async {
    var dio = Dio();
    var response = await dio.request(
      '$ondeURL/api/ExternalLink',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      print('-------_callReadExternalLink-------');
      print(response.data);
      print('-----------------------------------');

      _fundExternal.clear();
      _fundFinancial.clear();

      for (var item in response.data['data']) {
        if (item['linkCategory'] == 1) {
          _fundExternal.add(item);
        } else if (item['linkCategory'] == 2) {
          _fundFinancial.add(item);
        }
      }

      // print(json.encode(response.data));
    } else {
      print(response.statusMessage);
    }
  }

  _category() async {
    Dio dio = new Dio();
    var response =
        await dio.get('$ondeURL/api/masterdata/announcement/category');

    setState(() {
      _loadingWidget = true;
      listCat = response.data;

      listCat = (response.data as List).map(
        (item) {
          return {
            ...item,
            'selected': false,
          };
        },
      ).toList();
    });
  }

  _callReadInvestor() async {
    setState(() {
      _loadingWidget = true;
    });

    Dio dio = Dio();
    var response = await dio.get('$ondeURL/api/InvestorAnnoucement/portal');

    List<dynamic> data = response.data;

    // เรียงลำดับจากวันที่ใหม่ไปเก่า
    data.sort((a, b) {
      DateTime dateA = DateTime.parse(a['announceDate']);
      DateTime dateB = DateTime.parse(b['announceDate']);
      return dateB.compareTo(dateA);
    });

    setState(() {
      _investor = data;
      _investorTemp = data;
      _loadingWidget = false;
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
