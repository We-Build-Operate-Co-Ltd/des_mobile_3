import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/main.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_share/flutter_share.dart';

// ignore: must_be_immutable
class FindJobDetailPage extends StatefulWidget {
  const FindJobDetailPage({
    Key? key,
    this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  State<FindJobDetailPage> createState() => _FindJobDetailPageState();
}

class _FindJobDetailPageState extends State<FindJobDetailPage> {
  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;
  final storage = const FlutterSecureStorage();

  dynamic _detailModel;

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
                const SizedBox(width: 40),
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
            // showCupertinoDialog(
            //   context: context,
            //   builder: (context) {
            //     return ImageViewer(
            //       initialIndex: 0,
            //       imageProviders: [widget.model['docs']]
            //           .map<ImageProvider<Object>>((e) => NetworkImage(e))
            //           .toList(),
            //     );
            //   },
            // );
          },
          child: Container(
            height: 194,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17.5),
              child: CachedNetworkImage(
                imageUrl: 'https://lms.dcc.onde.go.th/uploads/course/' +
                    '${widget.model?['docs'] ?? ''}',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50, top: 10),
          child: Text(
            widget.model?['positionName'] ?? '',
            style: TextStyle(
              color: textTheme,
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50),
          child: Text(
            widget.model?['companyname'] ?? '',
            style: TextStyle(
              color: textTheme,
              fontSize: 15,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50, top: 50),
          child: Text(
            'คุณสมบัติ',
            style: TextStyle(
              color: textTheme,
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50),
          child: Text(
            widget.model?['jobHightlight'] ?? '',
            style: TextStyle(
              color: textTheme,
              fontSize: 15,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50, top: 50),
          child: Text(
            'รายละเอียดงาน',
            style: TextStyle(
              color: textTheme,
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50),
          child: Text(
            _detailModel != null
                ? _detailModel!['jobResponsibilityDto']![0]!['jobdescription']
                : '',
            style: TextStyle(
              color: textTheme,
              fontSize: 15,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50, top: 50),
          child: Text(
            'สวัสดิการ',
            style: TextStyle(
              color: textTheme,
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50),
          child: Text(
            widget.model?['benefit'] ?? '',
            style: TextStyle(
              color: textTheme,
              fontSize: 15,
              fontFamily: 'Kanit',
            ),
          ),
        ),

        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50, top: 10),
          child: Text(
            'เงินเดือน',
            style: TextStyle(
              color: textTheme,
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50),
          child: Text(
            _detailModel != null
                ? _detailModel!['jobPostSalaryDto']!['salary']
                : '',
            style: TextStyle(
              color: textTheme,
              fontSize: 15,
              fontFamily: 'Kanit',
            ),
          ),
        ),

        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50, top: 10),
          child: Text(
            'ข้อมูลติดต่อ',
            style: TextStyle(
              color: textTheme,
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // margin: const EdgeInsets.only(right: 50),
              child: Text(
                'Tel : ',
                style: TextStyle(
                  color: textTheme,
                  fontSize: 15,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(right: 50),
              child: Text(
                _detailModel != null
                    ? _detailModel!['jobPostContactDto']!['mobile']
                    : '',
                style: TextStyle(
                  color: textTheme,
                  fontSize: 15,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // margin: const EdgeInsets.only(right: 50),
              child: Text(
                'Email : ',
                style: TextStyle(
                  color: textTheme,
                  fontSize: 15,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(right: 50),
              child: Text(
                _detailModel != null
                    ? _detailModel!['jobPostContactDto']!['email']
                    : '',
                style: TextStyle(
                  color: textTheme,
                  fontSize: 15,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
          ],
        ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Row(
        //     children: [
        //       // Container(
        //       //   padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        //       //   decoration: BoxDecoration(
        //       //     color: buttonTheme,
        //       //     borderRadius: BorderRadius.circular(12.5),
        //       //     border: Border.all(color: colorTheme),
        //       //   ),
        //       //   child: Row(
        //       //     children: const [
        //       //       Icon(
        //       //         Icons.access_time_outlined,
        //       //         size: 10,
        //       //         color: Colors.white,
        //       //       ),
        //       //       SizedBox(width: 5),
        //       //       Text(
        //       //         '3 ชั่วโมง',
        //       //         style: TextStyle(
        //       //           fontSize: 9,
        //       //           color: Colors.white,
        //       //         ),
        //       //       ),
        //       //     ],
        //       //   ),
        //       // ),
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
        //       const Expanded(child: SizedBox()),
        //       InkWell(
        //         onTap: () => _callShare(widget.model),
        //         child: Container(
        //           height: 30,
        //           width: 30,
        //           alignment: Alignment.center,
        //           decoration: BoxDecoration(
        //             color: buttonTheme,
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
        // SizedBox(height: 10),
        // Padding(
        //   padding: const EdgeInsets.only(
        //     right: 10,
        //     left: 10,
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'รายละเอียด',
        //         style: TextStyle(
        //           color: textTheme,
        //           fontSize: 15,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //       Text(
        //         widget.model?['details'] ?? '',
        //         style: TextStyle(
        //           color: textTheme,
        //           fontSize: 13,
        //           fontWeight: FontWeight.w400,
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //         textAlign: TextAlign.left,
        //         maxLines: 3,
        //       ),
        //     ],
        //   ),
        // ),
        // GestureDetector(
        //   onTap: () => showDialog(
        //     context: context,
        //     useSafeArea: false,
        //     barrierColor: Colors.transparent,
        //     builder: (_) => Material(
        //       color: Color.fromARGB(0, 255, 255, 255),
        //       child: BackdropFilter(
        //         filter: ui.ImageFilter.blur(
        //           sigmaX: 5.0,
        //           sigmaY: 5.0,
        //         ),
        //         child: Container(
        //           color: MyApp.themeNotifier.value == ThemeModeThird.light
        //               ? Color(0xD953327A)
        //               : Colors.black,
        //           padding: EdgeInsets.only(
        //             top: MediaQuery.of(context).padding.top + 10,
        //             right: 10,
        //             bottom: 5,
        //             left: 10,
        //           ),
        //           child: Column(
        //             children: [
        //               Expanded(
        //                 child: FadingEdgeScrollView.fromScrollView(
        //                   child: ListView(
        //                     controller: _scController,
        //                     padding: EdgeInsets.zero,
        //                     children: [
        //                       SizedBox(height: 40),
        //                       Center(
        //                         child: Text(
        //                           'รายละเอียด',
        //                           style: TextStyle(
        //                             fontSize: 17,
        //                             fontWeight: FontWeight.w500,
        //                             color: MyApp.themeNotifier.value ==
        //                                     ThemeModeThird.light
        //                                 ? Colors.white
        //                                 : textTheme,
        //                           ),
        //                         ),
        //                       ),
        //                       SizedBox(height: 10),
        //                       Text(
        //                         widget.model['details'],
        //                         style: TextStyle(
        //                           color: Colors.white.withOpacity(0.8),
        //                         ),
        //                       ),
        //                       const SizedBox(height: 40),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //               Center(
        //                 child: GestureDetector(
        //                   onTap: () => Navigator.pop(context),
        //                   child: Container(
        //                     height: 40,
        //                     width: 40,
        //                     alignment: Alignment.center,
        //                     decoration: BoxDecoration(
        //                       color: buttonTheme,
        //                       borderRadius: BorderRadius.circular(10),
        //                       border: Border.all(color: colorTheme),
        //                     ),
        //                     child: Image.asset(
        //                       'assets/images/close_noti_list.png',
        //                       color: Colors.white,
        //                       height: 23.15,
        //                       width: 23.15,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               const SizedBox(height: 38),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 10),
        //         child: Text(
        //           '${parseHtmlString(widget.model?['description'] ?? '')}',
        //           style: TextStyle(
        //             fontSize: 13,
        //             color: colorTheme,
        //             overflow: TextOverflow.ellipsis,
        //           ),
        //           maxLines: 4,
        //         ),
        //       ),
        //       SizedBox(height: 5),
        //       Padding(
        //         padding: const EdgeInsets.only(
        //           right: 10,
        //           left: 10,
        //         ),
        //         child: Text(
        //           'อ่านทั้งหมด',
        //           style: TextStyle(
        //             color: textTheme,
        //             fontSize: 13,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 30),
        // const SizedBox(height: 85),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (_) => WebViewInAppPage(
        //           url:
        //               'https://lms.dcc.onde.go.th/user/user/lesson_details/${widget.model['id']}',
        //           title: widget.model['name'],
        //         ),
        //       ),
        //     );

        //     // launchUrl(
        //     //   Uri.parse(
        //     //       'https://lms.dcc.onde.go.th/user/user/lesson_details/${widget.model['id']}'),
        //     //   mode: LaunchMode.externalApplication,
        //     // );
        //   },
        //   child: Container(
        //     height: 45,
        //     alignment: Alignment.center,
        //     margin: EdgeInsets.symmetric(horizontal: 15),
        //     decoration: BoxDecoration(
        //       color: buttonTheme,
        //       borderRadius: BorderRadius.circular(22.5),
        //       border: Border.all(color: colorTheme),
        //     ),
        //     child: Text(
        //       'เริ่มเรียน',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 15,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
        // ),
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
        padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
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

  _callRead() async {
    Dio dio = new Dio();
    var response = await dio.get(
        'http://dcc-portal.webview.co/dcc-api/api/Job/GetJobPost/${widget.model['jobapplicationno']}');

    setState(() {
      _detailModel = response.data['data'];
    });

    // print(_model.toString());
  }
}
