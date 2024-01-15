import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'shared/config.dart';
import 'course_detail.dart';
import 'main.dart';

class MyClassAllPage extends StatefulWidget {
  MyClassAllPage({Key? key, this.title}) : super(key: key);

  final title;

  @override
  _MyClassAllPageState createState() => _MyClassAllPageState();
}

class _MyClassAllPageState extends State<MyClassAllPage> {
  Dio dio = Dio();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<dynamic> _typeList = [
    'คลาสทั้งหมด',
    'คลาสกำลังเรียน',
    'คลาสกำลังเรียนเสร็จแล้ว',
    'คลาสที่ชอบ',
  ];
  List<dynamic> _categoryList = [];

  int _categorySelected = 0;
  int _typeSelected = 0;
  dynamic _model;
  dynamic _tempModel;

  // String _api_key = '19f072f9e4b14a19f72229719d2016d1';
  // String _api_key = '29f5637fe877ab6d8797a8bcde3d67a7';
  // String endpoint_base_url = 'https://e2e.myappclass.bangalore2.com/api/api/';

  @override
  void initState() {
    _get_category();
    // _get_course();
    // _get_course();

    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _filtter(param) async {
    // logWTF('=========fsdfsdfsdfdsfsd==========' + _tempModel.toString());
    // var res = await _model;
    var temp =
        // _tempModel.where((item) => item['name'].contains(param)).toList();

        _tempModel
            .where((dynamic e) => e['course_name']
                .toString()
                .toUpperCase()
                .contains(param.toString().toUpperCase()))
            .toList();

    // logWTF('=========fsdfsdfsdfdsfsd==========' + temp.toString());

    setState(() {
      _model = Future.value(temp);
    });
  }

  _callRead() async {
    // var response =
    //     await Dio().get('${endpoint_base_url}get_course/${_api_key}');

    var response = await Dio().get('$serverLMS/get_course/$apiKeyLMS');

    setState(() {
      _model = Future.value(response.data['data']
          .where((dynamic e) => e['is_active'].toString() == 'yes')
          .toList());
      _tempModel = response.data['data'];
    });
  }

  _get_category() async {
    var response =
        await dio.get('${serverLMS}/get_coursecategory/${apiKeyLMS}');
    setState(() {
      _categoryList.addAll(response.data['data']);
    });
  }

  _get_course() async {
    try {
      if (_categorySelected == 0) {
        // return Dio().get('${endpoint_base_url}get_course/${_api_key}');
        logWTF('${serverLMS}get_course/${apiKeyLMS}');
        var response = await Dio().get('${serverLMS}get_course/${apiKeyLMS}');

        // print('----!!!!-----------------------------' +
        //     response.data['data'].toString());

        setState(() {
          _model = Future.value(response.data['data']);
        });
      } else {
        var temp =
            // _tempModel.where((item) => item['name'].contains(param)).toList();

            _tempModel
                .where((dynamic e) =>
                    e['course_cat_id'].toString() ==
                    _categorySelected.toString())
                .toList();

        // logWTF('=========fsdfsdfsdfdsfsd==========' + temp.toString());

        setState(() {
          _model = Future.value(temp);
        });
        // FormData formData = new FormData.fromMap({
        //   "apikey": apiKeyLMS,
        //   "cat_id": _categoryList[_categorySelected]['id']
        // });
        // var response = await dio.post(
        //   '${serverLMS}/popular_course',
        //   data: formData,
        //   options: Options(
        //     validateStatus: (_) => true,
        //     contentType: Headers.formUrlEncodedContentType,
        //     responseType: ResponseType.json,
        //     headers: {
        //       'Content-type': 'application/x-www-form-urlencoded',
        //     },
        //   ),
        // );

        // if (response.data['status'] == false) {
        //   setState(() {
        //     _model = Future.value([]);
        //   });
        // } else {
        //   setState(() {
        //     _model = Future.value(response.data['data']);
        //   });
        // }
      }
    } catch (e) {
      return {
        'status': false,
        'data': [],
      };
    }

    // try {
    // } catch (e) {
    //   Fluttertoast.showToast(msg: e.toString());
    // }
  }

  _loading() async {
    Response<dynamic> response =
        await dio.post('$server/de-api/m/eventcalendar/read', data: {});

    if (response.statusCode == 200) {
      if (response.data['status'] == 'S') {
        List<dynamic> data = response.data['objectData'];
        List<dynamic> lerning = [];
        List<dynamic> lerned = [];
        for (int i = 0; i < data.length; i++) {
          if (i % 2 == 0) {
            lerned.add(data[i]);
          } else {
            lerning.add(data[i]);
          }
        }
        setState(() {});
      }
    }

    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 10) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _buildHead(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: 360,
                child: TextField(
                  onChanged: (text) {
                    print("First text field: $text");
                    setState(() {
                      _filtter(text);
                    });
                  },
                  style: TextStyle(
                    color: const Color(0xff020202),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xfff1f1f1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "ค้นหาคอร์สเรียน",
                    hintStyle: TextStyle(
                        color: const Color(0xffb2b2b2),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        decorationThickness: 6),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 35,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, __) => GestureDetector(
                    onTap: () => setState(() => _typeSelected = __),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: __ == _typeSelected
                            ? Color(0xFF7A4CB1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(17.5),
                      ),
                      child: Text(
                        _typeList[__],
                        style: TextStyle(
                          color:
                              __ == _typeSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 5),
                  itemCount: _typeList.length,
                ),
              ),
              SizedBox(height: 10),
              if (_categoryList.length == 0)
                Container(
                  height: 35,
                  child: CircularProgressIndicator(),
                ),
              Container(
                height: 35,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, __) => GestureDetector(
                    onTap: () => setState(() {
                      _categorySelected = __;
                      _get_course();
                    }),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: __ == _categorySelected
                            ? Color(0xFF7A4CB1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(17.5),
                      ),
                      child: Text(
                        _categoryList[__]?['display_name'] != ''
                            ? _categoryList[__]['display_name']
                            : 'ทั้งหมด',
                        style: TextStyle(
                          color: __ == _categorySelected
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 5),
                  itemCount: _categoryList.length,
                ),
              ),
              SizedBox(height: 15),
              FutureBuilder<dynamic>(
                future: _model,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: _list(snapshot.data),
                    );
                  } else {
                    return _listLoading();
                  }
                },
              )
              // FutureBuilder<dynamic>(
              //   future: _model,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       // if (!snapshot.data['status']) {
              //       //   return Text(
              //       //     'ไม่พบข้อมูล',
              //       //     style: TextStyle(
              //       //       color: Theme.of(context).custom.b_W_fffd57,
              //       //     ),
              //       //   );
              //       // }

              //       return Expanded(
              //         child: _list(snapshot.data),
              //       );
              //     } else {
              //       return _listLoading();
              //     }
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

  _list(dynamic param) {
    var data = param;
    return ListView.separated(
      itemBuilder: (_, __) => _buildContant(data[__]),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: data.length,
    );
  }

  _listLoading() {
    return Expanded(
      child: ListView(
        children: [1, 1, 1, 1, 1, 1, 1, 1, 1]
            .map((e) => Container(
                  height: 95,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 95,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(width: 9),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildContant(dynamic param) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailPage(
              model: param,
            ),
          ),
        );
      },
      child: Container(
        height: 95,
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: '${param['cover_image_url']}',
                fit: BoxFit.cover,
                height: 95,
                width: 160,
                errorWidget: (context, url, error) => Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).custom.A4CB1_w_fffd57,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ),
            SizedBox(width: 9),
            Expanded(
              child: Container(
                child: Text(
                  '${param['course_name']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 15,
        right: 15,
      ),
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
              SizedBox(width: 34),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
