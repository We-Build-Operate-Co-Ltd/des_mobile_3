import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/booking_service.dart';
import 'package:des/learning.dart';
import 'package:des/login_first.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/secure_storage.dart';
import 'package:des/user_profile.dart';
import 'package:des/verify_first_step.dart';
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
  late TextEditingController _emailController;
  bool _verified = false;
  final _formKey = GlobalKey<FormState>();

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
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: IndexedStack(
                      index: _currentPage,
                      children: pages,
                    ),
                  ),
                  if (!_verified) const SizedBox(height: 250),
                ],
              ),
              if (!_verified)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      height: 300,
                      padding: EdgeInsets.only(
                        left: 35,
                        right: 35,
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0xFFC5C5C5),
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: ListView(
                        padding: EdgeInsets.only(top: 25),
                        children: [
                          Text(
                            'อีเมลของท่าน',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'กรุณาระบุอีเมลของท่านเพื่อให้เราแนะนำคลาสเรียนที่เหมาะกับท่านในอนาคต',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(decoration: TextDecoration.none),
                              decoration:
                                  _decorationBase(context, hintText: 'อีเมล'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'กรุณากรอกอีเมล';
                                }
                                if (!value.isValidEmail()) {
                                  return '**ตรวจสอบรูปแบบอีเมล';
                                }
                                return null;
                              }),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VerifyFirstStepPage(),
                                  ),
                                );
                                ;
                              }
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color(0xFF7A4CB1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/more_2.png',
                                    width: 14.88,
                                    height: 14.88,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'ดำเนินการต่อ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                )
            ],
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

  Widget _buildBottomNavBar() {
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

  Widget _buildTap(
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

  static InputDecoration _decorationBase(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),

        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(color: Color(0xFFE6B82C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 10.0,
        ),
      );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var pf = await ManageStorage.read('profileCode') ?? '';
      var im = await ManageStorage.read('profileImageUrl') ?? '';
      var value = await ManageStorage.read('profileData') ?? '';
      var profileData = json.decode(value);

      setState(() {
        _profileCode = pf;
        _imageUrl = im;
        _verified = profileData['email'] != null && profileData['email'] != ''
            ? true
            : false;
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

    _emailController = TextEditingController(text: '');

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
    _emailController.dispose();
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
