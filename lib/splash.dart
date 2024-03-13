import 'dart:async';
import 'dart:io';
import 'package:des/login_first.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:des/menu.dart';
import 'package:intl/intl.dart';
import 'check_version.dart';
import 'shared/config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
    this.code,
  }) : super(key: key);
  final String? code;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  dynamic profile;
  String now = DateFormat('dd/MM/yyyy').format(DateTime.now());
  late int version_store;
  dynamic _model_version;
  String os = Platform.operatingSystem;
  String _urlImage = '';
  int _timeOut = 1000;
  Future<dynamic>? futureModel;

  @override
  void initState() {
    version_store = versionNumber;
    _getImage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getImage() async {
    try {
      Response result =
          await Dio().post('$server/dcc-api/m/splash/read', data: {});
      logE('load splash screen');

      if (result.data['objectData'].length > 0) {
        setState(() {
          _urlImage = result.data['objectData'][0]['imageUrl'];
          _timeOut = int.parse(result.data['objectData'][0]['timeOut'] ?? 0);
        });
      }
      logWTF(_urlImage);
      int time = (_timeOut / 1000).round();
      Timer(Duration(seconds: time), _checkVersion);
    } catch (e) {
      logE('catch splash screen');
      _checkVersion();
    }
  }

  void _checkVersion() async {
    try {
      String os_device = os == 'ios' ? 'Ios' : 'Android-DCC';
      // print('os : ${os_device}');
      Dio dio = Dio();
      var res = await dio
          .post('$server/dcc-api/version/read', data: {"platform": os_device});
      setState(() {
        version_store =
            int.parse(res.data['objectData'][0]['version'].split('.').join(''));
        _model_version = res.data['objectData'][0];
      });
      navigationPage();
    } catch (e) {
      logE(e);
      navigationPage();
    }
  }

  Future<void> navigationPage() async {
    if (!mounted) return;
    if (version_store > versionNumber) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CheckVersionPage(model: _model_version),
        ),
      );
    } else {
      String accessToken = await ManageStorage.read('accessToken');
      if (!mounted) return;
      if (accessToken.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Menu(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginFirstPage(),
          ),
        );
      }
    }
  }

  _check() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const Menu(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Image.network(
          _urlImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
