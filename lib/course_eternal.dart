import 'package:des/main.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'course_detail_new.dart';

// ignore: must_be_immutable
class CourseEternalPage extends StatefulWidget {
  const CourseEternalPage({
    Key? key,
    this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  State<CourseEternalPage> createState() => _CourseEternalPageState();
}

Future<dynamic>? _modelCouseEternal;

class _CourseEternalPageState extends State<CourseEternalPage> {
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
            child: _buildHead(),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: _buildListModel(),
        ));
  }

  _buildListModel() {
    return FutureBuilder(
      future: _modelCouseEternal,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: 10 / 12.5,
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
                  containerEternal(snapshot.data![index]),
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget containerEternal(dynamic model) {
    return GestureDetector(
      onTap: () {
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
                            )
                      : ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
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
                        )),
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

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        // padding: EdgeInsets.all(5),
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
    _callReadCouseEternal();
    //  themeColor
    super.initState();
  }

  _callReadCouseEternal() async {
    var response = await Dio().get('$ondeURL/api/Lms/GetCouseExternal');

    setState(() {
      _modelCouseEternal = Future.value(response.data);
    });
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

  Widget _buildHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            // padding: EdgeInsets.all(5),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //     color: MyApp.themeNotifier.value == ThemeModeThird.light
            //         ? Color(0xFFB325F8)
            //         : Colors.black,
            //     border: Border.all(
            //       width: 1,
            //       style: BorderStyle.solid,
            //       color: MyApp.themeNotifier.value == ThemeModeThird.light
            //           ? Color(0xFFB325F8)
            //           : MyApp.themeNotifier.value == ThemeModeThird.dark
            //               ? Colors.white
            //               : Color(0xFFFFFD57),
            //     )),
            child: Image.asset(
              MyApp.themeNotifier.value == ThemeModeThird.light
                  ? 'assets/images/back_arrow.png'
                  : "assets/images/2024/back_balckwhite.png",
            ),
          ),
        ),
        SizedBox(width: 12),
        Flexible(
          child: Text(
            'สถาบันคุณวุฒิวิชาชีพ',
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
}
