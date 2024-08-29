import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:des/booking_service.dart';
import 'package:des/detail.dart';
import 'package:des/learning.dart';
import 'package:des/login_first.dart';
import 'package:des/policy.dart';
import 'package:des/shared/dcc.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/notification_service.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/user_profile.dart';
import 'package:des/user_profile_new.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:des/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'shared/config.dart';
import 'main.dart';

class Menu extends StatefulWidget {
  const Menu({
    Key? key,
    this.pageIndex,
  }) : super(key: key);
  final int? pageIndex;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  DateTime? currentBackPressTime;
  dynamic futureNotificationTire;
  int addBadger = 0;
  int _currentPage = 0;
  String _profileCode = '';
  String _imageProfile = '';
  bool hiddenMainPopUp = false;
  List<Widget> pages = <Widget>[];
  bool notShowOnDay = false;
  int _currentBanner = 0;

  var loadingModel = {
    'title': '',
    'imageUrl': '',
  };
  var homePage;
  var profilePage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1E1E1E),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: confirmExit,
          child: IndexedStack(
            index: _currentPage,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  _buildMainPopUp() async {
    var result = await _readMainPopup();
    if (result.length > 0) {
      String valueStorage = await ManageStorage.read('mainPopupDE') ?? '';
      var dataValue;
      if (valueStorage.isNotEmpty) {
        dataValue = json.decode(valueStorage);
      } else {
        dataValue = null;
      }

      var now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      if (dataValue != null) {
        var index = dataValue.indexWhere(
          (c) =>
              // c['username'] == userData.username &&
              c['date'].toString() ==
                  DateFormat("ddMMyyyy").format(date).toString() &&
              c['boolean'] == "true",
        );

        if (index != -1) {
          this.setState(() {
            hiddenMainPopUp = true;
          });
        }
      }

      if (!hiddenMainPopUp)
        return showDialog(
          barrierDismissible: true, // close outside
          context: context,
          barrierColor: Colors.black.withOpacity(0.6),
          builder: (_) {
            return StatefulBuilder(builder: (context, setStateMainPopUp) {
              return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  height: 420,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            'assets/images/close_noti_list.png',
                            height: 40,
                            width: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 1,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            viewportFraction: 1,
                            autoPlay: true,
                            // enlargeFactor: 0.4,
                            // enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                            onPageChanged: (index, reason) {
                              setStateMainPopUp(() {
                                _currentBanner = index;
                              });
                            },
                          ),
                          items: result.map<Widget>(
                            (item) {
                              int index = result.indexOf(item);
                              return GestureDetector(
                                onTap: () {
                                  if (result[_currentBanner]['action'] ==
                                      'out') {
                                    if (result[_currentBanner]
                                        ['isPostHeader']) {
                                      var path =
                                          result[_currentBanner]['linkUrl'];
                                      if (_profileCode != '') {
                                        var splitCheck =
                                            path.split('').reversed.join();
                                        if (splitCheck[0] != "/") {
                                          path = path + "/";
                                        }
                                        var codeReplae = "B" +
                                            _profileCode.replaceAll('-', '') +
                                            result[_currentBanner]['code']
                                                .replaceAll('-', '');
                                        launchUrl(Uri.parse('$path$codeReplae'),
                                            mode:
                                                LaunchMode.externalApplication);
                                      }
                                    } else
                                      launchUrl(
                                          Uri.parse(result[_currentBanner]
                                              ['linkUrl']),
                                          mode: LaunchMode.externalApplication);
                                  } else if (result[_currentBanner]['action'] ==
                                      'in') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          slug: 'mock',
                                          model: result[_currentBanner],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: _currentBanner == index
                                      ? BorderRadius.all(Radius.circular(10))
                                      : BorderRadius.circular(0),
                                  child: CachedNetworkImage(
                                    imageUrl: item['imageUrl'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(15),
                      //   child: CachedNetworkImage(
                      //     imageUrl: result[0]['imageUrl'],
                      //   ),
                      // ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 5.0, top: 10.0, bottom: 10.0),
                            child: InkWell(
                              onTap: () => {
                                setStateMainPopUp(() {
                                  notShowOnDay = !notShowOnDay;
                                }),
                                setHiddenMainPopup(),
                              },
                              child: new Icon(
                                !notShowOnDay
                                    ? Icons.check_box_outline_blank
                                    : Icons.check_box,
                                color: Colors.lightGreenAccent,
                                size: 40.0,
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 10.0),
                            child: InkWell(
                              onTap: () => {setHiddenMainPopup()},
                              child: Text(
                                'ไม่ต้องแสดงเนื้อหาอีกภายในวันนี้',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
          },
        );
    }
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'กดอีกครั้งเพื่อออก');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildBottomNavBar() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        height: 55 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: Theme.of(context).custom.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD8D8D8).withOpacity(0.29),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, -3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTap(0, 'หน้าหลัก', 'assets/images/home.png'),
            _buildTap(1, 'จองใช้บริการ', 'assets/images/computer.png'),
            _buildTap(2, 'การเรียน', 'assets/images/learning.png'),
            _buildTap(3, 'สมาชิก', _imageProfile, isNetwork: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTap(
    int index,
    String title,
    String pathImage, {
    bool isNetwork = false,
    Key? key,
  }) {
    Color color;
    if (_currentPage == index) {
      if ((MyApp.themeNotifier.value == ThemeModeThird.light) ||
          (MyApp.themeNotifier.value == ThemeModeThird.dark)) {
        color = const Color(0xFF7A4CB1);
      } else {
        color = Theme.of(context).custom.b_w_y;
      }
    } else {
      if (MyApp.themeNotifier.value == ThemeModeThird.light) {
        color = Theme.of(context).custom.f70f70_y;
      } else {
        color = Colors.white;
      }
    }
    // Color color = _currentPage == index
    //     ? const Color(0xFF7A4CB1)
    //     : Theme.of(context).custom.bwy;
    return Flexible(
      key: key,
      flex: 1,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            radius: 60,
            splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
            onTap: () {
              _onItemTapped(index);
              // postTrackClick("แท็บ$title");
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.only(
                top: 5,
              ),
              child: Column(
                children: [
                  isNetwork
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: pathImage != ''
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.memory(
                                    base64Decode(_imageProfile),
                                    fit: BoxFit.cover,
                                    height: 30,
                                    width: 30,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      "assets/images/profile_empty.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/profile_empty.png',
                                  height: 30,
                                  width: 30,
                                  color: color,
                                ),
                        )
                      : Image.asset(
                          pathImage,
                          height: 30,
                          width: 30,
                          color: color,
                        ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15,
                        color: color,
                        fontWeight: _currentPage == index
                            ? FontWeight.w500
                            : FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var pf = await ManageStorage.read('accessToken') ?? '';

      //set color init.
      var colorStorage = await storage.read(key: 'switchColor') ?? 'ปกติ';
      if (colorStorage == "ปกติ") {
        MyApp.themeNotifier.value = ThemeModeThird.light;
      } else if (colorStorage == "ขาวดำ") {
        MyApp.themeNotifier.value = ThemeModeThird.dark;
      } else {
        MyApp.themeNotifier.value = ThemeModeThird.blindness;
      }

      //set font size init.
      var fontStorageValue =
          await storage.read(key: 'switchSizeFont') ?? 'ปกติ';
      if (fontStorageValue == "ปกติ") {
        MyApp.fontKanit.value = FontKanit.small;
      } else if (fontStorageValue == "ปานกลาง") {
        MyApp.fontKanit.value = FontKanit.medium;
      } else {
        MyApp.fontKanit.value = FontKanit.large;
      }

      setState(() {
        _profileCode = pf;
      });

      if (_profileCode.isEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginFirstPage(),
          ),
          (Route<dynamic> route) => false,
        );
      }
      // _callReadPolicy(pf);
    });

    homePage = HomePage(changePage: _changePage);
    profilePage = UserProfileNewPage(changePage: _changePage);
    _buildMainPopUp();
    _callRead();
    _logUsed();
    pages = <Widget>[
      // SizedBox(),
      // SizedBox(),
      // SizedBox(),
      homePage,
      BookingServicePage(),
      LearningPage(),
      profilePage,
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _logUsed() async {
    try {
      String os = Platform.operatingSystem;
      String os_device = os == 'ios' ? 'Ios' : 'Android';
      var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
      var criteria = {
        'email': profileMe['email'],
        'category': 'admin',
        'platform': os_device,
      };
      Dio().post(
        '$server/dcc-api/m/register/log/used/create',
        data: criteria,
      );
    } on DioError catch (e) {
      logE(e.toString());
    }
  }

  Future<List<dynamic>> _readMainPopup() async {
    Dio dio = Dio();
    Response<dynamic> response;
    try {
      response = await dio.post('$server/dcc-api/m/MainPopup/read', data: {});
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          return response.data['objectData'];
        }
      }
    } catch (e) {}
    return [];
  }

  _changePage(index) {
    setState(() {
      _currentPage = index;
    });

    if (index == 0) {
      _callRead();
    }
  }

  onSetPage() {
    setState(() {
      _currentPage = widget.pageIndex ?? 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0 && _currentPage == 0) {
        _callRead();
        _buildMainPopUp();
      }
      _currentPage = index;
    });
  }

  _callRead() async {
    var img = await DCCProvider.getImageProfile();
    setState(() => _imageProfile = img);
    setState(() {
      if (_profileCode != '') {
        pages[3] = profilePage;
      }
    });
  }

  Future<Null> _callReadPolicy(pf) async {
    Dio dio = Dio();
    Response<dynamic> response;
    dynamic policy = [];
    try {
      response = await dio.post('$server/dcc-api/m/policy/read', data: {
        "category": "application",
        "profileCode": pf,
      });
      if (response.statusCode == 200) {
        if (response.data['status'] == 'S') {
          policy = response.data['objectData'];
        } else {}
      }
    } catch (e) {
      print(e);
    }
    if (policy.length > 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PolicyPage(
            category: 'application',
            navTo: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Menu(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  void setHiddenMainPopup() async {
    String name = 'mainPopupDE';

    var value = await ManageStorage.read(name);
    var dataValue = value != '' ? json.decode(value) : null;

    var now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    if (dataValue != null) {
      var index =
          dataValue.indexWhere((c) => c['profileCode'] == _profileCode);

      if (index == -1) {
        dataValue.add({
          'boolean': notShowOnDay.toString(),
          'profileCode': _profileCode,
          'date': DateFormat("ddMMyyyy").format(date).toString(),
        });
      } else {
        dataValue[index]['boolean'] = notShowOnDay.toString();
        dataValue[index]['profileCode'] = _profileCode;
        dataValue[index]['date'] =
            DateFormat("ddMMyyyy").format(date).toString();
      }
    } else {
      dataValue = [
        {
          'boolean': notShowOnDay.toString(),
          'profileCode': _profileCode,
          'date': DateFormat("ddMMyyyy").format(date).toString(),
        },
      ];
    }
    await ManageStorage.createSecureStorage(
      key: name,
      value: jsonEncode(dataValue),
    );
    print(dataValue);
  }
}
