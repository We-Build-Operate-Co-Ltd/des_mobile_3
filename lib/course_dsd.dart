import 'package:des/main.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: must_be_immutable
class CourseDsdPage extends StatefulWidget {
  const CourseDsdPage({
    Key? key,
    this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  State<CourseDsdPage> createState() => _CourseDsdPageState();
}

class _CourseDsdPageState extends State<CourseDsdPage> {
  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;
  final _scController = ScrollController();
  final storage = const FlutterSecureStorage();
  ScrollController? scrollController;
  String _numberSelected = '1';

  List<dynamic> _modelDSDCouse = [];
  List<dynamic> _tempModelDSDCouse = [];

  List<dynamic> _numberList = [
    {
      'key': '1',
      'value': '5'
      // 5
    },
    {
      'key': '2',
      'value': '10',
      // 10
    },
    {
      'key': '3',
      'value': '23',
      // 25
    },
  ];

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
          child: _buildHead(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ScrollableColumnWidget(context),
                  ScrollableColumnBottom(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ScrollableColumnBottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Scrollbar(
        // isAlwaysShown: false,
        // controller: scrollController,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'จำนวนรายการต่อหน้า',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).custom.b_w_y,
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 70,
                child: _dropdown(
                  data: _numberList,
                  value: _numberSelected,
                  onChanged: (String value) {
                    setState(() {
                      _numberSelected = value;
                      var number = _numberList
                          .firstWhere((x) => x['key'] == _numberSelected);
                      _modelDSDCouse.clear();
                      _modelDSDCouse.addAll(
                          _tempModelDSDCouse.take(int.parse(number['value'])));
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Text(
                'รายการที่ ${_modelDSDCouse.length == 0 ? 0 : 1} - ${_modelDSDCouse.length < 5 ? _modelDSDCouse.length : _numberSelected}  จากทั้งหมด ${_modelDSDCouse.length} รายการ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).custom.b_w_y,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ScrollableColumnWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Scrollbar(
        // isAlwaysShown: false,
        // controller: scrollController,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: DataTable(
              border: TableBorder(
                  horizontalInside: BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black.withOpacity(0.3)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white.withOpacity(0.5)
                        : Color(0xFFFFFD57).withOpacity(0.5),
              )),
              headingRowColor: MaterialStateProperty.all(
                  MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8)
                      : Color(0xFF000000)),
              dividerThickness: 0.5,
              // columnSpacing: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black.withOpacity(0.3)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                  width: 2,
                ),
              ),
              columns: [
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'สาขา',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'ระยะเวลาที่ฝึก (ชั่วโมง)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'วันที่เริ่มฝึกอบรม',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'วันสิ้นสุดฝึกอบรม',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'หน่วยงาน',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ),
                ),
                DataColumn(label: Text('')),
              ],
              rows: [
                ..._modelDSDCouse.map((x) => DataRow(
                      cells: [
                        DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(
                              x['course'].toString(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).custom.b_w_y,
                              ),
                            ))),
                        DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(x['period'].toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).custom.b_w_y,
                                )))),
                        DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(x['dsd_Start_Date'].toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).custom.b_w_y,
                                )))),
                        DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(x['dsd_End_Date'].toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).custom.b_w_y,
                                )))),
                        DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(x['site'].toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).custom.b_w_y,
                                )))),
                        DataCell(
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 100,
                              // padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFFB325F8)
                                    : Colors.black, // สีพื้นหลังของ Container
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Color(0xFFB325F8)
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57)),
                              ),
                              child: Center(
                                child: Text(
                                  'สมัคร', // ข้อความใน Container
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Colors.white
                                        : MyApp.themeNotifier.value ==
                                                ThemeModeThird.dark
                                            ? Colors.white
                                            : Color(0xFFFFFD57),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ]),
        ),
      ),
    );
  }

  @override
  void initState() {
    scrollController = new ScrollController();

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
    _callReadDSDCouse();

    super.initState();
  }

  lineBottom() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 2.0,
          ),
        ),
      ),
    );
  }

  _dropdown({
    required List<dynamic> data,
    required String value,
    Function(String)? onChanged,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).custom.w_b_b,
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x40F3D2FF),
            offset: Offset(0, 4),
          )
        ],
      ),
      child: DropdownButtonFormField(
        icon: Image.asset(
          'assets/images/arrow_down.png',
          width: 16,
          height: 8,
          color: Theme.of(context).custom.b325f8_w_fffd57,
        ),
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).custom.b_W_fffd57,
        ),
        decoration: _decorationNumber(context),
        isExpanded: true,
        value: value,
        dropdownColor: Theme.of(context).custom.w_b_b,
        // validator: (value) =>
        //     value == '' || value == null ? 'กรุณาเลือก' : null,
        onChanged: (dynamic newValue) {
          onChanged!(newValue);
        },
        items: data.map((item) {
          return DropdownMenuItem(
            value: item['key'],
            child: Text(
              '${item['value']}',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).custom.b_W_fffd57,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  _callReadDSDCouse() async {
    var response = await Dio().get('$ondeURL/api/Lms/GetDSDCourse');

    setState(() {
      _tempModelDSDCouse = response.data;
      _modelDSDCouse.clear();
      _modelDSDCouse.addAll(_tempModelDSDCouse.take(5));
      // _modelDSDCouse = _tempModelDSDCouse.take(5);
    });
  }

  Widget _buildHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 35,
            width: 35,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFB325F8)
                    : Colors.black,
                border: Border.all(
                  width: 1,
                  style: BorderStyle.solid,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                )),
            child: Image.asset(
              'assets/images/back_arrow.png',
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: Text(
              'สถาบันคุณวุฒิวิชาชีพ',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFB325F8)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  static InputDecoration _decorationNumber(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black.withOpacity(0.2)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Color(0xFF707070)
                    : Color(0xFFFFFD57),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );
}
