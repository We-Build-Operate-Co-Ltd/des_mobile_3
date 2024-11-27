import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/course_eternal.dart';
import 'package:des/home.dart';
import 'package:des/my_course.dart';
import 'package:des/my_course_category_search.dart';
import 'package:des/my_course_success.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/webview_inapp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'course_detail_new.dart';
import 'course_dsd.dart';
import 'my_class_all_bk.dart';
import 'shared/config.dart';
import 'course_detail.dart';
import 'main.dart';

class MyClassAllPage extends StatefulWidget {
  MyClassAllPage({Key? key, this.title, this.changePage}) : super(key: key);

  final title;
  Function? changePage;

  @override
  _MyClassAllPageState createState() => _MyClassAllPageState();
}

class _MyClassAllPageState extends State<MyClassAllPage> {
  Dio dio = Dio();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _typeList = [
    'ค้นหาคอร์ส',
    'คอร์สเรียนของคุณ',
    'คอร์สสำเร็จ',
  ];
  List<dynamic> _cateTypeList = [
    'คอร์สแนะนำ',
    'คอร์สภายนอก',
  ];

  List<dynamic> _valuesSearch = [
    'ทั้งหมด',
    'มีใบประกาศนียบัตร',
    'ไม่มีใบประกาศนียบัตร'
  ];

  List<dynamic> _categoryList = [];
  List<dynamic> _lmsCategoryList = [];

  int _categorySelected = 0;
  int _typeSelected = 0;
  int _cateTypeSelected = 0;
  String _cateCourseSelected = '';

  String textSearch = '';
  String cateSearch = '';
  String cateCourseSearch = '';
  String textEternalSearch = '';

  Future<dynamic>? _modelFilter;
  dynamic _tempModel;
  Future<dynamic>? _modelRecommend;
  Future<dynamic>? _modelCouseEternal;
  Future<dynamic>? _modelDSDCouse;
  int _listFilterLenght = 0;

  late MyCoursePage myCourse;
  late MyCourseSuccessPage myCourseSuccess;

  // dynamic _tempModelRecommend;
  List<dynamic> _tempModelRecommend = [];
  List<dynamic> _tempModelEternal = [];

  bool isObsecure = false;
  Color textTheme = Colors.transparent;

  // String _api_key = '19f072f9e4b14a19f72229719d2016d1';
  // String _api_key = '29f5637fe877ab6d8797a8bcde3d67a7';
  // String endpoint_base_url = 'https://e2e.myappclass.bangalore2.com/api/api/';

  String _topModalData = "ทั้งหมด";

