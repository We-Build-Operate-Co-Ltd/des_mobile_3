import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/shared/image_viewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  const DetailPage({
    Key? key,
    required this.slug,
    this.model,
  }) : super(key: key);

  final String slug;
  final dynamic model;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> _gallery = [];
  String _imageSelected = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              _buildContent(widget.model),
              Positioned(
                right: 0,
                child: MaterialButton(
                  minWidth: 29,
                  onPressed: () => Navigator.pop(context),
                  color: const Color(0xFF53327A),
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
        InkWell(
          onTap: () {
            int index =
                [widget.model['imageUrl'], ..._gallery].indexOf(_imageSelected);
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return ImageViewer(
                  initialIndex: index,
                  imageProviders: [widget.model['imageUrl'], ..._gallery]
                      .map<ImageProvider<Object>>((e) => NetworkImage(e))
                      .toList(),
                );
              },
            );
          },
          child: Container(
            height: 300,
            width: double.infinity,
            child: ClipRRect(
              child: CachedNetworkImage(
                imageUrl: _imageSelected,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        if (_gallery.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.separated(
              itemCount: [model['imageUrl'], ..._gallery].length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(10),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, __) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.2),
                      width: 0.5,
                    )),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _imageSelected = [model['imageUrl'], ..._gallery][__];
                  }),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: [model['imageUrl'], ..._gallery][__],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
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
                        Text(
                          '26 ธ.ค. 65 | เข้าชม 9,999 ครั้ง',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
            ),
            child: Html(
              data: model['description'],
            )),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _imageSelected = widget.model['imageUrl'];
    if (widget.slug != 'mock') {
      _galleryRead();
    }
  }

  _galleryRead() async {
    Response<dynamic> response;
    try {
      response = await Dio().post(
          'http://122.155.223.63/td-des-api/m/eventcalendar/gallery/read',
          data: {'code': widget.model['code']});
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
}
