import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/detail.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PoiPage extends StatefulWidget {
  PoiPage({Key? key, required this.latLng}) : super(key: key);

  final LatLng latLng;

  @override
  _PoiPage createState() => _PoiPage();
}

class _PoiPage extends State<PoiPage> {
  Completer<GoogleMapController> _mapController = Completer();

  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String keySearch = '';
  String categorySelected = '';
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  RefreshController _refreshPanelController =
      RefreshController(initialRefresh: false);

  Future<dynamic>? _futureModel;
  late LatLngBounds initLatLngBounds;

  double? positionScroll;
  bool showMap = true;
  LatLng? latLng;

  // Future<dynamic> _futureModel;
  List<dynamic> categoryList = [];
  List<dynamic> listTemp = [
    {
      'code': '',
      'title': '',
      'imageUrl': '',
      'createDate': '',
      'userList': [
        {'imageUrl': '', 'firstName': '', 'lastName': ''}
      ]
    }
  ];
  bool showLoadingItem = true;
  bool _linearLoading = false;
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _header(),
      body: showMap ? _buildMap() : _buildList(),
    );
  }

  AppBar _header() {
    return AppBar(
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: Color(0xFF7A4CB1)),
      ),
      backgroundColor: Color(0xFF9A1120),
      elevation: 0.0,
      titleSpacing: 5,
      automaticallyImplyLeading: false,
      title: Text(
        'สถานที่น่าสนใจ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          color: Colors.white,
        ),
      ),
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 10.0),
          margin: EdgeInsets.only(right: 10, top: 12, bottom: 12),
          width: 70,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: InkWell(
            onTap: () {
              setState(
                () {
                  showMap = !showMap;
                  _limit = 10;
                  _read();
                },
              );
            },
            child: showMap
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list,
                        color: Theme.of(context).primaryColor,
                        size: 15,
                      ),
                      Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 9,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      Text(
                        'แผนที่',
                        style: TextStyle(
                          fontSize: 9,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

// show map
  SlidingUpPanel _buildMap() {
    final double _initFabHeight = 50.0;
    double _fabHeight;
    double _panelHeightOpen = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 50);
    double _panelHeightClosed = 90;
    return SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: .5,
      body: Container(
        padding: EdgeInsets.only(
            bottom:
                _panelHeightClosed + MediaQuery.of(context).padding.top + 50),
        child: googleMap(_futureModel),
      ),
      panelBuilder: (sc) => _panel(sc),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
      onPanelSlide: (double pos) => {
        setState(
          () {
            positionScroll = pos;
            _fabHeight =
                pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
          },
        ),
      },
    );
  }

  FutureBuilder googleMap(modelData) {
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                slug: 'poi',
                                model: item,
                              ),
                            ),
                          );
                        },
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
            myLocationButtonEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: latLng!,
              zoom: 15,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            onMapCreated: (GoogleMapController controller) {
              controller.moveCamera(
                CameraUpdate.newLatLngBounds(
                  initLatLngBounds,
                  5.0,
                ),
              );
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: latLng!, zoom: 12)));
              _mapController.complete(controller);
            },
            // cameraTargetBounds: CameraTargetBounds(_createBounds()),
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
        } else if (snapshot.hasError) {
          return Center(
            child: Text('error'),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SmartRefresher(
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
        controller: _refreshPanelController,
        onLoading: _onLoadingPanel,
        child: ListView(
          controller: sc,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
                height: 4,
              ),
            ),
            Container(
              height: 35,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'จุดบริการ',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_linearLoading) LinearProgressIndicator(),
            SizedBox(
              height: 5,
            ),
            _listSlide()
          ],
        ),
      ),
    );
  }
// end show map

// -------------------------------

