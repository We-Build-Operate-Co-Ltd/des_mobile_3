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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'main.dart';

class BookingServicePage extends StatefulWidget {
  const BookingServicePage({super.key});

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
  dynamic modelCategory;

  String _selectedCategory = '0';

  late ScrollController _scrollController;
  bool lastStatus = true;

  late AnimationController _animationController;
  late TextEditingController _searchController;
  LoadingBookingStatus _loadingBookingStatus = LoadingBookingStatus.loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: _refreshController,
            onRefresh: onRefresh,
            onLoading: _onLoading,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  foregroundColor: Colors.red,
                  expandedHeight: 470.0,
                  collapsedHeight: 145,
                  toolbarHeight: 145,
                  backgroundColor:
                      MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                  titleSpacing: 0.0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    expandedTitleScale: 1,
                    title: Stack(
                      children: [
                        Positioned(
                          top: -42,
                          right: 0,
                          child: AnimatedOpacity(
                            duration: _animationController.duration!,
                            curve: Curves.fastOutSlowIn,
                            opacity: _isShrink ? 0.0 : 1,
                            child: Image.asset(
                              'assets/images/logo_2o.png',
                              fit: BoxFit.fitWidth,
                              width: 290,
                              alignment: Alignment.topRight,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: !_isShrink
                              ? AnimatedOpacity(
                                  duration: _animationController.duration!,
                                  curve: Curves.easeIn,
                                  opacity: _isShrink ? 0.0 : 1,
                                  child: ListView(
                                    physics: ClampingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    children: _criteriaExpanded(),
                                  ),
                                )
                              : _criteriaCollapse(),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  ..._history(),
                ]))
              ],
            )),
      ),
    );
  }

  _criteriaCollapse() {
    return GestureDetector(
      onTap: () {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 400), curve: Curves.linear);
      },
      child: Container(
        color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Color(0xFFFEF7FF)
            : Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 20 + MediaQuery.of(context).padding.top,
            ),
            Text(
              'จองบริการ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.black
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.white
                        : Color(0xFFFFFD57),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => dialogOpenPickerDate(),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: txtDate,
                        style: TextStyle(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Colors.black
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 15.0,
                        ),
                        decoration: _decorationDate(
                          context,
                          hintText: 'วันใช้บริการ',
                        ),
                        validator: (model) {
                          if (model!.isEmpty) {
                            return 'กรุณากรอกวันเดือนปีเกิด.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingServiceSearchResultPage(
                            date: txtDate.text,
                            startTime: txtStartTime.text,
                            endTime: txtEndTime.text,
                            search: _searchController.text,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ค้นหา',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Colors.white
                                  : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _criteriaExpanded() {
    return <Widget>[
      SizedBox(
        height: 20 + MediaQuery.of(context).padding.top,
      ),
      Text(
        'จองบริการ',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.black
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 25,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            // 292929
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.white
                : Color(0xFF121212),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Colors.grey.withOpacity(0.4)
                    : Colors.white.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _currentPage = 0;
                      }),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? (_currentPage == 0
                                  ? Color(0xFF7A4CB1)
                                  : Color(0xFFDDDDDD))
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? (_currentPage == 0
                                      ? Colors.white
                                      : Color(0xFF121212))
                                  : (_currentPage == 0
                                      ? Color(0xFFFFFD57)
                                      : Color(0xFF121212)),
                          border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? (_currentPage == 0
                                      ? Color(0xFF7A4CB1)
                                      : Color(0xFFDDDDDD))
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? (_currentPage == 0
                                          ? Colors.black
                                          : Color(0xFF707070))
                                      : Color(0xFFFFFD57)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'จองใช้บริการ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? (_currentPage == 0
                                        ? Colors.black
                                        : Color(0xFF707070))
                                    : (_currentPage == 0
                                        ? Colors.black
                                        : Color(0xFFFFFD57)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _currentPage = 1;
                      }),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? (_currentPage == 1
                                  ? Color(0xFF7A4CB1)
                                  : Color(0xFFDDDDDD))
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? (_currentPage == 1
                                      ? Colors.white
                                      : Color(0xFF121212))
                                  : (_currentPage == 1
                                      ? Color(0xFFFFFD57)
                                      : Color(0xFF121212)),
                          border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? (_currentPage == 1
                                      ? Color(0xFF7A4CB1)
                                      : Color(0xFFDDDDDD))
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? (_currentPage == 1
                                          ? Colors.black
                                          : Color(0xFF707070))
                                      : Color(0xFFFFFD57)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'เลือกศูนย์ฯ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? (_currentPage == 1
                                        ? Colors.black
                                        : Color(0xFF707070))
                                    : (_currentPage == 1
                                        ? Colors.black
                                        : Color(0xFFFFFD57)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              if (_currentPage == 0) ..._pageOne(),
              if (_currentPage == 1) ..._pageTwo(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingServiceSearchResultPage(
                        date: txtDate.text,
                        startTime: txtStartTime.text,
                        endTime: txtEndTime.text,
                        search: _searchController.text,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF7A4CB1)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'ค้นหา',
                    style: TextStyle(
                      fontSize: 15,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _history() {
    return <Widget>[
      SizedBox(
        height: 10,
      ),
      Container(
        color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: FutureBuilder<dynamic>(
          future: Future.value(modelCategory),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: 25,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, __) => _itemCategory(snapshot.data[__]),
                  separatorBuilder: (_, __) => SizedBox(width: 10),
                  itemCount: snapshot.data!.length,
                ),
              );
            }
            return SizedBox(height: 25);
          },
        ),
      ),
      SizedBox(height: 15),
      Container(
        color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        child: _list(),
      ),
    ];
  }

  _list() {
    if (_loadingBookingStatus == LoadingBookingStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_loadingBookingStatus == LoadingBookingStatus.success) {
      if (_modelBookingFiltered.length == 0) {
        return Center(
          child: Text('ไม่พบข้อมูล'),
        );
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        itemCount: _modelBookingFiltered.length,
        separatorBuilder: (_, __) => SizedBox(height: 15),
        itemBuilder: (_, __) => _itemBooking(_modelBookingFiltered[__]),
      );
    } else {
      return Center(
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
      );
    }
  }

  List<Widget> _pageOne() {
    return <Widget>[
      GestureDetector(
        onTap: () => dialogOpenPickerDate(),
        child: AbsorbPointer(
          child: TextFormField(
            controller: txtDate,
            style: TextStyle(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.black
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
              fontSize: 15.0,
            ),
            decoration: _decorationDate(
              context,
              hintText: 'วันใช้บริการ',
            ),
            validator: (model) {
              if (model!.isEmpty) {
                return 'กรุณากรอกวันเดือนปีเกิด.';
              }
              return null;
            },
          ),
        ),
      ),
      SizedBox(height: 15),
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => dialogOpenPickerTime('start'),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: txtStartTime,
                  style: TextStyle(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                    fontSize: 15.0,
                  ),
                  decoration: _decorationTime(
                    context,
                    hintText: 'เวลาเริ่ม',
                  ),
                  validator: (model) {
                    if (model!.isEmpty) {
                      return 'กรุณาเลือกเวลาเริ่ม';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: GestureDetector(
              onTap: () => dialogOpenPickerTime('end'),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: txtEndTime,
                  style: TextStyle(
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                    fontSize: 15.0,
                  ),
                  decoration: _decorationTime(
                    context,
                    hintText: 'เวลาเลิก',
                  ),
                  validator: (model) {
                    if (model!.isEmpty) {
                      return 'กรุณาเลือกเวลาเลิก';
                    }
                    return null;
                  },
                ),
              ),
            ),
          )
        ],
      ),
      SizedBox(height: 15),
      // SizedBox(
      //   height: 35,
      //   child:
      TextFormField(
        controller: _searchController,
        decoration: _decorationSearch(
          context,
          hintText: 'สถานที่',
        ),
        style: TextStyle(
          fontFamily: 'Kanit',
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.black
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
        ),
      ),
      // ),
      SizedBox(height: 65),
    ];
  }

  List<Widget> _pageTwo() {
    return <Widget>[
      // SizedBox(
      //   height: 35,
      // child:
      TextFormField(
        decoration: _decorationSearch(
          context,
          hintText: 'สถานที่',
        ),
      ),
      // ),
      SizedBox(height: 15),
      Text(
        'ศูนย์ฯ ใกล้ฉัน',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Colors.black
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
        ),
        textAlign: TextAlign.left,
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Image.asset(
            'assets/images/vector.png',
            height: 15,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
          SizedBox(width: 10),
          Text(
            'ศูนย์ฯ จังหวัดนนทบุรี',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.black
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Image.asset(
            'assets/images/vector.png',
            height: 15,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
          SizedBox(width: 10),
          Text(
            'ศูนย์ฯ อำเภอเมืองนนทบุรี',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.black
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
            ),
          ),
        ],
      ),
      SizedBox(height: 50),
    ];
  }

  Widget _itemCategory(model) {
    return GestureDetector(
      onTap: () => setState(() {
        _selectedCategory = model['code'].toString();
        _callRead(refresh: false);
      }),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? (_selectedCategory == model['code']
                  ? Color(0xFFB325F8)
                  : Color(0xFFB325F8).withOpacity(.1))
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? (_selectedCategory == model['code']
                      ? Colors.white
                      : Colors.black)
                  : (_selectedCategory == model['code']
                      ? Color(0xFFFFFD57)
                      : Colors.black),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: 1,
              style: BorderStyle.solid,
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? (_selectedCategory == model['code']
                      ? Color(0xFFB325F8)
                      : Color(0xFFB325F8).withOpacity(.1))
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57)),
        ),
        child: Text(
          '${model['title']}',
          style: TextStyle(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? (_selectedCategory == model['code']
                    ? Colors.white
                    : Color(0xFFB325F8).withOpacity(.4))
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? (_selectedCategory == model['code']
                        ? Colors.black
                        : Colors.white)
                    : (_selectedCategory == model['code']
                        ? Colors.black
                        : Color(0xFFFFFD57)),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _itemBooking(model) {
    return GestureDetector(
      onTap: () {
        //
        bool edit = false;
        bool repeat = false;

        // กำลังมาถึง && ยังไม่ check in
        if (_selectedCategory == '0' && model['status'] != '4') {
          edit = true;
        } else {
          repeat = true;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingServiceDetailPage(
              model: model,
              edit: edit,
              repeat: repeat,
              repeatCurrentDay: false,
              date: DateFormat("dd / MM / yyyy")
                  .format(DateTime.parse(model['bookingdate'])),
              startTime: model['startTime'],
              endTime: model['endTime'],
            ),
          ),
        );
      },
      child: Container(
        color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8).withOpacity(.1)
                      : Colors.black,
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFFB325F8).withOpacity(.1)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  )),
              child: Image.asset(
                'assets/images/computer.png',
                width: 17,
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFF53327A)
                    : Colors.white,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${model['centerName']}',
                          style: TextStyle(
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7A4CB1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  if (_checkCurrentDate(
                            dateStr: model['bookingdate'],
                            startTime: model['startTime'],
                            onlyDay: true,
                          ) ==
                          0 &&
                      model['status'] != "4")
                    GestureDetector(
                      onTap: () async {
                        try {
                          logWTF(
                              {"bookingNo": model['bookingNo'], "status": "4"});
                          //check in
                          await Dio().put(
                              '$serverBooking/api/Booking/UserCheckin',
                              data: {
                                "bookingNo": model['bookingno'],
                                "status": "4"
                              });

                          _callRead(refresh: true);
                        } catch (e) {
                          logE(e);
                        }
                      },
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFF7A4CB1)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'เช็คอิน',
                          style: TextStyle(
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  if (model['status'] == "4")
                    Container(
                      height: 30,
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
                      child: Text(
                        'เช็คอินแล้ว',
                        style: TextStyle(
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (_checkedCurrent(model))
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
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : Colors.black,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'เช็คอินแล้ว',
                            style: TextStyle(
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF53327A)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        _dateFormat(model?['bookingdate'] ?? ''),
                        style: TextStyle(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFF53327A)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.access_time_rounded,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF53327A)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        (model?['startTime'] ?? '') + ' น.',
                        style: TextStyle(
                          color: MyApp.themeNotifier.value ==
                                  ThemeModeThird.light
                              ? Color(0xFF53327A)
                              : MyApp.themeNotifier.value == ThemeModeThird.dark
                                  ? Colors.white
                                  : Color(0xFFFFFD57),
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 20),
                      // Text(
                      //   _setDifferentTime(
                      //     dateStr: model?['bookingdate'] ?? '',
                      //     startTime: model?['startTime'] ?? '',
                      //   ),
                      //   style: TextStyle(
                      //     color: MyApp.themeNotifier.value ==
                      //             ThemeModeThird.light
                      //         ? Color(0xFF53327A)
                      //         : MyApp.themeNotifier.value == ThemeModeThird.dark
                      //             ? Colors.white
                      //             : Color(0xFFFFFD57),
                      //     fontSize: 9,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Color(0xFF707070).withOpacity(.5)
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  )
                ],
              ),
            )
          ],
        ),
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
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
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

  static InputDecoration _decorationDate(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
        ),
        hintStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        suffixIcon: const Icon(Icons.calendar_today, size: 17),
        suffixIconColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.black
            : MyApp.themeNotifier.value == ThemeModeThird.dark
                ? Colors.white
                : Color(0xFFFFFD57),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black.withOpacity(0.2)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Color(0xFF707070)
                    : Color(0xFFFFFD57),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );
  static InputDecoration _decorationTime(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
        ),
        hintStyle: TextStyle(
          color: MyApp.themeNotifier.value == ThemeModeThird.light
              ? Color(0xFF707070)
              : MyApp.themeNotifier.value == ThemeModeThird.dark
                  ? Colors.white
                  : Color(0xFFFFFD57),
          fontSize: 12,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        suffixIcon: const Icon(Icons.access_time_rounded, size: 17),
        suffixIconColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.black
            : MyApp.themeNotifier.value == ThemeModeThird.dark
                ? Colors.white
                : Color(0xFFFFFD57),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF7A4CB1)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.black.withOpacity(0.2)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Color(0xFF707070)
                    : Color(0xFFFFFD57),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );

  // DatePickerTheme datepickerTheme = DatePickerTheme(
  //   backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
  //       ? Colors.white
  //       : Color(0xFF292929),
  //   containerHeight: 210.0,
  //   itemStyle: TextStyle(
  //     fontSize: 16.0,
  //     color: MyApp.themeNotifier.value == ThemeModeThird.light
  //         ? Color(0xFF7A4CB1)
  //         : MyApp.themeNotifier.value == ThemeModeThird.dark
  //             ? Colors.white
  //             : Color(0xFFFFFD57),
  //     fontWeight: FontWeight.normal,
  //     fontFamily: 'Kanit',
  //   ),
  //   doneStyle: TextStyle(
  //     fontSize: 16.0,
  //     color: MyApp.themeNotifier.value == ThemeModeThird.light
  //         ? Color(0xFF7A4CB1)
  //         : MyApp.themeNotifier.value == ThemeModeThird.dark
  //             ? Colors.white
  //             : Color(0xFFFFFD57),
  //     fontWeight: FontWeight.normal,
  //     fontFamily: 'Kanit',
  //   ),
  //   cancelStyle: TextStyle(
  //     fontSize: 16.0,
  //     color: MyApp.themeNotifier.value == ThemeModeThird.light
  //         ? Color(0xFF7A4CB1)
  //         : MyApp.themeNotifier.value == ThemeModeThird.dark
  //             ? Colors.white
  //             : Color(0xFFFFFD57),
  //     fontWeight: FontWeight.normal,
  //     fontFamily: 'Kanit',
  //   ),
  // );

  dynamic dialogOpenPickerDate() {
    var now = DateTime.now();
    DatePicker.showDatePicker(
      context,
      theme: DatePickerTheme(
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
      locale: LocaleType.th,
    );
  }

  dynamic dialogOpenPickerTime(String type) {
    var now = DateTime.now();

    TimeOfDay timeStart;
    late TimeOfDay timeEnd;

    DateTime initCurrentTime = DateTime.now();
    DatePicker.showTimePicker(
      context,
      theme: DatePickerTheme(
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
        // ----> ตรวจสอบวันที่เลือกเป็นเวลาปัจจุบันหรือไม่.
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
        // <----

        // ตรวจสอบวันที่เลือกเป็นเวลาปัจจุบันหรือไม่.
        if (diffDate >= 0) {
          // ตรวจสอบเวลาที่เลือกไม่น้อยกว่าเวลาปัจจุบัน.
          //  + เพิ่ม 1 ซม ไหม.
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
      locale: LocaleType.th,
    );
  }

  @override
  void initState() {
    super.initState();
    modelCategory = MockBookingData.category();
    _modelBookingFiltered = MockBookingData.bookingReal();
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
    _callRead(refresh: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  _callRead({required bool refresh}) async {
    try {
      setState(() => _loadingBookingStatus = LoadingBookingStatus.loading);

      List<dynamic> dataWithoutCancelBooking = [];
      if (refresh) {
        // โหลดข้อมูลใหม่
        var value = await ManageStorage.read('profileData') ?? '';
        var profileData = json.decode(value);
        Response response = await Dio().get(
            '$serverBooking/api/Booking/GetBooking/mobile/${profileData['email']}');

        _modelBookingAll = response.data;
      }

      //data without cancel.
      dataWithoutCancelBooking =
          _modelBookingAll.where((e) => e['status'] != '0').toList();

      List<dynamic> result = [];

      if (_selectedCategory == '0') {
        result = await dataWithoutCancelBooking
            .where((dynamic e) =>
                _checkCurrentDate(
                  dateStr: e?['bookingdate'] ?? '',
                  startTime: e?['startTime'] ?? '',
                ) >=
                0)
            .toList();
        result.sort((a, b) => a['bookingdate'].compareTo(b['bookingdate']));
      } else {
        result = await dataWithoutCancelBooking
            .where((dynamic e) =>
                _checkCurrentDate(
                  dateStr: e?['bookingdate'] ?? '',
                  startTime: e?['startTime'] ?? '',
                ) <
                0)
            .toList();
        result.sort((a, b) => b['bookingdate'].compareTo(a['bookingdate']));
      }

      setState(() {
        _loadingBookingStatus = LoadingBookingStatus.success;
        _modelBookingFiltered = result;
      });
      // logWTF(_modelBookingFiltered);
    } on DioError catch (e) {
      setState(() => _loadingBookingStatus = LoadingBookingStatus.fail);
      Fluttertoast.showToast(msg: e.response!.data['message']);
    }
  }

  void onRefresh() async {
    await _callRead(refresh: true);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  String _setDate(String? date) {
    if (date!.isEmpty) return '';
    String year = date.substring(0, 4);
    int yearIntTh = int.parse(year) + 543;
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    return day + '/' + month + '/' + yearIntTh.toString().substring(2, 4);
  }

  String _setDifferentTime({
    required String dateStr,
    required String startTime,
  }) {
    if (dateStr.isNotEmpty) {
      // จัด format date
      DateFormat formatDate = DateFormat('yyyy-MM-dd');
      DateTime bookingDate = formatDate.parse(dateStr);

      List<String> timeSpit = startTime.split(':');

      int year = bookingDate.year;
      int month = bookingDate.month;
      int day = bookingDate.day;
      int hour = int.parse(timeSpit[0]);
      int minute = int.parse(timeSpit[1]);
      final now = DateTime.now();
      DateTime date = DateTime(year, month, day, hour, minute);
      DateTime currentDate =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);

      final difDate = currentDate.compareTo(date);
      if (difDate == 0) {
        if (hour > DateTime.now().hour) {
          if (hour == DateTime.now().hour + 1 &&
              (minute + 60) > DateTime.now().minute)
            return ((minute + 60) - DateTime.now().minute).toString() + ' นาที';
          return (hour - DateTime.now().hour).toString() + ' ชั่วโมง';
        } else if (hour == DateTime.now().hour) {
          return (minute - DateTime.now().minute).toString() + ' นาที';
        }
      }
    }
    return '';
  }

  _dateFormat(dateStr) {
    // จัด format date
    DateFormat formatDate = DateFormat('yyyy-MM-dd');
    DateTime bookingDate = formatDate.parse(dateStr);
    return formatDate.format(bookingDate);
  }

  int _checkCurrentDate({
    required String dateStr,
    required String startTime,
    bool onlyDay = false,
  }) {
    if (dateStr.isNotEmpty) {
      // จัด format date
      DateFormat formatDate = DateFormat('yyyy-MM-dd');
      DateTime bookingDate = formatDate.parse(dateStr);

      List<String> timeSpit = startTime.split(':');

      int year = bookingDate.year;
      int month = bookingDate.month;
      int day = bookingDate.day;
      int hour = int.parse(timeSpit[0]);
      int minute = int.parse(timeSpit[1]);

      final now = DateTime.now();
      DateTime date = DateTime(year, month, day, hour, minute);
      DateTime currentDate =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);
      if (onlyDay) {
        date = DateTime(year, month, day);
        currentDate = DateTime(now.year, now.month, now.day);
      }

      final difDate = date.compareTo(currentDate);
      if (difDate == 0) {
        return 0;
      } else if (difDate > 0) {
        return 1;
      }
    }
    return -1;
  }

  bool _checkedCurrent(model) {
    String dateStr = model['dateTime'] ?? '';
    var result = -1;
    if (dateStr.isNotEmpty) {
      int year = int.parse(dateStr.substring(0, 4));
      int month = int.parse(dateStr.substring(4, 6));
      int day = int.parse(dateStr.substring(6, 8));
      int hour = int.parse(dateStr.substring(8, 10));
      final date = DateTime(year, month, day, hour);
      final now = DateTime.now();
      final currentDate = DateTime(now.year, now.month, now.day);
      final difDate = date.compareTo(currentDate);
      if (difDate == 0) {
        result = 0;
      } else if (difDate > 0) {
        result = 1;
      }
    }
    // check current day morethen;
    bool currentDay = result == 1 ? true : false;

    // วันปัจจุบัน และ เช็คอินแล้ว และ อยู่ในประวัติการจอง
    if (currentDay && model['checkIn'] && _selectedCategory == '1') {
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
}
