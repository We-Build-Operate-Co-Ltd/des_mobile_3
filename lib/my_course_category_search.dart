import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/main.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/image_viewer.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:ui' as ui show ImageFilter;

import 'webview_inapp.dart';

// ignore: must_be_immutable
class MyCourseCategorySearchPage extends StatefulWidget {
  const MyCourseCategorySearchPage({
    Key? key,
    this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  State<MyCourseCategorySearchPage> createState() =>
      _MyCourseCategorySearchPageState();
}

Future<dynamic>? _modelCouseCategory;
dynamic _model = {};

class _MyCourseCategorySearchPageState
    extends State<MyCourseCategorySearchPage> {
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
        appBar:  PreferredSize(
          preferredSize: Size.fromHeight(70.0), // here the desired height
          child: AppBar(
          backgroundColor: backgroundTheme,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            height: 80 + MediaQuery.of(context).padding.top,
            color: backgroundTheme,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 15,
              right: 15,
            ),
            child: _buildHead(),
          ),
        ),),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: _buildListModel(),
        ));
  }

  _buildListModel() {
    return FutureBuilder(
      future: _modelCouseCategory,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 10 / 12.5,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              physics: const ClampingScrollPhysics(),
              // itemCount: snapshot.data!.length,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  containerCategory(snapshot.data![index]),
            );
          } else {
            return Center(
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget containerCategory(dynamic model) {
    return GestureDetector(
      onTap: () {},
      child: Container(
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
                child: (model?['cover_image_url'] ?? '') != ''
                    ? CachedNetworkImage(
                        imageUrl: '${model['cover_image_url']}',
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
                    model?['course_Name'] ?? '',
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
                    Image.asset('assets/images/course_time.png',
                        height: 24, width: 24),
                    const SizedBox(width: 8),
                    Text(
                      model?['course_Duration'],
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
    _callReadCouseCategory();
    //  themeColor
    super.initState();
  }

  _callReadCouseCategory() async {
    var response = await Dio()
        .get('$ondeURL/api/Lms/GetcoursewithCatId?catId=${widget.model['id']}');

    setState(() {
      _modelCouseCategory = Future.value(response.data['course_Data']);
      _model = response.data;
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
        SizedBox(width: 10),
        Container(
          width: 270,
          margin: EdgeInsets.all(5),
          child: Text(
            _model['cat_Thai'],
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
