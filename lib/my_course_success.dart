import 'package:des/main.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/widget/blinking_icon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyCourseSuccessPage extends StatefulWidget {
  const MyCourseSuccessPage({
    Key? key,
    this.model,
    this.callBack,
    this.page,
  }) : super(key: key);

  final dynamic model;
  final Function? callBack;
  final String? page;
  @override
  State<MyCourseSuccessPage> createState() => _MyCourseSuccessPageState();
}

Future<dynamic>? _modelMyCourseSuccess;

class _MyCourseSuccessPageState extends State<MyCourseSuccessPage> {
  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;
  final _scController = ScrollController();
  final storage = const FlutterSecureStorage();
  int _listLenght = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _modelMyCourseSuccess, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (_isLoading) {
          return Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFB325F8)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          );
        }

        if (snapshot.hasData &&
            snapshot.data is List &&
            (snapshot.data as List).isNotEmpty) {
          return Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'คอร์สสำเร็จ (${_listLenght})',
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
              Expanded(
                child: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          param['course_Thumbnail_Url'],
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
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.grey, BlendMode.saturation),
                          child: Image.network(
                            param['course_Thumbnail_Url'],
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
                      ),
              ),
              SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: 160,
                      child: Text(
                        '${param['course_Name']}',
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(
                                  MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? 'assets/images/course_time.png'
                                      : "assets/images/2024/time_home_page_blackwhite.png",
                                  height: 24,
                                  width: 24),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.005),
                              Text(
                                (param?['course_Duration']),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
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
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print(
                                  '-------------->> Handle certificate tap <<--------------');
                            },
                            child: Container(
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFFB325F8)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                              child: Center(
                                child: Text(
                                  'Certificate',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: MyApp.themeNotifier.value ==
                                              ThemeModeThird.light
                                          ? Colors.white
                                          : MyApp.themeNotifier.value ==
                                                  ThemeModeThird.dark
                                              ? Colors.black
                                              : Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ),
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
        const SizedBox(height: 15),
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
            'คอร์สสำเร็จ (0)',
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
            'คุณยังไม่มีคอร์สที่เรียนสำเร็จ',
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
            'มาเรียนรู้ต่อหรือค้นหาคอร์สที่คุณสนใจกันเลย!',
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
              widget.callBack!(1);
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
                'ไปยังคอร์สเรียนของคุณ',
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
        const SizedBox(height: 10),
        if (widget.page != 'profile')
          GestureDetector(
            onTap: () {
              widget.callBack!(0);
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
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: buttonTheme,
          border: Border.all(color: colorTheme),
        ),
        child: Image.asset(
          'assets/images/back_arrow.png',
        ),
      ),
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

  bool _isLoading = false;
  _callRead() async {
    try {
      var dio = Dio();
      var profileMe = await ManageStorage.readDynamic('profileMe') ?? {};
      var accessToken = await ManageStorage.read('accessToken') ?? '';
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      setState(() {
        _isLoading = true;
      });

      if (profileMe['lmsUserId'] == null ||
          profileMe['lmsUserId'].toString().isEmpty) {
        setState(() {
          _modelMyCourseSuccess = Future.value([]);
          _listLenght = 0;
          _isLoading = false;
        });
        return;
      }

      var response = await dio.get(
        'https://dcc.onde.go.th/dcc-api/api/Lms/GetCompleteCourse?studentId=${profileMe['lmsUserId']}',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        var model = response.data ?? [];

        setState(() {
          _modelMyCourseSuccess = Future.value(model);
          _listLenght = model.length;

          _isLoading = false;
        });
      } else {
        print('Error: ${response.statusMessage}');
        _isLoading = false;
      }
    } catch (e) {
      print('Exception: $e');
      _isLoading = false;
    }
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
        Container(
          margin: EdgeInsets.all(5),
          child: Text(
            'สถาบันคุณวุฒิวิชาชีพ',
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
}
