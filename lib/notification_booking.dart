import 'dart:convert';
import 'package:des/category_selector.dart';
import 'package:des/detail.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'shared/config.dart';
import 'main.dart';

class NotificationBookingPage extends StatefulWidget {
  NotificationBookingPage({
    Key? key,
  }) : super(key: key);
  @override
  _NotificationBookingPage createState() => _NotificationBookingPage();
}

class _NotificationBookingPage extends State<NotificationBookingPage> {
  dynamic model = {
    "title": 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน',
    "description": 'หมู่ที่ 5 99/99 ตำบล เสาธงหิน อำเภอบางใหญ่ นนทบุรี 11140',
    "time": '11:00:00',
    "date": '20220911110000',
    "timeOfUse": '3',
  };

  List<dynamic> cateNoti = [
    'ทั้งหมด',
    'ยังไม่อ่าน',
  ];
  int _typeSelected = 0;

  int notiCount = 0;
  int totalSelected = 0;
  int selectedIndex = 0;
  String profileCode = '';
  String selectedCategoryDays = '';
  String selectedCategoryDaysName = '';
  String selectedTitleIndex = '';
  String categorySelected = '';
  String categoryTitleSelected = '';
  bool isNoActive = false;
  bool isCheckSelect = false;
  bool chkListCount = false;
  bool chkListActive = false;
  dynamic modelNotiCount;
  Future<dynamic>? futureProfile;
  Future<dynamic>? _futureModel;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Dio dio = Dio();
  final _controllerBuildCategory = ScrollController();
  final _controllerCardV2 = ScrollController();
  final _controller = ScrollController();

  bool _loadingWidget = true;
  List<dynamic> _listBooking = [];
  List<dynamic> _listTempBooking = [];

  List<dynamic> listData = [];
  List<dynamic> listResultData = [];
  List<dynamic> listCategoryDays = [
    {
      'code': '1',
      'title': 'วันนี้',
    },
    {
      'code': '2',
      'title': 'เมื่อวาน',
    },
    {
      'code': '3',
      'title': '7 วันก่อน',
    },
    {
      'code': '4',
      'title': 'เก่ากว่า 7 วัน',
    },
    {
      'code': '5',
      'title': 'ยังไม่อ่าน',
    },
  ];

  @override
  void dispose() {
    _controllerBuildCategory.dispose();
    _controllerCardV2.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _readBooking();
    // _loading();
    super.initState();
  }

  void _loading() async {
    try {
      _readNotiCount();
      if (_readNotiCount != []) {
        modelNotiCount = await _readNotiCount();
        setState(() {
          notiCount = modelNotiCount['total'];
        });
      }
      selectedCategoryDays = "";
      Response<dynamic> result =
          await dio.post('$server/dcc-api/m/v2/notification/read', data: {
        'skip': 0,
        'limit': 999,
        'profileCode': profileCode,
        'category': categorySelected,
      });

      List<dynamic> list = [
        {
          "category": "bookingPage",
          "title":
              "ถึงท่านสมาชิก การจองเครื่องสำหรับการเรียนรู้ ระบบได้ทำการจองให้ท่านเป็นที่เรียบร้อย ท่านสามารถเข้าใช้ได้ในวันที่ 31/03/66",
          "totalDays": 0,
          "status": "N",
          "docTime": "09:31:00",
          "createDate": "20230210093100",
          "imageUrlCreateBy":
              "$server/raot-document/images/member/member_234043642.png",
          "createBy": "admincms",
          "description":
              "<font face=\"Kanit\">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum</font>",
        },
      ];

      List<dynamic> _listModel = [];
      if (result.statusCode == 200) {
        if (result.data['status'] == 'S') {
          if (categorySelected == '' || categorySelected == 'bookingPage') {
            setState(() {
              _listModel = [...list, ...result.data['objectData']];
            });
          } else {
            setState(() {
              _listModel = result.data['objectData'];
            });
          }
          setState(() {
            _futureModel = Future.value(_listModel);
          });
        }
      }
      setState(() => _loadingWidget = false);

      setState(() {
        listData = [];
        if (_listModel.length > 0) {
          for (var i = 0; i < _listModel.length; i++) {
            var categoryDays = _listModel[i]['totalDays'] == 0
                ? "1"
                : _listModel[i]['totalDays'] == 1
                    ? "2"
                    : _listModel[i]['totalDays'] <= 7 &&
                            _listModel[i]['totalDays'] > 0
                        ? "3"
                        : _listModel[i]['totalDays'] > 7
                            ? "4"
                            : "";
            _listModel[i]['categoryDays'] = categoryDays;
            _listModel[i]['isSelected'] = false;
            listData.add(_listModel[i]);
          }
        }
        _futureModel = Future.value(listData);
        chkListCount = listResultData.length > 0 ? true : false;
        chkListActive =
            listData.where((x) => x['status'] != "A").toList().length > 0
                ? true
                : false;
        totalSelected = 0;
      });
      await Future.delayed(Duration(milliseconds: 1000));

      setState(() => _loadingWidget = false);
      _refreshController.loadComplete();
    } catch (e) {
      setState(() => _loadingWidget = false);
    }
  }

