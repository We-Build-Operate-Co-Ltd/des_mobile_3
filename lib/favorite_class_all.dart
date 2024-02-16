import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'detail.dart';
import 'main.dart';

class FavoriteClassAllPage extends StatefulWidget {
  FavoriteClassAllPage({
    Key? key,
  }) : super(key: key);
  @override
  _FavoriteClassAllState createState() => _FavoriteClassAllState();
}

class _FavoriteClassAllState extends State<FavoriteClassAllPage> {
  Dio dio = Dio();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final _controllerContant = ScrollController();
  Future<dynamic>? _futureModel;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _loading();
    super.initState();
  }

  _loading() async {
    Response<dynamic> response =
        await dio.post('$server/de-api/m/eventcalendar/read', data: {});

    if (response.statusCode == 200) {
      if (response.data['status'] == 'S') {
        setState(() {
          _futureModel = Future.value(response.data['objectData']);
        });
      }
    }

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: MyApp.themeNotifier.value == ThemeModeThird.light
            ? Colors.white
            : Colors.black,
        body: ListView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 25,
            right: 15,
            left: 15,
          ),
          children: [
            _buildHead(),
            SizedBox(height: 20),
            _buildFavoriteClass(),
            //
          ],
        ),
      ),
    );
  }

  Widget _buildContant(BuildContext context, dynamic model) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(
            slug: 'eventcalendar',
            model: model,
          ),
        ),
      ),
      child: Container(
        height: 95,
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: '${model['imageUrl']}',
                fit: BoxFit.cover,
                height: 95,
                width: 169,
              ),
            ),
            SizedBox(width: 9),
            Expanded(
              child: Container(
                child: Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: MyApp.themeNotifier.value == ThemeModeThird.light
                        ? Colors.black
                        : MyApp.themeNotifier.value == ThemeModeThird.dark
                            ? Colors.white
                            : Color(0xFFFFFD57),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteClass() {
    return FutureBuilder(
      future: _futureModel,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container();
          } else {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) =>
                  _buildContant(context, snapshot.data[index]),
              shrinkWrap: true,
              controller: _controllerContant,
              physics: ClampingScrollPhysics(), // 2nd
            );
          }
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            child: Text(
              'Network ขัดข้อง',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildHead() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      color: MyApp.themeNotifier.value == ThemeModeThird.light
          ? Colors.white
          : Colors.black,
      child: Column(
        children: [
          SizedBox(height: 13),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFF7A4CB1)
                          : Colors.black,
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFF7A4CB1)
                            : MyApp.themeNotifier.value == ThemeModeThird.dark
                                ? Colors.white
                                : Color(0xFFFFFD57),
                      )),
                  child: Image.asset(
                    'assets/images/back_arrow.png',
                  ),
                ),
              ),
              SizedBox(width: 34),
              Text(
                '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Colors.black
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//
}
