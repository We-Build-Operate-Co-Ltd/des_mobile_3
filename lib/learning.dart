import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'course_detail.dart';
import 'main.dart';
import 'shared/config.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key}) : super(key: key);
  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  dynamic _model = [];

  @override
  void initState() {
    _callReadGetCourse();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).custom.w_b_b,
        title: Text(
          'การเรียน',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).custom.b_w_y,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 25,
          right: 15,
          left: 15,
        ),
        children: [
          const SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _model.length,
            separatorBuilder: (_, __) => const SizedBox(height: 25),
            itemBuilder: (context, _) {
              if (_model.length != 0)
                return _buildHistoryOfServiceReservations(_model[_]);
            },
          )
        ],
      ),
    );
  }

  Widget _buildHistoryOfServiceReservations(dynamic model) {
    // String title, String title2, int hour, String date, String time
    return InkWell(
      onTap: () {
        var data = {
          'course_id': model?['id'] ?? '',
          "course_name": model?['name'] ?? '',
          "course_cat_id": model?['course_cat_id'] ?? '',
          "cover_image": model?['docs'] ?? '',
          "description": model['details'] ?? '',
          "created_at": model['created_at'] ?? '',
          "category_name": model['cat_name'] ?? '',
          "certificate": model['certificate'] ?? '',
        };
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(
              model: data,
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: (model?['docs'] ?? '') != ''
                    ? Image.network(
                        'https://lms.dcc.onde.go.th/uploads/course/' +
                            model['docs'],
                        height: 120,
                        width: 120,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        'assets/icon.png',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${model?['name'] ?? ''}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      '${model?['details'] ?? ''}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF707070)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          const SizedBox(height: 6),
          Container(
            height: 1,
            color: MyApp.themeNotifier.value == ThemeModeThird.light
                ? Color(0xFF707070)
                : MyApp.themeNotifier.value == ThemeModeThird.dark
                    ? Colors.white
                    : Color(0xFFFFFD57),
          ),
        ],
      ),
    );
  }

  void _callReadGetCourse() async {
    // print('------------hello');
    dynamic response = await Dio().get('$server/py-api/dcc/lms/recomend');
    // print(response.data.toString());

    setState(() {
      _model = response.data;
    });

    // return Future.value(response);
  }
}
