import 'dart:async';
import 'package:des/main.dart';
import 'package:des/shared/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  Completer<gmap.GoogleMapController> _mapController = Completer();

  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;

  @override
  void initState() {
    //  themeColor
    if (MyApp.themeNotifier.value == ThemeModeThird.light) {
      backgroundTheme = Colors.white;
      colorTheme = Color(0xFFB325F8);
      buttonTheme = Color(0xFFB325F8);
      textTheme = Colors.black;
    } else if (MyApp.themeNotifier.value == ThemeModeThird.dark) {
      backgroundTheme = Colors.black;
      colorTheme = Colors.white;
      buttonTheme = Colors.black;
      textTheme = Colors.white;
    } else {
      backgroundTheme = Colors.black;
      colorTheme = Color(0xFFFFFD57);
      buttonTheme = Colors.black;
      textTheme = Color(0xFFFFFD57);
    }
    //  themeColor
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundTheme,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              height: 1000,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/new_bg.png"),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: deviceHeight * 0.8,
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Colors.white
                          : Colors.black,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _backButton(context),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'ศูนย์ดิจิทัลชุมชน',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: MyApp.themeNotifier.value ==
                                    ThemeModeThird.light
                                ? Colors.black
                                : MyApp.themeNotifier.value ==
                                        ThemeModeThird.dark
                                    ? Colors.white
                                    : Color(0xFFFFFD57),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              Column(
                                children: [
                                  rowContactInformation(
                                      'เลขที่ 120 หมู่ 3 ชั้น 3 และ 5 ศูนย์ราชการฯ แจ้งวัฒนะ (อาคาร ซี) ซอยแจ้งวัฒนะ 7 ถนนแจ้งวัฒนะ แขวงทุ่งสองห้อง เขตหลักสี่ กรุงเทพฯ 10210',
                                      'assets/images/about_us_mark.png'),
                                  SizedBox(height: 15),
                                  rowContactInformation('02-114-8592',
                                      'assets/images/about_us_phone.png'),
                                  SizedBox(height: 15),
                                  // rowContactInformationSocial(
                                  //     'www.dcc.onde.go.th', 'assets/images/about_us_web.png'),

                                  rowContactInformationSocial(
                                    title: 'www.dcc.onde.go.th',
                                    image: 'assets/images/about_us_web.png',
                                    onTap: () async {
                                      launchUrl(
                                          Uri.parse('https://dcc.onde.go.th/'),
                                          mode: LaunchMode.externalApplication);
                                    },
                                  ),

                                  SizedBox(height: 30),
                                  Text(
                                    'ช่องทางการติดต่อ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: MyApp.themeNotifier.value ==
                                              ThemeModeThird.light
                                          ? Colors.black
                                          : MyApp.themeNotifier.value ==
                                                  ThemeModeThird.dark
                                              ? Colors.white
                                              : Color(0xFFFFFD57),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  rowSocialMedia(),
                                  SizedBox(height: 30),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: SizedBox(
                                      height: 195,
                                      child: googleMap(
                                        double.parse('13.88261'),
                                        double.parse('100.56487'),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: Container(
                    height: 168,
                    width: 168,
                    child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/images/avatar_about_us.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: buttonTheme,
          border: Border.all(color: colorTheme),
        ),
        child: Image.asset(
          'assets/images/back_arrow.png',
        ),
      ),
    );
  }

  Widget googleMap(double lat, double lng) {
    return gmap.GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      mapType: gmap.MapType.normal,
      initialCameraPosition: gmap.CameraPosition(
        target: gmap.LatLng(lat, lng),
        zoom: 15,
      ),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
      onMapCreated: (gmap.GoogleMapController controller) {
        _mapController.complete(controller);
      },
      // onTap: _handleTap,
      markers: <gmap.Marker>[
        gmap.Marker(
          markerId: gmap.MarkerId('1'),
          position: gmap.LatLng(lat, lng),
          icon: gmap.BitmapDescriptor.defaultMarkerWithHue(
              gmap.BitmapDescriptor.hueRed),
        ),
      ].toSet(),
    );
  }

  Widget rowContactInformation(String title, String image) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          child: Image.asset(image),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textTheme,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget rowContactInformationSocial({
    required String title,
    required String image,
    Function? onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            child: Image.asset(image),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textTheme,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton({
    String image = '',
    Function? onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: 50,
        width: 50,
        child: Image.asset(image),
      ),
    );
  }

  Widget rowSocialMedia() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _socialButton(
            onTap: () {
              launchUrl(Uri.parse('https://www.youtube.com/@onde_go_th6218'),
                  mode: LaunchMode.externalApplication);
            },
            image: 'assets/images/about_us_yt.png'),
        _socialButton(
            onTap: () async {
              launchUrl(Uri.parse('https://www.facebook.com/ONDE.GO.TH/'),
                  mode: LaunchMode.externalApplication);
            },
            image: 'assets/images/about_us_fb.png'),
        _socialButton(
            onTap: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'dcc-platform@onde.go.th',
              );
              launchUrl(emailUri);
            },
            image: 'assets/images/about_us_gmail.png'),
        _socialButton(
            onTap: () async {
              launchUrl(Uri.parse('https://x.com/onde_go_th'),
                  mode: LaunchMode.externalApplication);
            },
            image: 'assets/images/about_us_x.png'),
        _socialButton(
            onTap: () async {
              launchUrl(Uri.parse('https://www.instagram.com/onde_go_th/'),
                  mode: LaunchMode.externalApplication);
            },
            image: 'assets/images/about_us_ig.png'),
        _socialButton(
            onTap: () async {
              launchUrl(Uri.parse('https://line.me/R/ti/p/@223hnckq'),
                  mode: LaunchMode.externalApplication);
            },
            image: 'assets/images/about_us_line.png'),
      ],
    );
  }
}
