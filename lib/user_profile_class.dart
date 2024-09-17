import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/course_eternal.dart';
import 'package:des/home.dart';
import 'package:des/my_class_all.dart';
import 'package:des/my_course.dart';
import 'package:des/my_course_success.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
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

class UserProfileClassPage extends StatefulWidget {
  UserProfileClassPage({Key? key, this.title}) : super(key: key);

  final title;

  @override
  _UserProfileClassPageState createState() => _UserProfileClassPageState();
}

class _UserProfileClassPageState extends State<UserProfileClassPage> {
  Dio dio = Dio();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<dynamic> _typeList = [
    'คอร์สเรียนของคุณ',
    'คอร์สสำเร็จ',
  ];
  List<dynamic> _categoryList = [];
  List<dynamic> _lmsCategoryList = [];

  int _typeSelected = 0;

  dynamic _model;
  dynamic _tempModel;

  late MyCoursePage myCourse;
  late MyCourseSuccessPage myCourseSuccess;

  // dynamic _tempModelRecommend;
  List<dynamic> _tempModelRecommend = [];

  bool isObsecure = false;
  Color textTheme = Colors.transparent;

  String _topModalData = "ทั้งหมด";

  @override
  void initState() {
    myCourse = new MyCoursePage(
      page: 'profile',
      callBack: () {
        setState(() {});
      },
    );

    myCourseSuccess = new MyCourseSuccessPage(
      page: 'profile',
      callBack: (value) {
        setState(() {});
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
                    image: AssetImage("assets/images/new_bg.png"),
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
                    // height:  MediaQuery.of(context).size.height * .650,
                    width: 350,
                    height: deviceHeight * 0.75,
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
                                  physics: const ClampingScrollPhysics(), // 2nd
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

  Widget _buildHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => HomePage(),
            //   ),
            // );
          },
          child: Container(
            height: 35,
            width: 35,
            padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
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
        Container(
          margin: EdgeInsets.all(5),
          child: Text(
            'คลาสและความสำเร็จ',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFB325F8)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
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
              borderRadius: BorderRadius.circular(17.5),
              color: __ == _typeSelected ? Color(0xFFB325F8) : Colors.white,
            ),
            child: Text(
              _typeList[__],
              style: TextStyle(
                color: __ == _typeSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemCount: _typeList.length,
      ),
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
}
