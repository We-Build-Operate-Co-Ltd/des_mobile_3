import 'package:des/chat.dart';
import 'package:des/contact.dart';
import 'package:des/contact_category.dart';
import 'package:flutter/material.dart';

import 'chat_botnoi.dart';
import 'main.dart';
import 'models/mock_data.dart';
import 'shared/theme_data.dart';

class ReportProblemPage extends StatelessWidget {
  const ReportProblemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  MyApp.themeNotifier.value == ThemeModeThird.light
                      ? "assets/images/BG.png"
                      : "",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 130,
                  right: 30,
                  child: Image(
                    image: AssetImage('assets/images/Owl-6 3.png'),
                  ),
                ),
                Positioned(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Colors.white
                                  : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: Column(
                            children: [
                              ListTile(
                                leading: GestureDetector(
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
                                      child: Image.asset(
                                        'assets/images/back_profile.png',
                                        // color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'แจ้งปัญหา',
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
                                trailing: Text(''),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('เบอร์ติดต่อ'),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ContactPage(),
                                        ),
                                      ),
                                      child: Image.asset(
                                          'assets/images/arrow_next.png'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Container(height: 1, color: Color(0xFFEEEEEE)),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('สนทนา'),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChatBotNoiPage(),
                                          // builder: (context) => ChatPage(),
                                        ),
                                      ),
                                      child: Image.asset(
                                          'assets/images/arrow_next.png'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Container(height: 1, color: Color(0xFFEEEEEE)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );

    //     Scaffold(
    //   body: Stack(
    //     children: [
    //       Positioned(
    //         top: 0,
    //         right: 0,
    //         child: Image.asset(
    //           'assets/images/bg_about_us.png',
    //           fit: BoxFit.fitWidth,
    //           width: 290,
    //           alignment: Alignment.topRight,
    //         ),
    //       ),
    //       Positioned.fill(
    //         child: ListView(
    //           padding: const EdgeInsets.symmetric(horizontal: 15),
    //           children: [
    //             SizedBox(
    //               height: MediaQuery.of(context).padding.top + 5,
    //             ),
    //             // Align(
    //             //   alignment: Alignment.centerLeft,
    //             //   child: GestureDetector(
    //             //     onTap: () => Navigator.pop(context),
    //             //     child: Image.asset(
    //             //       'assets/images/back.png',
    //             //       height: 40,
    //             //       width: 40,
    //             //     ),
    //             //   ),
    //             // ),
    //             Image.asset(
    //               'assets/images/report_icon.png',
    //               height: 190,
    //               width: 225.8,
    //             ),
    //             SizedBox(height: 5),
    //             Text(
    //               'แจ้งปัญหา',
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 color: Color(0xFF7A4CB1),
    //                 fontWeight: FontWeight.w500,
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //             Text(
    //               'ท่านมีความสงสัยการใช้งานศูนย์ฯ\nหรือพบปัญหาจากการใช้สามารถแจ้งให้เราทราบได้เลย\nเราพร้อมช่วยเหลือท่านเสมอ',
    //               style: TextStyle(
    //                 color: Colors.black.withOpacity(0.5),
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //             SizedBox(height: 25),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 GestureDetector(
    //                   // onTap: () => Navigator.push(
    //                   //   context,
    //                   //   MaterialPageRoute(
    //                   //     builder: (_) => ChatPage(),
    //                   //   ),
    //                   // ),
    //                   onTap: () => Navigator.of(context).push(
    //                     MaterialPageRoute(
    //                       builder: (context) => ChatBotNoiPage(),
    //                       // builder: (context) => ChatPage(),
    //                     ),
    //                   ),
    //                   child: Column(
    //                     children: [
    //                       Container(
    //                         height: 45,
    //                         width: 45,
    //                         alignment: Alignment.center,
    //                         decoration: BoxDecoration(
    //                           color: Color(0xFF7A4CB1),
    //                           borderRadius: BorderRadius.circular(22.5),
    //                         ),
    //                         child: Image.asset(
    //                           'assets/images/chat.png',
    //                           width: 22.41,
    //                           height: 22.41,
    //                         ),
    //                       ),
    //                       const SizedBox(height: 10),
    //                       Text(
    //                         'แชท',
    //                         style: TextStyle(
    //                           fontSize: 15,
    //                           fontWeight: FontWeight.w400,
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 ),

    //                 const SizedBox(width: 36),
    //                 GestureDetector(
    //                   onTap: () => Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (_) => ContactCategoryPage(),
    //                     ),
    //                   ),
    //                   child: Column(
    //                     children: [
    //                       Container(
    //                         height: 45,
    //                         width: 45,
    //                         alignment: Alignment.center,
    //                         decoration: BoxDecoration(
    //                           color: Color(0xFF7A4CB1),
    //                           borderRadius: BorderRadius.circular(22.5),
    //                         ),
    //                         child: Image.asset(
    //                           'assets/images/phone.png',
    //                           width: 25.5,
    //                           height: 25.5,
    //                         ),
    //                       ),
    //                       const SizedBox(height: 10),
    //                       Text(
    //                         'เบอร์ติดต่อ',
    //                         style: TextStyle(
    //                           fontSize: 15,
    //                           fontWeight: FontWeight.w400,
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(height: 25),
    //             Container(
    //               height: 45,
    //               width: 300,
    //               decoration: BoxDecoration(
    //                 border: Border.all(
    //                   width: 1,
    //                   color: Color(0x807A4CB1),
    //                 ),
    //                 borderRadius: BorderRadius.circular(22.5),
    //               ),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Image.asset(
    //                     'assets/images/plus_circle.png',
    //                     height: 15.43,
    //                     width: 15.43,
    //                   ),
    //                   const SizedBox(width: 10.23),
    //                   Text(
    //                     'แจ้งปัญหาการใช้งาน',
    //                     style: TextStyle(
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.w500,
    //                       color: Color(0xFF7A4CB1),
    //                     ),
    //                     textAlign: TextAlign.center,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             SizedBox(height: 25),
    //             Align(
    //               alignment: Alignment.centerLeft,
    //               child: Text(
    //                 'หัวข้อปัญหาที่พบบ่อย',
    //                 style: TextStyle(
    //                   fontSize: 15,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: 5),
    //             Column(
    //               children: mockFAQ
    //                   .map<Widget>(
    //                     (dynamic e) => Container(
    //                       height: 45,
    //                       width: double.infinity,
    //                       alignment: Alignment.centerLeft,
    //                       padding: EdgeInsets.symmetric(horizontal: 15),
    //                       decoration: BoxDecoration(
    //                         border: Border.symmetric(
    //                           horizontal: BorderSide(
    //                             width: 1,
    //                             color: Color(0xFFF7F7F7),
    //                           ),
    //                         ),
    //                       ),
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text(
    //                             e['title'],
    //                             style: TextStyle(
    //                               fontSize: 13,
    //                               fontWeight: FontWeight.w400,
    //                             ),
    //                           ),
    //                           Icon(
    //                             Icons.arrow_forward_ios_rounded,
    //                             size: 12,
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   )
    //                   .toList(),
    //             )
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
