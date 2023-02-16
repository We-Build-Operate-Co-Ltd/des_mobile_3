import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dio/dio.dart';

import 'splash.dart';

class VersionPage extends StatefulWidget {
  const VersionPage({super.key});

  @override
  State<VersionPage> createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  Future<dynamic>? futureModel;
  int versionNumber = 100;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) => _callRead());
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              debugPrint(snapshot.data);
              if (snapshot.data['isActive']) {
                if (versionNumber < snapshot.data['version']) {
                  _callGoSplash();
                } else {
                  _callGoSplash();
                }
              } else {
                _callGoSplash();
              }
              return Container();
            } else if (snapshot.hasError) {
              _callGoSplash();
              return Container();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  _callRead() async {
    debugPrint('111');
    Dio dio = Dio();
    String platform = Platform.isAndroid ? 'Android' : 'Ios';
    Response<dynamic> result = await dio.post(
        'http://122.155.223.63/td-des-api/m/v2/version/read',
        data: {'platform': platform});

    if (result.statusCode == 200) {
      if (result.data['status'] == 'S') {
        setState(() {
          futureModel = Future.value(result.data['objectData']);
        });
      }
    }
  }

  _callGoSplash() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // add your code here.
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SplashPage()));
    });
  }
}
