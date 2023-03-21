import 'dart:async';

import 'package:des/detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PoiPage extends StatefulWidget {
  PoiPage({Key? key}) : super(key: key);

  @override
  _PoiPage createState() => _PoiPage();
}

class _PoiPage extends State<PoiPage> {
  Completer<GoogleMapController> _mapController = Completer();

  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String keySearch = '';
  String category = '';
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<dynamic>? _futurePoi;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _read();
  }

  void _onLoading() async {
    setState(() => _limit = _limit + 10);
    _read();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  Future<List<dynamic>> _read() async {
    Dio dio = Dio();
    Response<dynamic> response;
    try {
      response = await dio.post(
          'http://122.155.223.63/td-des-api/m/eventCalendar/read',
          data: {'skip': 0, 'limit': _limit});
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          print('${response.data['objectData']}');
          return response.data['objectData'];
        }
      }
      setState(() {
        _futurePoi = Future.value(response);
      });
    } catch (e) {}
    return [];
  }

  void goBack() => Navigator.pop(context, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        footer: ClassicFooter(
          loadingText: ' ',
          canLoadingText: ' ',
          idleText: ' ',
          idleIcon: Icon(
            Icons.arrow_upward,
            color: Colors.transparent,
          ),
        ),
        controller: _refreshController,
        onLoading: _onLoading,
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              height: 300,
              margin: EdgeInsets.only(bottom: 10.0),
              width: double.infinity,
              child: googleMap(_futurePoi),
            ),
            _gridViewItem(),
          ],
        ),
      ),
    );
  }

  googleMap(modelData) {
    List<Marker> _markers = <Marker>[];

    return FutureBuilder<dynamic>(
      future: modelData, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            snapshot.data
                .map(
                  (item) => _markers.add(
                    Marker(
                      markerId: MarkerId(item['code']),
                      position: LatLng(
                        double.parse(item['latitude']),
                        double.parse(item['longitude']),
                      ),
                      infoWindow: InfoWindow(
                        title: item['title'].toString(),
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  ),
                )
                .toList();
          }

          return GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(13.743894, 100.538592),
              zoom: 12,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            markers: snapshot.data.length > 0
                ? _markers.toSet()
                : <Marker>[
                    Marker(
                      markerId: MarkerId('1'),
                      position: LatLng(0.00, 0.00),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  ].toSet(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _gridViewItem() {
    return FutureBuilder<dynamic>(
      future: _futurePoi, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              height: 200,
              alignment: Alignment.center,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.5),
                ),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            slug: 'poi',
                            model: snapshot.data[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: index == 0
                          ? EdgeInsets.only(left: 10.0, right: 5.0)
                          : index == snapshot.data.length - 1
                              ? EdgeInsets.only(left: 5.0, right: 15.0)
                              : EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(5),
                        color: Colors.transparent,
                      ),
                      width: 170.0,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 170.0,
                            width: 170.0,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(5.0),
                                topRight: const Radius.circular(5.0),
                              ),
                              color: Colors.white.withAlpha(220),
                              image: DecorationImage(
                                //fit:BoxFit.cover,
                                fit: snapshot.data[index]['typeImage'] ==
                                        'cover'
                                    ? BoxFit.cover
                                    : snapshot.data[index]['typeImage'] ==
                                            'fill'
                                        ? BoxFit.fill
                                        : snapshot.data[index]['typeImage'] ==
                                                'contain'
                                            ? BoxFit.contain
                                            : BoxFit.cover,
                                image: NetworkImage(
                                  snapshot.data[index]['imageUrl'],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 150.0),
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.topLeft,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                bottomLeft: const Radius.circular(5.0),
                                bottomRight: const Radius.circular(5.0),
                              ),
                              color: Color(0xFFDFC6C6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data[index]['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                    color: Colors.black.withAlpha(150),
                                    fontFamily: 'Kanit',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  snapshot.data[index]['distance'] == null
                                      ? "ระยะทาง - กิโลเมตร"
                                      : "ระยะทาง " +
                                          snapshot.data[index]['distance']
                                              .toStringAsFixed(2) +
                                          " กิโลเมตร",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 8,
                                    fontFamily: 'Kanit',
                                    color: Colors.black.withAlpha(150),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
