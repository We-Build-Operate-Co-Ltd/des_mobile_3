import 'package:des/shared/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:ui' as ui show ImageFilter;

import 'main.dart';

buildModalConnectionInProgress(
  BuildContext context,
) {
  return showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              height: 487,
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Color(0xCCFFFFFF)
            : Color(0xFF292929),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/build_modal_connection_in_progress.png',
                        height: 297,
                        width: 297,
                      ),
                    ),
                    Text(
                      'อยู่ในระหว่างการเชื่อมต่อ',
                      style: TextStyle(
                        fontSize: 20,
                        color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF707070)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'เรากำลังทำการเชื่อมต่อระบบอยู่ อดใจรออีกไม่นาน\nเพราะเราให้ความสำคัญกับการเรียนรู้',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.black.withOpacity(0.50)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white.withOpacity(0.50)
                                    : Color(0xFFFFFD57),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 145,
                        decoration: BoxDecoration(
                          color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Color(0xFF7A4CB1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          borderRadius: BorderRadius.circular(73),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 17,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
