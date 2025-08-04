import 'package:des/main.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/image_viewer.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/widget/blinking_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:share_plus/share_plus.dart';

import 'webview_inapp.dart';

// ignore: must_be_immutable
class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({
    Key? key,
    this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;
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
                return MyApp.themeNotifier.value == ThemeModeThird.light
                    ? ImageViewer(
                        initialIndex: 0,
                        imageProviders: [widget.model['course_Thumbnail_Url']]
                            .map<ImageProvider<Object>>((e) => NetworkImage(e))
                            .toList(),
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                        child: ImageViewer(
                          initialIndex: 0,
                          imageProviders: [widget.model['course_Thumbnail_Url']]
                              .map<ImageProvider<Object>>(
                                  (e) => NetworkImage(e))
                              .toList(),
                        ),
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
              child: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Image.network(
                      (widget.model?['course_Thumbnail_Url'] ?? '') != ''
                          ? widget.model['course_Thumbnail_Url']
                          : '',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return BlinkingIcon(); // Placeholder ขณะโหลด
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error); // เมื่อโหลดรูปไม่สำเร็จ
                      },
                    )
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                      child: Image.network(
                        (widget.model?['course_Thumbnail_Url'] ?? '') != ''
                            ? widget.model['course_Thumbnail_Url']
                            : '',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return BlinkingIcon(); // Placeholder ขณะโหลด
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error); // เมื่อโหลดรูปไม่สำเร็จ
                        },
                      )),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       Expanded(
        //           child: Row(
        //         children: [
        //           Image.asset('assets/images/course_time.png',
        //               height: 25, width: 25),
        //           const SizedBox(width: 8),
        //           Text(
        //             widget.model?['course_duration'] ?? '',
        //             style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.w400,
        //               color: MyApp.themeNotifier.value == ThemeModeThird.light
        //                   ? Colors.white
        //                   : Colors.black,
        //             ),
        //           ),
        //         ],
        //       )),
        //       InkWell(
        //         onTap: () => _callShare(widget.model),
        //         child: Container(
        //           height: 30,
        //           width: 30,
        //           alignment: Alignment.center,
        //           decoration: BoxDecoration(
        //             color: Theme.of(context).custom.b325f8_w_fffd57,
        //             borderRadius: BorderRadius.circular(15),
        //             border: Border.all(color: colorTheme),
        //           ),
        //           child: Image.asset(
        //             'assets/images/share.png',
        //             width: 14.83,
        //             height: 13.38,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          // margin: const EdgeInsets.only(right: 50, top: 10),
          child: Text(
            widget.model?['course_name'] ?? '',
            style: TextStyle(
              color: textTheme,
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        // SizedBox(height: 20),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Row(
        //     children: [
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        //         decoration: BoxDecoration(
        //           color: buttonTheme,
        //           borderRadius: BorderRadius.circular(12.5),
        //           border: Border.all(color: colorTheme),
        //         ),
        //         child: Row(
        //           children: [
        //             Icon(
        //               Icons.access_time_outlined,
        //               size: 10,
        //               color: Colors.white,
        //             ),
        //             SizedBox(width: 5),
        //             Text(
        //               widget.model?['course_duration'] ?? '',
        //               // '3 ชั่วโมง',
        //               style: TextStyle(
        //                 fontSize: 9,
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       // const SizedBox(width: 5),
        //       // Container(
        //       //   padding: EdgeInsets.symmetric(
        //       //     horizontal: 9,
        //       //     vertical: 3,
        //       //   ),
        //       //   decoration: BoxDecoration(
        //       //     color: buttonTheme,
        //       //     borderRadius: BorderRadius.circular(12.5),
        //       //     border: Border.all(color: colorTheme),
        //       //   ),
        //       //   child: Row(
        //       //     children: [
        //       //       Image.asset(
        //       //         'assets/images/book.png',
        //       //         height: 10,
        //       //         width: 8.41,
        //       //       ),
        //       //       const SizedBox(width: 5),
        //       //       const Text(
        //       //         '4 บทเรียน',
        //       //         style: TextStyle(
        //       //           fontSize: 9,
        //       //           color: Colors.white,
        //       //         ),
        //       //       ),
        //       //     ],
        //       //   ),
        //       // ),
        //       // const Expanded(child: SizedBox()),
        //       // InkWell(
        //       //   onTap: () => _callShare(widget.model),
        //       //   child: Container(
        //       //     height: 30,
        //       //     width: 30,
        //       //     alignment: Alignment.center,
        //       //     decoration: BoxDecoration(
        //       //       color: Theme.of(context).custom.b325f8_w_fffd57,
        //       //       borderRadius: BorderRadius.circular(15),
        //       //       border: Border.all(color: colorTheme),
        //       //     ),
        //       //     child: Image.asset(
        //       //       'assets/images/share.png',
        //       //       width: 14.83,
        //       //       height: 13.38,
        //       //     ),
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),

        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'รายละเอียด',
                style: TextStyle(
                  color: textTheme,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // lineBottom(),
              Text(
                widget.model?['description'] ?? '',
                style: TextStyle(
                  color: Color(0xFF707070),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.left,
                maxLines: 3,
              ),
              // SizedBox(height: 10),
              // lineBottom()
            ],
          ),
        ),

        const SizedBox(height: 85),
        InkWell(
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
                  title: widget.model?['course_name'] ?? '',
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
              color: Theme.of(context).custom.b325f8_w_fffd57,
              borderRadius: BorderRadius.circular(22.5),
              // border: Border.all(color: colorTheme),
            ),
            child: Text(
              'เริ่มเรียน',
              style: TextStyle(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.white
                    : Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        child: Image.asset(MyApp.themeNotifier.value == ThemeModeThird.light
            ? 'assets/images/back_arrow.png'
            : 'assets/images/2024/back_balckwhite.png'),
      ),
    );
  }

  @override
  void initState() {
    if (MyApp.themeNotifier.value == ThemeModeThird.light) {
      backgroundTheme = Colors.white;
      colorTheme = Color(0xFFB325F8);
      buttonTheme = Color(0xFFB325F8);
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

  Future<void> _callShare(Map<String, dynamic> param) async {
    final String message =
        '''📚🔖ขอเชิญชวนร่วม คอร์สเรียนเพื่อการเรียนรู้ ดิจิทัลชุมชน หัวข้อ
"${param['title']}"
🚩🚩 🚩🚩
${param['imageUrl']}
''';

    await Share.share(
      message,
      subject: 'DCC Platform',
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
