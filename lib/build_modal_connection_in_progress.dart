import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xCCFFFFFF),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        color: Color(0xFF707070),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'เรากำลังทำการเชื่อมต่อระบบอยู่ อดใจรออีกไม่นานเพราะเราให้ความสำคัญกับการเรียนรู้',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0x80000000),
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
                          color: Color(0xFF7A4CB1),
                          borderRadius: BorderRadius.circular(73),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFFFFFFFF),
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
