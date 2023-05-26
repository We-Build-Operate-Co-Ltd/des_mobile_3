import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'menu.dart';

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
          .post('http://122.155.223.63/td-des-api/m/policy/read', data: {
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
      backgroundColor: Colors.white,
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
                alignment: Alignment.topCenter,
                image: AssetImage('assets/images/background_policy.png'),
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
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 50,
              left: 40,
              right: 40,
            ),
            color: Colors.transparent,
            child: Text(
              ' Khuru On Mobile',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Kanit',
                color: Colors.white,
              ),
            ),
          ),
        ),
        lastPage ? _buildListCard(model) : _buildCard(model[currentCardIndex])
      ],
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
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
                                  color: Color(0xFFEEBA33),
                                ),
                                child: Text(
                                  (index + 1).toString() +
                                      '/' +
                                      policyLength.toString(),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Kanit',
                                    color: Colors.white,
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
                                child: Html(
                                  data: model[index]['description'],
                                  onLinkTap: (String? url,
                                      RenderContext context,
                                      Map<String, String> attributes,
                                      element) {
                                    launch(url!);
                                    //open URL in webview, or launch URL in browser, or any other logic here
                                  },
                                ),

                                // HtmlView(
                                //   data: model[index]['description'],
                                //   scrollable:
                                //       false, //false to use MarksownBody and true to use Marksown
                                // ),
                              ),
                            ),
                          ),
                        ),
                        _buildButton(
                          acceptPolicyList[index]['isActive']
                              ? 'ยอมรับ'
                              : 'ไม่ยอมรับ',
                          acceptPolicyList[index]['isActive']
                              ? Color(0xFF9A1120)
                              : Color(0xFF707070),
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
            Color(0xFF9A1120),
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
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
                    color: Color(0xFFEEBA33),
                  ),
                  child: Text(
                    (currentCardIndex + 1).toString() +
                        '/' +
                        policyLength.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Kanit',
                      color: Colors.white,
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
                  child: Html(
                    data: model['description'],
                    onLinkTap: (String? url, RenderContext context,
                        Map<String, String> attributes, element) {
                      launch(url!);
                      //open URL in webview, or launch URL in browser, or any other logic here
                    },
                  ),

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
            Color(0xFF9A1120),
            onTap: () {
              nextIndex(model, true);
            },
          ),
          SizedBox(height: 15),
          _buildButton(
            'ไม่ยอมรับ',
            Color(0xFF707070),
            onTap: () {
              nextIndex(model, false);
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildButton(String title, Color color,
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
        ),
        child: Row(
          children: [
            SizedBox(width: 40),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Kanit',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: corrected
                  ? Image.asset(
                      'assets/images/correct.png',
                      height: 15,
                      width: 15,
                    )
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
            child: Container(
              width: 220,
              height: 155,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'เรียบร้อย',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Kanit',
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
                    SizedBox(height: 15),
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
                          color: Color(0xFF9A1120),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'ตกลง',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Kanit',
                                  color: Colors.white,
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
        dio.post('http://122.155.223.63/td-des-api/m/policy/create', data: e);
      });
    } catch (e) {}
    return dialogConfirm();
  }
}
