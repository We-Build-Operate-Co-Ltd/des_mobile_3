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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Color(0xFF292929),
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
            : Color(0xFF292929),
              // borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Color(0xFFDADADA)
            : Color(0xFF292929).withOpacity(1),
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
                          color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7F34EE)
                                : Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7A4CB1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.black
                                    : Color(0xFFFFFD57),
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            'assets/chat.png',
                            height: 26,
                            width: 26,
                            color: Colors.white
                          ),
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
                        color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFFF7A4CB1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
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
            : Colors.black,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7F34EE)
                                : Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7A4CB1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.black
                                    : Color(0xFFFFFD57),
                          )
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
                            color: Color(0xFF7F34EE).withOpacity(0.15),
                            // shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'สวัสดีค่ะ ท่านต้องการความช่วยเหลือ\nด้านไหนสามารถเลือกหัวข้อได้ หรือ\nจะส่งเป็นข้อความก็ได้ค่ะ',
                              style: TextStyle(
                                fontSize: 11,
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
                      child: Container(
                        // height: 70,
                        // width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                                color: Color(0xFF7F34EE),
                                width: 1,
                                style: BorderStyle.solid),
                            color: Colors.white
                            // shape: BoxShape.circle,
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'การจองใช้บริการ',
                            style: TextStyle(
                              fontSize: 11,
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
                      child: Container(
                        // height: 70,
                        // width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                                color: Color(0xFF7F34EE),
                                width: 1,
                                style: BorderStyle.solid),
                            color: Colors.white
                            // shape: BoxShape.circle,
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'การยืนยันตัวตน',
                            style: TextStyle(
                              fontSize: 11,
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
                      child: Container(
                        // height: 70,
                        // width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                                color: Color(0xFF7F34EE),
                                width: 1,
                                style: BorderStyle.solid),
                            color: Colors.white
                            // shape: BoxShape.circle,
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'สมัครสมาชิก',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Flexible(
            flex: 2,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                // height: 20,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 10,
                      child: TextFormField(
                        // obscureText: showTxtPasswordOld,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 15.0,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
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

                    // Text('ความต้องการของท่าน'),
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/send.png',
                        height: 26,
                        width: 26,
                      ),
                    ),
                  ],
                )))
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
}