  _readBooking() async {
    var profileMe = await ManageStorage.readDynamic('profileMe');
    try {
      Response response = await Dio().post(
        '$server/dcc-api/m/v2/notificationbooking/read',
        data: {
          'email': profileMe['email'],
        },
      );

      var data = response.data['objectData'];

      List<dynamic> list = [];

      list = data.map<dynamic>((e) {
        DateTime date = dateStringToDateBirthDay(e['createDate']);
        DateTime now = DateTime.now();

        int dif = now.difference(date).inDays;

        String type =
            (e?['bookingSlotType'] != '' && e?['bookingSlotType'] != null)
                ? 'ทำการ' + e['bookingSlotType']
                : 'ทำการเลื่อนการจอง';

        var categoryDays = dif == 0
            ? "1"
            : dif == 1
                ? "2"
                : dif <= 7 && dif > 0
                    ? "3"
                    : dif > 7
                        ? "4"
                        : "";
        return {
          "isSelected": false,
          "code": e['code'],
          "email": e['email'],
          "category": "bookingPage",
          "title":
              "ระบบได้ $type ให้ท่านเป็นที่เรียบร้อย ท่านสามารถเข้าใช้ได้ในวันที่ ${dateTimeToDateStringFormat(e['bookingDate'])} เวลา ${e['startTime']} ถึง ${e['endTime']}",
          "totalDays": dif,
          "categoryDays": categoryDays,
          "status": e?['status'] ?? '',
          "docTime": e?['docTime'] ?? '',
          "createDate": e?['createDate'] ?? '',
          "createBy": e?['createBy'] ?? '',
        };
      }).toList();
      logWTF('list');
      logWTF(list);
      setState(() {
        if (_typeSelected != 0) {
          list = list.where((x) => x['status'] == "N").toList();
        }
        _listBooking = list;
        _listTempBooking = list;
        _loadingWidget = false;
        chkListCount = _listBooking.length > 0 ? true : false;
        chkListActive =
            _listBooking.where((x) => x['status'] != "A").toList().length > 0
                ? true
                : false;
        totalSelected = 0;
      });
    } on DioError catch (e) {
      setState(() => _loadingWidget = false);
      var err = e.toString();
      if (e.response!.statusCode != 200) {
        err = e.response!.data['message'];
      }
      // Fluttertoast.showToast(msg: err);
    } catch (e) {
      setState(() => _loadingWidget = false);
      logE(e);
    }
  }

  void _holdClick(dynamic model) {
    setState(() {
      if (!isCheckSelect) {
        isCheckSelect = true;
        for (int j = 0; j < listData.length; j++) {
          if (listData[j]['code'] == model['code']) {
            listData[j]['isSelected'] = !listData[j]['isSelected'];
          }
        }
      } else {
        for (int j = 0; j < listData.length; j++) {
          if (listData[j]['code'] == model['code']) {
            listData[j]['isSelected'] = !listData[j]['isSelected'];
          }
        }
      }
      totalSelected =
          listData.where((i) => i['isSelected'] == true).toList().length;
    });
  }

  void _clearSelected() {
    setState(() {
      isCheckSelect = false;
      for (int j = 0; j < listData.length; j++) {
        listData[j]['isSelected'] = false;
      }

      totalSelected =
          listData.where((i) => i['isSelected'] == true).toList().length;
    });
  }

