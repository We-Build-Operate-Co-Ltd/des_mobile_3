import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/main.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/image_viewer.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:ui' as ui show ImageFilter;

import 'webview_inapp.dart';

// ignore: must_be_immutable
class CourseDetailNewPage extends StatefulWidget {
  const CourseDetailNewPage({
    Key? key,
    this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  State<CourseDetailNewPage> createState() => _CourseDetailNewPageState();
}

class _CourseDetailNewPageState extends State<CourseDetailNewPage> {
  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;
  final _scController = ScrollController();
  final storage = const FlutterSecureStorage();

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
                const SizedBox(width: 20),
                Flexible(
                  child: Text(
                    'รายละเอียดคอร์ส',
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
            ),
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return ListView(
      shrinkWrap: true, // 1st add
      physics: const ClampingScrollPhysics(), // 2nd
      children: [
        InkWell(
          onTap: () {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return ImageViewer(
                  initialIndex: 0,
                  imageProviders: [widget.model['url']]
                      .map<ImageProvider<Object>>((e) => NetworkImage(e))
                      .toList(),
                );
              },
            );
          },
          child: Container(
            height: 194,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17.5),
              child: CachedNetworkImage(
                imageUrl: (widget.model?['thumbnailLink'] ?? '') != ''
                    ? widget.model['thumbnailLink']
                    : '',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            widget.model?['title'] ?? '',
            style: TextStyle(
                color: textTheme,
                fontSize: 18,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            widget.model?['subject'] ?? '',
            style: TextStyle(
                color: textTheme,
                fontSize: 16,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w400),
          ),
        ),
        // SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 25,
                width: 25,
                child: Image.asset(
                  MyApp.themeNotifier.value == ThemeModeThird.light
                      ? 'assets/images/course_time.png'
                      : "assets/images/2024/time_home_page_blackwhite.png",
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  widget.model?['duration'] ?? '',
                  style: TextStyle(
                      color: textTheme,
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //   height: 25,
              //   width: 25,
              //   child: Image.asset('assets/images/about_us_mark.png'),
              // ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  widget.model?['course_Duration'] ?? '',
                  style: TextStyle(
                      color: textTheme,
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: lineBottom(),
        ),
        const SizedBox(height: 85),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: InkWell(
            onTap: () async {
              var loginData = await ManageStorage.readDynamic('loginData');
              var accessToken = await ManageStorage.read('accessToken');
              logWTF(
                  'https://lms.dcc.onde.go.th/user/user/lesson_details/${widget.model['course_id']}?sso_key=${loginData['sub']}&access_token=${accessToken}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WebViewInAppPage(
                    url:
                        'https://lms.dcc.onde.go.th/user/user/lesson_details/${widget.model['course_id']}?sso_key=${loginData['sub']}&access_token=${accessToken}',
                    title: widget.model?['subject'] ?? '',
                  ),
                ),
              );

              // launchUrl(
              //   Uri.parse(
              //       'https://lms.dcc.onde.go.th/user/user/lesson_details/${widget.model['id']}'),
              //   mode: LaunchMode.externalApplication,
              // );
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).custom.b325f8_w_g,
                borderRadius: BorderRadius.circular(22.5),
                border: Border.all(color: colorTheme),
              ),
              child: Text(
                'ลงทะเบียนเรียน',
                style: TextStyle(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.black
                          : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        // const SizedBox(height: 50),
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        // padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(8),
        //   color: buttonTheme,
        //   border: Border.all(color: colorTheme),
        // ),
        child: Image.asset(
          MyApp.themeNotifier.value == ThemeModeThird.light
              ? "assets/images/back_arrow.png"
              : "assets/images/2024/back_balckwhite.png",
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
    //  themeColor
    super.initState();
  }

  Future<void> _callShare(param) async {
    await FlutterShare.share(
        title: 'DCC Platform',
        text:
            '''📚🔖ขอเชิญชวนร่วม คอร์สเรียนเพื่อการเรียนรู้ ดิจิทัลชุมชน หัวข้อ
"${param['title']}"
🚩🚩 🚩🚩''',
        linkUrl: param['imageUrl'],
        chooserTitle: 'Example Chooser Title');
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
