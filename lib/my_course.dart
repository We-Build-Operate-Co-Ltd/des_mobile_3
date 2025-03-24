import 'package:des/main.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/widget/blinking_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: must_be_immutable
class MyCoursePage extends StatefulWidget {
  const MyCoursePage({
    Key? key,
    this.model,
    this.page,
    this.callBack,
  }) : super(key: key);

  final dynamic model;
  final Function? callBack;
  final String? page;

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

Future<dynamic>? _modelMyCourse;

class _MyCoursePageState extends State<MyCoursePage> {
  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;
  final storage = const FlutterSecureStorage();
  int _listLenght = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _modelMyCourse, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'คอร์สเรียนของคุณ (${_listLenght})',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w600,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFB325F8)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return _buildContant(snapshot.data[index]);
                        }),
                  ],
                ));
          } else {
            return blankListData(context);
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildContant(dynamic param) {
    return Column(
      children: [
        Container(
          height: 100,
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  param['thumbnailLink'],
                  fit: BoxFit.cover,
                  height: 95,
                  width: 160,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return BlinkingIcon(); // Placeholder ขณะโหลด
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error); // เมื่อโหลดรูปไม่สำเร็จ
                  },
                ),
              ),
              SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: 160,
                      child: Text(
                        '${param['title']}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.black
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                border: Border.all(
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
                            Container(
                              width: 80 * 50 / 100,
                              height: 9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFFB325F8)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                                border: Border.all(
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
                        const SizedBox(width: 4),
                        Text(
                          'เรียนแล้ว 50%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).custom.b_w_y,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        lineBottom(),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget containerList(dynamic model) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        // elevation: 4,
        color: Theme.of(context).custom.primary,
        child: Container(
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
                child: (model?['thumbnailLink'] ?? '') != ''
                    ? Image.network(
                        model['thumbnailLink'],
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
                      model?['duration'],
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

  blankListData(BuildContext context, {double height = 100}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            'คอร์สเรียนของคุณ (0)',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFB325F8)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 143,
          width: 180,
          padding: EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/owl-3.png"),
              alignment: Alignment.topCenter,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Text(
            'คุณยังไม่เคยลงทะเบียนเรียนคอร์สของเรามาก่อน',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Kanit',
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFB325F8)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Text(
            'มาเริ่มค้นหาคอร์สที่คุณสนใจกันเลย!',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Kanit',
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFB325F8)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (widget.page != 'profile')
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => MyClassAllNewPage(),
              //   ),
              // );
              widget.callBack!();
            },
            child: Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8)
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
                'ค้นหาคอร์ส',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
            ),
          ),
        SizedBox(height: 50),
      ],
    );
  }

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
    _callRead();
    //  themeColor
    super.initState();
  }

  _callRead() async {
    setState(() {
      // _modelMyCourse = Future.value(response.data);

      _modelMyCourse = Future.value({});
    });

    var model = await _modelMyCourse;
    _listLenght = model.length;
  }

  lineBottom() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.white.withOpacity(0.5)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white.withOpacity(0.5)
                    : Color(0xFFFFFD57).withOpacity(0.5),
            width: 0.8,
          ),
        ),
      ),
    );
  }
}
