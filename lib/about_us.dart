import 'dart:async';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              child: Image.asset(
                'assets/images/bg_about_us.png',
                width: 290,
                height: 186,
                alignment: Alignment.centerRight,
              ),
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
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/back.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
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
                    color: Color(0xFF7A4CB1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Container(
                    height: 19,
                    width: 164,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Color(0xFFFEF7FF),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/pin_about_us.png',
                          height: 11,
                          width: 11,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '120 หมู่ 3 เขตหลักสี่ กรุงเทพ 10210',
                          style: TextStyle(
                            color: Color(0xFF000000),
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
                    'ข้อมูลติดต่อ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                rowContactInformation('เบอร์ติดต่อ', '02 123 4568',
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
        Image.asset(
          image,
          height: 45,
          width: 45,
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
                ),
              ),
              Text(
                title2,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 15),
        Image.asset(
          'assets/images/next_arrow_about_us.png',
          height: 50,
          width: 50,
        ),
      ],
    );
  }
  //
}
