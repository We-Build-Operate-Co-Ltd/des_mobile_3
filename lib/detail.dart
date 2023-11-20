import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/main.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/image_viewer.dart';
import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:html/parser.dart' show parse;
import 'dart:ui' as ui show ImageFilter;
import 'build_modal_connection_in_progress.dart';
import 'config.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  const DetailPage({
    Key? key,
    required this.slug,
    this.checkNotiPage = false,
    this.model,
  }) : super(key: key);

  final String slug;
  final dynamic model;
  final bool checkNotiPage;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> _gallery = [];
  String _imageSelected = '';
  Color colorTheme = Colors.transparent;
  Color backgroundTheme = Colors.transparent;
  Color buttonTheme = Colors.transparent;
  Color textTheme = Colors.transparent;
  Future<dynamic>? _futureModel;
  final _scController = ScrollController();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundTheme,
        appBar: AppBar(
          backgroundColor: backgroundTheme,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            height: 60 + MediaQuery.of(context).padding.top,
            color: backgroundTheme,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 15,
              right: 15,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  _backButton(context),
                  if (widget.slug == 'bookingPage')
                    Expanded(
                      child: Text(
                        'รายละเอียด',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textTheme,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ),
        body: _buildContentMainPage(widget.model)
        // widget.slug == 'bookingPage'
        //     ? _buildContentBookingPage(widget.model)
        //     : ListView(
        //         shrinkWrap: true,
        //         children: [
        //           SizedBox(height: 10),
        //           Stack(
        //             children: [
        //               widget.checkNotiPage != true
        //                   ? _buildContent(widget.model)
        //                   : widget.slug != 'mainPage' &&
        //                           widget.slug != 'bookingPage'
        //                       ? FutureBuilder(
        //                           future: _futureModel,
        //                           builder: (_, snapshot) {
        //                             if (snapshot.hasData) {
        //                               return _buildContent(snapshot.data);
        //                             } else if (snapshot.hasError) {
        //                               return Container(
        //                                 alignment: Alignment.center,
        //                                 height: 200,
        //                                 width: double.infinity,
        //                                 child: Text(
        //                                   'Network ขัดข้อง',
        //                                   style: TextStyle(
        //                                     fontSize: 18,
        //                                     fontFamily: 'Kanit',
        //                                     color: Color.fromRGBO(0, 0, 0, 0.6),
        //                                   ),
        //                                 ),
        //                               );
        //                             } else {
        //                               return Center(
        //                                 child: CircularProgressIndicator(),
        //                               );
        //                             }
        //                           },
        //                         )
        //                       : _buildContentMainPage(widget.model),
        //             ],
        //           ),
        //         ],
        //       ),
        );
  }

  Widget _buildContent(dynamic model) {
    return ListView(
      shrinkWrap: true, // 1st add
      physics: const ClampingScrollPhysics(), // 2nd
      children: [
        InkWell(
          onTap: () {
            int index =
                [widget.model['imageUrl'], ..._gallery].indexOf(_imageSelected);
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return ImageViewer(
                  initialIndex: index,
                  imageProviders: [widget.model['imageUrl']]
                      .map<ImageProvider<Object>>((e) => NetworkImage(e))
                      .toList(),
                );
              },
            );
          },
          child: Container(
            height: 194,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17.5),
              child: CachedNetworkImage(
                imageUrl: _imageSelected,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(right: 50, top: 10),
          child: Text(
            model?['title'] ?? '',
            style: TextStyle(
              color: textTheme,
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: buttonTheme,
                  borderRadius: BorderRadius.circular(12.5),
                  border: Border.all(color: colorTheme),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.access_time_outlined,
                      size: 10,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '3 ชั่วโมง',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: buttonTheme,
                  borderRadius: BorderRadius.circular(12.5),
                  border: Border.all(color: colorTheme),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/book.png',
                      height: 10,
                      width: 8.41,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '4 บทเรียน',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              InkWell(
                onTap: () => _callShare(model),
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: buttonTheme,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: colorTheme),
                  ),
                  child: Image.asset(
                    'assets/images/share.png',
                    width: 14.83,
                    height: 13.38,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Text(
            'รายละเอียด',
            style: TextStyle(
              color: textTheme,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            useSafeArea: false,
            barrierColor: Colors.transparent,
            builder: (_) => Material(
              color: Color.fromARGB(0, 255, 255, 255),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xD953327A)
                      : Colors.black,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    right: 10,
                    bottom: 5,
                    left: 10,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: FadingEdgeScrollView.fromScrollView(
                          child: ListView(
                            controller: _scController,
                            padding: EdgeInsets.zero,
                            children: [
                              SizedBox(height: 40),
                              Center(
                                child: Text(
                                  'รายละเอียด',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Colors.white
                                        : textTheme,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Html(
                                data: '${model?['description'] ?? ''}',
                                style: {
                                  'body': Style(
                                    color: MyApp.themeNotifier.value ==
                                            ThemeModeThird.light
                                        ? Colors.white
                                        : textTheme,
                                  ),
                                },
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: buttonTheme,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: colorTheme),
                            ),
                            child: Image.asset(
                              'assets/images/close_noti_list.png',
                              color: Colors.white,
                              height: 23.15,
                              width: 23.15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 38),
                    ],
                  ),
                ),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                ),
                child: Text(
                  '${parseHtmlString(model?['description'] ?? '')}',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorTheme,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 4,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                ),
                child: Text(
                  'อ่านทั้งหมด',
                  style: TextStyle(
                    color: textTheme,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const SizedBox(height: 85),
        InkWell(
          onTap: () {
            buildModalConnectionInProgress(context);
          },
          child: Container(
            height: 45,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: buttonTheme,
              borderRadius: BorderRadius.circular(22.5),
              border: Border.all(color: colorTheme),
            ),
            child: Text(
              'เริ่มเรียน',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildContentMainPage(dynamic model) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true, // 1st add
      physics: const ClampingScrollPhysics(), // 2nd
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: '${model?['img_url'] ?? ''}',
            // height: 30,
            width: 30,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/logo.png'),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(right: 50, top: 10),
          child: Text(
            model?['name'] ?? '',
            style: TextStyle(
              color: textTheme,
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(height: 10),
        Row(
          children: [
            CachedNetworkImage(
              imageUrl: '${model?['imageUrlCreateBy'] ?? ''}',
              height: 30,
              width: 30,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/logo.png',
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            )

            // Container(
            //   padding: const EdgeInsets.all(10),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         '${model['createBy'] ?? ''}',
            //         style: TextStyle(
            //           color: textTheme,
            //           fontSize: 15,
            //           fontFamily: 'Kanit',
            //         ),
            //       ),
            //       Text(
            //         '${dateStringToDateStringFormatV2(model['createDate'])}',
            //         style: TextStyle(
            //           color: textTheme,
            //           fontSize: 10,
            //           fontFamily: 'Kanit',
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'รายละเอียด',
          style: TextStyle(
              color: textTheme,
              fontSize: 15,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Text(
          '${model?['details'] ?? ''}',
          style: TextStyle(
            color: Color(0xFF707070),
            fontSize: 13,
            fontFamily: 'Kanit',
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 4,
        ),
        SizedBox(height: 5),
        Text(
          'อ่านทั้งหมด',
          style: TextStyle(
              color: textTheme,
              fontSize: 13,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500),
        ),
        // Html(
        //   data: model['description'],
        //   style: {
        //     "body": Style(
        //       color: textTheme,
        //       maxLines: 4,
        //       textOverflow: TextOverflow.ellipsis,
        //     ),
        //   },
        // ),
      ],
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

  Widget _buildContentBookingPage(dynamic model) {
    return ListView(
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            model?['title'] ?? '',
            style: TextStyle(
              color: textTheme,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(
                'assets/images/event_detail.png',
                color: MyApp.themeNotifier.value == ThemeModeThird.light
                    ? Color(0xFFB325F8)
                    : textTheme,
                height: 10,
                width: 10,
              ),
              SizedBox(width: 5),
              Text(
                '${timeString(model['docTime'])} น.',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8)
                      : textTheme,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Html(
            data: model?['description'] ?? '',
            style: {
              "body": Style(
                color: textTheme,
                // maxLines: 4,
                // textOverflow: TextOverflow.ellipsis,
              ),
            },
          ),
        ),
      ],
    );
  }

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
    _imageSelected = widget.model['imageUrl'] ?? '';
    if (widget.slug != 'mainPage' &&
        widget.slug != 'mock' &&
        widget.slug != 'bookingPage' &&
        widget.slug != 'certificatePage') {
      _read();
      _galleryRead();
    }
    super.initState();
  }

  void _read() async {
    Response<dynamic> result = await Dio()
        .post('$server/de-api/m/${widget.slug}/read', data: {
      'code': widget.checkNotiPage
          ? widget.model['reference']
          : widget.model['code']
    });
    var model;
    if (result.statusCode == 200) {
      if (result.data['status'] == 'S') {
        model = result.data['objectData'][0];
        _futureModel = Future.value(model);
        setState(() {
          _imageSelected = model['imageUrl'];
        });
      }
    }
    setState(() {});
  }

  void _galleryRead() async {
    Response<dynamic> response;
    try {
      response = await Dio()
          .post('$server/de-api/m/${widget.slug}/gallery/read', data: {
        'code': widget.checkNotiPage
            ? widget.model['reference']
            : widget.model['code']
      });
    } catch (ex) {
      throw Exception();
    }
    var result = response.data;
    List<String> listImage = [];
    result['objectData'].map((e) => listImage.add(e['imageUrl'])).toList();
    setState(() {
      _gallery = listImage;
    });
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Future<void> _callShare(param) async {
    await FlutterShare.share(
        title: 'DES ดิจิทัลชุมชน',
        text: '''📚🔖ขอเชิญชวนร่วม คลาสเรียนเพื่อการเรียนรู้ ดิจิทัลชุมชน หัวข้อ
"${param['title']}"
🚩🚩 🚩🚩''',
        linkUrl: param['imageUrl'],
        chooserTitle: 'Example Chooser Title');
  }
}
