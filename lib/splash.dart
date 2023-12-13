import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/login_first.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:des/menu.dart';
import 'check_version.dart';
import 'shared/config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<dynamic>? futureModel;
  String _profileCode = '';
  List<dynamic> _model = [];
  late int version_store;
  dynamic _model_version;
  String os = Platform.operatingSystem;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _profileCode = await ManageStorage.read('profileCode') ?? '';
      await _callRead();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSplash();
  }

  _buildSplash() {
    if (_model.length > 0) {
      _callTimer((int.parse(_model[0]['timeOut']) / 1000).round());
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CachedNetworkImage(
              imageUrl: _model[0]['imageUrl'],
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),
      );
    } else {
      _callTimer(1);
      return Container(
        color: Colors.white,
      );

      // return Image.asset(
      //   'assets/splash.png',
      //   fit: BoxFit.fill,
      //   height: double.infinity,
      //   width: double.infinity,
      // );
    }
  }

  _callRead() async {
    try {
      Dio dio = Dio();
      Response<dynamic> result =
          await dio.post('$server/de-api/m/splash/read', data: {});

      if (result.statusCode == 200) {
        if (result.data['status'] == 'S') {
          setState(() {
            _model = result.data['objectData'];
          });
          // return result.data['objectData'];
        }
      }
    } catch (e) {}
  }

  _callTimer(time) {
    var duration = Duration(seconds: time);
    Timer.periodic(duration, (timer) async {
      if (_profileCode != '') {
        check_version();
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => const Menu(),
        //   ),
        //   (Route<dynamic> route) => false,
        // );
      } else {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginFirstPage(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  void check_version() async {
    String os_device = os == 'ios' ? 'Ios' : 'Android';
    // print('os : ${os_device}');
    Dio dio = Dio();
    var res = await dio
        .post('$server/de-api/version/read', data: {"platform": os_device});
    setState(() {
      version_store =
          int.parse(res.data['objectData'][0]['version'].split('.').join(''));
      _model_version = res.data['objectData'][0];
    });

    navigationPage();
  }

  Future<void> navigationPage() async {
    if (!mounted) return;
    if (version_store > versionNumber) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // builder: (context) => const IntroductionPage(),
          builder: (context) => CheckVersionPage(model: _model_version),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Menu(),
        ),
      );
    }
  }
}
