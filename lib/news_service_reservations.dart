import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class NewsServiceReservationsPage extends StatefulWidget {
  const NewsServiceReservationsPage({
    Key? key,
    this.url,
    this.code,
    this.model,
    this.urlComment,
    this.urlGallery,
  }) : super(key: key);

  final String? url;
  final String? code;
  final dynamic model;
  final String? urlComment;
  final String? urlGallery;

  @override
  State<NewsServiceReservationsPage> createState() =>
      _NewsServiceReservationsState();
}

class _NewsServiceReservationsState extends State<NewsServiceReservationsPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  dynamic modelData = {
    'title': 'ศูนย์ดิจิทัลชุมชนเทศบาลตำบลเสาธงหิน',
    'imageUrl': '',
    'createBy': 'เจ้าหน้าที่ศูนย์ดิติทัลชุมชน',
    'description':
        '''หมู่ที่ 5 99/99 ตำบล เสาธงหิน อำเภอบางใหญ่ นนทบุรี 11140''',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              _buildContent(modelData),
              Positioned(
                right: 0,
                child: MaterialButton(
                  minWidth: 29,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: const Color.fromRGBO(194, 223, 249, 1),
                  textColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.close,
                    size: 29,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _buildContent(dynamic model) {
    return ListView(
      shrinkWrap: true, // 1st add
      physics: const ClampingScrollPhysics(), // 2nd
      children: [
        Container(
          padding: const EdgeInsets.only(
            right: 10.0,
            left: 10.0,
          ),
          margin: const EdgeInsets.only(right: 50.0, top: 10.0),
          child: Text(
            model['title'],
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/modern_farmer.png',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['createBy'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        Row(
                          children: const [
                            Text(
                              '26 ธ.ค. 65 | ',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                              ),
                            ),
                            Text(
                              'เข้าชม 9,999 ครั้ง',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Text(model['description']),
        ),
      ],
    );
  }

  void _onLoading() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000));

    // });
    _refreshController.loadComplete();
  }
}