// show content
  Widget _buildList() {
    return Column(
      children: [
        Stack(
          children: [
            _buildCategory(),
            if (showProgress) LinearProgressIndicator(),
          ],
        ),
        Expanded(
          child: buildList(),
        )
      ],
    );
  }

  FutureBuilder buildList() {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              showProgress = true;
            });
          });
        }
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              showProgress = false;
            });
          });
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sarabun',
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            return refreshList(snapshot.data);
          }
        } else if (snapshot.hasError) {
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              _read();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 50.0, color: Colors.blue),
                Text('ลองใหม่อีกครั้ง')
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SmartRefresher refreshList(List<dynamic> model) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      footer: ClassicFooter(
        loadingText: ' ',
        canLoadingText: ' ',
        idleText: ' ',
        idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
      ),
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 15),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return card(context, model[index]);
        },
      ),
    );
  }

  Container card(BuildContext context, dynamic model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                slug: 'poi',
                model: model,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          margin: EdgeInsets.only(bottom: 5.0),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(5.0),
                    topRight: const Radius.circular(5.0),
                  ),
                  color: Colors.white,
                ),
                child: model['imageUrl'] != null
                    ? ClipRRect(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(5.0),
                          topRight: const Radius.circular(5.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: '${model['imageUrl']}',
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/logo.png'),
                        ))
                    : Container(
                        height: 200,
                      ),
              ),
              Container(
                // height: 60,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(5.0),
                    bottomRight: const Radius.circular(5.0),
                  ),
                  color: Color(0xFFFFFFFF),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                    Text(
                      'วันที่ ' + _dateStringToDate(model['createDate']),
                      style: TextStyle(
                        color: Color(0xFF8F8F8F),
                        fontFamily: 'Sarabun',
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      height: 40,
      child: ListView.separated(
        itemCount: categoryList.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) => GestureDetector(
          onTap: () {
            setState(() {
              categorySelected = categoryList[__]['code'];
              _limit = 10;
            });
            _read();
          },
          child: Container(
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(40),
              color: categoryList[__]['code'] == categorySelected
                  ? Color(0xFFB325F8)
                  : Color(0xFFB325F8).withOpacity(0.1),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              categoryList[__]['title'],
              style: TextStyle(
                color: categoryList[__]['code'] == categorySelected
                    ? Color(0xFFFFFFFF)
                    : Color(0xFFB325F8).withOpacity(0.1),
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                letterSpacing: 1.2,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ),
    );
  }
// end show content

  Widget _listSlide() {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.connectionState == ConnectionState.waiting) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              showProgress = true;
            });
          });
        }
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              showProgress = false;
            });
          });
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
                      (MediaQuery.of(context).size.height / 1.85),
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(5),
                        color: Colors.transparent,
                      ),
                      width: 170.0,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned.fill(
                            child: Container(
                              height: 170.0,
                              width: double.infinity,
                              padding: EdgeInsets.only(bottom: 45),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    color: Color(0xFFcfcfcf),
                                    offset: Offset(0, 0.75),
                                  )
                                ],
                                color: Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data[index]['imageUrl'],
                                fit: BoxFit.contain,
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/images/logo.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              height: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  bottomLeft: const Radius.circular(5.0),
                                  bottomRight: const Radius.circular(5.0),
                                ),
                                color: Color(0xFF7A4CB1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[index]['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  _textDistance(
                                      snapshot.data[index]['distance']),
                                ],
                              ),
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
          return Container(
            height: 100,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _textDistance(dynamic value) {
    var distance;
    if (value == 0) {
      distance = "N/A";
    } else {
      distance = value.toStringAsFixed(2);
    }
    return Text(
      "ระยะทาง " + distance + " กิโลเมตร",
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 8,
        fontFamily: 'Kanit',
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  String _dateStringToDate(String date) {
    var year = date.substring(0, 4);
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
    return day + '-' + month + '-' + year;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _determinePosition();
      await _getLocation();
    });
    _readCategory();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _read() async {
    print('----> call function read');
    Dio dio = Dio();
    Response<dynamic> response;
    try {
      response =
          await dio.post('http://122.155.223.63/td-des-api/m/poi/read', data: {
        'skip': 0,
        'limit': _limit,
        'latitude': latLng!.latitude,
        'longitude': latLng!.longitude
      });
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          setState(() {
            _futureModel = Future.value(response.data['objectData']);
          });
        }
      }
    } catch (e) {}
    return [];
  }

  _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else if (permission == LocationPermission.always) {
    } else if (permission == LocationPermission.whileInUse) {
    } else if (permission == LocationPermission.unableToDetermine) {
    } else {
      throw Exception('Error');
    }
    return await Geolocator.getCurrentPosition();
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      initLatLngBounds = LatLngBounds(
          southwest: LatLng(position.latitude - 0.2, position.longitude - 0.15),
          northeast: LatLng(position.latitude + 0.1, position.longitude + 0.1));
    });
    _read();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
    });
    _read();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  void _onLoadingPanel() async {
    setState(() {
      _limit = _limit + 10;
    });
    _read();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshPanelController.loadComplete();
  }

  void changeTab() async {
    // Navigator.pop(context, false);
    setState(() {
      showMap = !showMap;
    });
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  Future<dynamic> _readCategory() async {
    Response<dynamic> response;
    try {
      response = await Dio().post(
          'http://122.155.223.63/td-des-api/m/poi/category/read',
          data: {});
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          var data = response.data['objectData'];
          List<dynamic> list = [
            {'code': "", 'title': 'ทั้งหมด'}
          ];
          list = [...list, ...data];
          print(list);
          setState(() {
            categoryList = list;
          });
        }
      }
    } catch (e) {
      print('false');
    }
    return [];
  }
}
