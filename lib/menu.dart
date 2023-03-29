import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/booking_service.dart';
import 'package:des/learning.dart';
import 'package:des/login_first.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/user_profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:des/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
  String _imageUrl = '';
  bool hiddenMainPopUp = false;
  List<Widget> pages = <Widget>[];

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
      backgroundColor: const Color(0xFFFBFDF8),
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

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    debugPrint('current ${currentBackPressTime.toString()}');
    debugPrint('now ${now.toString()}');
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'กดอีกครั้งเพื่อออก');
      return Future.value(false);
    }
    return Future.value(true);
  }

  // _buildMainPopUp() async {
  //   try {
  //     var response = await Dio()
  //         .post('http://122.155.223.63/td-des-api/m/MainPopup/read', data: {});
  //     var result = response.data;
  //     if (result['status'] == 'S') {
  //       var valueStorage = await ManageStorage.read('mainPopup');
  //       var dataValue = json.decode(valueStorage) ?? null;

  //       var now = new DateTime.now();
  //       DateTime date = new DateTime(now.year, now.month, now.day);

  //       if (dataValue != null) {
  //         var index = dataValue.indexWhere(
  //           (c) =>
  //               // c['username'] == userData.username &&
  //               c['date'].toString() ==
  //                   DateFormat("ddMMyyyy").format(date).toString() &&
  //               c['boolean'] == "true",
  //         );

  //         if (index == -1) {
  //           this.setState(() {
  //             hiddenMainPopUp = false;
  //           });
  //           return showDialog(
  //             barrierDismissible: false, // close outside
  //             context: context,
  //             builder: (_) {
  //               return WillPopScope(
  //                 onWillPop: () {
  //                   return Future.value(false);
  //                 },
  //                 child: MainPopupDialog(
  //                   model: _futureMainPopUp,
  //                   type: 'mainPopup',
  //                 ),
  //               );
  //             },
  //           );
  //         } else {
  //           this.setState(() {
  //             hiddenMainPopUp = true;
  //           });
  //         }
  //       } else {
  //         this.setState(() {
  //           hiddenMainPopUp = false;
  //         });
  //         return showDialog(
  //           barrierDismissible: false, // close outside
  //           context: context,
  //           builder: (_) {
  //             return WillPopScope(
  //               onWillPop: () {
  //                 return Future.value(false);
  //               },
  //               child: MainPopupDialog(
  //                 model: _futureMainPopUp,
  //                 type: 'mainPopup',
  //               ),
  //             );
  //           },
  //         );
  //       }
  //     }
  //   } catch (ex) {}
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var pf = await ManageStorage.read('profileCode') ?? '';
      var im = await ManageStorage.read('profileImageUrl') ?? '';
      _profileCode = pf;
      setState(() {
        _imageUrl = im;
      });

      if (_profileCode.isEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginFirstPage(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });

    homePage = HomePage(changePage: _changePage);
    profilePage = UserProfilePage(changePage: _changePage);

    _callRead();
    pages = <Widget>[
      homePage,
      BookingServicePage(),
      const LearningPage(),
      profilePage,
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        // homePage.getState().onRefresh();
      }
      _currentPage = index;
    });
  }

  _buildBottomNavBar() {
    return Container(
      height: 55 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: Colors.white,
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
          _buildTap(1, 'จองบริการ', 'assets/images/computer.png'),
          _buildTap(2, 'การเรียน', 'assets/images/learning.png'),
          _buildTap(3, 'สมาชิก', _imageUrl, isNetwork: true),
        ],
      ),
    );
  }

  _buildTap(
    int index,
    String title,
    String pathImage, {
    bool isNetwork = false,
    Key? key,
  }) {
    Color color = _currentPage == index
        ? const Color(0xFF7A4CB1)
        : const Color(0xFF707070);
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
                                  child: CachedNetworkImage(
                                    imageUrl: pathImage,
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
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

  _callRead() async {
    // if (token != '' && token != null) {
    //   postDio('${server}m/v2/register/token/create',
    //       {'token': token, 'profileCode': profileCode});
    // }

    setState(() {
      if (_profileCode != '') {
        pages[3] = profilePage;
      }
    });
  }
}
