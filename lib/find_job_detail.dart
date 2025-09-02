import 'package:des/main.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: must_be_immutable
class FindJobDetailPage extends StatefulWidget {
  FindJobDetailPage({Key? key, this.model, this.typeselect2}) : super(key: key);

  final dynamic model;
  final dynamic typeselect2;

  @override
  State<FindJobDetailPage> createState() => _FindJobDetailPageState();
}

class _FindJobDetailPageState extends State<FindJobDetailPage> {
  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;
  final storage = const FlutterSecureStorage();

  dynamic _detailModel = {};

  @override
  void initState() {
    if (MyApp.themeNotifier.value == ThemeModeThird.light) {
      backgroundTheme = Colors.white;
      colorTheme = Color(0xFF7A4CB1);
      buttonTheme = Color(0xFF7A4CB1);
      textTheme = Colors.black;
    } else if (MyApp.themeNotifier.value == ThemeModeThird.dark) {
      backgroundTheme = Colors.black;
      colorTheme = Colors.white;
      buttonTheme = Colors.black;
      textTheme = Colors.white;
    } else {
      backgroundTheme = Colors.black;
      colorTheme = Color(0xFFFFFD57);
      buttonTheme = Colors.black;
      textTheme = Color(0xFFFFFD57);
    }
    //  themeColor
    super.initState();
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
        backgroundColor: backgroundTheme,
        appBar: AppBar(
          backgroundColor: backgroundTheme,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            height: 60 + MediaQuery.of(context).padding.top,
            color: backgroundTheme,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 15,
              right: 15,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  _backButton(context),
                  SizedBox(width: 10),
                  Text(
                    'รายละเอียดงาน',
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
                ],
              ),
            ),
          ),
        ),
        body: widget.typeselect2 == 0 ? _buildContent2() : _buildContent());
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 195,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // color: Color(0xFFB325F8),
                        borderRadius: BorderRadius.circular(24),
                        // border: Border.all(),
                      ),
                      child: Image.asset(
                        'assets/images/rectangle.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      widget.model['jobposition'] ?? '',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Theme.of(context).custom.b325f8_w_fffd57),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/images/work.png'),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          widget.model['employername'] ?? '',
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
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Color(0xFFB325F8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/images/clock_white.png'),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'ไม่ระบุ',
                          // widget.model['companyName'],
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
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Color(0xFFB325F8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child:
                                Image.asset('assets/images/calendar_menu.png'),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'ไม่ระบุ',
                          // DateFormat('dd/MM/yyyy').format(
                          //   DateTime.parse(widget.model['announceDate']),
                          // ),
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
                      height: 20,
                    ),
                    Container(
                      height: 1,
                      color: Color(0xFFDDDDDD),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'ไม่ระบุ',
                      //widget.model['target'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 1,
                      color: Color(0xFFDDDDDD),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'ข้อมูลบริษัท',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFB325F8),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Kanit"),
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.model['employername'] ?? '',
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tel : ไม่ระบุ',
                      // widget.model['investTel'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email : ไม่ระบุ',
                      // widget.model['investEmail'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'ข้อมูลงบประมาณของโครงการ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFB325F8),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Kanit"),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'ไม่ได้ระบุ',
                      // widget.model['investTel'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFB325F8),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x40F3D2FF),
                              offset: Offset(0, -4),
                            )
                          ],
                        ),
                        child: Center(
                          child: const Text(
                            'สมัครงาน',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildContent2() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 195,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // color: Color(0xFFB325F8),
                        borderRadius: BorderRadius.circular(24),
                        // border: Border.all(),
                      ),
                      child: Image.asset(
                        'assets/images/rectangle.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      widget.model['positionName'] ?? '',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Theme.of(context).custom.b325f8_w_fffd57),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/images/work.png'),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          widget.model['companyname'] ?? '',
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
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Color(0xFFB325F8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/images/clock_white.png'),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'ไม่ระบุ',
                          // widget.model['companyName'],
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
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Color(0xFFB325F8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child:
                                Image.asset('assets/images/calendar_menu.png'),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'ไม่ระบุ',
                          // DateFormat('dd/MM/yyyy').format(
                          //   DateTime.parse(widget.model['announceDate']),
                          // ),
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
                      height: 20,
                    ),
                    Container(
                      height: 1,
                      color: Color(0xFFDDDDDD),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'ไม่ระบุ',
                      //widget.model['target'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 1,
                      color: Color(0xFFDDDDDD),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'ข้อมูลบริษัท',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFB325F8),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Kanit"),
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.model['companyname'] ?? '',
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tel : ไม่ระบุ',
                      // widget.model['investTel'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email : ไม่ระบุ',
                      // widget.model['investEmail'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'ข้อมูลงบประมาณของโครงการ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFB325F8),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Kanit"),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'ไม่ได้ระบุ',
                      // widget.model['investTel'],
                      style: TextStyle(
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF707070)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFB325F8),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x40F3D2FF),
                              offset: Offset(0, -4),
                            )
                          ],
                        ),
                        child: Center(
                          child: const Text(
                            'สมัครงาน',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 35,
        width: 35,
        child: Image.asset(
          'assets/images/back_arrow.png',
        ),
      ),
    );
  }

  _callRead() async {
    Dio dio = new Dio();
    var response = await dio
        .get('$ondeURL/api/Job/GetJobPost/${widget.model['jobapplicationno']}');

    setState(() {
      _detailModel = response.data['data'];
    });

    print(_detailModel.toString());
  }
}