  void _singleClick(dynamic model) {
    setState(() {
      for (int j = 0; j < listData.length; j++) {
        if (listData[j]['code'] == model['code']) {
          listData[j]['isSelected'] = !listData[j]['isSelected'];
        }
      }

      totalSelected =
          listData.where((i) => i['isSelected'] == true).toList().length;
    });
  }

  void unSelectall() {
    setState(() {
      for (var i = 0; i < listData.length; i++) {
        listData[i]['isSelected'] = false;
      }
      totalSelected = 0;
      isCheckSelect = false;
    });
  }

  Future<dynamic> _readNotiCount() async {
    var profileMe = await ManageStorage.read('profileMe') ?? '';
    Response<dynamic> response;
    try {
      response = await dio
          .post('$server/dcc-api/m/v2/notificationbooking/count', data: {
        "email": profileMe['email'],
      });
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          modelNotiCount = response.data['objectData'];
          setState(() {
            notiCount = modelNotiCount['total'];
          });
          return response.data['objectData'];
        }
      }
    } catch (e) {
      logE(e);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: [
                _buildHead(),
                // SizedBox(height: selectedCategoryDays == '' ? 20 : 0),
                // selectedCategoryDays == ''
                //     ? CategorySelector(
                //         onChange: (String val, String valTitle) {
                //           setState(
                //             () => {
                //               categorySelected = val,
                //               categoryTitleSelected = valTitle,
                //             },
                //           );
                //           _loading();
                //         },
                //       )
                //     : Container(),
                SizedBox(height: 20),

                _buildListNotiCategory(),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: false,
                    footer: ClassicFooter(
                      loadingText: ' ',
                      canLoadingText: ' ',
                      idleText: ' ',
                      idleIcon:
                          Icon(Icons.arrow_upward, color: Colors.transparent),
                    ),
                    controller: _refreshController,
                    onLoading: _loading,
                    child: Stack(
                      children: <Widget>[
                        _buildBody(),
                        isCheckSelect
                            ? Positioned(
                                top: -10.0,
                                right: 0.0,
                                child: Padding(
                                  padding: EdgeInsets.zero,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Color(0xFF7A4CB1),
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        _clearSelected();
                                      },
                                    ),
                                  ),
                                ))
                            : Container()
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(26, 255, 255, 255),
                        blurRadius: 4,
                        offset: Offset(5, -5), // changes position of shadow/
                      ),
                    ],
                  ),
                  child: Container(
                    // color: MyApp.themeNotifier.value == ThemeModeThird.light
                    //             ? Colors.white
                    //             : Color(0xFF292929),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        chkListActive
                            ? _buildButton(
                                'อ่านแล้ว  (${totalSelected.toString()})',
                                'อ่านทั้งหมด',

                                // color
                                MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7A4CB1)
                                    : Colors.black,

                                // borderColor
                                MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7A4CB1)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),

                                // fontColor
                                MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.white
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                                () => _DialogUpdate(),
                              )
                            : _buildButton(
                                'อ่านทั้งหมด',
                                'อ่านทั้งหมด',
                                const Color(0xFFDDDDDD),
                                const Color(0xFFDDDDDD),
                                const Color(0xFFDDDDDD),
                                () => null,
                              ),
                        SizedBox(width: 20),
                        _listBooking.length > 0
                            ? _buildButton(
                                'ลบรายการ  (${totalSelected.toString()})',
                                'ลบทั้งหมด',
                                // color
                                MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7A4CB1)
                                    : Colors.black,

                                // borderColor
                                MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7A4CB1)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),

                                // fontColor
                                MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.white
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                                () => _DialogDelete(),
                              )
                            : _buildButton(
                                'ลบทั้งหมด',
                                'ลบทั้งหมด',
                                const Color(0xFFDDDDDD),
                                const Color(0xFFDDDDDD),
                                const Color(0xFFDDDDDD),
                                () => null,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBody() {
    if (_loadingWidget)
      return Center(
        child: CircularProgressIndicator(),
      );

    return _listBooking.length > 0
        ?
        // Container(
        //     child: FadingEdgeScrollView.fromScrollView(
        //       child: ListView.builder(
        //         padding: EdgeInsets.zero,
        //         itemCount: listCategoryDays.length,
        //         itemBuilder: (context, index) =>
        //             _buildCategory(listCategoryDays[index]),
        //         shrinkWrap: true,
        //         controller: _controllerBuildCategory,
        //         physics: ClampingScrollPhysics(), // 2nd
        //       ),
        //     ),
        //   )

        Container(
            child: FadingEdgeScrollView.fromScrollView(
              child: ListView(
                padding: EdgeInsets.zero,
                controller: _controller,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(), // 2nd
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Text(
                      '$selectedCategoryDaysName',
                      style: TextStyle(
                        color: Color(0xFF7A4CB1),
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  for (int i = 0; i < _listBooking.length; i++)
                    Container(child: cardV2(context, _listBooking[i])),
                ],
              ),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            width: (MediaQuery.of(context).size.width),
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_noti_list.png',
                  width: 189,
                  height: 121,
                ),
                SizedBox(height: 11),
                Text(
                  textNotiEmpty(selectedCategoryDays),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF707070).withOpacity(0.5),
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildHead() {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, right: 15, left: 15),
      color: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      child: Column(
        children: [
          SizedBox(height: 13),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : Colors.black,
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      )),
                  child: Image.asset(
                    'assets/images/back_arrow.png',
                  ),
                ),
              ),
              // SizedBox(width: 34),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'การแจ้งเตือน',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.black
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                    ),
                    SizedBox(width: 15),
                    _buildNotiCount(),
                  ],
                ),
              ),
              // InkWell(
              //   child: Image.asset(
              //     'assets/images/noti_list.png',
              //     height: 25,
              //     width: 25,
              //     color: MyApp.themeNotifier.value == ThemeModeThird.light
              //         ? Colors.black
              //         : MyApp.themeNotifier.value == ThemeModeThird.dark
              //             ? Colors.white
              //             : Color(0xFFFFFD57),
              //   ),
              //   onTap: _handleClickMe,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String titleI, String titleE, Color color,
      Color borderColor, Color fontColor, Function onTapFunction) {
    return InkWell(
      onTap: () {
        onTapFunction();
      },
      child: Container(
        alignment: Alignment.center,
        width: 145,
        height: 40,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, style: BorderStyle.solid, color: borderColor),
            borderRadius: BorderRadius.circular(73),
            color: color),
        child: Text(
          totalSelected > 0 ? titleI : titleE,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: fontColor,
            fontWeight: FontWeight.w400,
            fontFamily: 'Kanit',
          ),
        ),
      ),
    );
  }

  Widget _buildNotiCount() {
    return FutureBuilder<dynamic>(
      future: _readNotiCount(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container();
          } else {
            return Container(
              // height: 22,
              width: 22,
              padding: EdgeInsets.all(5),
              decoration:
                  BoxDecoration(color: Color(0xFFDD2A00), shape: BoxShape.circle
                      // borderRadius: BorderRadius.circular(11),
                      ),
              child: Text(
                notiCount.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            child: Text(
              'Network ขัดข้อง',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
            ),
          );
        } else {
          return Container(
            height: 10,
            width: 10,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildCategory(dynamic model) {
    // if (isNoActive) {
    //   listResultData = listData
    //       .where(
    //           (x) => x['categoryDays'] == model['code'] && x['status'] != "A")
    //       .toList();
    // } else {
    //   listResultData =
    //       listData.where((x) => x['categoryDays'] == model['code']).toList();
    // }

    return _listBooking.length > 0
        ? Container(
            // margin: EdgeInsets.only(top: height * 1.5 / 100, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text(
                    '${model?['title'] ?? ''}',
                    style: TextStyle(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _listBooking.length,
                  itemBuilder: (context, index) =>
                      cardV2(context, _listBooking[index]),
                  shrinkWrap: true,
                  controller: _controllerCardV2,
                  physics: ClampingScrollPhysics(), // 2nd
                ),
                SizedBox(height: 34),
              ],
            ),
          )
        : Container();
  }

  Widget cardV2(BuildContext context, dynamic model) {
    return InkWell(
      // onLongPress: () {
      //   _holdClick(model);
      // },
      onTap: () async {
        try {
          if (model['category'] == 'bookingPage') {
            dio.post(
              '$server/dcc-api/m/v2/notificationBooking/update',
              data: {"code": '${model['code']}'},
            );
            // model['status'] = 'A';
            var index =
                _listBooking.indexWhere((x) => x['code'] == model['code']);
            setState(() {
              _listBooking[index]['status'] = 'A';

              chkListActive = _listBooking
                          .where((x) => x['status'] != "A")
                          .toList()
                          .length >
                      0
                  ? true
                  : false;
            });
          } else {
            isCheckSelect
                ? _singleClick(model)
                : await dio.post(
                    '$server/dcc-api/m/v2/notification/update',
                    data: {
                      'category': '${model['category']}',
                      "code": '${model['code']}'
                    },
                  );
          }
          // checkNavigationPage(model['category'], model);
        } catch (e) {
          logE(e);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: model['isSelected'] ? Color(0x1AB325F8) : Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: model['status'] == 'A'
                    ? Colors.transparent
                    : Color(0xFFF44336),
              ),
              height: 10,
              width: 10,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      checkCategoryName(model['category'], model),
                      style: TextStyle(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFB325F8)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Text(
                      '${model?['title'] ?? ''}',
                      style: TextStyle(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF000000)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  model['categoryDays'] == "1"
                      ? '${timeString(model['docTime'])} น.'
                      : '${dateStringToDateStringFormatV2(model['createDate'])}',
                  style: TextStyle(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                    fontFamily: 'Arial',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                model['isSelected']
                    ? Container(
                        child: Image.asset(
                          'assets/images/check.png',
                          fit: BoxFit.contain,
                          color: Color(0xFF7A4CB1),
                        ),
                        height: 20,
                        width: 20,
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.white
              : Color(0xFF292929),
          titlePadding: EdgeInsets.all(0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 13),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Text(
                        'เลือกแสดงผล',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.black
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/close_noti_list.png',
                        width: 23,
                        height: 23,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                setState(() {
                  selectedCategoryDays = "";
                  isNoActive = false;
                  unSelectall();
                  chkListCount = listData.length > 0 ? true : false;
                  chkListActive = listData
                              .where((x) => x['status'] != "A")
                              .toList()
                              .length >
                          0
                      ? true
                      : false;
                  Navigator.pop(context);
                });
              },
              child: Center(
                child: Container(
                  child: Text(
                    'ทั้งหมด',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF707070)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.5,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF707070)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  unSelectall();
                  selectedCategoryDays = "5";
                  selectedCategoryDaysName = "ยังไม่อ่าน";
                  isNoActive = true;
                  listResultData =
                      listData.where((x) => x['status'] != "A").toList();
                  chkListCount = listResultData.length > 0 ? true : false;
                  chkListActive = listResultData.length > 0 ? true : false;
                  Navigator.pop(context);
                });
              },
              child: Center(
                child: Container(
                  child: Text(
                    'ยังไม่อ่าน',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF707070)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.5,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF707070)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  unSelectall();
                  selectedCategoryDays = "1";
                  selectedCategoryDaysName = "วันนี้";
                  listResultData = listData
                      .where((i) => i['categoryDays'] == selectedCategoryDays)
                      .toList();
                  chkListCount = listResultData.length > 0 ? true : false;
                  chkListActive = listResultData
                              .where((x) => x['status'] != "A")
                              .toList()
                              .length >
                          0
                      ? true
                      : false;
                  Navigator.pop(context);
                });
              },
              child: Center(
                child: Container(
                  child: Text(
                    'วันนี้',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF707070)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.5,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF707070)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  unSelectall();
                  selectedCategoryDays = "2";
                  selectedCategoryDaysName = "เมื่อวาน";
                  listResultData = listData
                      .where((i) => i['categoryDays'] == selectedCategoryDays)
                      .toList();
                  chkListCount = listResultData.length > 0 ? true : false;
                  chkListActive = listResultData
                              .where((x) => x['status'] != "A")
                              .toList()
                              .length >
                          0
                      ? true
                      : false;

                  Navigator.pop(context);
                });
              },
              child: Center(
                child: Container(
                  child: Text(
                    'เมื่อวาน',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF707070)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.5,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF707070)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  unSelectall();
                  selectedCategoryDays = "3";
                  selectedCategoryDaysName = "7 วันก่อน";
                  listResultData = listData
                      .where((i) => i['categoryDays'] == selectedCategoryDays)
                      .toList();
                  chkListCount = listResultData.length > 0 ? true : false;
                  chkListActive = listResultData
                              .where((x) => x['status'] != "A")
                              .toList()
                              .length >
                          0
                      ? true
                      : false;
                  Navigator.pop(context);
                });
              },
              child: Center(
                child: Container(
                  child: Text(
                    '7 วันก่อน',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF707070)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.5,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF707070)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  unSelectall();
                  selectedCategoryDays = "4";
                  selectedCategoryDaysName = "เก่ากว่า 7 วัน";
                  listResultData = listData
                      .where((i) => i['categoryDays'] == selectedCategoryDays)
                      .toList();
                  chkListCount = listResultData.length > 0 ? true : false;
                  chkListActive = listResultData
                              .where((x) => x['status'] != "A")
                              .toList()
                              .length >
                          0
                      ? true
                      : false;
                  Navigator.pop(context);
                });
              },
              child: Center(
                child: Container(
                  child: Text(
                    'เก่ากว่า 7 วัน',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF707070)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Future<void> _DialogUpdate() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        backgroundColor: Color(0xFFFFFFFF),
        titlePadding: EdgeInsets.all(0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Color(0xFF7A4CB1),
                  size: 35,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    totalSelected > 0
                        ? 'เปลี่ยน ' +
                            totalSelected.toString() +
                            ' รายการที่เลือก เป็นอ่านแล้วใช่หรือไม่'
                        : textDialogUpdate(selectedCategoryDays),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF7A4CB1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width / 100) * 30,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFFB7B7B7))))),
                  child: Text(
                    "ยกเลิก",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                        color: Color(0xFFB7B7B7)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: (MediaQuery.of(context).size.width / 100) * 30,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF7A4CB1),
                  child: MaterialButton(
                    height: 30,
                    onPressed: () async {
                      logWTF('update');
                      try {
                        var profileMe =
                            await ManageStorage.readDynamic('profileMe');

                        logWTF(profileMe);
                        Navigator.pop(context);
                        setState(() => _loadingWidget = true);

                        await dio.post(
                            '$server/dcc-api/m/v2/notificationBooking/update/all',
                            data: {"email": '${profileMe['email']}'});
                        _readBooking();
                      } catch (e) {
                        setState(() => _loadingWidget = false);
                        logE(e);
                      }
                    },
                    child: Text(
                      'ใช่',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _DialogDelete() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        backgroundColor: Color(0xFFFFFFFF),
        titlePadding: EdgeInsets.all(0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Color(0xFF7A4CB1),
                  size: 35,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    totalSelected > 0
                        ? 'ลบ ' +
                            totalSelected.toString() +
                            ' รายการที่เลือก ออกจากแจ้งเตือนใช่หรือไม่'
                        : textDialogDelete(selectedCategoryDays),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF7A4CB1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width / 100) * 30,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFFB7B7B7))))),
                  child: Text(
                    "ยกเลิก",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                        color: Color(0xFFB7B7B7)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: (MediaQuery.of(context).size.width / 100) * 30,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF7A4CB1),
                  child: MaterialButton(
                    height: 30,
                    onPressed: () async {
                      logWTF('delete');
                      try {
                        var profileMe =
                            await ManageStorage.readDynamic('profileMe');

                        logWTF(profileMe);
                        Navigator.pop(context);
                        setState(() => _loadingWidget = true);

                        await dio.post(
                            '$server/dcc-api/m/v2/notificationBooking/delete',
                            data: {"email": '${profileMe['email']}'});
                        _readBooking();
                      } catch (e) {
                        setState(() => _loadingWidget = false);
                        logE(e);
                      }
                    },
                    child: Text(
                      'ใช่',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  textNotiEmpty(String categoryDay) {
    switch (categoryDay) {
      case '1':
        {
          return "ท่านไม่มีข้อมูลการแจ้งเตือน\nสำหรับวันนี้";
        }
      case '2':
        {
          return "ท่านไม่มีข้อมูลการแจ้งเตือน\nสำหรับเมื่อวาน";
        }
      case '3':
        {
          return "ท่านไม่มีข้อมูลการแจ้งเตือน\nเมื่อ 7 วันก่อน";
        }
      case '4':
        {
          return "ท่านไม่มีข้อมูลการแจ้งเตือน\nที่เก่ากว่า 7 วัน";
        }
      case '5':
        {
          return "ท่านไม่มีข้อมูลการแจ้งเตือน\nที่ยังไม่อ่าน";
        }
      default:
        {
          return "ท่านไม่มีข้อมูลการแจ้งเตือน\nทั้งหมด";
        }
    }
  }

  textDialogDelete(
    String categoryDay,
  ) {
    switch (categoryDay) {
      case '1':
        {
          return "ลบรายการทั้งหมดของวันนี้ออกจากการแจ้งเตือนใช่หรือไม่";
        }
      case '2':
        {
          return "ลบรายการทั้งหมดของเมื่อวานออกจากการแจ้งเตือนใช่หรือไม่";
        }
      case '3':
        {
          return "ลบรายการทั้งหมดของเมื่อ 7 วันก่อนออกจากการแจ้งเตือนใช่หรือไม่";
        }
      case '4':
        {
          return "ลบรายการทั้งหมดที่เก่ากว่า 7 วันก่อนออกจากการแจ้งเตือนใช่หรือไม่";
        }
      default:
        {
          return "ลบรายการทั้งหมด ออกจากแจ้งเตือนใช่หรือไม่";
        }
    }
  }

  textDialogUpdate(
    String categoryDay,
  ) {
    switch (categoryDay) {
      case '1':
        {
          return "เปลี่ยนรายการทั้งหมดของวันนี้เป็นอ่านแล้วใช่หรือไม่";
        }
      case '2':
        {
          return "เปลี่ยนรายการทั้งหมดของเมื่อวานเป็นอ่านแล้วใช่หรือไม่";
        }
      case '3':
        {
          return "เปลี่ยนรายการทั้งหมดของเมื่อ 7 วันก่อนเป็นอ่านแล้วใช่หรือไม่";
        }
      case '4':
        {
          return "เปลี่ยนรายการทั้งหมดที่เก่ากว่า 7 วันก่อนเป็นอ่านแล้วใช่หรือไม่";
        }
      default:
        {
          return "เปลี่ยนรายการทั้งหมด เป็นอ่านแล้วใช่หรือไม่";
        }
    }
  }

  checkNavigationPage(String page, dynamic model) {
    switch (page) {
      case 'eventPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                slug: 'eventcalendar',
                model: model,
                checkNotiPage: true,
              ),
            ),
          );
        }
        break;

      case 'mainPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                slug: 'mainPage',
                model: model,
                checkNotiPage: true,
              ),
            ),
          );
        }
        break;

      case 'bookingPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                slug: 'bookingPage',
                model: model,
                checkNotiPage: true,
              ),
            ),
          );
        }
        break;

      // case 'privilegePage':
      //   {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => PrivilegeForm(
      //           code: model['reference'],
      //           model: model,
      //         ),
      //       ),
      //     ).then((value) => {_loading()});
      //   }
      //   break;

      default:
        {
          Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
        }
        break;
    }
  }

  Widget _buildListNotiCategory() {
    return Container(
      height: 35,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => GestureDetector(
          onTap: () {
            setState(() => _typeSelected = __);

            _readBooking();
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: __ == _typeSelected ? Color(0xFF7A4CB1) : Colors.white,
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Text(
              cateNoti[__],
              style: TextStyle(
                color: __ == _typeSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemCount: cateNoti.length,
      ),
    );
  }

  checkCategoryName(String page, dynamic model) {
    switch (page) {
      case 'eventPage':
        {
          return "ข่าวและกิจกรรม";
        }
      case 'privilegePage':
        {
          return "สิทธิประโยชน์";
        }
      // case 'mainPage':
      //   {
      //     return "กำหนดเอง";
      //   }
      case 'bookingPage':
        {
          return "จองใช้บริการ";
        }
      default:
        {
          return "";
        }
    }
  }

//
}
