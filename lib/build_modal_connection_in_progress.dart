import 'package:des/shared/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:ui' as ui show ImageFilter;

import 'main.dart';

buildModalConnectionInProgress(
  BuildContext context,
) {
  return 
  
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Dialog(
            backgroundColor: Theme.of(context).custom.w_292929,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
                width: 220,
               height: 155,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(
                  //   color: Theme.of(context).custom.w_w_fffd57,
                  // ),
                  color: Theme.of(context).custom.w_292929,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).custom.g05_w01_w01,
                      spreadRadius: 0,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                //   color: Colors.white,
                //   border: Border.all(
                //     color: Theme.of(context).custom.w_w_fffd57,
                //   )
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(height: 10),
                    Text(
                      'บันทึกเรียบร้อยแล้ว',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        color: Theme.of(context).custom.b_W_fffd57,
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
                    // SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Menu(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 35,
                        width: 160,
                        alignment: Alignment.center,
                        // margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).custom.b325f8_w_fffd57,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'ตกลง',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Kanit',
                                  color: Theme.of(context).custom.w_b_b,
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
        );
      },
    );

  // showCupertinoModalBottomSheet(
  //     expand: false,
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return Material(
  //         type: MaterialType.transparency,
  //         child: BackdropFilter(
  //           filter: ui.ImageFilter.blur(
  //             sigmaX: 5.0,
  //             sigmaY: 5.0,
  //           ),
  //           child: Container(
  //             height: 487,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).custom.w_292929,
  //               borderRadius: BorderRadius.vertical(
  //                 top: Radius.circular(10),
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 15),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     child: Image.asset(
  //                       MyApp.themeNotifier.value == ThemeModeThird.light
  //                                         ? 'assets/images/build_modal_connection_in_progress.png'
  //                                         : 'assets/images/build_modal_connection_in_progress_dark.png',
                        
  //                       height: 297,
  //                       width: 297,
  //                     ),
  //                   ),
  //                   Text(
  //                     'อยู่ในระหว่างการเชื่อมต่อ',
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       color: MyApp.themeNotifier.value ==
  //                                   ThemeModeThird.light
  //                               ? Color(0xFF707070)
  //                               : MyApp.themeNotifier.value ==
  //                                       ThemeModeThird.dark
  //                                   ? Colors.white
  //                                   : Color(0xFFFFFD57),
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   Text(
  //                     'เรากำลังทำการเชื่อมต่อระบบอยู่ อดใจรออีกไม่นาน\nเพราะเราให้ความสำคัญกับการเรียนรู้',
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       color: MyApp.themeNotifier.value ==
  //                                   ThemeModeThird.light
  //                               ? Colors.black.withOpacity(0.50)
  //                               : MyApp.themeNotifier.value ==
  //                                       ThemeModeThird.dark
  //                                   ? Colors.white.withOpacity(0.50)
  //                                   : Color(0xFFFFFD57),
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                   SizedBox(height: 20),
  //                   InkWell(
  //                     onTap: () => Navigator.pop(context),
  //                     child: Container(
  //                       alignment: Alignment.center,
  //                       height: 40,
  //                       width: 145,
  //                       decoration: BoxDecoration(
  //                         color: MyApp.themeNotifier.value ==
  //                                   ThemeModeThird.light
  //                               ? Color(0xFF7A4CB1)
  //                               : MyApp.themeNotifier.value ==
  //                                       ThemeModeThird.dark
  //                                   ? Colors.white
  //                                   : Color(0xFFFFFD57),
  //                         borderRadius: BorderRadius.circular(73),
  //                       ),
  //                       child: Text(
  //                         'ตกลง',
  //                         style: TextStyle(
  //                           fontSize: 17,
  //                           color: MyApp.themeNotifier.value ==
  //                                   ThemeModeThird.light
  //                               ? Colors.white
  //                               : Colors.black,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     });

}
