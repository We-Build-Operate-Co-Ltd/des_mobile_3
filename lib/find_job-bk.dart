import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'find_job_detail.dart';

class FindJobPage extends StatefulWidget {
  const FindJobPage({super.key});

  @override
  State<FindJobPage> createState() => _FindJobPageState();
}

class _FindJobPageState extends State<FindJobPage> {
  dynamic _model = [];
  dynamic _tempModel;

  dynamic _categoryModel = [];
  int _typeSelected = 0;
  int _cateSelected = 0;

  List<dynamic> catFindJob = [
    'ตำแหน่งงานทั้งหมด',
    'ตำแหน่งงานภายนอก',
    'ค้นหาข้อมูลเรซูเม่',
  ];

  @override
  void initState() {
    _callCategoryRead();
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
      backgroundColor: Theme.of(context).custom.w_b_b,
      appBar: AppBar(
        backgroundColor: Theme.of(context).custom.w_b_b,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/images/back_arrow.png',
                  height: 40,
                  width: 40,
                ),
              ),
              Expanded(
                child: Text(
                  'จับคู่งาน',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).custom.b_w_y,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 25),
          _buildListJobCategory(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
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
                  fontSize: 14,
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
          ),
          SizedBox(height: 15),
          if (_typeSelected != 1) _buildListCategory(),
          if (_typeSelected == 0) _buildListJob(),
          if (_typeSelected == 1) _buildListJobExternal(),
          if (_typeSelected == 2) _buildListJobResume(),
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
            _model = [];
            _callReadByJobCategory(_typeSelected, '');
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: __ == _typeSelected ? Color(0xFF7A4CB1) : Colors.white,
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Text(
              catFindJob[__],
              style: TextStyle(
                color: __ == _typeSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemCount: catFindJob.length,
      ),
    );
  }

  Widget _buildListCategory() {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        // itemBuilder: (_, __) => _buildItemCategory(MockFindJob.category[__]),
        itemBuilder: (_, __) => _buildItemCategory(_categoryModel[__]),
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemCount: _categoryModel.length,
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
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      // itemBuilder: (_, __) => _buildItemJob(MockFindJob.data[__]),
      itemBuilder: (_, __) => _buildItemJob(_model[__]),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: _model.length,
    );
  }

  _buildItemJob(dynamic data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FindJobDetailPage(
              model: data,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).custom.w_b_b,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    'assets/icon.png',
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data?['positionName'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).custom.b325f8_w_fffd57,
                        ),
                      ),
                      Text(
                        data?['companyname'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).custom.b325f8_w_fffd57,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Theme.of(context).custom.b_w_y,
                          ),
                          Text(
                            data?['changwatT'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).custom.b_w_y,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 13,
                            color: Theme.of(context).custom.b_w_y,
                          ),
                          Text(
                            data?['nameTh'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).custom.b_w_y,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        data?['jobHightlight'] ?? '',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).custom.f70f70_w_fffd57,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'ค่าจ้าง ${data?['salaryRange'] ?? ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).custom.b_w_y,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).custom.b325f8_w_g,
                ),
                child: Text(
                  'สมัครงานนี้',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).custom.w_b_y,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListJobExternal() {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      // itemBuilder: (_, __) => _buildItemJob(MockFindJob.data[__]),
      itemBuilder: (_, __) => _buildItemJobExternal(_model[__]),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: _model.length,
    );
  }

  _buildItemJobExternal(dynamic data) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).custom.w_b_b,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    'assets/icon.png',
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data?['jobpositionName'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).custom.b325f8_w_fffd57,
                        ),
                      ),
                      Text(
                        data?['employername'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .custom
                              .b325f8_w_fffd57
                              .withOpacity(0.6),
                        ),
                      ),
                      Text(
                        data?['education'] ?? '',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).custom.f70f70_w_fffd57,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: 100,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).custom.b325f8_w_g,
                        ),
                        child: Text(
                          'รายละเอียด',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).custom.w_b_y,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      // itemBuilder: (_, __) => _buildItemJob(MockFindJob.data[__]),
      itemBuilder: (_, __) => _buildItemJobResume(_model[__]),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: _model.length,
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
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).custom.w_b_b,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    'assets/icon.png',
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${data?['firstnameTh'] ?? ''}  ${data?['lastnameTh'] ?? ''}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).custom.b325f8_w_fffd57,
                        ),
                      ),
                      Text(
                        'ประเภทงานที่สนใจ : ' +
                            _getJobCate(data['userJobCategories']),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).custom.b325f8_w_fffd57,
                        ),
                      ),
                      Text(
                        'ทักษะ : ' + _getUserSkill(data['userSkills']),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).custom.b325f8_w_fffd57,
                        ),
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Theme.of(context).custom.b_w_y,
                          ),
                          Text(
                            data?['provinceName'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).custom.b_w_y,
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   'วันที่ประกาศ : ' +
                      //       _convertDate(data?['resumeAnnDate']),
                      //   style: TextStyle(
                      //     fontSize: 13,
                      //     color: Theme.of(context).custom.b_w_y,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).custom.b325f8_w_g,
                ),
                child: Text(
                  'รายละเอียด',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).custom.w_b_y,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _callRead() async {
    Dio dio = new Dio();
    var response = await dio
        .get('https://dcc.onde.go.th/dcc-api/api/Job/GetSearchJob?search=');

    setState(() {
      _model = response.data['data'];
      _tempModel = response.data['data'];
    });

    // print(_model.toString());
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
        _tempModel = response.data['data'];
      });
    } else if (index == 1) {
      var response = await dio.get(
          'https://dcc.onde.go.th/dcc-api/api/Job/GetJobSearchExternal?search=$param');
      setState(() {
        _model = response.data;
        _tempModel = response.data;
      });
    } else if (index == 2) {
      var response = await dio.get(
          'https://dcc.onde.go.th/dcc-api/api/Resume/resumes?keyword=$param');
      setState(() {
        _model = response.data['data'];
        _tempModel = response.data['data'];
      });
    }

    logWTF(_tempModel);

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
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  }

  _filtter(param) async {
    // logWTF(param);
    // logWTF('=========fsdfsdfsdfdsfsd==========' + _tempModel.toString());
    // var res = await _model;
    var temp =
        // _tempModel.where((item) => item['name'].contains(param)).toList();
        _typeSelected == 0
            ? _tempModel
                .where((dynamic e) => e['companyname']
                    .toString()
                    .toUpperCase()
                    .contains(param.toString().toUpperCase()))
                .toList()
            : _typeSelected == 1
                ? _tempModel
                    .where((dynamic e) => e['employername']
                        .toString()
                        .toUpperCase()
                        .contains(param.toString().toUpperCase()))
                    .toList()
                : _tempModel
                    .where((dynamic e) => e['firstnameTh']
                        .toString()
                        .toUpperCase()
                        .contains(param.toString().toUpperCase()))
                    .toList();

    // logWTF('=========fsdfsdfsdfdsfsd==========' + temp.toString());

    setState(() {
      _model = temp;
    });
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
