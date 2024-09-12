import 'package:des/chat.dart';
import 'package:des/contact.dart';
import 'package:des/contact_category.dart';
import 'package:flutter/material.dart';

import 'chat_botnoi.dart';
import 'main.dart';
import 'models/mock_data.dart';
import 'shared/theme_data.dart';

class ReportProblemPage extends StatefulWidget {
  ReportProblemPage({super.key, this.changePage});
  Function? changePage;

  @override
  _ReportProblemPageState createState() => _ReportProblemPageState();
  getState() => _ReportProblemPageState;
}

class _ReportProblemPageState extends State<ReportProblemPage> {
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
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Colors.white
                            : Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: Column(
                          children: [
                            ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  widget.changePage!(0);
                                  // Navigator.pop(context);
                                },
                                child: Container(
                                  width: 35.0,
                                  height: 35.0,
                                  margin: EdgeInsets.all(5),
                                  child: Image.asset(
                                    'assets/images/back_profile.png',
                                    // color: Colors.white,
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
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
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
                                  Container(
                                      height: 1, color: Color(0xFFEEEEEE)),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('สนทนา'),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).push(
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
                                  Container(
                                      height: 1, color: Color(0xFFEEEEEE)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
// class ReportProblemPage extends StatelessWidget {
//   ReportProblemPage({super.key, this.changePage});
//   Function? changePage;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.transparent,
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                   MyApp.themeNotifier.value == ThemeModeThird.light
//                       ? "assets/images/BG.png"
//                       : "",
//                 ),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 130,
//                   right: 30,
//                   child: Image(
//                     image: AssetImage('assets/images/Owl-6 3.png'),
//                   ),
//                 ),
//                 Positioned(
//                   child: Container(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       padding: EdgeInsets.all(20.0),
//                       decoration: BoxDecoration(
//                         color: MyApp.themeNotifier.value == ThemeModeThird.light
//                             ? Colors.white
//                             : Colors.black,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20)),
//                       ),
//                       child: SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.55,
//                         child: Column(
//                           children: [
//                             ListTile(
//                               leading: GestureDetector(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Container(
//                                   width: 35.0,
//                                   height: 35.0,
//                                   margin: EdgeInsets.all(5),
//                                   child: InkWell(
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Image.asset(
//                                       'assets/images/back_profile.png',
//                                       // color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               title: Align(
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   'แจ้งปัญหา',
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.w500,
//                                     color: MyApp.themeNotifier.value ==
//                                             ThemeModeThird.light
//                                         ? Color(0xFFB325F8)
//                                         : MyApp.themeNotifier.value ==
//                                                 ThemeModeThird.dark
//                                             ? Colors.white
//                                             : Color(0xFFFFFD57),
//                                   ),
//                                 ),
//                               ),
//                               trailing: Text(''),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text('เบอร์ติดต่อ'),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: GestureDetector(
//                                     onTap: () => Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => ContactPage(),
//                                       ),
//                                     ),
//                                     child: Image.asset(
//                                         'assets/images/arrow_next.png'),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 12),
//                             Container(height: 1, color: Color(0xFFEEEEEE)),
//                             SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text('สนทนา'),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: GestureDetector(
//                                     onTap: () => Navigator.of(context).push(
//                                       MaterialPageRoute(
//                                         builder: (context) => ChatBotNoiPage(),
//                                         // builder: (context) => ChatPage(),
//                                       ),
//                                     ),
//                                     child: Image.asset(
//                                         'assets/images/arrow_next.png'),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 12),
//                             Container(height: 1, color: Color(0xFFEEEEEE)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }
