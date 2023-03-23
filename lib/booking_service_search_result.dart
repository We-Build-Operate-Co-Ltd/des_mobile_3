import 'package:des/booking_service_detail.dart';
import 'package:des/models/mock_data.dart';
import 'package:flutter/material.dart';

class BookingServiceSearchResultPage extends StatefulWidget {
  const BookingServiceSearchResultPage({
    super.key,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  final String date;
  final String startTime;
  final String endTime;

  @override
  State<BookingServiceSearchResultPage> createState() =>
      _BookingServiceSearchResultPageState();
}

class _BookingServiceSearchResultPageState
    extends State<BookingServiceSearchResultPage> {
  dynamic modelCenter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: FutureBuilder<List<dynamic>>(
        future: Future.value(modelCenter),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemBuilder: (_, __) => _item(snapshot.data![__]),
              separatorBuilder: (_, __) => SizedBox(height: 10),
              itemCount: snapshot.data!.length,
            );
          }
          return Container();
        },
      ),
    );
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingServiceDetailPage(
            code: model['code'],
            date: widget.date,
            startTime: widget.startTime,
            endTime: widget.endTime,
          ),
        ),
      ),
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
                  '${model['title']}',
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
                    '${model['count']} เครื่อง',
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
    );
  }

  @override
  void initState() {
    super.initState();
    modelCenter = MockBookingData.center();
  }
}
