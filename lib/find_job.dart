import 'package:des/main.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'find_job_detail.dart';

class FindJobPage extends StatefulWidget {
  FindJobPage({super.key, this.changePage});

  Function? changePage;

  @override
  State<FindJobPage> createState() => _FindJobPageState();
}

class _FindJobPageState extends State<FindJobPage> {
  dynamic _model = [];
  dynamic _modelExternal = [];
  dynamic _modelResume = [];
  dynamic _modelExternal2 = [
    {
      "linkUrl": "https://th.jobsdb.com/",
      "imageUrl":
          "https://dcc.onde.go.th/_next/static/media/JobsDB_Logo.53d4d001.png",
      "jobpositionName": "JobsDB",
      "employername": "",
      "education": "",
    },
    {
      "linkUrl":
          "https://www.jobthai.com/%E0%B8%AB%E0%B8%B2%E0%B8%87%E0%B8%B2%E0%B8%99",
      "imageUrl":
          "https://dcc.onde.go.th/_next/static/media/jobthai_Logo.c2c1c0bd.png",
      "jobpositionName": "JobThai",
      "employername": "",
      "education": "",
    },
    {
      "linkUrl": "https://www.jobtopgun.com/th",
      "imageUrl":
          "https://dcc.onde.go.th/_next/static/media/jobtopgun_logo.bdeb9332.jpeg",
      "jobpositionName": "jobTopGun",
      "employername": "",
      "education": "",
    },
    {
      "linkUrl": "https://xn--72c5abh2bf8icw0m9d.doe.go.th/",
      "imageUrl":
          "https://dcc.onde.go.th/_next/static/media/meeworktum.bbf8173b.png",
      "jobpositionName": "ไทยมีงานทำ",
      "employername": "",
      "education": "",
    },
    {
      "linkUrl": "https://www.jobbkk.com/",
      "imageUrl":
          "https://dcc.onde.go.th/_next/static/media/jobbkk.a2bf93d8.png",
      "jobpositionName": "JobBKK",
      "employername": "",
      "education": "",
    },
    {
      "linkUrl": "https://www.jobmyway.com/",
      "imageUrl":
          "https://dcc.onde.go.th/_next/static/media/jobmyway.21a72ad5.png",
      "jobpositionName": "JobMyWay",
      "employername": "",
      "education": "",
    },
  ];
  List<dynamic> _salatyModel = [];
  List<dynamic> _selectedSalaty = [];
  List<dynamic> _jobTypeModel = [];
  List<dynamic> _selectedJobType = [];
  dynamic _categoryModel = [];
  int _typeSelected = 0;
  int _cateSelected = 0;

  List<dynamic> catFindJob = [
    'ค้นหาตำแหน่งงาน',
    'แหล่งงานภายนอก',
    'ค้นหาข้อมูลเรซูเม่',
  ];

