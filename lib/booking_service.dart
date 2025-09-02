import 'dart:convert';

import 'package:des/booking_service_detail.dart';
import 'package:des/booking_service_search_result.dart';
import 'package:des/models/mock_data.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dtpp;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'main.dart';
import 'menu.dart';

class BookingServicePage extends StatefulWidget {
  BookingServicePage({
    super.key,
    required this.catSelectedWidget,
  });

  final String catSelectedWidget;

  @override
  State<BookingServicePage> createState() => _BookingServicePageState();
}

class _BookingServicePageState extends State<BookingServicePage>
    with SingleTickerProviderStateMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  DateTime selectedDate = DateTime.now();
  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int _year = 0;
  int _month = 0;
  int _day = 0;
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtStartTime = TextEditingController();
  TextEditingController txtEndTime = TextEditingController();
  int _currentPage = 0;
  dynamic modelCenter;
  List<dynamic> _modelBookingAll = [];
  List<dynamic> _modelBookingFiltered = [];
  List<dynamic> _modelBookingHistory = [];
  dynamic modelCategory;
  late List<dynamic> _modelNearMe;
  late bool _loadingNearMe;

  late ScrollController _scrollController;
  bool lastStatus = true;

  late AnimationController _animationController;
  late TextEditingController _searchController;
  LoadingBookingStatus _loadingBookingStatus = LoadingBookingStatus.loading;
  List<String> _modelAutoComplete = [];
  List<dynamic> listCatPage = [
    {"id": "0", "title": "ค้นหาศูนย์"},
    {"id": "1", "title": "รายการจอง"},
    {"id": "2", "title": "รายการจอง"},
  ];

  String catSelected = '0';
  List<dynamic> provinceList = [
    {"label": 'เลือกจังหวัด', "value": '0'}
  ];
  List<dynamic> districtList = [
    {"label": 'เลือกอำเภอ', "value": '0'}
  ];
  bool _loadingDropdownType = false;
  dynamic filter = {
    "provinceSelected": '0',
    "provinceTitleSelected": '',
    "districtSelected": '0',
    "districtTitleSelected": '',
    "bookingType": '',
    "latitude": '',
    "longitude": ''
  };

  List<dynamic> bookingTypeList = [
    {"label": 'ทั้งหมด', "value": ''},
    {"label": 'ห้องประชุม', "value": '1'},
    {"label": 'เครื่องคอมพิวเตอร์', "value": '2'},
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: Container(
            padding: EdgeInsets.only(top: 103),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/BG.png"),
                fit: BoxFit.cover,
                colorFilter: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? null
                    : ColorFilter.mode(Colors.grey, BlendMode.saturation),
              ),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 80),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.black
                          : Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Menu(),
                            ),
                            (Route<dynamic> route) => false,
                          ),
                        },
                        child: Image.asset(
                          MyApp.themeNotifier.value == ThemeModeThird.light
                              ? 'assets/images/back_profile.png'
                              : "assets/images/2024/back_balckwhite.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Text(
                        "จองใช้บริการศูนย์\nดิจิทัลชุมชนและอุปกรณ์",
                        style: TextStyle(
                            fontSize: 20,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFFBD4BF7)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                            fontWeight: FontWeight.w500),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  catContentPage(),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                      child: catSelected == '0'
                          ? _pageOne()
                          : catSelected == '1'
                              ? _pageTwo()
                              : _pageThree()),
                ],
              ),
            ),
          ),
        ));
  }

  catContentPage() {
    return Container(
      // height: double.infinity,
      // height: 40,
      height: MyApp.fontKanit.value == FontKanit.small
          ? 40
          : MyApp.fontKanit.value == FontKanit.medium
              ? 45
              : 50,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            itemCat(title: "ค้นหาศูนย์", indexSelected: '0'),
            const SizedBox(
              width: 8,
            ),
            itemCat(
                title: "รายการจอง (${_modelBookingFiltered.length})",
                indexSelected: '1'),
            const SizedBox(
              width: 8,
            ),
            itemCat(
                title: "ประวัติการจอง (${_modelBookingHistory.length})",
                indexSelected: '2')
          ],
        ),
      ),
    );
  }

  Widget itemCat({title, indexSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _callRead(refresh: false);
          catSelected = indexSelected;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: catSelected == indexSelected
              // ? Color(0xFFB325F8)
              ? MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Color(0xFFBD4BF7)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57)
              : MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.white
                  : Colors.black,
          borderRadius: BorderRadius.circular(17.5),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: catSelected == indexSelected
                  ? MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.white
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.black
                          : Colors.black
                  : MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8).withOpacity(0.5)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57)),
        ),
      ),
    );
  }

  _pageOne() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text(
          "ค้นหาศูนย์",
          style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          height: 50,
          child: Autocomplete<String>(
            initialValue: _searchController.value,
            fieldViewBuilder: (BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              controller.addListener(() {
                _searchController.text = controller.text;
              });
              return TextFormField(
                decoration: _decorationSearch(
                  context,
                  hintText: 'พิมพ์คำค้นหา',
                ),
                controller: controller,
                focusNode: focusNode,
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
                onChanged: (value) {
                  setState(() {
                    filter['provinceSelected'] = '0';
                    filter['provinceSelectedTitle'] = '';
                    filter['districtSelected'] = '0';
                    filter['districtSelectedTitle'] = '';
                    districtList.clear();
                    districtList = [
                      {"label": 'เลือกอำเภอ', "value": '0'}
                    ];
                  });
                },
              );
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return _modelAutoComplete.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              setState(() {
                _searchController.text = selection;
                filter['provinceSelected'] = '0';
                filter['provinceSelectedTitle'] = '';
                filter['districtSelected'] = '0';
                filter['districtSelectedTitle'] = '';
                // districtList.clear();
                districtList = [
                  {"label": 'เลือกอำเภอ', "value": '0'}
                ];
              });
            },
          ),
        ),
        SizedBox(height: 15),
        _dropdown(
          data: bookingTypeList,
          value: filter['bookingType'],
          onChanged: (p0) {
            setState(() {
              filter['bookingType'] = p0;
              print('-----------------${filter['bookingType']}');
            });
          },
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _dropdown(
                data: provinceList,
                value: filter['provinceSelected'],
                onChanged: (p0) {
                  setState(() {
                    filter['provinceTitleSelected'] =
                        provinceList.firstWhereOrNull(
                            (e) => e['value'] == int.parse(p0))['label'];
                    filter['provinceSelected'] = p0;
                  });

                  districtList.clear();
                  districtList = [
                    {"label": 'เลือกอำเภอ', "value": '0'}
                  ];
                  _callReadDistrict();
                },
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: _dropdown(
                data: districtList,
                value: filter['districtSelected'],
                onChanged: (p0) {
                  setState(() {
                    filter['districtTitleSelected'] =
                        districtList.firstWhereOrNull(
                            (e) => e['value'] == int.parse(p0))['label'];
                    filter['districtSelected'] = p0;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            var startTime = _currentPage == 0 ? txtStartTime.text : '';
            var endTime = _currentPage == 0 ? txtEndTime.text : '';
            var search = _searchController.text;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingServiceSearchResultPage(
                    date: txtDate.text,
                    startTime: startTime,
                    endTime: endTime,
                    search: search,
                    filter: filter,
                    mode: '1'),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: Theme.of(context).custom.b325f8_w_fffd57,
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              'ค้นหาศูนย์',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).custom.w_b_b,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'หรือ',
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).custom.f70f70_w_fffd57,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () async => {
            setState(() {
              filter = {
                "provinceSelected": '0',
                "provinceTitleSelected": '',
                "districtSelected": '0',
                "districtTitleSelected": '',
                "bookingType": '',
                "latitude": '',
                "longitude": ''
              };
            }),
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingServiceSearchResultPage(
                  date: txtDate.text,
                  startTime: '',
                  endTime: '',
                  search: '',
                  filter: filter,
                  mode: '2',
                ),
              ),
            )
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.white
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.black
                      : Colors.black,
              border: Border.all(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFBD4BF7)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              'ค้นหาศูนย์ใกล้ฉัน',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).custom.b325f8_w_fffd57,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _pageTwo() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text(
          "รายการจอง (${_modelBookingFiltered.length})",
          style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 16,
        ),
        _loadingBookingStatus == LoadingBookingStatus.loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _loadingBookingStatus == LoadingBookingStatus.success
                ? _modelBookingFiltered.length == 0
                    ? Column(
                        children: [
                          Image.asset(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/owl_3.png'
                                : "assets/images/owl-3-b.png",
                            height: 153,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "คุณยังไม่เคยจองศูนยดิจิทัลชุมชน\nมาเริ่มจองกันเลย!",
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                catSelected = '0';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color: Theme.of(context).custom.b325f8_w_fffd57,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'ค้นหาศูนย์',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).custom.w_b_b,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                catSelected = '0';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.white
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.black
                                        : Colors.black,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .custom
                                      .b325f8_w_fffd57_OVF50,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'ค้นหาศูนย์ใกล้ฉัน',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Color(0xFFBD4BF7)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _modelBookingFiltered.length,
                        separatorBuilder: (context, index) => Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: Theme.of(context).custom.DDD_w_fffd57,
                            height: 1,
                          ),
                        ),
                        itemBuilder: (context, index) =>
                            _itemBooking(_modelBookingFiltered[index], index),
                      )
                : Center(
                    child: GestureDetector(
                      onTap: () {
                        _callRead(refresh: true);
                      },
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            Icon(Icons.refresh),
                            Text('โหลดใหม่'),
                          ],
                        ),
                      ),
                    ),
                  ),
        SizedBox(height: 36)
      ],
    );
  }

  _pageThree() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text(
          "ประวัติการจอง (${_modelBookingHistory.length})",
          style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 16,
        ),
        _loadingBookingStatus == LoadingBookingStatus.loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _loadingBookingStatus == LoadingBookingStatus.success
                ? _modelBookingHistory.length == 0
                    ? Column(
                        children: [
                          Image.asset(
                            MyApp.themeNotifier.value == ThemeModeThird.light
                                ? 'assets/images/owl_3.png'
                                : "assets/images/owl-3-b.png",
                            height: 153,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "คุณยังไม่เคยจองศูนยดิจิทัลชุมชน\nมาเริ่มจองกันเลย!",
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                catSelected = '0';
                              });
                              // _cancelBooking();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color: Theme.of(context).custom.b325f8_w_fffd57,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'ค้นหาศูนย์',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).custom.w_b_b,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.white
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.black
                                        : Colors.black,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .custom
                                      .b325f8_w_fffd57_OVF50,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'ค้นหาศูนย์ใกล้ฉัน',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Color(0xFFBD4BF7)
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.white
                                          : Color(0xFFFFFD57),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _modelBookingHistory.length,
                        separatorBuilder: (context, index) => Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: Theme.of(context).custom.DDD_w_fffd57,
                            height: 1,
                          ),
                        ),
                        itemBuilder: (context, index) =>
                            _itemBooking(_modelBookingHistory[index], index),
                      )
                : Center(
                    child: GestureDetector(
                      onTap: () {
                        _callRead(refresh: true);
                      },
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            Icon(Icons.refresh),
                            Text('โหลดใหม่'),
                          ],
                        ),
                      ),
                    ),
                  ),
        SizedBox(height: 36)
      ],
    );
  }

  Widget _itemBooking(model, index) {
    return Container(
      color: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : const Color.fromRGBO(0, 0, 0, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyApp.themeNotifier.value == ThemeModeThird.light
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: (model['base64'] ?? '') != ''
                      ? Image.memory(
                          base64Decode(model['base64']),
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/banner_mock.jpg',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey,
                      BlendMode.saturation,
                    ),
                    child: (model['base64'] ?? '') != ''
                        ? Image.memory(
                            base64Decode(model['base64']),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/banner_mock.jpg',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${index + 1}. ${model['centerName']}',
                  style: TextStyle(
                    color: Theme.of(context).custom.b325f8_w_fffd57,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (_checkedCurrent(model, '4'))
            Container(
              height: 30,
              width: 120,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFF7A4CB1)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.white
                        : Colors.black,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'เช็คอินแล้ว',
                    style: TextStyle(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          if (_checkedCurrent(model, '0'))
            Container(
              height: 30,
              width: 100,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFD9D9D9)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Text(
                    'ยกเลิกแล้ว',
                    style: TextStyle(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF707070)
                          : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 12),
          Wrap(
            children: [
              Image.asset(
                MyApp.themeNotifier.value == ThemeModeThird.light
                    ? 'assets/images/time.png'
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? "assets/images/2024/time _w.png"
                        : "assets/images/2024/time _y.png",
                width: 22,
              ),
              SizedBox(width: 5),
              Text(
                _dateFormat(model?['bookingdate'] ?? '') ?? '',
                style: TextStyle(
                  color: Theme.of(context).custom.b_w_y,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
              ),
              SizedBox(width: 6),
              Text(
                '(${model?['startTime'] ?? ''} - ${model?['endTime'] ?? ''} น.)',
                style: TextStyle(
                  color: Theme.of(context).custom.b_w_y,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          catSelected == '1' ? SizedBox(height: 16) : Container(),
          catSelected == '1'
              ? Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (catSelected == '1') {
                            bool edit = false;
                            bool repeat = false;
                            if (catSelected == '1' && model['status'] != '4') {
                              edit = true;
                            } else {
                              repeat = true;
                            }

                            DateTime date =
                                DateTime.parse(model['bookingdate']);
                            DateTime dateTH =
                                DateTime(date.year + 543, date.month, date.day);
                            var dateFormat =
                                DateFormat("dd / MM / yyyy").format(dateTH);
                            logWTF(model);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingServiceDetailPage(
                                  model: model,
                                  edit: edit,
                                  repeat: repeat,
                                  repeatCurrentDay: false,
                                  date: dateFormat,
                                  startTime: model['startTime'],
                                  endTime: model['endTime'],
                                  phone: model['phone'],
                                  remark: model['remark'],
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.black
                                    : Colors.black,
                            border: Border.all(
                              color: Theme.of(context)
                                  .custom
                                  .b325f8_w_fffd57_OVF50,
                            ),
                            borderRadius: BorderRadius.circular(22.5),
                          ),
                          child: Text(
                            'แก้ไขการจอง',
                            style: TextStyle(
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          _dialogConfirmCheckIn(model);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).custom.b325f8_w_fffd57,
                            borderRadius: BorderRadius.circular(22.5),
                          ),
                          child: Text(
                            'เช็คอิน',
                            style: TextStyle(
                              color: Theme.of(context).custom.w_b_b,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  static InputDecoration _decorationSearch(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          // fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          // fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: Container(
          padding: EdgeInsets.all(15),
          child: Image.asset(
            'assets/images/search.png',
            height: 16,
            width: 16,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF707070)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(15.0, 2.0, 2.0, 2.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black.withOpacity(0.2)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Color(0xFF707070)
                    : Color(0xFFFFFD57),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  static InputDecoration _decorationDropdown(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Theme.of(context).custom.b325f8_w_fffd57,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Theme.of(context).custom.b325f8_w_fffd57,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );

  dynamic dialogOpenPickerDate() {
    var now = DateTime.now();
    dtpp.DatePicker.showDatePicker(
      context,
      theme: dtpp.DatePickerTheme(
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Color(0xFF292929),
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF7A4CB1)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF7A4CB1)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF7A4CB1)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
      showTitleActions: true,
      minTime:
          DateTime(now.year + 543, now.month, now.day, now.hour, now.minute),
      maxTime: DateTime(_year + 1, _month, _day),
      onChanged: (time) {},
      onConfirm: (date) {
        int difDate = DateTime(now.year + 543, now.month, now.day)
            .compareTo(DateTime(date.year, date.month, date.day));

        TimeOfDay timeStart = TimeOfDay(hour: 00, minute: 00);
        if (txtStartTime.text.isNotEmpty) {
          timeStart = TimeOfDay(
            hour: int.parse(txtStartTime.text.substring(0, 2)),
            minute: int.parse(txtStartTime.text.substring(3, 5)),
          );
        }
        bool timeSelectMoreThenCurrent = true;
        timeSelectMoreThenCurrent = _getTime(
          TimeOfDay(hour: now.hour, minute: now.minute),
          TimeOfDay(hour: timeStart.hour, minute: timeStart.minute),
        );

        setState(
          () {
            _selectedYear = date.year;
            _selectedMonth = date.month;
            _selectedDay = date.day;
            txtDate.value = TextEditingValue(
              text: DateFormat("dd / MM / yyyy").format(date),
            );
            // reset time if time selected less then current time.
            if (!timeSelectMoreThenCurrent && difDate == 0) {
              txtStartTime.value = TextEditingValue(text: '');
              txtEndTime.value = TextEditingValue(text: '');
            }
          },
        );
      },
      currentTime: DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
      locale: dtpp.LocaleType.th,
    );
  }

  dynamic dialogOpenPickerTime(String type) {
    var now = DateTime.now();

    TimeOfDay timeStart;
    late TimeOfDay timeEnd;

    DateTime initCurrentTime = DateTime.now();
    dtpp.DatePicker.showTimePicker(
      context,
      theme: dtpp.DatePickerTheme(
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Color(0xFF292929),
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF7A4CB1)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF7A4CB1)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF7A4CB1)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
      showTitleActions: true,
      onChanged: (date) {},
      onConfirm: (date) {
        DateTime dateSet =
            DateTime(_selectedYear, _selectedMonth, _selectedDay);
        DateTime selectedDate = DateTime(date.year + 543, date.month, date.day);
        int diffDate = -1;
        var difDate = dateSet.compareTo(selectedDate);
        if (difDate == 0) {
          diffDate = 0;
        } else if (difDate > 0) {
          diffDate = 1;
        }
        if (diffDate >= 0) {
          bool timeSelectMoreThenCurrent = true;
          if (diffDate == 0)
            timeSelectMoreThenCurrent = _getTime(
              TimeOfDay(hour: now.hour, minute: now.minute),
              TimeOfDay(hour: date.hour, minute: date.minute),
            );
          setState(
            () {
              bool endMoreThenStart = false;
              if (type == 'start' && timeSelectMoreThenCurrent) {
                timeStart = TimeOfDay(hour: date.hour, minute: date.minute);
                if (txtEndTime.text.isNotEmpty) {
                  timeEnd = TimeOfDay(
                    hour: int.parse(txtEndTime.text.substring(0, 2)),
                    minute: int.parse(txtEndTime.text.substring(3, 5)),
                  );
                  endMoreThenStart = _getTime(timeStart, timeEnd);
                  if (endMoreThenStart == false) {
                    txtEndTime.value = TextEditingValue(
                      text: '',
                    );
                  }
                }
                txtStartTime.value = TextEditingValue(
                  text: DateFormat("HH:mm").format(date),
                );
              } else if (type == 'end' && timeSelectMoreThenCurrent) {
                timeEnd = TimeOfDay(hour: date.hour, minute: date.minute);
                if (txtStartTime.text.isNotEmpty) {
                  timeStart = TimeOfDay(
                    hour: int.parse(txtStartTime.text.substring(0, 2)),
                    minute: int.parse(txtStartTime.text.substring(3, 5)),
                  );
                  endMoreThenStart = _getTime(timeStart, timeEnd);
                  if (endMoreThenStart == false) {
                    txtStartTime.value = TextEditingValue(
                      text: '',
                    );
                  }
                }
                txtEndTime.value = TextEditingValue(
                  text: DateFormat("HH:mm").format(date),
                );
              } else {
                Fluttertoast.showToast(msg: 'เวลาไม่ถูกต้อง');
              }
            },
          );
        } else {
          Fluttertoast.showToast(msg: 'เวลาไม่ถูกต้อง');
        }
      },
      currentTime: initCurrentTime,
      showSecondsColumn: false,
      locale: dtpp.LocaleType.th,
    );
  }

  _dialogConfirmCheckIn(dynamic param) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool loadingCheckIn = false;
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter mSetState /*You can rename this!*/) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Theme.of(context).custom.w_b_b,
            elevation: 0,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    constraints: BoxConstraints(minHeight: 127),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/warning.png',
                          width: 77.5,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'เช็คอิน',
                          style: TextStyle(
                            color: Theme.of(context).custom.b325f8_w_fffd57,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'ท่านยืนยันที่จะทำการเช็คอินใช่หรือไม่',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).custom.b325f8_w_fffd57,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                try {
                                  mSetState(() => loadingCheckIn = true);
                                  var accessToken =
                                      await ManageStorage.read('accessToken') ??
                                          '';

                                  // check in
                                  await Dio().put(
                                    '$ondeURL/api/Booking/UserCheckin',
                                    data: {
                                      "bookingNo": param['bookingno'],
                                      "status": "4"
                                    },
                                    options: Options(
                                      headers: {
                                        'Authorization': 'Bearer $accessToken',
                                      },
                                    ),
                                  );

                                  mSetState(() => loadingCheckIn = false);

                                  Navigator.pop(context);
                                  _dialogSuccess();

                                  _callRead(refresh: true);
                                } catch (e) {
                                  logE(e);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).custom.b325f8_w_fffd57,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'ยืนยัน',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).custom.w_b_b,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  color: MyApp.themeNotifier.value ==
                                          ThemeModeThird.light
                                      ? Colors.white
                                      : MyApp.themeNotifier.value ==
                                              ThemeModeThird.dark
                                          ? Colors.black
                                          : Colors.black,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .custom
                                        .b325f8_w_fffd57_OVF50,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'ย้อนกลับ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .custom
                                        .b325f8_w_fffd57,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                if (loadingCheckIn)
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.3)),
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ),
          );
        });
      },
    );
  }

  _dialogSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter mSetState /*You can rename this!*/) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Theme.of(context).custom.w_b_b,
            elevation: 0,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    constraints: BoxConstraints(minHeight: 127),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/check.png',
                          width: 77.5,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'เช็คอินสำเร็จ!',
                          style: TextStyle(
                            color: Theme.of(context).custom.C19AA6A_w_fffd57,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'ทำการเช็คอินเรียบร้อยแล้ว\nท่านสามารถดูประวัติการจอง\nได้ที่เมนูจองใช้บริการ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                setState(() {
                                  catSelected = '2';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).custom.b325f8_w_fffd57,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'ดูประวัติการจอง',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).custom.w_b_b,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void initState() {
    print('------initState------');
    widget.catSelectedWidget != null
        ? catSelected = widget.catSelectedWidget
        : catSelected = '0';
    _callReadProvince();
    super.initState();
    modelCategory = MockBookingData.category();
    _modelBookingFiltered = MockBookingData.bookingReal();
    _modelBookingHistory = MockBookingData.bookingReal();
    modelCenter = MockBookingData.center();
    var now = DateTime.now();
    _year = now.year + 543;
    _month = now.month;
    _day = now.day;
    _selectedYear = now.year + 543;
    _selectedMonth = now.month;
    _selectedDay = now.day;
    _scrollController = ScrollController()..addListener(_scrollListener);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _searchController = TextEditingController(text: '');
    _modelNearMe = [];
    _loadingNearMe = false;
    _determinePosition();
    _callAutoComplete();
    _callRead(refresh: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    // _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  _callAutoComplete() async {
    try {
      String accessToken = await ManageStorage.read('accessToken');

      var response = await Dio().get(
        '$ondeURL/api/ShowCenter',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      List<dynamic> data = response.data;

      setState(() {
        _modelAutoComplete = data.map<String>((e) => e['centerName']).toList();
      });
    } on DioError catch (e) {
      logE(e);
      setState(() => _loadingBookingStatus = LoadingBookingStatus.fail);
      Fluttertoast.showToast(msg: e.response!.data['message']);
    }
  }

  _callRead({required bool refresh}) async {
    try {
      _modelBookingHistory.clear();
      _modelBookingFiltered.clear();
      List<dynamic> result = [];
      List<dynamic> result2 = [];

      setState(() => _loadingBookingStatus = LoadingBookingStatus.loading);
      String accessToken = await ManageStorage.read('accessToken');
      if (refresh) {
        var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
        var response = await Dio().get(
          '$ondeURL/api/Booking/GetBooking/mobile/${profileMe['email']}',
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );

        if (response.data.isEmpty) {
          // if ((response.data as List).isEmpty) {
          print("เข้ามาเพราะ response.data ว่างจริงๆ -> ${response.data}");
          setState(() {
            _loadingBookingStatus = LoadingBookingStatus.success;
            _modelBookingFiltered = [];
          });
          return;
        }
        print(
            "ออกมาเพราะ response.data  -> ${(response.data as List).isEmpty}");
        setState(() {
          _modelBookingAll = response.data;
          print(
              "_modelBookingAll -> ${_modelBookingAll.length} : ${_modelBookingAll.runtimeType}");
        });
      }

      // result = await _modelBookingAll
      //     .where((dynamic e) => (_checkCurrentDate(
      //               dateStr: e?['bookingdate'] ?? '',
      //               startTime: e?['startTime'] ?? '',
      //               endTime: e?['endTime'] ?? '',
      //             ) >=
      //             0 &&
      //         e['status'] == '1'))
      //     .toList();
      // แก้ไขให้แสดงเฉพาะรายการที่ตรงกับวันปัจจุบัน ไม่เช็คเวลา
      result = await _modelBookingAll
          .where((dynamic e) =>
              (DateTime.parse(e['bookingdate']).day == DateTime.now().day &&
                  e['status'] == '1'))
          .toList();
      result.sort((a, b) => a['bookingdate'].compareTo(b['bookingdate']));
      setState(() {
        _loadingBookingStatus = LoadingBookingStatus.success;
        _modelBookingFiltered = result;
      });
      result2 = await _modelBookingAll
          .where((dynamic e) => (_checkCurrentDate(
                    dateStr: e?['bookingdate'] ?? '',
                    startTime: e?['startTime'] ?? '',
                  ) <
                  0 ||
              e['status'] == '0' ||
              e['status'] == '4'))
          .toList();
      result2.sort((a, b) => b['bookingdate'].compareTo(a['bookingdate']));
      setState(() {
        _loadingBookingStatus = LoadingBookingStatus.success;
        _modelBookingHistory = result2;
      });
    } on DioError catch (e) {
      logE(e);
      setState(() => _loadingBookingStatus = LoadingBookingStatus.fail);
      Fluttertoast.showToast(msg: e.response!.data['message']);
    }
  }

  _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else if (permission == LocationPermission.always) {
    } else if (permission == LocationPermission.whileInUse) {
    } else if (permission == LocationPermission.unableToDetermine) {
    } else {
      setState(() => _loadingNearMe = false);
      throw Exception('Error');
    }
  }

  void onRefresh() async {
    _determinePosition();
    await _callRead(refresh: true);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  // ignore: unused_element
  String _setDate(String? date) {
    if (date!.isEmpty) return '';
    String year = date.substring(0, 4);
    int yearIntTh = int.parse(year) + 543;
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    return day + '/' + month + '/' + yearIntTh.toString().substring(2, 4);
  }

  _dateFormat(dateStr) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateTime inputDate = inputFormat.parse(dateStr);
    DateFormat outputFormat = DateFormat('dd/MM/yyyy', 'th');
    return outputFormat.format(inputDate);
  }

  int _checkCurrentDate({
    required String dateStr,
    required String startTime,
    String endTime = "",
    bool onlyDay = false,
  }) {
    if (dateStr.isNotEmpty) {
      DateFormat formatDate = DateFormat('yyyy-MM-dd');
      DateTime bookingDate = formatDate.parse(dateStr);

      List<String> timeSpit = startTime.split(':');

      int year = bookingDate.year;
      int month = bookingDate.month;
      int day = bookingDate.day;
      int hour = int.parse(timeSpit[0]);
      int minute = int.parse(timeSpit[1]);

      final now = DateTime.now();
      DateTime dateStart = DateTime(year, month, day, hour, minute);
      DateTime currentDate =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);
      if (onlyDay) {
        dateStart = DateTime(year, month, day);
        currentDate = DateTime(now.year, now.month, now.day);
      }

      if (endTime != "") {
        List<String> timeSpitEnd = endTime.split(':');
        int hourEnd = int.parse(timeSpitEnd[0]);
        int minuteEnd = int.parse(timeSpitEnd[1]);
        DateTime dateEnd = DateTime(year, month, day, hourEnd, minuteEnd);
        if (now.isAfter(dateStart) && now.isBefore(dateEnd)) {
          return 1;
        } else {
          return -1;
        }
      }

      final difDate = dateStart.compareTo(currentDate);
      if (difDate == 0) {
        return 0;
      } else if (difDate > 0) {
        return 1;
      }
    }
    return -1;
  }

  bool _checkedCurrent(model, String type) {
    String dateStr = model['bookingdate'] ?? '';
    var result = -1;
    if (dateStr.isNotEmpty) {
      // จัด format date
      DateFormat formatDate = DateFormat('yyyy-MM-dd');
      DateTime bookingDate = formatDate.parse(dateStr);

      int year = bookingDate.year;
      int month = bookingDate.month;
      int day = bookingDate.day;

      final now = DateTime.now();
      DateTime date = DateTime(year, month, day);
      DateTime currentDate = DateTime(now.year, now.month, now.day);

      final difDate = date.compareTo(currentDate);
      if (difDate == 0) {
        result = 0;
      } else if (difDate > 0) {
        result = 1;
      }
    }

    bool currentDay = result == 0 ? true : false;

    if (model['status'] == type && catSelected == 2) {
      return true;
    }
    return false;
  }

  _getTime(TimeOfDay startTime, TimeOfDay endTime) {
    bool result = false;
    int startTimeInt = (startTime.hour * 60 + startTime.minute) * 60;
    int EndTimeInt = (endTime.hour * 60 + endTime.minute) * 60;

    if (EndTimeInt > startTimeInt) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController.hasClients && _scrollController.offset > (291);
  }

  _callReadProvince() async {
    try {
      Dio dio = Dio();
      await dio.get('$ondeURL/api/masterdata/changwat').then((value) => {
            setState(() {
              provinceList.addAll(value.data);
              districtList.clear();
              districtList = [
                {"label": 'เลือกอำเภอ', "value": '0'}
              ];
            })
          });
    } catch (e) {
    } finally {}
  }

  _callReadDistrict() async {
    try {
      Dio dio = Dio();
      await dio.post('$ondeURL/api/masterdata/amphoe', data: {
        "filters": [filter['provinceSelected']]
      }).then((value) => {
            setState(() {
              districtList.addAll(value.data);
            })
          });
    } catch (e) {
    } finally {}
  }

  _dropdown({
    required List<dynamic> data,
    required String value,
    Function(String)? onChanged,
  }) {
    return Stack(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).custom.w_b_b,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x40F3D2FF),
                offset: Offset(0, 4),
              )
            ],
          ),
          child: DropdownButtonFormField(
            icon: Image.asset(
              'assets/images/arrow_dropdown.png',
              width: 16,
              height: 8,
            ),
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).custom.b_W_fffd57,
              fontFamily: 'Kanit',
            ),
            decoration: _decorationDropdown(context),
            isDense: false,
            isExpanded: true,

            value: value != null &&
                    data.any((item) => item['value'].toString() == value)
                ? value
                : null, // Ensure value is in items
            dropdownColor: Theme.of(context).custom.w_b_b,

            onChanged: (dynamic newValue) {
              onChanged!(newValue);
            },
            items: data.map((item) {
              return DropdownMenuItem(
                value: item['value'].toString(),
                child: Text(
                  '${item['label']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).custom.b_W_fffd57,
                  ),
                  maxLines: 1,
                ),
              );
            }).toList(),
          ),
        ),
        if (_loadingDropdownType)
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.only(right: 50),
              alignment: Alignment.centerRight,
              child: const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
