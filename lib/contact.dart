import 'dart:convert';

import 'package:des/main.dart';
import 'package:des/models/mock_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'shared/theme_data.dart';

class ContactPage extends StatefulWidget {
  ContactPage({super.key, this.changePage});
  Function? changePage;

  // final String category;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late TextEditingController _searchController;
  Future<dynamic>? _futureModel;
  Future<dynamic>? _futureCategoryModel;
  String _categoryCode = '';

  @override
  Widget build(BuildContext context) {
    List<dynamic> categoryList = MockContact.mockContactCategoryList();

    // Find the category that matches _categoryCode
    var selectedCategory = categoryList.firstWhere(
      (category) => category['code'] == _categoryCode,
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/BG.png"),
                      fit: BoxFit.cover,
                      colorFilter: MyApp.themeNotifier.value ==
                              ThemeModeThird.light
                          ? null
                          : ColorFilter.mode(Colors.grey, BlendMode.saturation),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 85),
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.white
                            : Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    widget.changePage!(6);
                                    // Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 35.0,
                                    height: 35.0,
                                    margin: EdgeInsets.all(5),
                                    child: Image.asset(
                                        MyApp.themeNotifier.value ==
                                                ThemeModeThird.light
                                            ? 'assets/images/back_profile.png'
                                            : "assets/images/2024/back_balckwhite.png"
                                        // color: Colors.white,
                                        ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'เบอร์ติดต่อ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
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
                            SizedBox(height: 12),
                            SizedBox(
                              height: MyApp.fontKanit.value == FontKanit.small
                                  ? 25
                                  : MyApp.fontKanit.value == FontKanit.medium
                                      ? 35
                                      : 45,
                              width: double.infinity,
                              child: FutureBuilder(
                                future: _futureCategoryModel,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return _builditemCategory(
                                            snapshot.data[index]);
                                      },
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 10),
                                      itemCount: snapshot.data.length,
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: _isLoading
                                  ? Center(
                                      child:
                                          CircularProgressIndicator()) // แสดง loading เมื่อ _isLoading = true
                                  : FutureBuilder<dynamic>(
                                      future: _futureModel,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.separated(
                                            padding: EdgeInsets.only(top: 15),
                                            itemBuilder: (_, index) =>
                                                _buildItem(
                                                    snapshot.data[index]),
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 10),
                                            itemCount: snapshot.data.length,
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  bool _isLoading = false;

  void onCategoryChanged(String newCategoryCode) {
    setState(() {
      _categoryCode = newCategoryCode;
    });
    _callRead();
  }

  Widget _builditemCategory(dynamic model) {
    bool thisItem = model['code'] == _categoryCode;
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _categoryCode = model['code'];
            print('======== >>Category Code: $_categoryCode');
            _callRead();
          }),
          child: Container(
            height: MyApp.fontKanit.value == FontKanit.small
                ? 25
                : MyApp.fontKanit.value == FontKanit.medium
                    ? 35
                    : 45,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: thisItem
                  ? MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFBD4BF7)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57)
                  : MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : Colors.black,
              borderRadius: BorderRadius.circular(12.5),
            ),
            child: Text(
              model['title'],
              style: TextStyle(
                color: thisItem
                    ? MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.white
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.black
                            : Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFBD4BF7)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                fontSize: 13,
                fontWeight: thisItem ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(dynamic model) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse('tel:${model['center_Tel']}'),
          mode: LaunchMode.externalApplication),
      child: SizedBox(
        height: MyApp.fontKanit.value == FontKanit.small
            ? 45
            : MyApp.fontKanit.value == FontKanit.medium
                ? 65
                : 85,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['center_Name'],
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.black
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    model['center_Tel'] ?? 'ไม่มีข้อมูล',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFBD4BF7)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.white
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFBD4BF7)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                MyApp.themeNotifier.value == ThemeModeThird.light
                    ? 'assets/images/Icon zocial-call.png'
                    : "assets/images/2024/Icon zocial-call_black.png",
                height: 22.7,
                width: 22.7,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildText(dynamic model) {
    return Text(model['title']);
  }

  // static InputDecoration _decorationSearch(context, {String hintText = ''}) =>
  //     InputDecoration(
  //       label: Text(hintText),
  //       labelStyle: const TextStyle(
  //         color: Color(0xFF707070),
  //         fontSize: 12,
  //       ),
  //       // hintText: hintText,
  //       filled: true,
  //       fillColor: Colors.transparent,
  //       prefixIcon: Container(
  //         padding: EdgeInsets.all(9),
  //         child: Image.asset(
  //           'assets/images/search.png',
  //           color: Color(0xFF707070),
  //         ),
  //       ),
  //       contentPadding: const EdgeInsets.fromLTRB(15.0, 2.0, 2.0, 2.0),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(20.0),
  //         borderSide: BorderSide(color: Theme.of(context).primaryColor),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(20.0),
  //         borderSide: BorderSide(color: Theme.of(context).primaryColor),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(20.0),
  //         borderSide: BorderSide(
  //           color: Colors.black.withOpacity(0.2),
  //         ),
  //       ),
  //       errorStyle: const TextStyle(
  //         fontWeight: FontWeight.normal,
  //         fontSize: 10.0,
  //       ),
  //     );

  @override
  void initState() {
    _searchController = TextEditingController(text: '');
    // _categoryCode = widget.category;
    _callReadCategory();
    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _callReadCategory() async {
    dynamic data = await MockContact.mockContactCategoryList();
    setState(() {
      _futureCategoryModel = Future.value(data);
    });
  }

  void _callRead() async {
    // เริ่มแสดง loading
    setState(() {
      _isLoading = true;
    });

    try {
      List<dynamic> data = await MockContact.mockContactCategoryList();

      var dio = Dio();
      var response = await dio.request(
        'https://dcc.onde.go.th/dcc-api/api/DataManagement/GetCenterLocation?latitude=13.7981919&longitude=100.5602958',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
        setState(() {
          _futureModel = _categoryCode == ''
              ? Future.value(response.data['data'])
              : _categoryCode == '2'
                  ? Future.value(MockContact.emergency)
                  : _categoryCode == '1'
                      ? Future.value(MockContact.DE)
                      : Future.value(response.data['data']);
          _isLoading = false; // หยุดแสดง loading
        });
      } else {
        print(response.statusMessage);
        setState(() {
          _isLoading = false; // หยุดแสดง loading แม้จะเกิด error
        });
      }
    } catch (e) {
      // จัดการ error
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
