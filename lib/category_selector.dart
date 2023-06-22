import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class CategorySelector extends StatefulWidget {
  CategorySelector({
    Key? key,
    required this.onChange,
  }) : super(key: key);
  final Function(String, String) onChange;

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String selectedIndex = '';
  String selectedTitleIndex = '';
  Dio dio = Dio();

  @override
  void initState() {
    _readGroupByCategory();
    super.initState();
  }

  Future<dynamic> _readGroupByCategory() async {
    Response<dynamic> response;
    try {
      response = await dio.post(
          'https://des.we-builds.com/de-api/m/v2/notification/groupByCategory',
          data: {});
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          var data = response.data['objectData'];
          List<dynamic> list = [
            {'value': "", 'display': 'ทั้งหมด'},
            {'value': "bookingPage", 'display': 'จองใช้บริการ'}
          ];
          list = [...list, ...data];
          return Future.value(list);
        }
      }
    } catch (e) {
      print('false');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _readGroupByCategory(), // function where you call your api\
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data
                  .map<Widget>(
                    (c) => GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        widget.onChange(c['value'], c['display']);
                        setState(() {
                          selectedIndex = c['value'];
                          selectedTitleIndex = c['display'];
                        });
                      },
                      child: c['value'] == selectedIndex ?
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 15),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(40),
                          color: MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Color(0xFFB325F8)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          // c['value'] == selectedIndex
                          //     ? Color(0xFFB325F8)
                          //     : Color(0xFFB325F8).withOpacity(0.1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text(
                          c['display'],
                          style: TextStyle(
                            color: MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Colors.white
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.black
                                    : Colors.black,
                            // c['value'] == selectedIndex
                            //     ? Color(0xFFFFFFFF)
                            //     : Color(0xFFB325F8).withOpacity(0.1),
                            // decoration: index == selectedIndex
                            //     ? TextDecoration.underline
                            //     : null,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1.2,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      )
                      : Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 15),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(40),
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Color(0xFFB325F8).withOpacity(0.1)
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                          ),
                          color: MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Color(0xFFB325F8).withOpacity(0.2)
                                : Colors.black,
                          // c['value'] == selectedIndex
                          //     ? Color(0xFFB325F8)
                          //     : Color(0xFFB325F8).withOpacity(0.1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text(
                          c['display'],
                          style: TextStyle(
                            color: MyApp.themeNotifier.value == ThemeModeThird.light
                                ? Colors.white
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                            // c['value'] == selectedIndex
                            //     ? Color(0xFFFFFFFF)
                            //     : Color(0xFFB325F8).withOpacity(0.1),
                            // decoration: index == selectedIndex
                            //     ? TextDecoration.underline
                            //     : null,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1.2,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                    
                    ),
                  )
                  .toList(),
            ),
          );
        } else {
          return Container(
            height: 30,
            // padding: EdgeInsets.only(left: 5.0, right: 5.0),
            // margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
