import 'package:des/main.dart';
import 'package:des/shared/extension.dart';
import 'package:des/shared/theme_data.dart';
import 'package:des/webview_inapp.dart';
import 'package:des/widget/cache_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key, this.model});
  final dynamic model;

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late dynamic model;
  List<String> _gallery = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFCF9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          height: 60 + MediaQuery.of(context).padding.top,
          color: Colors.transparent,
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
                const SizedBox(width: 20),
                Flexible(
                  child: Text(
                    'ข่าวสารและกิจกรรม',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: MyApp.themeNotifier.value == ThemeModeThird.light
                          ? Color(0xFFB325F8)
                          : MyApp.themeNotifier.value == ThemeModeThird.dark
                              ? Colors.white
                              : Color(0xFFFFFD57),
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: CachedImageWidget(
              imageUrl: model['imageUrl'],
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            model['title'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          // const SizedBox(height: 10),
          // Row(
          //   children: [
          //     Image.asset(
          //       'assets/images/calendar.png',
          //       height: 20,
          //       width: 20,
          //       color: const Color(0xFFB3B3B3),
          //     ),
          //     const SizedBox(width: 5),
          //     Expanded(
          //       child: Text(
          //         dateStringToDateStringFormat(model['createDate']),
          //         style: const TextStyle(
          //           fontSize: 12,
          //           fontWeight: FontWeight.w400,
          //           color: Color(0xFFB3B3B3),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 20),
          // HtmlWidget(
          //   model['description'],
          //   onTapUrl: (url) => Future.value(true),
          // ),
          HtmlWidget(
            model['description'] ?? '',
            onTapUrl: (url) async {
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication, // เปิดใน browser
                );
                return true;
              }
              return false;
            },
          ),
          if (_gallery.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'ภาพประกอบ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 98,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    // itemBuilder: (_, __) => _itemGallery(_gallery[__]),
                    itemBuilder: (context, index) =>
                        _itemGallery(_gallery[index], index, context, _gallery),
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemCount: _gallery.length,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 50),
          if ((model['linkUrl'] != null &&
                  model['linkUrl'].toString().isNotEmpty) ||
              (model['fileUrl'] != null &&
                  model['fileUrl'].toString().isNotEmpty))
            InkWell(
              onTap: () {
                if (model['linkUrl'] != null &&
                    model['linkUrl'].toString().isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WebViewInAppPage(
                        url: model['linkUrl'],
                        title: model['title'] ?? '',
                      ),
                    ),
                  );
                } else if (model['fileUrl'] != null &&
                    model['fileUrl'].toString().isNotEmpty) {
                  launchUrl(
                    Uri.parse(model['fileUrl']),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: Container(
                height: 50,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: MyApp.themeNotifier.value == ThemeModeThird.light
                      ? Color(0xFFB325F8)
                      : MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Colors.white
                          : Color(0xFFFFFD57),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    (model['textButton'] != null &&
                            model['textButton'].toString().isNotEmpty)
                        ? model['textButton']
                        : 'ดูเพิ่มเติม',
                    style: TextStyle(
                      color: MyApp.themeNotifier.value == ThemeModeThird.dark
                          ? Color(0xFFB325F8)
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _itemGallery(
      String imageUrl, int index, BuildContext context, List<String> gallery) {
    return GestureDetector(
      onTap: () {
        PageController controller = PageController(initialPage: index);

        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: '',
          barrierColor: Colors.transparent,
          pageBuilder: (_, __, ___) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  PageView.builder(
                    controller: controller,
                    itemCount: gallery.length,
                    itemBuilder: (context, i) {
                      return InteractiveViewer(
                        child: Center(
                          child: Image.network(
                            gallery[i],
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          height: 98,
          width: 98,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  void initState() {
    model = widget.model;
    _galleryRead();
    super.initState();
  }

  void _galleryRead() async {
    dio.Response<dynamic> response;
    try {
      response = await dio.Dio().post(
        'https://decms.dcc.onde.go.th/dcc-api/m/eventcalendar/gallery/read',
        data: {'code': widget.model['code']},
      );
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

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        child: Image.asset(MyApp.themeNotifier.value == ThemeModeThird.light
            ? 'assets/images/back_arrow.png'
            : 'assets/images/2024/back_balckwhite.png'),
      ),
    );
  }
}
