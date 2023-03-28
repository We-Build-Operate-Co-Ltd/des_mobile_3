import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'detail.dart';

class MyClassAllPage extends StatefulWidget {
  MyClassAllPage({
    Key? key,
    this.model,
  }) : super(key: key);
  final dynamic model;
  @override
  _MyClassAllPageState createState() => _MyClassAllPageState();
}

class _MyClassAllPageState extends State<MyClassAllPage> {
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
    _futureModel = Future.value(widget.model);
    // _loading();
    super.initState();
  }

  _loading() async {
    Response<dynamic> response = await dio.post(
        'http://122.155.223.63/td-des-api/m/eventcalendar/read',
        data: {});

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
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 25,
            right: 15,
            left: 15,
          ),
          children: [
            _buildHead(),
            SizedBox(height: 20),
            _buildMyClass(),
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

  Widget _buildMyClass() {
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
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 13),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset('assets/images/back.png',
                    height: 40, width: 40),
              ),
              SizedBox(width: 34),
              Text(
                '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
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
