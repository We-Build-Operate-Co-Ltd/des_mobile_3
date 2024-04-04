import 'dart:async';
import 'package:des/main.dart';
import 'package:des/shared/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  Completer<GoogleMapController> _mapController = Completer();

  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;

  @override
  void initState() {
    //  themeColor
    if (MyApp.themeNotifier.value == ThemeModeThird.light) {
      backgroundTheme = Colors.white;
      colorTheme = Color(0xFF7A4CB1);
      buttonTheme = Color(0xFF7A4CB1);
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
    return Scaffold(
      backgroundColor: backgroundTheme,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bg_logo_about_us.png',
              width: 290,
              height: 186,
              alignment: Alignment.centerRight,
            ),
          ),
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _backButton(context),
                ),
                Image.asset(
                  'assets/images/logo_about_us.png',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 15),
                Text(
                  'ศูนย์ดิจิทัลชุมชน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: colorTheme,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Container(
                    height: 20,
                    width: 170,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: MyApp.themeNotifier.value == ThemeModeThird.light
                            ? Color(0xFFFEF7FF)
                            : Colors.black,
                        borderRadius: BorderRadius.circular(12.5),
                        border: Border.all(
                          color:
                              MyApp.themeNotifier.value == ThemeModeThird.light
                                  ? Color(0xFFFEF7FF)
                                  : colorTheme,
                        )),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/pin_about_us.png',
                          height: 11,
                          width: 11,
                          color: textTheme,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '120 หมู่ 3 เขตหลักสี่ กรุงเทพ 10210',
                          style: TextStyle(
                            color: textTheme,
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ช่องทางติดต่อ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: textTheme,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                rowContactInformation('เบอร์โทรติดต่อ', '02 123 4568',
                    'assets/images/contact_number_about_us.png'),
                SizedBox(height: 15),
                rowContactInformation(
                    'Facebook Page',
                    'ศูนย์ดิจิทัลชุมชน ศูนย์ราชการฯ',
                    'assets/images/facebook_about_us.png'),
                SizedBox(height: 15),
                rowContactInformation('อีเมล', 'dcc@onde.go.th',
                    'assets/images/email_about_us.png'),
                SizedBox(height: 15),
                rowContactInformation('เว็บไซต์', 'dcc.onde.go.th/home',
                    'assets/images/website_about_us.png'),
                SizedBox(height: 25),
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
                SizedBox(height: 60),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        padding: EdgeInsets.fromLTRB(10, 7, 13, 7),
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
    return GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 15,
      ),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      // onTap: _handleTap,
      markers: <Marker>[
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      ].toSet(),
    );
  }

  Widget rowContactInformation(String title, String title2, String image) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: colorTheme),
            color: buttonTheme,
          ),
          height: 45,
          width: 45,
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
                  fontWeight: FontWeight.w400,
                  color: textTheme,
                ),
              ),
              Text(
                title2,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textTheme,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 15),
        Container(
          height: 45,
          width: 45,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: backgroundTheme,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: MyApp.themeNotifier.value == ThemeModeThird.light
                  ? Colors.transparent
                  : colorTheme,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/next_arrow_about_us.png',
            color: colorTheme,
          ),
        ),
      ],
    );
  }
  //
}
