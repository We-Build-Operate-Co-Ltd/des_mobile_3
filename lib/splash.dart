import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/login.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:des/menu.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<dynamic>? futureModel;
  String _profileCode = '';

  @override
  Widget build(BuildContext context) {
    return _buildSplash();
  }

  _buildSplash() {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: _callRead(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              //if no splash from service is return array length 0
              _callTimer((snapshot.data.length > 0
                      ? int.parse(snapshot.data[0]['timeOut']) / 1000
                      : 0)
                  .round());

              return snapshot.data.length > 0
                  ? Center(
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data[0]['imageUrl'],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    )
                  : Container();
            } else if (snapshot.hasError) {
              // postLineNoti();
              _callTimer(3);
              return Image.asset(
                'assets/splash.png',
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
              );
            } else {
              return Center(
                child: Container(),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _profileCode = await ManageStorage.read('profileCode') ?? '';
    });
    super.initState();
  }

  _callRead() async {
    Dio dio = Dio();
    Response<dynamic> result = await dio
        .post('http://122.155.223.63/td-des-api/m/splash/read', data: {});

    if (result.statusCode == 200) {
      if (result.data['status'] == 'S') {
        return result.data['objectData'];
      }
    }

    return Error();
  }

  _callTimer(time) {
    var duration = Duration(seconds: time);
    Timer.periodic(duration, (timer) {
      if (_profileCode != '') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Menu(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });
  }
}