  @override
  void initState() {
    _callReadRecomment();
    _get_category();
    _get_LmsCategory();
    _callReadCouseEternal();
    _callReadDSDCouse();

    // _get_course();
    // _get_course();
    // _callRead();

    myCourse = new MyCoursePage(
      callBack: () {
        setState(() {
          _onLoading();
          _typeSelected = 0;
        });
      },
    );

    myCourseSuccess = new MyCourseSuccessPage(
      callBack: (value) {
        setState(() {
          _onLoading();
          _typeSelected = value;
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  _filter() async {
    // logWTF(
    //     '=========fsdfsdfsdfdsfsd==========' + _tempModelRecommend.toString());
    // var res = await _model;
    // print('--1---$cateSearch');
    var temp = _tempModelRecommend
        .where((item) => item['course_Name'].contains(textSearch.toString()))
        .toList();

    // _tempModelRecommend
    //     .where((dynamic e) =>
    //         e['course_Name']
    //             .toString()
    //             .toUpperCase()
    //             .contains(textSearch.toString().toUpperCase()) &&
    //         e['certificate']
    //             .toString()
    //             .toUpperCase()
    //             .contains(cateSearch.toString().toUpperCase()) &&
    //         e['course_cat_id']
    //             .toString()
    //             .toUpperCase()
    //             .contains(cateCourseSearch.toString().toUpperCase()))
    //     .toList();

    // logWTF('=========fsdfsdfsdfdsfsd123==========' + temp.toString());

    setState(() {
      _listFilterLenght = temp.length;
      _modelRecommend = Future.value(temp);
    });
  }

  _filterEternal() async {
    // logWTF(
    // '=========fsdfsdfsdfdsfsd==========' + _tempModelEternal.toString());
    // var res = await _model;
    var temp =
        // _tempModel.where((item) => item['name'].contains(param)).toList();

        _tempModelEternal
            .where((dynamic e) => e['title']
                .toString()
                .toUpperCase()
                .contains(textEternalSearch.toString().toUpperCase()))
            .toList();

    // logWTF('=========fsdfsdfsdfdsfsd123==========' + temp.toString());

    setState(() {
      // _listFilterLenght = temp.length;
      _modelCouseEternal = Future.value(temp);
    });
  }

  _callReadRecomment() async {
    // var response = await Dio().get('$server/py-api/dcc/lms/recomend');
    var response =
        await Dio().get('$serverPlatform/api/Lms/GetRecommendCourse');

    setState(() {
      _modelRecommend = Future.value(response.data);
      // _tempModel.addAll(response.data);
      _tempModelRecommend.addAll(response.data);
    });
  }

  _callReadCouseEternal() async {
    var response = await Dio().get('$ondeURL/api/Lms/GetCouseExternal');

    setState(() {
      _modelCouseEternal = Future.value(response.data);
      _tempModelEternal.addAll(response.data);
    });
  }

  _callReadDSDCouse() async {
    var response = await Dio().get('$ondeURL/api/Lms/GetDSDCourse');

    setState(() {
      _modelDSDCouse = Future.value(response.data);
    });
  }

  _get_category() async {
    var response =
        await dio.get('${serverLMS}/get_coursecategory/${apiKeyLMS}');
    setState(() {
      _categoryList.addAll(response.data['data']);
    });
  }

  _get_LmsCategory() async {
    var response = await dio.get('${ondeURL}/api/Lms/GetCategory');
    setState(() {
      _lmsCategoryList.addAll(response.data['data']);
    });
  }

  _loading() async {
    Response<dynamic> response =
        await dio.post('$server/dcc-api/m/eventcalendar/read', data: {});

    if (response.statusCode == 200) {
      if (response.data['status'] == 'S') {
        List<dynamic> data = response.data['objectData'];
        List<dynamic> lerning = [];
        List<dynamic> lerned = [];
        for (int i = 0; i < data.length; i++) {
          if (i % 2 == 0) {
            lerned.add(data[i]);
          } else {
            lerning.add(data[i]);
          }
        }
        setState(() {});
      }
    }

    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 10) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 25),
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? "assets/images/BG.png"
                          : "assets/images/2024/BG_Blackwhite.jpg",
                    ),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    // height: MediaQuery.of(context).size.height * 0.8,
                    width: 350,
                    height: deviceHeight * 0.8,
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        _buildHead(),
                        SizedBox(height: 20),
                        _typeCategory(),
                        _typeSelected == 0
                            ? SizedBox(
                                height: deviceHeight * 0.6,
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true, // 1st add
                                  physics: const ClampingScrollPhysics(), // 2nd
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      'ค้นหาคอร์ส',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeNotifier.value ==
                                                ThemeModeThird.light
                                            ? Color(0xFFB325F8)
                                            : MyApp.themeNotifier.value ==
                                                    ThemeModeThird.dark
                                                ? Colors.white
                                                : Color(0xFFFFFD57),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(
                                      height: 45,
                                      width: 360,
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (text) {
                                          // print("First text field: $text");
                                          setState(() {
                                            // if (_cateTypeSelected == 0) {
                                            textSearch = text;
                                            _filter();
                                            // textEternalSearch = '';
                                            // _filterEternal();
                                            // } else {
                                            textEternalSearch = text;
                                            _filterEternal();
                                            // textSearch = '';
                                            // _filter();
                                            // }
                                          });
                                        },
                                        style: TextStyle(
                                          color: MyApp.themeNotifier.value ==
                                                  ThemeModeThird.light
                                              ? Colors.black
                                              : MyApp.themeNotifier.value ==
                                                      ThemeModeThird.dark
                                                  ? Colors.black
                                                  : Color(0xFFFFFD57),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.5,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor:
                                              MyApp.themeNotifier.value ==
                                                      ThemeModeThird.light
                                                  ? Colors.white
                                                  : MyApp.themeNotifier.value ==
                                                          ThemeModeThird.dark
                                                      ? Colors.white
                                                      : Colors.grey
                                                          .withOpacity(0.3),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: "ค้นหาคอร์สเรียน",
                                          hintStyle: TextStyle(
                                              color: MyApp.themeNotifier
                                                          .value ==
                                                      ThemeModeThird.light
                                                  ? const Color(0xffb2b2b2)
                                                  : MyApp.themeNotifier.value ==
                                                          ThemeModeThird.dark
                                                      ? Colors.black
                                                      : Color(0xFFFFFD57),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.5,
                                              decorationThickness: 6),
                                          prefixIcon: const Icon(Icons.search),
                                          prefixIconColor:
                                              MyApp.themeNotifier.value ==
                                                      ThemeModeThird.light
                                                  ? Colors.black
                                                  : MyApp.themeNotifier.value ==
                                                          ThemeModeThird.dark
                                                      ? Colors.black
                                                      : Color(0xFFFFFD57),
                                          suffixIcon: _cateTypeSelected == 0
                                              ? IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _showTopModal();
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.tune,
                                                  ),
                                                )
                                              : null,
                                          suffixIconColor: _cateTypeSelected ==
                                                  0
                                              ? MyApp.themeNotifier.value ==
                                                      ThemeModeThird.light
                                                  ? Colors.black
                                                  : MyApp.themeNotifier.value ==
                                                          ThemeModeThird.dark
                                                      ? Colors.black
                                                      : Color(0xFFFFFD57)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    if (_cateTypeSelected == 0) _lmsCategory(),
                                    const SizedBox(height: 10),
                                    lineBottom(),
                                    const SizedBox(height: 20),
                                    _cateTypeCategory(),
                                    SizedBox(height: 20),
                                    _cateTypeSelected == 0
                                        ? _buildRecomment()
                                        : _buildEternal(),
                                    // textSearch == '' ? _test1() : _test2(),
                                  ],
                                ),
                              )
                            : _typeSelected == 1
                                ? SizedBox(
                                    height: deviceHeight * 0.6,
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true, // 1st add
                                      physics:
                                          const ClampingScrollPhysics(), // 2nd
                                      children: [
                                        const SizedBox(height: 20),
                                        myCourse,
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: deviceHeight * 0.6,
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true, // 1st add
                                      physics:
                                          const ClampingScrollPhysics(), // 2nd
                                      children: [
                                        const SizedBox(height: 20),
                                        myCourseSuccess,
                                      ],
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTopModal() async {
    final value = await showTopModalSheet<String?>(
      context,
      _listTopModal(),
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
    );

    if (value != null)
      setState(() {
        _topModalData = value;
        cateSearch = _topModalData == 'ทั้งหมด'
            ? ''
            : _topModalData == 'มีใบประกาศนียบัตร'
                ? '1'
                : '0';
        _filter();
      });
  }

  _test1() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _cateTypeCategory(),
        SizedBox(height: 20),
        _cateTypeSelected == 0 ? _buildRecomment() : _buildEternal(),
      ],
    );
  }

