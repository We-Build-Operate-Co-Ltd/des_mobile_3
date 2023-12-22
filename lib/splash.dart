import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/login_first.dart';
import 'package:des/shared/extension.dart';
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
  bool _loading = true;
  String _image = '';

  @override
  void initState() {
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
        body: _buildSplash(),
      ),
    );
  }

  _buildSplash() {
    if (!_loading) {
      if (_image != '') {
        return Center(
          child: CachedNetworkImage(
            imageUrl: _image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        );
      }
    }
    return Container(
      color: Colors.white,
    );
  }

  _callRead() async {
    try {
      var pf = await ManageStorage.read('profileCode') ?? '';

      Dio dio = Dio();
      Response result =
          await dio.post('$server/de-api/m/splash/read', data: {});

      if (result.statusCode == 200) {
        if (result.data['status'] == 'S') {
          setState(() {
            _profileCode = pf;
            _model = result.data['objectData'];
            _image = _model.length > 0 ? _model[0]['imageUrl'] : '';
          });
        }
      }
      setState(() => _loading = false);
      _callTimer();
    } catch (e) {
      setState(() => _loading = false);
      logE(e);
      _callTimer();
    }
  }

  _callTimer() async {
    int time = 0;
    if (_model.length > 0) {
      time = int.parse((_model[0]?['timeOut'] ?? '0'));
    }
    var calTime = time > 0 ? (time / 1000).round() : 0;

    Timer(Duration(seconds: calTime), () {
      if (_profileCode != '') {
        check_version();
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