  int _typeSelected2 = 0;
  int _cateSelected2 = 0;
  List<dynamic> catFindJob2 = [
    'ตำแหน่งงานทั้งหมด',
    'ตำแหน่งงานภายนอก',
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late List<dynamic> _modelType = [];
  late List<dynamic> _modelChangwat = [];
  late List<dynamic> _modelAmphoe = [];

  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchFilterController = TextEditingController();
  int _typeRefNo = 0;
  int _changwatRefNo = 0;
  int _amphoeRefNo = 0;

  late List<dynamic> _modelAmphoeResume = [];
  TextEditingController _searchResumeController = TextEditingController();
  TextEditingController _searchFilterResumeController = TextEditingController();
  int _typeRefNoResume = 0;
  int _changwatRefNoResume = 0;
  int _amphoeRefNoResume = 0;

  @override
  void initState() {
    _callCategoryRead();
    _callRead();
    _callReadJobType();
    _callReadChangwat();
    _callCategorySalary();
    _callCategorJobTypy();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/new_bg.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          // backgroundColor: Theme.of(context).custom.w_b_b,
          backgroundColor: Colors.transparent,
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowGlow();
              return false;
            },
            child: Column(
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    right: 15,
                    left: 15,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.10),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Column(
                        children: [
                          _buildHead(),
                          SizedBox(height: 20),
                          _buildListJobCategory(),

                          SizedBox(height: 20),
                          // _buildListCategory(),
                          Expanded(
                            child: SmartRefresher(
                              enablePullDown: false,
                              enablePullUp: false,
                              footer: ClassicFooter(
                                loadingText: ' ',
                                canLoadingText: ' ',
                                idleText: ' ',
                                idleIcon: Icon(Icons.arrow_upward,
                                    color: Colors.transparent),
                              ),
                              controller: _refreshController,
                              onLoading: _loading,
                              child: _typeSelected == 0
                                  ? _buildListJob()
                                  : _typeSelected == 1
                                      ? _buildListJobExternal()
                                      : _typeSelected == 2
                                          ? _buildListJobResume()
                                          : Container(),
                            ),
                          ),
                          SizedBox(
                              height:
                                  20 + MediaQuery.of(context).padding.bottom),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHead() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      color: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => {
                  widget.changePage!(0),
                  // Navigator.pop(context),
                },
                child: Container(
                  height: 40,
                  width: 40,
                  child: Image.asset(
                    'assets/images/back_arrow.png',
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'จับคู่งาน',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Theme.of(context).custom.b325f8_w_fffd57
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
        ],
      ),
    );
  }

  Widget _buildListJobCategory() {
    return Container(
      height: 35,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => GestureDetector(
          onTap: () {
            setState(() => _typeSelected = __);
            // _model = [];
            // _callReadByJobCategory(_typeSelected, '');
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? __ == _typeSelected
                      ? Color(0xFFB325F8)
                      : Color(0xFFB325F8).withOpacity(0.1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Text(
              catFindJob[__],
              style: TextStyle(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? __ == _typeSelected
                        ? Colors.white
                        : Color(0xFFB325F8).withOpacity(0.5)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.black
                        : Colors.black,
              ),
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemCount: catFindJob.length,
      ),
    );
  }

  Widget _buildListJobCategory2() {
    return Container(
      height: 35,
      child: ListView.separated(
        // padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => GestureDetector(
          onTap: () {
            setState(() => _typeSelected2 = __);
            _callReadByJobCategory(_typeSelected2, '');
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? __ == _typeSelected2
                      ? Color(0xFFB325F8)
                      : Color(0xFFB325F8).withOpacity(0.1)
                  : MyApp.themeNotifier.value == ThemeModeThird.dark
                      ? Colors.white
                      : Color(0xFFFFFD57),
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Text(
              catFindJob2[__],
              style: TextStyle(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? __ == _typeSelected2
                        ? Colors.white
                        : Color(0xFFB325F8).withOpacity(0.5)
                    : MyApp.themeNotifier.value == ThemeModeThird.dark
                        ? Colors.black
                        : Colors.black,
              ),
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemCount: catFindJob2.length,
      ),
    );
  }

  Widget _buildItemCategory(dynamic data) {
    return InkWell(
      onTap: () {
        setState(() {
          _cateSelected = data['jobCateId'];
        });
        _callReadByCategory(data['jobCateId']);
      },
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: data['jobCateId'] == _cateSelected
              ? Color(0xFF7A4CB1)
              : Colors.white,
          borderRadius: BorderRadius.circular(17.5),
        ),
        child: Text(
          data?['nameTh'] ?? "",
          style: TextStyle(
            color: data['jobCateId'] == _cateSelected
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildListJob() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      children: [
        Container(
          child: Text(
            'ค้นหาตำแหน่งงาน',
            style: TextStyle(
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(height: 15),
        _buildSearch(
          _searchController,
          () {
            _showModelBottonSheetFind(context);
          },
        ),
        SizedBox(height: 15),
        _dropdown(
          hintText: "เลือกประเภทงาน",
          data: _modelType.map((item) {
            return DropdownMenuItem(
              value: item['jobCateId'],
              child: Text(
                '${item['nameTh']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).custom.b_W_fffd57,
                ),
              ),
            );
          }).toList(),
          // data: _modelType,
          value: _typeRefNo,
          onChanged: (value) {
            setState(() {
              _typeRefNo = value;
            });
          },
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _dropdown(
                hintText: "เลือกจังหวัด",
                data: _modelChangwat.map((item) {
                  return DropdownMenuItem(
                    value: item['value'],
                    child: Text(
                      '${item['label']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).custom.b_W_fffd57,
                      ),
                    ),
                  );
                }).toList(),
                // data: _modelType,
                value: _changwatRefNo,
                onChanged: (value) {
                  // print('------เลือกจังหวัด-------${value}');
                  _changwatRefNo = value;
                  _amphoeRefNo = 0;
                  _callReadAmphoe(value);
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _dropdown(
                hintText: "เลือกอำเภอ",
                data: _modelAmphoe.map((item) {
                  return DropdownMenuItem(
                    value: item['value'],
                    child: Text(
                      '${item['label']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).custom.b_W_fffd57,
                      ),
                    ),
                  );
                }).toList(),
                // data: _modelType,
                value: _amphoeRefNo,
                onChanged: (value) {
                  // print('------เลือกอำเภอ-------${value}');
                  setState(() {
                    _amphoeRefNo = value;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            // print(
            //     '---------_searchController----------${_searchController.text}');
            _handleSearch();
            _searchController.clear();
          },
          child: Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFB325F8),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x40F3D2FF),
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: const Text(
              'ค้นหาตำแหน่งงาน',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
        ContainerLine(),
        SizedBox(height: 15),
        _buildListJobCategory2(),
        SizedBox(height: 15),
        Container(
          child: Text(
            catFindJob2[_typeSelected2],
            // 'ตำแหน่งงานทั้งหมด',
            style: TextStyle(
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        _typeSelected2 == 0
            ? _model.length == 0
                ? Center(child: Text('ไม่พบข้อมูล'))
                : ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    // itemBuilder: (_, __) => _buildItemJob(MockFindJob.data[__]),
                    itemBuilder: (_, __) => _buildItemJob2(_model[__]),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: _model.length)
            : _modelExternal.length == 0
                ? Center(child: Text('ไม่พบข้อมูล'))
                : ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    // itemBuilder: (_, __) => _buildItemJob(MockFindJob.data[__]),
                    itemBuilder: (_, __) => _buildItemJob(_modelExternal[__]),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: _modelExternal.length)
      ],
    );
  }

  _buildItemJob(dynamic data) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FindJobDetailPage(model: data, typeselect2: _typeSelected2),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Container(
                // height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Color(0xFFB325F8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Image.asset('assets/images/jobkk11576.png'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data?['jobpositionName'] ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).custom.b325f8_w_fffd57,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Color(0xFFB325F8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset('assets/images/work.png'),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Text(
                    data?['employername'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Color(0xFFB325F8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset('assets/images/icon-map-marker.png'),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Text(
                    'ไม่ระบุ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Color(0xFFB325F8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset('assets/images/icon-money.png'),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Text(
                    'ไม่ระบุ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Color(0xFFB325F8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset('assets/images/icon-word.png'),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Text(
                    'ไม่ระบุ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ContainerLine(),
            const SizedBox(height: 10),
          ],
        ));
  }

  _buildItemJob2(dynamic data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FindJobDetailPage(
              model: data,
              typeselect2: _typeSelected2,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Container(
              // height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Color(0xFFB325F8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.asset('assets/images/jobkk11576.png'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data?['positionName'] ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xFFB325F8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset('assets/images/work.png'),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  data['companyname'] ?? '',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xFFB325F8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset('assets/images/icon-map-marker.png'),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  'ไม่ระบุ',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xFFB325F8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset('assets/images/icon-money.png'),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  'ไม่ระบุ',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xFFB325F8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset('assets/images/icon-word.png'),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  'ไม่ระบุ',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ContainerLine(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildListJobExternal() {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            'แหล่งงานภายนอก',
            style: TextStyle(
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          // itemBuilder: (_, __) => _buildItemJob(MockFindJob.data[__]),
          itemBuilder: (_, __) => _buildItemJobExternal(_modelExternal2[__]),
          separatorBuilder: (_, __) => const Divider(
            color: Color(0xFFDDDDDD),
          ),
          itemCount: _modelExternal2.length,
        ),
      ],
    );
  }

  _buildItemJobExternal(dynamic data) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(data?['linkUrl'] ?? ''),
            mode: LaunchMode.externalApplication);
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).custom.w_b_b,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 160.8,
                    height: 95,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFDDDDDD),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      // color: Color(0xFFDDDDDD),
                    ),
                    child: Image.network(
                      data?['imageUrl'] ?? '',
                      height: 80,
                      width: 80,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?['jobpositionName'] ?? '',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).custom.b_w_y,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5),
            //       color: Theme.of(context).custom.b325f8_w_g,
            //     ),
            //     child: Text(
            //       'รายละเอียด',
            //       style: TextStyle(
            //         fontSize: 13,
            //         color: Theme.of(context).custom.w_b_y,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildListJobResume() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      children: [
        Container(
          margin: EdgeInsets.only(left: 15),
          // padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'ค้นหาข้อมูลเรซูเม่',
            style: TextStyle(
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(height: 15),

        SizedBox(
          height: 50,
          child: TextField(
            controller: _searchResumeController,
            style: TextStyle(
              color: const Color(0xff020202),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffFFFFFF),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0XFFDDDDDD), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0XFFDDDDDD), width: 1),
              ),
              hintText: 'พิมพ์คำค้นหา',
              hintStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                // letterSpacing: 0.5,
                // decorationThickness: 6,
                color: Color(0XFF000000),
              ),
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: Colors.black,
            ),
          ),
        ),
        // _buildSearch(
        //   _searchResumeController,
        //   () {},
        // ),
        SizedBox(height: 15),
        _dropdown(
          hintText: "เลือกประเภทงาน",
          data: _modelType.map((item) {
            return DropdownMenuItem(
              value: item['jobCateId'],
              child: Text(
                '${item['nameTh']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).custom.b_W_fffd57,
                ),
              ),
            );
          }).toList(),
          // data: _modelType,
          value: _typeRefNoResume,
          onChanged: (value) {
            // print('-------เลือกประเภทงาน---------${value}');
            setState(() {
              _typeRefNoResume = value;
            });
          },
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _dropdown(
                hintText: "เลือกจังหวัด",
                data: _modelChangwat.map((item) {
                  return DropdownMenuItem(
                    value: item['value'],
                    child: Text(
                      '${item['label']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).custom.b_W_fffd57,
                      ),
                    ),
                  );
                }).toList(),
                // data: _modelType,
                value: _changwatRefNoResume,
                onChanged: (value) {
                  // print('--------เลือกจังหวัด2--------${value}');
                  _changwatRefNoResume = value;
                  _amphoeRefNoResume = 0;
                  _callReadAmphoe(value);
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _dropdown(
                hintText: "เลือกอำเภอ",
                data: _modelAmphoeResume.map((item) {
                  return DropdownMenuItem(
                    value: item['value'],
                    child: Text(
                      '${item['label']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).custom.b_W_fffd57,
                      ),
                    ),
                  );
                }).toList(),
                // data: _modelType,
                value: _amphoeRefNoResume,
                onChanged: (value) {
                  setState(() {
                    // print('--------เลือกอำเภอ2--------${value}');
                    _amphoeRefNoResume = value;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            _handleSearch();
            _searchResumeController.clear();
          },
          child: Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFB325F8),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x40F3D2FF),
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: const Text(
              'ค้นหาเรซูเม่',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
        ContainerLine(),
        SizedBox(height: 15),
        Container(
          child: Text(
            'เรซูเม่ทั้งหมด',
            style: TextStyle(
              color: Theme.of(context).custom.b325f8_w_fffd57,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        _modelResume.length != 0
            ? ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 10),
                // itemBuilder: (_, __) => _buildItemJob(MockFindJob.data[__]),
                itemBuilder: (_, __) => _buildItemJobResume(_modelResume[__]),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemCount: _modelResume.length,
              )
            : Center(child: Text('ไม่พบข้อมูล'))
      ],
    );
  }

  _buildItemJobResume(dynamic data) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => FindJobDetailPage(
        //       model: data,
        //     ),
        //   ),
        // );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '${data?['firstnameTh'] ?? ''}  ${data?['lastnameTh'] ?? ''}',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).custom.b325f8_w_fffd57,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xFFB325F8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset('assets/images/icon-map-marker.png'),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  '${data?['provinceName'] ?? ''}',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xFFB325F8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset('assets/images/calendar_menu.png'),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  '${_convertDate(data?['resumeAnnDate'] ?? '')}',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'ประเภทงานที่สนใจ:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).custom.b_w_y,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0, // ระยะห่างระหว่าง widget ในแนวนอน
            runSpacing: 4.0, // ระยะห่างระหว่างบรรทัด
            children: [...data?['userJobCategories']]
                .map(
                  (e) => Text(
                    '${e?['nameTh'] ?? ''} /',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).custom.b_w_y,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Text(
            'ทักษะ:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).custom.b_w_y,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0, // ระยะห่างระหว่าง widget ในแนวนอน
            runSpacing: 4.0, // ระยะห่างระหว่างบรรทัด
            children: [...data?['userSkills']]
                .map(
                  (e) => Text(
                    '${e?['skill'] ?? ''} /',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).custom.b_w_y,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          ContainerLine(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  _buildSearch(TextEditingController textController, Function onTap) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: textController,
        style: TextStyle(
          color: const Color(0xff020202),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffFFFFFF),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFDDDDDD), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0XFFDDDDDD), width: 1),
          ),
          hintText: 'พิมพ์คำค้นหา',
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            // letterSpacing: 0.5,
            // decorationThickness: 6,
            color: Color(0XFF000000),
          ),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.black,
          suffixIcon: GestureDetector(
            onTap: () {
              onTap();
            },
            child: Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Image.asset('assets/images/filter.png'),
            ),
          ),
        ),
      ),
    );
  }

  _dropdown({
    // required List<dynamic> data,
    required int value,
    required List<DropdownMenuItem<Object>>? data,
    Function(dynamic)? onChanged,
    String hintText = "",
  }) {
    return Container(
      height: 50,
      width: double.infinity,
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
        // icon: Image.asset(
        //   'assets/images/arrow_down.png',
        //   width: 16,
        //   height: 8,
        //   color: Theme.of(context).custom.b325f8_w_fffd57,
        // ),
        hint: Text(
          hintText,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            // letterSpacing: 0.5,
            // decorationThickness: 6,
            color: Color(0XFF000000),
          ),
        ),
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).custom.b_W_fffd57,
        ),
        decoration: _decorationDropdown(context),
        isExpanded: true,
        value: value,
        // dropdownColor: Colors.black,//Theme.of(context).custom.w_b_b,
        // iconDisabledColor: Colors.red,
        onChanged: (dynamic newValue) {
          onChanged!(newValue);
        },
        items: data,
        // items: data.map((item) {
        //   return DropdownMenuItem(
        //     value: item['jobCateId'],
        //     child: Text(
        //       '${item['nameTh']}',
        //       style: TextStyle(
        //         fontSize: 14,
        //         color: Theme.of(context).custom.b_W_fffd57,
        //       ),
        //     ),
        //   );
        // }).toList(),
      ),
    );
  }

  Future<dynamic> _showModelBottonSheetFind(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(24.0)),
              ),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.045),
                      ListTile(
                        leading: Text(''),
                        title: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'กรองตำแหน่งงาน',
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
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 35.0,
                            height: 35.0,
                            margin: EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset('assets/images/back-x.png'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            color: const Color(0xff020202),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffFFFFFF),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0XFFDDDDDD), width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0XFFDDDDDD), width: 1),
                            ),
                            hintText: 'พิมพ์คำค้นหา',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              // letterSpacing: 0.5,
                              // decorationThickness: 6,
                              color: Color(0XFF000000),
                            ),
                            prefixIcon: const Icon(Icons.search),
                            prefixIconColor: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      _dropdown(
                        hintText: "เลือกประเภทงาน",
                        data: _modelType.map((item) {
                          return DropdownMenuItem(
                            value: item['jobCateId'],
                            child: Text(
                              '${item['nameTh']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).custom.b_W_fffd57,
                              ),
                            ),
                          );
                        }).toList(),
                        // data: _modelType,
                        value: _typeRefNo,
                        onChanged: (value) {
                          // print('----------เลือกประเภทงาน3----------${value}');
                          setState(() {
                            _typeRefNo = value;
                          });
                        },
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _dropdown(
                              hintText: "เลือกจังหวัด",
                              data: _modelChangwat.map((item) {
                                return DropdownMenuItem(
                                  value: item['value'],
                                  child: Text(
                                    '${item['label']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).custom.b_W_fffd57,
                                    ),
                                  ),
                                );
                              }).toList(),
                              // data: _modelType,
                              value: _changwatRefNo,
                              onChanged: (value) {
                                setModalState(() {
                                  _changwatRefNo = value;
                                  _amphoeRefNo = 0;
                                  _callReadAmphoe1(value, setModalState);
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _dropdown(
                              hintText: "เลือกอำเภอ",
                              data: _modelAmphoe.map((item) {
                                return DropdownMenuItem(
                                  value: item['value'],
                                  child: Text(
                                    '${item['label']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).custom.b_W_fffd57,
                                    ),
                                  ),
                                );
                              }).toList(),
                              // data: _modelType,
                              value: _amphoeRefNo,
                              onChanged: (value) {
                                // print('------เลือกอำเภอ3-------${value}');
                                setModalState(() {
                                  _amphoeRefNo = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'ลักษณะงาน',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            StatefulBuilder(
                              builder: (context, MysetState) {
                                return _buildCategory(
                                    MysetState, _jobTypeModel, 'nameTh');
                              },
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'ช่วงเงินเดือนที่ต้องการ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            StatefulBuilder(
                              builder: (context, MysetState) {
                                return _buildCategory(
                                    MysetState, _salatyModel, 'salary');
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          _handleSearch();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFB325F8),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0x40F3D2FF),
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'ค้นหาตำแหน่งงาน',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -1), // เลื่อนลงมาจากข้างบน
            end: Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }

  _buildCategory(StateSetter MysetState, List<dynamic> data, String textname) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => GestureDetector(
        onTap: () {
          MysetState(() {
            // print('----cateId------${listCat[__]['cateId']}');
            data[__]['selected'] = !(data[__]['selected']);

            if (data[__]['selected']) {
              _selectedJobType.add(data[__]['jobtId']);
              _selectedSalaty.add(data[__]['salaryId']);
            } else {
              _selectedJobType.remove(data[__]['jobtId']);
              _selectedSalaty.remove(data[__]['salaryId']);
            }
            // print(
            //     '--------_selectedJobType------${_selectedJobType.toString()}');
            // print('-----_selectedSalaty---------${_selectedSalaty.toString()}');
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).custom.b325f8_w_fffd57,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: data[__]['selected']
                          ? Theme.of(context).custom.b325f8_w_fffd57
                          : Theme.of(context).custom.w_b_b),
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${data[__][textname]}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).custom.b_W_fffd57,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

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
          borderSide: const BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0xFFE6B82C)),
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

  ContainerLine() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  _callRead() async {
    Dio dio = new Dio();
    var response = await dio
        .get('https://dcc.onde.go.th/dcc-api/api/Job/GetSearchJob?search=');

    var responseExternal = await dio.get(
        'https://dcc.onde.go.th/dcc-api/api/Job/GetJobSearchExternal?search=');

    var responseResume = await dio
        .get('https://dcc.onde.go.th/dcc-api/api/Resume/resumes?keyword=');
    setState(() {
      _model = response.data['data'];
      _modelExternal = responseExternal.data;
      _modelResume = responseResume.data['data'];
    });

    // print(_model.toString());
  }

  _callReadJobType() async {
    Dio dio = new Dio();
    var response = await dio
        .get('https://dcc.onde.go.th/dcc-api/api/masterdata/jobcategory');

    setState(() {
      _modelType = [
        {
          "jobCateId": 0,
          "nameTh": "เลือกประเภทงาน",
        },
        ...response.data
      ];
    });
  }

  _callReadChangwat() async {
    Dio dio = new Dio();
    var response =
        await dio.get('https://dcc.onde.go.th/dcc-api/api/masterdata/changwat');

    setState(() {
      _modelChangwat = [
        {
          "value": 0,
          "label": "เลือกจังหวัด",
        },
        ...response.data
      ];
    });
  }

  _callReadAmphoe(value) async {
    var accessToken = await ManageStorage.read('accessToken') ?? '';
    Dio dio = new Dio();
    var response = await dio.post(
      'https://dcc.onde.go.th/dcc-api/api/masterdata/amphoe',
      data: {
        "filters": [value]
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    setState(() {
      if (_typeSelected == 0) {
        _modelAmphoe = [
          {
            "value": 0,
            "label": "เลือกอำเภอ",
          },
          ...response.data
        ];
      } else {
        _modelAmphoeResume = [
          {
            "value": 0,
            "label": "เลือกอำเภอ",
          },
          ...response.data
        ];
      }
    });
  }

  _callReadAmphoe1(value, StateSetter setModalState) async {
    var accessToken = await ManageStorage.read('accessToken') ?? '';
    Dio dio = new Dio();
    var response = await dio.post(
      'https://dcc.onde.go.th/dcc-api/api/masterdata/amphoe',
      data: {
        "filters": [value]
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    setModalState(() {
      _modelAmphoe = [
        {
          "value": 0,
          "label": "เลือกอำเภอ",
        },
        ...response.data
      ];
      _amphoeRefNo = 0; // รีเซ็ตค่าอำเภอ
    });
  }

  void _loading() async {
    try {
      _callRead();
      _refreshController.loadComplete();
    } catch (e) {}
  }

  _callReadByCategory(param) async {
    Dio dio = new Dio();

    var response = _typeSelected == 0
        ? await dio.get(
            // 'http://dcc-portal.webview.co/dcc-api/api/Job/GetSearchJob?search=$aa&CatId=$param');
            'http://dcc-portal.webview.co/dcc-api/api/Job/GetSearchJob?CatId=$param')
        : await dio.get(
            'https://dcc.onde.go.th/dcc-api/api/Resume/resumes?keyword=&catId=$param');

    setState(() {
      _model = response.data['data'];
    });

    // print(_model.toString());
  }

  _callReadByJobCategory(index, param) async {
    Dio dio = new Dio();
    if (index == 0) {
      var response = await dio.get(
          'http://dcc-portal.webview.co/dcc-api/api/Job/GetSearchJob?CatId=$param');
      setState(() {
        _model = response.data['data'];
      });
    } else if (index == 1) {
      var response = await dio.get(
          'https://dcc.onde.go.th/dcc-api/api/Job/GetJobSearchExternal?search=$param');
      setState(() {
        _modelExternal = response.data;
      });
    } else if (index == 2) {
      var response = await dio.get(
          'https://dcc.onde.go.th/dcc-api/api/Resume/resumes?keyword=$param');
      setState(() {
        _modelResume = response.data['data'];
      });
    }

    // print(_model.toString());
  }

  _callCategoryRead() async {
    Dio dio = new Dio();
    var response = await dio
        .get('http://dcc-portal.webview.co/dcc-api/api/masterdata/jobcategory');

    setState(() {
      _categoryModel = response.data;
    });

    // print(_model.toString());
  }

  _callCategorySalary() async {
    Dio dio = Dio();
    var response =
        await dio.get('https://dcc.onde.go.th/dcc-api/api/Job/GetJobSalaryMS');

    // print('---------_callCategorySalary------------${response.data}');

    // Check if the response is a Map and contains a 'data' key
    if (response.data is Map<String, dynamic> &&
        response.data['data'] is List) {
      setState(() {
        // Extract the list from 'data'
        _salatyModel = (response.data['data'] as List).map(
          (item) {
            return {
              ...item,
              'selected': false, // Add 'selected' field
            };
          },
        ).toList();
      });
    } else {
      print("Unexpected response structure");
    }
  }

  _callCategorJobTypy() async {
    Dio dio = Dio();
    var response =
        await dio.get('https://dcc.onde.go.th/dcc-api/api/Job/GetJobTypeMS');

    // print('---------_callCategorJobTypy------------${response.data}');

    // Check if the response is a Map and contains a 'data' key
    if (response.data is Map<String, dynamic> &&
        response.data['data'] is List) {
      setState(() {
        // Extract the list from 'data'
        _jobTypeModel = (response.data['data'] as List).map(
          (item) {
            return {
              ...item,
              'selected': false, // Add 'selected' field
            };
          },
        ).toList();
      });
    } else {
      print("Unexpected response structure");
    }
  }

  // print(_model.toString());

  _getJobCate(param) {
    // logWTF(param);
    var title = "";
    if (param.length > 0) {
      param.forEach((e) {
        if (title.isEmpty) {
          title = title + e['nameTh'].toString();
        } else {
          title = title + ' ' + e['nameTh'].toString();
        }
      });
    } else {
      title = '';
    }

    return title;
  }

  _getUserSkill(param) {
    // logWTF(param);
    var title = "";
    if (param.length > 0) {
      param.forEach((e) {
        if (title.isEmpty) {
          title = title + e['skill'].toString();
        } else {
          title = title + ' ' + e['skill'].toString();
        }
      });
    } else {
      title = '';
    }

    return title;
  }

  _convertDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat formatter =
        DateFormat('dd MMM yyyy', 'th_TH'); // กำหนด locale เป็นไทย
    String formattedDate = formatter.format(dateTime);

    // เพิ่มปี พ.ศ. โดยบวก 543 เข้ากับปีคริสต์ศักราช
    int thaiYear = dateTime.year + 543;
    formattedDate =
        formattedDate.replaceAll(RegExp(r'\d{4}'), thaiYear.toString());

    return formattedDate;
    // return DateFormat('dd MMM yyyy', 'th_TH').format(DateTime.parse(date));
  }

  _handleSearch() async {
    Dio dio = new Dio();
    if (_typeSelected == 0 && _typeSelected2 == 0) {
      var response = await dio.get(
          'https://dcc.onde.go.th/dcc-api/api/Job/GetSearchJob?${(_searchController.text ?? "") == "" ? 'search=' : 'search=${_searchController.text}'}${_typeRefNo == 0 ? '' : '&catId=$_typeRefNo'}${_changwatRefNo == 0 ? '' : '&provinceId=$_changwatRefNo'}${_amphoeRefNo == 0 ? '' : '&amphoeId=$_amphoeRefNo'} ${_selectedJobType.isEmpty ? '' : '&_selectedJobType=$_selectedJobType.join(",")'}  ${_selectedSalaty.isEmpty ? '' : '&_selectedSalaty=$_selectedSalaty.join(",")'}');

      setState(() {
        _model = response.data['data'];
      });
    } else if (_typeSelected == 0 && _typeSelected2 == 1) {
      var response = await dio.get(
          'https://dcc.onde.go.th/dcc-api/api/Job/GetSearchJob?${(_searchController.text ?? "") == "" ? 'search=' : 'search=${_searchController.text}'}${_typeRefNo == 0 ? '' : '&catId=$_typeRefNo'}${_changwatRefNo == 0 ? '' : '&provinceId=$_changwatRefNo'}${_amphoeRefNo == 0 ? '' : '&amphoeId=$_amphoeRefNo'} ${_selectedJobType.isEmpty ? '' : '&_selectedJobType=$_selectedJobType.join(",")'}  ${_selectedSalaty.isEmpty ? '' : '&_selectedSalaty=$_selectedSalaty.join(",")'}');

      setState(() {
        _modelExternal = response.data['data'];
      });
    } else if (_typeSelected == 2) {
      var response = await dio.get(
          'https://dcc.onde.go.th/dcc-api/api/Resume/resumes?${(_searchResumeController.text ?? "") == "" ? 'keyword=' : 'keyword=${_searchResumeController.text}'}${_typeRefNoResume == 0 ? '' : '&catId=$_typeRefNoResume'}${_changwatRefNoResume == 0 ? '' : '&provinceId=$_changwatRefNoResume'}${_amphoeRefNoResume == 0 ? '' : '&amphoeId=$_amphoeRefNoResume'}');

      setState(() {
        _modelResume = response.data['data'];
      });
    }
  }
}

class MockFindJob {
  static List<dynamic> category = [
    {
      'code': '0',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'โรงงาน/ผลิต/ควบคุมคุณภาพ',
      'count': '69,030'
    },
    {
      'code': '1',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'การขาย/การตลาด',
      'count': '60,132'
    },
    {
      'code': '2',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'ส่งเอกสาร/ขับรถ/แม่บ้าน/รปภ.',
      'count': '44,435'
    },
    {
      'code': '3',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'บัญชี/การเงิน',
      'count': '34,324'
    },
    {
      'code': '4',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'ช่าง/โฟร์แมน',
      'count': '30,450'
    },
    {
      'code': '5',
      'imageUrl': 'assets/images/find_job_category.png',
      'title': 'ผู้บริหาร/ผู้จัดการ/ผู้อำนวยการ',
      'count': '28,130'
    },
  ];

  static List<dynamic> data = [
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'พนักงานฝ่ายผลิต ',
      'description': '-',
      'category': '0',
      'organize': 'บริษัท  แชมป์กบินทร์  จำกัด',
      'location': ' กบินทร์บุรี ปราจีนบุรี',
      'type': 'งานประจำ',
      'salary': '15,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'พนักงานฝ่ายผลิต',
      'description': 'ทำงานเป็นกะ',
      'category': '0',
      'organize': 'บริษัท จี-เทคคุโตะ (ประเทศไทย) จำกัด',
      'location': 'กทม',
      'type': 'งานประจำ',
      'salary': '12,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'พนักงานขับรถส่งสินค้า',
      'description': '-',
      'category': '0',
      'organize': 'บริษัท อินชา บีฟ จำกัด',
      'location': 'ชลบุรี',
      'type': 'งานประจำ',
      'salary': '450'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'พนักงานฝ่ายผลิต',
      'description': 'ทำงานเป็นกะ',
      'category': '0',
      'organize': 'บริษัท จี-เทคคุโตะ (ประเทศไทย) จำกัด',
      'location': 'อ่างทอง',
      'type': 'งานประจำ',
      'salary': '15,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'คอมพิวเตอร์ กราฟฟิค',
      'description':
          'สามารถใช้โปรแกรม Photoshop ได้ หรืิโปรแกรมเกี่ยวกับ การแต่งภาพ ตัดต่อวิดีโอ ได้ สามารถดูแลซ่อม บำรุง ระบบคอมพิวเตอร์เบื้องต้นได้',
      'category': '0',
      'organize': 'บริษัท ไทยพิพัฒน์ทูล แอนด์ โฮมมาร์ท จำกัด',
      'location': 'เมืองอุดรธานี อุดรธานี',
      'type': 'งานประจำ',
      'salary': '25,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'Sales E -commerce',
      'description': '-',
      'category': '1',
      'organize': 'บ.ทีแม็กซ์ คอร์ปอเรชั่น จำกัด',
      'location': 'เมืองชลบุรี ชลบุรี',
      'type': 'งานประจำ',
      'salary': '14,000'
    },
    {
      'imageUrl': 'assets/images/logo_thai_jobs.png',
      'title': 'QC ไลน์ผลิต',
      'description': 'ประกันสังคม',
      'category': '0',
      'organize': 'บริษัท สานิตแอนด์ซันส์ จำกัด (สาขานครนายก)',
      'location': 'เมืองชลบุรี ชลบุรี',
      'type': 'งานประจำ',
      'salary': '11,500'
    },
  ];
}