  _test2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'ผลการค้นหา "${textSearch}"',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'พบข้อมูลที่ตรงกัน ${_listFilterLenght} คอร์สเรียน',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _listTopModal() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 15),
          Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 50),
                      alignment: Alignment.center,
                      child: Text(
                        'กรองการค้นหา', // Title in Thai
                        style: TextStyle(
                          fontSize: 22,
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
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.only(right: 25),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFFB325F8)
                                : Colors.black,
                            border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Color(0xFFB325F8)
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                            )),
                        child: Image.asset(
                          'assets/images/close_icon.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          ..._valuesSearch
              .map(
                (value) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context, value);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: value == _topModalData
                            ? MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Color(0xFFB325F8)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57)
                            : MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Colors.white
                                : Colors.black,
                        border: Border.all(
                          width: 1,
                          style: BorderStyle.solid,
                          color: value == _topModalData
                              ? MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.white
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57)
                              : MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Color(0xFFB325F8).withOpacity(0.5)
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                        )),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: value == _topModalData
                            ? MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Colors.white
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.black
                                    : Colors.black
                            : MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Color(0xFFB325F8)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void showTopModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Dim background
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.zero,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'กรองการค้นหา', // Title in Thai
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.close, color: Colors.purple),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Button options
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('ทั้งหมด'), // Button label in Thai
                    ),
                    SizedBox(height: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('มีใบประกาศนียบัตร'),
                    ),
                    SizedBox(height: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('ไม่มีใบประกาศนียบัตร'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildRecomment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textSearch != '' ? _test2() : Container(),
        Text(
          'คอร์​สแนะนำ',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFB325F8)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _buildListModel(),
        const SizedBox(height: 120),
      ],
    );
  }

  _buildListModel() {
    return FutureBuilder(
      future: _modelRecommend,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // childAspectRatio: 10 / 14,
                  childAspectRatio: MyApp.fontKanit.value == FontKanit.small
                      ? 10 / 12.5
                      : MyApp.fontKanit.value == FontKanit.medium
                          ? 10 / 13
                          : 10 / 14,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              physics: const ClampingScrollPhysics(),
              // itemCount: snapshot.data!.length,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  containerRecommendedClass(snapshot.data![index]),
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  _buildFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        _buildListFilterModel(),
        const SizedBox(height: 50),
      ],
    );
  }

  _buildListFilterModel() {
    return FutureBuilder(
      future: _modelFilter,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: 10 / 11.5,
                childAspectRatio: MyApp.fontKanit.value == FontKanit.small
                    ? 10 / 12.5
                    : MyApp.fontKanit.value == FontKanit.medium
                        ? 10 / 13
                        : 10 / 14,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              physics: const ClampingScrollPhysics(),
              // itemCount: snapshot.data!.length,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  containerRecommendedClass(snapshot.data![index]),
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget containerRecommendedClass(dynamic model) {
    return GestureDetector(
      onTap: () async {
        var loginData = await ManageStorage.readDynamic('loginData');
        var accessToken = await ManageStorage.read('accessToken');
        logWTF(
            'https://lms.dcc.onde.go.th/user/user/lesson_details/${model['course_id']}?sso_key=${loginData['sub']}&access_token=${accessToken}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewInAppPage(
              url:
                  'https://lms.dcc.onde.go.th/user/user/lesson_details/${model['course_id']}?sso_key=${loginData['sub']}&access_token=${accessToken}',
              title: model?['course_name'] ?? '',
            ),
          ),
        );
        // var data = {
        //   'course_id': model?['id'] ?? '',
        //   "course_name": model?['name'] ?? '',
        //   "course_cat_id": model?['course_cat_id'] ?? '',
        //   "cover_image": model?['docs'] ?? '',
        //   "description": model['details'] ?? '',
        //   "created_at": model['created_at'] ?? '',
        //   "category_name": model['cat_name'] ?? '',
        //   "certificate": model['certificate'] ?? '',
        //   "course_duration": model['course_duration'] ?? '',
        // };
        // logWTF(data);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CourseDetailPage(
        //       model: model,
        //     ),
        //   ),
        // );
      },
      child: Container(
        // elevation: 4,
        color: Theme.of(context).custom.primary,
        child: Container(
          padding: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).custom.primary,
            // border: Border.all(
            //   color: Theme.of(context).custom.b_w_y,
            // ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(0, 0, 0, 0).withOpacity(0.15),
                offset: const Offset(
                  3.0,
                  3.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? (model?['course_Thumbnail_Url'] ?? '') != ''
                        ? CachedNetworkImage(
                            imageUrl: model?['course_Thumbnail_Url'],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/icon.png',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: model?['course_Thumbnail_Url'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 9),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    model?['course_Name'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).custom.b_w_y,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Image.asset(
                        MyApp.themeNotifier.value == ThemeModeThird.light
                            ? 'assets/images/course_time.png'
                            : "assets/images/2024/time_home_page_blackwhite.png",
                        height: 24,
                        width: 24),
                    const SizedBox(width: 8),
                    Text(
                      formatDuration(model?['course_Duration']),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildEternal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'สถาบันคุณวุฒิวิชาชีพ',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFB325F8)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _listEternalModel(),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseEternalPage(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.white
                    : Colors.black,
                border: Border.all(
                  width: 1,
                  style: BorderStyle.solid,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8).withOpacity(0.5)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                )),
            child: Text(
              'ดูทั้งหมด',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFB325F8)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'กรมพัฒนาฝีมือแรงงาน',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFB325F8)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _listDSDModel(),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseDsdPage(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                // color: Theme.of(context).custom.primary,
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromARGB(0, 0, 0, 0).withOpacity(0.15),
                //     offset: const Offset(
                //       3.0,
                //       3.0,
                //     ),
                //     blurRadius: 10.0,
                //     spreadRadius: 0.0,
                //   ),
                // ],
                borderRadius: BorderRadius.circular(20),
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.white
                    : Colors.black,
                border: Border.all(
                  width: 1,
                  style: BorderStyle.solid,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8).withOpacity(0.5)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                )),
            child: Text(
              'ดูทั้งหมด',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFB325F8)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
            ),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  _listEternalModel() {
    return Container(
      height: 250,
      child: FutureBuilder(
        future: _modelCouseEternal,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.horizontal,
              // physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) =>
                  containerCouseEternal(snapshot.data![index]),
              separatorBuilder: (_, index) => const SizedBox(width: 15),
              itemCount: snapshot.data!.length < 6 ? snapshot.data!.length : 6,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  containerCouseEternal(dynamic model) {
    return GestureDetector(
      onTap: () {
        // var data = {
        //   'course_id': model?['id'] ?? '',
        //   "course_name": model?['name'] ?? '',
        //   "course_cat_id": model?['course_cat_id'] ?? '',
        //   "cover_image": model?['docs'] ?? '',
        //   "description": model['details'] ?? '',
        //   "created_at": model['created_at'] ?? '',
        //   "category_name": model['cat_name'] ?? '',
        //   "certificate": model['certificate'] ?? '',
        // };
        // logWTF(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailNewPage(
              model: model,
            ),
          ),
        );
      },
      child: Container(
        height: 250,
        width: 200,
        color: Theme.of(context).custom.primary,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).custom.primary,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(0, 0, 0, 0).withOpacity(0.15),
                offset: const Offset(
                  3.0,
                  3.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? (model?['thumbnailLink'] ?? '') != ''
                        ? CachedNetworkImage(
                            imageUrl: '${model['thumbnailLink']}',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/icon.png',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                    : ColorFiltered(
                        colorFilter:
                            ColorFilter.mode(Colors.grey, BlendMode.saturation),
                        child: (model?['thumbnailLink'] ?? '') != ''
                            ? CachedNetworkImage(
                                imageUrl: '${model['thumbnailLink']}',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/icon.png',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
              ),
              const SizedBox(height: 9),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    model?['title'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).custom.b_w_y,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Image.asset(
                        MyApp.themeNotifier.value == ThemeModeThird.light
                            ? 'assets/images/course_time.png'
                            : "assets/images/2024/time_home_page_blackwhite.png",
                        height: 24,
                        width: 24),
                    const SizedBox(width: 8),
                    Text(
                      model?['duration'] + ' นาที',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _listDSDModel() {
    return Container(
      height: 250,
      child: FutureBuilder(
        future: _modelDSDCouse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.horizontal,
              // physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) =>
                  containerDSDCouse(snapshot.data![index]),
              separatorBuilder: (_, index) => const SizedBox(width: 15),
              itemCount: snapshot.data!.length < 6 ? snapshot.data!.length : 6,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  containerDSDCouse(dynamic model) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 250,
        width: 200,
        color: Theme.of(context).custom.primary,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).custom.primary,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(0, 0, 0, 0).withOpacity(0.15),
                offset: const Offset(
                  3.0,
                  3.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  'assets/images/logo_dsdcourse.png',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 9),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    model?['course'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).custom.b_w_y,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Image.asset(
                        MyApp.themeNotifier.value == ThemeModeThird.light
                            ? 'assets/images/course_time.png'
                            : "assets/images/2024/time_home_page_blackwhite.png",
                        height: 24,
                        width: 24),
                    const SizedBox(width: 8),
                    Text(
                      model['period'].toString() + ' นาที',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).custom.b_w_y,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _list(dynamic param) {
    var data = param;
    return ListView.separated(
      itemBuilder: (_, __) => _buildContant(data[__]),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: data.length,
    );
  }

  _listLoading() {
    return Expanded(
      child: ListView(
        children: [1, 1, 1, 1, 1, 1, 1, 1, 1]
            .map((e) => Container(
                  height: 95,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 95,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(width: 9),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildContant(dynamic param) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseDetailPage(
                model: param,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: '${param['course_Thumbnail_Url']}',
                  fit: BoxFit.fill,
                  height: 95,
                  width: 150,
                  errorWidget: (context, url, error) => Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).custom.A4CB1_w_fffd57,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 9),
            Expanded(
              child: Container(
                width: 150,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '${param['course_Name']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            widget.changePage!(0);
            // setState(() {
            //   _searchController.clear();
            //   textSearch = '';
            //   textEternalSearch = '';
            //   _cateTypeSelected = 0; // reset category selection if applicable
            //   _listFilterLenght = 0; // reset the length of filtered list

            //   // Clear current search results
            //   _modelRecommend = Future.value([]);
            //   _modelCouseEternal = Future.value([]);
            // });

            // Reload initial data
            // _callReadRecomment();
            // _callReadCouseEternal();
          },
          child: Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(5),
            child: Image.asset(
              MyApp.themeNotifier.value == ThemeModeThird.light
                  ? 'assets/images/back_arrow.png'
                  : 'assets/images/2024/back_balckwhite.png',
            ),
          ),
        ),
        Flexible(
          child: Text(
            'ระบบส่งเสริม Re-skill',
            style: TextStyle(
              fontSize: 16,
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
      ],
    );
  }

  _typeCategory() {
    return Container(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => GestureDetector(
          onTap: () => setState(() => _typeSelected = __),
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
                  : MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : Colors.black,
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Text(
              _typeList[__],
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
        itemCount: _typeList.length,
      ),
    );
  }

  _cateTypeCategory() {
    return Container(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => GestureDetector(
          onTap: () => setState(() {
            _cateTypeSelected = __;
            // if (_cateTypeSelected == 0) {
            // textEternalSearch = '';
            _filterEternal();
            // } else {
            // textSearch = '';
            _filter();
            // }
          }),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(17.5),
            //   color: __ == _cateTypeSelected
            //       ? MyApp.themeNotifier.value == ThemeModeThird.light
            //           ? Color(0xFFBD4BF7)
            //           : MyApp.themeNotifier.value == ThemeModeThird.dark
            //               ? Colors.white
            //               : Color(0xFFFFFD57)
            //       : Colors.white,
            // ),
            decoration: BoxDecoration(
              color: __ == _cateTypeSelected
                  // ? Color(0xFFB325F8)
                  ? MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFBD4BF7)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57)
                  : MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : Colors.black,
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Text(
              _cateTypeList[__],
              // style: TextStyle(
              //   color: __ == _cateTypeSelected
              //       ? MyApp.themeNotifier.value == ThemeModeThird.light
              //           ? Colors.white
              //           : MyApp.themeNotifier.value == ThemeModeThird.dark
              //               ? Colors.black
              //               : Colors.black
              //       : Colors.black,
              // ),
              style: TextStyle(
                  color: __ == _cateTypeSelected
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
        itemCount: _cateTypeList.length,
      ),
    );
  }

  _lmsCategory() {
    return Container(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 0,
          direction: Axis.vertical,
          children: _lmsCategoryList
              .map(
                (element) => Container(
                  width: 250,
                  // height: MyApp.fontKanit.value != FontKanit.small &&
                  //         MyApp.fontKanit.value != FontKanit.medium
                  //     ? 90
                  //     : 66,
                  height: MyApp.fontKanit.value == FontKanit.small
                      ? 60
                      : MyApp.fontKanit.value == FontKanit.medium
                          ? 94
                          : 118,

                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (cateCourseSearch != element['id']) {
                          cateCourseSearch = element['id'];
                          print('----------------${element['id']}');
                          print(
                              '----------cateCourseSearch------${cateCourseSearch}');
                        } else {
                          cateCourseSearch = '';
                        }
                        _filter();
                      });
                      // _cateCourseSelected =
                      // _filter();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MyCourseCategorySearchPage(
                      //       model: element,
                      //     ),
                      //   ),
                      // );
                    },
                    child: rowContactInformation(
                        element['cat_Thai'], element['img_Url'], element['id']),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget rowContactInformation(String title, String image, String id) {
    return Row(
      children: [
        MyApp.themeNotifier.value == ThemeModeThird.light
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              )
            : ColorFiltered(
                colorFilter:
                    ColorFilter.mode(Colors.grey, BlendMode.saturation),
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                  decoration: cateCourseSearch == id
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor:
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                ),
                // overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
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

  String formatDuration(String? duration) {
    if (duration == null || duration.isEmpty)
      return '0 นาที'; // ตรวจสอบค่าว่างหรือ null

    // แยกเวลาโดยใช้ ':' เป็นตัวแบ่ง
    final parts = duration.split(':');
    if (parts.length != 3) return 'รูปแบบเวลาไม่ถูกต้อง'; // ตรวจสอบรูปแบบเวลา

    // แปลงเวลาเป็นตัวเลข
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;

    // สร้างข้อความที่มีหน่วยเวลา
    final buffer = StringBuffer();
    if (hours >= 0) buffer.write('$hours ชั่วโมง ');
    if (minutes > 0) buffer.write('$minutes นาที ');
    // if (seconds > 0) buffer.write('$seconds วินาที');

    return buffer.toString().trim(); // ลบช่องว่างส่วนเกิน
  }
}
