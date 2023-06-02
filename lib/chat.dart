import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();
  final ScrollController _controller = ScrollController();

  String _imageUrl = '';
  List<dynamic> _listChat = [
    // {'code': '1', 'title': 'ปกติ', 'type': 'user'},
    // {'code': '2', 'title': 'ขาวดำ', 'type': 'chatBot'},
    // {'code': '3', 'title': 'ดำเหลือง', 'type': 'user'},
  ];

  List<dynamic> _listRate = [
    {'title': 'ดีมาก', 'titleEn': 'Excellent', 'point': '5', 'value': false},
    {'title': 'ดี', 'titleEn': 'Good', 'point': '4', 'value': false},
    {'title': 'พอใช้', 'titleEn': 'Average', 'point': '3', 'value': false},
    {'title': 'แย่', 'titleEn': 'Poor', 'point': '2', 'value': false},
    {'title': 'แย่มาก', 'titleEn': 'Very Poor', 'point': '1', 'value': false},
  ];

  bool _isSendRate = false;
  bool _isShowRate = false;
  bool _isCheck = false;
  int _countChat = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var im = await ManageStorage.read('profileImageUrl') ?? '';

      setState(() {
        _imageUrl = im;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: _header()),
      ),
    );
  }

  _header() {
    return Container(
      color: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Color(0xFFfef7ff)
          : Colors.black,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.white
                  : Colors.black,
              // borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFDADADA)
                      : Colors.black,
                  blurRadius: 6,
                  offset: Offset(4, 4), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Color(0xFF7F34EE)
                                  : Color(0xFF7D7D7D),
                          shape: BoxShape.circle,
                          // border: Border.all(
                          //   width: 1,
                          //   style: BorderStyle.solid,
                          //   color: MyApp.themeNotifier.value ==
                          //           ThemeModeThird.light
                          //       ? Color(0xFF7A4CB1)
                          //       : MyApp.themeNotifier.value ==
                          //               ThemeModeThird.dark
                          //           ? Colors.black
                          //           : Color(0xFFFFFD57),
                          // )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset('assets/chat.png',
                              height: 26, width: 26, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'แชทบอท',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.black
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                            ),
                          ),
                          // Expanded(child: SizedBox(),),
                          Text(
                            'ออนไลน์',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.black
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 35,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      )),
                ],
              ),
            ),
          ),
          // SizedBox(height: 10),
          Expanded(child: _body())
        ],
      ),
    );
  }

  _body() {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 10,
          child: Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFFFEF7FF)
                : Color(0xFF2F2F2F),
            child: ListView(
              controller: _controller,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Color(0xFF7F34EE)
                                  : Color(0xFF7D7D7D),
                          shape: BoxShape.circle,
                          // border: Border.all(
                          //   width: 1,
                          //   style: BorderStyle.solid,
                          //   color: MyApp.themeNotifier.value ==
                          //           ThemeModeThird.light
                          //       ? Color(0xFF7A4CB1)
                          //       : MyApp.themeNotifier.value ==
                          //               ThemeModeThird.dark
                          //           ? Colors.black
                          //           : Color(0xFFFFFD57),
                          // )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            'assets/chat.png',
                            height: 26,
                            width: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          // height: 70,
                          // width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(10),
                            ),
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7F34EE).withOpacity(0.15)
                                : Color(0xFF7D7D7D),
                            // shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'สวัสดีค่ะ ท่านต้องการความช่วยเหลือ\nด้านไหนสามารถเลือกหัวข้อได้ หรือ\nจะส่งเป็นข้อความก็ได้ค่ะ',
                              style: TextStyle(
                                fontSize: 11,
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Colors.black
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _radomChat("การจองบริการ");
                        });

                        _controller
                            .jumpTo(_controller.position.maxScrollExtent + 200);
                      },
                      child: Container(
                        // height: 70,
                        // width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7F34EE)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                                width: 1,
                                style: BorderStyle.solid),
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : Colors.black
                            // shape: BoxShape.circle,
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'การจองใช้บริการ',
                            style: TextStyle(
                              fontSize: 11,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.black
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _radomChat("การยืนยันตัวตน");
                        });

                        _controller
                            .jumpTo(_controller.position.maxScrollExtent + 200);
                      },
                      child: Container(
                        // height: 70,
                        // width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7F34EE)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                                width: 1,
                                style: BorderStyle.solid),
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : Colors.black
                            // shape: BoxShape.circle,
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'การยืนยันตัวตน',
                            style: TextStyle(
                              fontSize: 11,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.black
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _radomChat("สมัครสมาชิก");
                        });

                        _controller
                            .jumpTo(_controller.position.maxScrollExtent + 200);
                      },
                      child: Container(
                        // height: 70,
                        // width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                                color: MyApp.themeNotifier.value ==
                                        ThemeModeThird.light
                                    ? Color(0xFF7F34EE)
                                    : MyApp.themeNotifier.value ==
                                            ThemeModeThird.dark
                                        ? Colors.white
                                        : Color(0xFFFFFD57),
                                width: 1,
                                style: BorderStyle.solid),
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : Colors.black
                            // shape: BoxShape.circle,
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'สมัครสมาชิก',
                            style: TextStyle(
                              fontSize: 11,
                              color: MyApp.themeNotifier.value ==
                                      ThemeModeThird.light
                                  ? Colors.black
                                  : MyApp.themeNotifier.value ==
                                          ThemeModeThird.dark
                                      ? Colors.white
                                      : Color(0xFFFFFD57),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Wrap(
                      children: _listChat
                          .map(
                            (item) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: item['type'] == "chatBot"
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: MyApp.themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? Color(0xFF7F34EE)
                                                : Color(0xFF7D7D7D),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Image.asset(
                                              'assets/chat.png',
                                              height: 26,
                                              width: 26,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          // height: 70,
                                          // width: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            color: MyApp.themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? Color(0xFF7F34EE)
                                                    .withOpacity(0.15)
                                                : Color(0xFF7D7D7D),
                                            // shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              item['title'],
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: MyApp.themeNotifier
                                                            .value ==
                                                        ThemeModeThird.light
                                                    ? Colors.black
                                                    : MyApp.themeNotifier
                                                                .value ==
                                                            ThemeModeThird.dark
                                                        ? Colors.white
                                                        : Color(0xFFFFFD57),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            // height: 70,
                                            // width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                              color: MyApp.themeNotifier.value ==
                                                    ThemeModeThird.light
                                                ? Color(0xFF7F34EE)
                                                    .withOpacity(0.15)
                                                : Color(0xFF7D7D7D),
                                              // shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(
                                                item['title'],
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: MyApp.themeNotifier
                                                            .value ==
                                                        ThemeModeThird.light
                                                    ? Colors.black
                                                    : MyApp.themeNotifier
                                                                .value ==
                                                            ThemeModeThird.dark
                                                        ? Colors.white
                                                        : Color(0xFFFFFD57),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              imageUrl: _imageUrl,
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          )
                          .toList()),
                ),
                _isShowRate == true
                    ? Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF7F34EE),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          color: Colors.white,
                        ),
                        child: _isSendRate == true
                            ? Container(
                                height: 300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                      size: 100,
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          'ขอบคุณสำหรับคะแนนความพึงพอใจ',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Thank you for the satisfaction rate.',
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          'กรุณาให้คะแนนความพึงพอใจ',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Please Rate Satisfaction',
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    for (int i = 0; i < _listRate.length; i++)
                                      checkBoxSingle(_listRate, i),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: MaterialButton(
                                        minWidth: 35,
                                        onPressed: () {
                                          setState(() {
                                            var chkValue = _listRate
                                                .where(
                                                    (i) => i["value"] == true)
                                                .first['title'];
                                            if (chkValue != "") {
                                              _isSendRate = true;
                                            }
                                          });
                                        },
                                        color: Color(0xFF7F34EE),
                                        textColor: Colors.white,
                                        child: Text(
                                          'Send',
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // height: 20,
            width: MediaQuery.of(context).size.width,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Colors.white
                : Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 10,
                  child: TextFormField(
                    // obscureText: showTxtPasswordOld,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.black
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                    cursorColor:
                        MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF707070)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      hintStyle: TextStyle(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF707070)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      hintText: 'ความต้องการของท่าน',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      errorStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                        fontSize: 10.0,
                      ),
                    ),
                    // validator: (model) {
                    //   if (model.isEmpty) {
                    //     return 'กรุณากรอกรหัสผ่านปัจจุบัน.';
                    //   }
                    // },
                    controller: chatController,
                    enabled: true,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _radomChat(chatController.text);
                    });
                    chatController.text = "";
                  },
                  // Text('ความต้องการของท่าน'),
                  child: Flexible(
                    flex: 1,
                    child: Image.asset(
                      'assets/send.png',
                      height: 26,
                      width: 26,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF707070)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    )

        // Container(
        //   height: MediaQuery.of(context).size.longestSide,
        //   width: MediaQuery.of(context).size.longestSide,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage(
        //         'assets/report_mock.png',
        //       ),
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        //   // child: SizedBox(),
        //   // ),
        //   // Expanded(child: SizedBox())
        //   // ],
        // ),

        );
  }

  _radomChat(String title) {
    _countChat++;
    var list = [
      'ตังค์ไม่มี แต่หนี้ยืนหนึ่ง',
      'เห็นแดดแล้วอุ่นใจ ตกนรกไปก็ไม่ตื่นเต้น',
      'ไม่มีลิมิต ชีวิตนอนน้อย',
      'จีบตัวเองได้มั้ย คนบ้าอะไรน่ารักชะมัด',
      'ชีวิตยังต้องสู้ เพราะเรากู้หลายทาง'
    ];
    final _random = new Random();
    var element = list[_random.nextInt(list.length)];
    var listTemp = [
      {'title': '', 'type': ''},
      {'title': '', 'type': ''},
    ];
    listTemp[0]['title'] = title;
    listTemp[0]['type'] = 'user';
    listTemp[1]['title'] = element;
    listTemp[1]['type'] = 'chatBot';

    if (title != "") {
      _listChat.add(listTemp[0]);
      _listChat.add(listTemp[1]);
    }

    if (_countChat == 3) {
      listTemp = [
        {'title': '', 'type': ''},
      ];
      _isShowRate = true;
      listTemp[0]['title'] = "กรุณาให้คะแนนความพึงพอใจ";
      listTemp[0]['type'] = 'chatBot';
      _listChat.add(listTemp[0]);
      _countChat = 0;
    }
    // var _timer = Timer(Duration(seconds: 5), () => print('done'));
  }

  checkBoxSingle(dynamic model, int i) {
    return Container(
      margin: EdgeInsets.symmetric(
        // vertical: 5.0,
        horizontal: 50.0,
      ),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              child: Text(
                '${model[i]['title']}',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(width: 30),
            Container(
              child: Text(
                '${model[i]['titleEn']}',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        value: model[i]['value'],
        onChanged: (value) {
          setState(() {
            _selectedIndex = i;
            for (int j = 0; j < model.length; j++) {
              if (j == _selectedIndex) {
                model[j]['value'] = !model[j]['value'];
              } else {
                model[j]['value'] = false;
              }
            }
          });
        },
        activeColor: Color(0xFF7F34EE),
        checkColor: Colors.white,
      ),
    );
  }
}
