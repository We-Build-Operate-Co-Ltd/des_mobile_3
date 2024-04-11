import 'package:des/booking_service_detail.dart';
import 'package:des/shared/config.dart';
import 'package:des/shared/extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingServiceSearchResultPage extends StatefulWidget {
  const BookingServiceSearchResultPage({
    super.key,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.search,
  });

  final String date;
  final String startTime;
  final String endTime;
  final String search;

  @override
  State<BookingServiceSearchResultPage> createState() =>
      _BookingServiceSearchResultPageState();
}

class _BookingServiceSearchResultPageState
    extends State<BookingServiceSearchResultPage> {
  List<dynamic> _modelCenter = [];
  List<dynamic> _filterModelCenter = [];
  LoadingBookingStatus _loadingBookingStatus = LoadingBookingStatus.loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              _backButton(context),
              Expanded(
                child: Text(
                  'ผลการค้นหา',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
      ),
      body: _list(),
    );
  }

  _list() {
    if (_loadingBookingStatus == LoadingBookingStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_loadingBookingStatus == LoadingBookingStatus.success) {
      if (_filterModelCenter.length == 0) {
        return Center(
          child: Text('ไม่พบข้อมูล'),
        );
      }
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemBuilder: (_, __) => _item(_filterModelCenter[__]),
        separatorBuilder: (_, __) => SizedBox(height: 10),
        itemCount: _filterModelCenter.length,
      );
    } else {
      return Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _loadingBookingStatus = LoadingBookingStatus.loading;
            });
            _callRead();
          },
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                Icon(Icons.refresh),
                Text('โหลดใหม่'),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Image.asset(
        'assets/images/back.png',
        height: 40,
        width: 40,
      ),
    );
  }

  Widget _item(model) {
    return GestureDetector(
      onTap: () {
        // logWTF(model);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingServiceDetailPage(
              model: model,
              date: widget.date,
              startTime: widget.startTime,
              endTime: widget.endTime,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xFFB325F8).withOpacity(.1),
              ),
              child: Image.asset(
                'assets/images/computer.png',
                width: 30,
                color: Color(0xFF53327A),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model?['centerName'] ?? ''}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFFB325F8).withOpacity(.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '${model?['slotCount'] ?? ''} เครื่อง',
                      style: TextStyle(
                        color: Color(0xFFB325F8),
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(Icons.arrow_forward_ios, size: 16),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _callRead();
  }

  _callRead() async {
    try {
      Response response = await Dio().get('$ondeURL/api/ShowCenter');
      _loadingBookingStatus = LoadingBookingStatus.success;

      // logWTF(response.data);

      setState(() {
        _modelCenter = response.data;
        if (widget.search.isNotEmpty) {
          _filterModelCenter = _modelCenter
              .where(
                (item) => item['centerName'].contains(widget.search),
              )
              .toList();
          ;
        } else {
          _filterModelCenter = _modelCenter;
        }
      });
      // logWTF('search :: ${widget.search}');
    } on DioError catch (e) {
      setState(() => _loadingBookingStatus = LoadingBookingStatus.fail);
      Fluttertoast.showToast(msg: e.response!.data['message']);
    }
  }
}
