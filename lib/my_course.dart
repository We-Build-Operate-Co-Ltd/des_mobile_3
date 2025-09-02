import 'package:des/main.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/webview_inapp.dart';
import 'package:des/widget/blinking_icon.dart';
import 'package:dio/dio.dart';
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
      future: _modelMyCourse,
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

        // print('data(length): ${snapshot.data.length}');
        // if (snapshot.data.length > 0) {
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
                      'คอร์สเรียนของคุณ (${_listLenght})',
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
                      })
                ],
              ));
        } else {
          return blankListData(context);
        }
      },
    );
  }

  Widget _buildContant(dynamic param) {
    return InkWell(
      onTap: () async {
        print('_buildContant: ${param['course_Id']}');
        var loginData = await ManageStorage.readDynamic('loginData');
        var accessToken = await ManageStorage.read('accessToken');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewInAppPage(
              url:
                  'https://lms.dcc.onde.go.th/user/user/lesson_details/${param['course_Id']}?sso_key=${loginData['sub']}&access_token=${accessToken}',
              title: param['course_Name'] ?? '',
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 100,
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyApp.themeNotifier.value == ThemeModeThird.light
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
                SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
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
                      const SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: (param['watch_Percentage'] ?? 0.0) / 100,
                        minHeight: 10,
                        backgroundColor:
                            MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.grey[700]
                                : Colors.grey[100],
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFB325F8)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(param['watch_Percentage'] ?? 0.0).toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFFB325F8)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          lineBottom(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget containerList(dynamic model) {
    return GestureDetector(
      onTap: () {},
      child: Container(
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

    super.initState();
  }

  bool _isLoading = false;
  _callRead() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var profileMe = await ManageStorage.readDynamic('profileMe') ?? {};
      var accessToken = await ManageStorage.read('accessToken') ?? '';
      var dio = Dio();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      if (profileMe['lmsUserId'] == null ||
          profileMe['lmsUserId'].toString().isEmpty) {
        setState(() {
          _modelMyCourse = Future.value([]);
          _listLenght = 0;
          _isLoading = false;
        });
        return;
      }

      var response = await dio.get(
        '$ondeURL/api/Lms/GetEnrolledCourse?studentId=${profileMe['lmsUserId']}',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        var model = response.data ?? [];

        setState(() {
          _modelMyCourse = Future.value(model);
          _listLenght = model.length;

          _isLoading = false;
        });

        print("_listLenght : $_listLenght");
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
