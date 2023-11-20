import 'package:des/menu.dart';
import 'package:des/shared/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckVersionPage extends StatefulWidget {
  CheckVersionPage({super.key, this.model});
  late dynamic model;
  @override
  State<CheckVersionPage> createState() => _CheckVersionPageState();
}

class _CheckVersionPageState extends State<CheckVersionPage>
    with TickerProviderStateMixin {
  int _pageSelected = 0;
  int _count = 0;

  late final AnimationController _controllerAnimation = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(6, 0),
    end: const Offset(-2.2, 0),
  ).animate(
    CurvedAnimation(
      parent: _controllerAnimation,
      curve: Curves.elasticOut,
    ),
  );

  late final AnimationController _controllerAnimationDialog =
      AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animationDialog = CurvedAnimation(
      parent: _controllerAnimationDialog,
      curve: Curves.elasticOut,
      reverseCurve: Curves.elasticOut);

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      _controllerAnimation.stop();
      _controllerAnimationDialog.stop();
    });
    Future.delayed(const Duration(seconds: 0), () {
      _dialog();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Color.fromARGB(255, 35, 67, 61).withOpacity(0.66),
          // constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  _update_later() {
    _controllerAnimation.reverse();
    _controllerAnimationDialog.reverse();
    Future.delayed(const Duration(milliseconds: 1020), () {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
      );
    });
  }

  _update_now() {
    _controllerAnimation.reverse();
    _controllerAnimationDialog.reverse();
    Future.delayed(const Duration(milliseconds: 800), () {
      launchUrl(
        Uri.parse(checkIfUrlContainPrefixHttp(widget.model['url'])),
        mode: LaunchMode.externalApplication,
      );
    });
    Future.delayed(const Duration(milliseconds: 1300), () {
      _controllerAnimation.forward();
      _controllerAnimationDialog.forward();
    });
  }

  String checkIfUrlContainPrefixHttp(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    } else {
      return 'http://' + url;
    }
  }

  _dialog() {
    showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Color.fromARGB(255, 35, 67, 61)
          .withOpacity(0.66), // space around dialog
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: _animationDialog,
          child: Dialog(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
            ),
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                // color: Color.fromARGB(255, 35, 67, 61)
                color: Colors.transparent,
              ),
              child: Stack(
                // alignment: Alignment.center,
                // clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 14,
                    right: 24,
                    // left: 0,
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: Image.asset(
                        'assets/images/logo_dialog_chk_version.png',
                        height: 100,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      constraints: const BoxConstraints(
                          maxWidth: 400, maxHeight: 400, minHeight: 200),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                      ),
                      width: double.infinity,
                      height: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 24),
                          // Image.asset(
                          //   'assets/images/otp-success-top.png',
                          //   height: 70,
                          //   width: 70,
                          // ),
                          Text(
                            'มีอัพเดตใหม่',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${widget.model['title']} (v${widget.model['version']})',
                            style: const TextStyle(
                              // color: ThemeColor.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Text(
                            '${widget.model['description']}',
                            style: TextStyle(
                              color: Color(0xFF707070),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 20),

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _update_now();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(45),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: <Color>[
                                          Theme.of(context).primaryColor,
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.8),
                                        ],
                                        tileMode: TileMode.mirror,
                                      ),
                                    ),
                                    child: const Text(
                                      'อัพเดทตอนนี้',
                                      style: TextStyle(
                                          fontSize: 20,
                                          // fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                widget.model['isForce']
                                    ? GestureDetector(
                                        onTap: () {
                                          _update_later();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                          child: const Text(
                                            'ภายหลัง',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff1A7263),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),

                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(36),
                          //   child: Image.asset(
                          //     'assets/images/otp-success-bottom.png',
                          //     width: double.infinity,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Container();
      },
    );
  }
}
