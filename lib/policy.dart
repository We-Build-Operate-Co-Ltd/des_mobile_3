import 'package:des/shared/extension.dart';
import 'package:des/shared/notification_service.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'menu.dart';
import 'dart:ui' as ui show ImageFilter;

// ignore: must_be_immutable
class PolicyPage extends StatefulWidget {
  PolicyPage({
    Key? key,
    this.category,
    this.navTo,
  }) : super(key: key);

  final String? category;
  final Function? navTo;

  @override
  _PolicyPage createState() => _PolicyPage();
}

class _PolicyPage extends State<PolicyPage> {
  late int _limit;
  DateTime? currentBackPressTime;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController? scrollController;
  String _profileCode = '';
  List<dynamic> _listSwitchColors = [
    {'code': '1', 'title': 'ปกติ', 'isSelected': true},
    {'code': '2', 'title': 'ขาวดำ', 'isSelected': false},
    {'code': '3', 'title': 'ดำเหลือง', 'isSelected': false},
  ];

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });
    scrollController = new ScrollController();

    _read();

    super.initState();
  }

  Future<dynamic>? _futureModel;
  int currentCardIndex = 0;
  int policyLength = 0;
  bool lastPage = false;

  List acceptPolicyList = [];

  _read() async {
    var pf = await ManageStorage.read('profileCode') ?? '';
    setState(() {
      _profileCode = pf;
    });
    Dio dio = Dio();
    Response<dynamic> response;
    try {
      response = await dio
          .post('https://des.we-builds.com/de-api/m/policy/read', data: {
        "category": "application",
        "profileCode": _profileCode,
      });
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          setState(() {
            _futureModel = Future.value(response.data['objectData']);
          });
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).custom.w_b_b,
      body: WillPopScope(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowGlow();
            return false;
          },
          child: Container(
            alignment: Alignment.center,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                // alignment: Alignment.topCenter,
                image: AssetImage(
                  // 'assets/images/background_policy.png'
                  MyApp.themeNotifier.value == ThemeModeThird.light
                      ? 'assets/images/logo_2o.png'
                      : 'assets/images/logo_2o.png',
                ),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topRight,
              ),
            ),
            child: _futureBuilderModel(),
          ),
        ),
        onWillPop: confirmExit,
      ),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'กดอีกครั้งเพื่อออก');
      return Future.value(false);
    }
    return Future.value(true);
  }

  _futureBuilderModel() {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _screen(snapshot.data);
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return _screen([
            {'title': '', 'description': ''}
          ]);
        }
      },
    );
  }

  _screen(dynamic model) {
    policyLength = model.length;
    return Column(
      children: [
        // Expanded(
        //   flex: 1,
        //   child: Container(
        //     padding: EdgeInsets.only(top: 50),
        //     child: GestureDetector(
        //       onTap: () {
        //         buildModalSwitch(context);
        //       },
        //       child: Container(
        //         // height: 35,
        //         // width: 35,
        //         // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        //         decoration: BoxDecoration(
        //             color: Colors.black,
        //             borderRadius: BorderRadius.circular(10),
        //             border: Border.all(
        //               width: 1,
        //               style: BorderStyle.solid,
        //               color: Theme.of(context).custom.b_w_y,
        //             )),
        //         child: Icon(
        //           Icons.visibility_outlined,
        //           color: Theme.of(context).custom.w_w_y,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 50,
              left: 40,
              right: 40,
            ),
            color: Colors.transparent,
            child: Text(
              ' DES ดิจิทัลชุมชน',
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Kanit',
                  color: Theme.of(context).custom.A4CB1_w_fffd57),
            ),
          ),
        ),
        lastPage ? _buildListCard(model) : _buildCard(model[currentCardIndex])
      ],
    );
  }

  buildModalSwitch(
    BuildContext context,
  ) {
    return showCupertinoModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : Color(0xFF121212),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ความตัดกันของสี',
                        style: TextStyle(
                          fontSize: 20,
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.black
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      // contentCard(context, "ปกติ", "1", "color"),
                      // SizedBox(height: 10),
                      // contentCard(context, "ขาวดำ", "2", "color"),
                      // SizedBox(height: 10),
                      // contentCard(context, "ดำเหลือง", "3", "color"),
                      contentCardV2(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  contentCardV2(BuildContext context) {
    return Container(
      child: Wrap(
          children: _listSwitchColors
              .map(
                (item) => GestureDetector(
                  onTap: () {
                    setState(
                      (() async {
                        await storage.write(
                          key: 'switchColor',
                          value: item['title'],
                        );
                        setState(
                          () {
                            if (item['title'] == "ปกติ") {
                              MyApp.themeNotifier.value = ThemeModeThird.light;
                            } else if (item['title'] == "ขาวดำ") {
                              MyApp.themeNotifier.value = ThemeModeThird.dark;
                            } else {
                              MyApp.themeNotifier.value =
                                  ThemeModeThird.blindness;
                            }
                            for (int i = 0; i < _listSwitchColors.length; i++) {
                              if (_listSwitchColors[i]['code'] ==
                                  item['code']) {
                                item['isSelected'] = !item['isSelected'];
                              } else {
                                _listSwitchColors[i]['isSelected'] = false;
                              }
                            }
                          },
                        );
                      }),
                    );
                    // _callRead();
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      height: 45,
                      // width: 145,
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? (item['isSelected'] == true
                                ? Color(0xFF7A4CB1)
                                : Colors.white)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? (item['isSelected'] == true
                                    ? Colors.white
                                    : Color(0xFF121212))
                                : (item['isSelected'] == true
                                    ? Color(0xFFFFFD57)
                                    : Color(0xFF121212)),
                        // item['isSelected'] == true
                        //     ? Color(0xFF7A4CB1)
                        //     : Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(73),
                        // border: Border.all(
                        //   width: 1,
                        //   style: BorderStyle.solid,
                        //   color: MyApp.themeNotifier.value ==
                        //           ThemeModeThird.light
                        //       ? (item['isSelected'] == true
                        //           ? Color(0xFF7A4CB1)
                        //           : Colors.white)
                        //       : MyApp.themeNotifier.value ==
                        //               ThemeModeThird.dark
                        //           ? (item['isSelected'] == true
                        //               ? Colors.white
                        //               : Color(0xFF292929))
                        //           : (item['isSelected'] == true
                        //               ? Color(0xFFFFFD57)
                        //               : Color(0xFF292929)),
                        // )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                item['code'] == '1'
                                    ? 'assets/images/icon_rp.png'
                                    : item['code'] == '2'
                                        ? 'assets/images/icon_wb.png'
                                        : "assets/images/icon_yb.png",
                                height: 35,
                                // width: 35,
                              ),
                              SizedBox(width: 5),
                              Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 17,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? (item['isSelected'] == true
                                          ? Colors.white
                                          : Colors.black)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? (item['isSelected'] == true
                                              ? Colors.black
                                              : Colors.white)
                                          : (item['isSelected'] == true
                                              ? Colors.black
                                              : Color(0xFFFFFD57)),
                                  // color: item['isSelected'] == true
                                  //     ? Color(0xFFFFFFFF)
                                  //     : Color(0xFF000000),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? (item['isSelected'] == true
                                        ? Colors.white
                                        : Color(0xFFDDDDDD))
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? (item['isSelected'] == true
                                            ? Colors.black
                                            : Colors.white)
                                        : (item['isSelected'] == true
                                            ? Colors.black
                                            : Color(0xFFFFFD57)),
                              ),
                              shape: BoxShape.circle,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? (item['isSelected'] == true
                                      ? Colors.white
                                      : Color(0xFFDDDDDD))
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? (item['isSelected'] == true
                                          ? Colors.black
                                          : Color(0xFF1E1E1E))
                                      : (item['isSelected'] == true
                                          ? Colors.black
                                          : Colors.black),
                            ),
                            child: Container(
                              // height: 15,
                              // width: 15,
                              // padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? (item['isSelected'] == true
                                        ? Color(0xFF7A4CB1)
                                        : Color(0xFFDDDDDD))
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? (item['isSelected'] == true
                                            ? Colors.white
                                            : Color(0xFF1E1E1E))
                                        : (item['isSelected'] == true
                                            ? Color(0xFFFFFD57)
                                            : Colors.black),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 12,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? (item['isSelected'] == true
                                        ? Colors.white
                                        : Color(0xFFDDDDDD))
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? (item['isSelected'] == true
                                            ? Colors.black
                                            : Color(0xFF1E1E1E))
                                        : (item['isSelected'] == true
                                            ? Colors.black
                                            : Colors.black),
                              ),
                            ),
                            //   child:
                            //   Image.asset(
                            //   item['isSelected'] == true
                            //       ? 'assets/images/icon_check.png'
                            //       : "assets/images/icon_nocheck.png",

                            // )
                          ),
                        ],
                      )),
                ),
              )
              .toList()),
    );
  }

  _buildListCard(dynamic model) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.75,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 40,
      ),
      padding: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).custom.w_292929,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).custom.g05_w01_w01,
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              // color: Colors.blueAccent,
              alignment: Alignment.topCenter,
              child: ListView.builder(
                shrinkWrap: true, // 1st add
                physics: ClampingScrollPhysics(),
                itemCount: model.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  model[index]['title'],
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Kanit',
                                    color: Theme.of(context).custom.b_W_fffd57,
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                              // SizedBox(width: 10),
                              Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context)
                                        .custom
                                        .eeba33_292929_292929,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .custom
                                            .w_w_fffd57)),
                                child: Text(
                                  (index + 1).toString() +
                                      '/' +
                                      policyLength.toString(),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Kanit',
                                    color: Theme.of(context).custom.w_w_fffd57,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.4,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              controller: scrollController,
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    parseHtmlString(
                                        model[index]['description']),
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).custom.b_W_fffd57,
                                    ),
                                  )

                                  // Html(
                                  //   data: model[index]['description'],
                                  //   onLinkTap: (String? url,
                                  //       RenderContext context,
                                  //       Map<String, String> attributes,
                                  //       element) {
                                  //     launch(url!);
                                  //     //open URL in webview, or launch URL in browser, or any other logic here
                                  //   },
                                  // ),

                                  // HtmlView(
                                  //   data: model[index]['description'],
                                  //   scrollable:
                                  //       false, //false to use MarksownBody and true to use Marksown
                                  // ),
                                  ),
                            ),
                          ),
                        ),
                        //             Theme.of(context).custom.f70f70_b_b,
                        // Theme.of(context).custom.f70f70_w_fffd57,
                        // Theme.of(context).custom.w_w_y,
                        _buildButton(
                          acceptPolicyList[index]['isActive']
                              ? 'ยอมรับ'
                              : 'ไม่ยอมรับ',
                          acceptPolicyList[index]['isActive']
                              ? Theme.of(context).custom.A4CB1_w_fffd57
                              : Theme.of(context).custom.f70f70_292929_292929,
                          acceptPolicyList[index]['isActive']
                              ? Theme.of(context).custom.f70f70_w_fffd57
                              : Theme.of(context).custom.A4CB1_w_fffd57,
                          acceptPolicyList[index]['isActive']
                              ? Theme.of(context).custom.w_b_b
                              : Theme.of(context).custom.w_w_fffd57,
                          // Theme.of(context).custom.w_b_b,
                          corrected: true,
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildButton(
            'บันทึกข้อมูล',
            Theme.of(context).custom.A4CB1_w_fffd57,
            Theme.of(context).custom.A4CB1_w_fffd57,
            Theme.of(context).custom.w_b_b,
            onTap: () {
              sendAcceptedPolicy();
              // dialogConfirm();
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildCard(dynamic model) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.75,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 40,
      ),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).custom.w_292929,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).custom.g05_w01_w01,
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    model['title'],
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Kanit',
                      color: Theme.of(context).custom.b_W_fffd57,
                    ),
                    maxLines: 3,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).custom.eeba33_292929_292929,
                      border: Border.all(
                          color: Theme.of(context).custom.w_w_fffd57)),
                  child: Text(
                    (currentCardIndex + 1).toString() +
                        '/' +
                        policyLength.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Kanit',
                      color: Theme.of(context).custom.w_w_fffd57,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              // isAlwaysShown: false,
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      parseHtmlString(model['description']),
                      style: TextStyle(
                        color: Theme.of(context).custom.b_W_fffd57,
                      ),
                    )
                    // Html(
                    //   data: model['description'],
                    //   onLinkTap: (String? url, RenderContext context,
                    //       Map<String, String> attributes, element) {
                    //     launch(url!);
                    //     //open URL in webview, or launch URL in browser, or any other logic here
                    //   },
                    // ),

                    // HtmlView(
                    //   data: model['description'],
                    //   scrollable:
                    //       false, //false to use MarksownBody and true to use Marksown
                    // ),
                    // child: Text(parseHtmlString(model['description'])),
                    ),
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildButton(
            'ยอมรับ',
            Theme.of(context).custom.A4CB1_w_fffd57,
            Theme.of(context).custom.A4CB1_w_fffd57,
            Theme.of(context).custom.w_b_b,
            onTap: () {
              nextIndex(model, true);
            },
          ),
          SizedBox(height: 15),
          _buildButton(
            'ไม่ยอมรับ',
            Theme.of(context).custom.f70f70_292929_292929,
            Theme.of(context).custom.f70f70_w_fffd57,
            Theme.of(context).custom.w_w_y,
            onTap: () {
              nextIndex(model, false);
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildButton(String title, Color color, Color colorBorder, Color titleColor,
      {Function? onTap, bool corrected = false}) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: 40,
        width: 285,
        alignment: Alignment.center,
        // margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
            border: Border.all(color: colorBorder)),
        child: Row(
          children: [
            SizedBox(width: 40),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 20, fontFamily: 'Kanit', color: titleColor),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: corrected
                  ? Icon(
                      Icons.check,
                      size: 25,
                      color: titleColor,
                    )
                  // Image.asset(
                  //     'assets/images/correct.png',
                  //     height: 15,
                  //     width: 15,
                  //     color: titleColor,
                  //   )
                  : null,
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> dialogConfirm() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Dialog(
            backgroundColor: Theme.of(context).custom.w_292929,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: 220,
              height: 155,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(
                //   color: Theme.of(context).custom.w_w_fffd57,
                // ),
                color: Theme.of(context).custom.w_292929,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).custom.g05_w01_w01,
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(15),
              //   color: Colors.white,
              //   border: Border.all(
              //     color: Theme.of(context).custom.w_w_fffd57,
              //   )
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(height: 10),
                  Text(
                    'บันทึกเรียบร้อยแล้ว',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Kanit',
                      color: Theme.of(context).custom.b_W_fffd57,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Text(
                  //   'เราจะทำการส่งเรื่องของท่าน',
                  //   style: TextStyle(
                  //     fontSize: 13,
                  //     fontFamily: 'Kanit',
                  //   ),
                  // ),
                  // Text(
                  //   'เพื่อทำการยืนยันต่อไป',
                  //   style: TextStyle(
                  //     fontSize: 13,
                  //     fontFamily: 'Kanit',
                  //   ),
                  // ),
                  // SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Menu(),
                        ),
                      );
                    },
                    child: Container(
                      height: 35,
                      width: 160,
                      alignment: Alignment.center,
                      // margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).custom.b325f8_w_fffd57,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'ตกลง',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Kanit',
                                color: Theme.of(context).custom.w_b_b,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // child: //Contents here
          ),
        );
      },
    );
  }

  nextIndex(dynamic model, bool accepted) {
    scrollController!.jumpTo(0);
    if (currentCardIndex == policyLength - 1) {
      setState(() {
        lastPage = true;
        acceptPolicyList.add({
          'index': currentCardIndex,
          'reference': model['code'],
          'isActive': accepted
        });
      });
    } else {
      setState(() {
        acceptPolicyList.add({
          'index': currentCardIndex,
          'reference': model['code'],
          'isActive': accepted
        });
        currentCardIndex++;
      });
    }
  }

  sendAcceptedPolicy() async {
    Dio dio = Dio();
    try {
      setState(() {
        _futureModel = Future.value([]);
      });
      acceptPolicyList.forEach((e) {
        e['profileCode'] = _profileCode;
        dio.post('https://des.we-builds.com/de-api/m/policy/create', data: e);
      });
    } catch (e) {}
    return dialogConfirm();
  }
}
