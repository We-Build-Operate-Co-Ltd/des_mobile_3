import 'package:des/shared/theme_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'shared/config.dart';

class FundPage extends StatefulWidget {
  const FundPage({super.key});

  @override
  State<FundPage> createState() => _FundPageState();
}

class _FundPageState extends State<FundPage> {
  dynamic _model = [];
  dynamic _categoryModel = [];

  @override
  void initState() {
    // _callCategoryRead();
    _callRead();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).custom.w_b_b,
      appBar: AppBar(
        backgroundColor: Theme.of(context).custom.w_b_b,
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
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/images/back.png',
                  height: 40,
                  width: 40,
                ),
              ),
              Expanded(
                child: Text(
                  'หาแหล่งทุน',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).custom.b_w_y,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemBuilder: (context, index) => _buildItem(_model[index]),
        itemCount: _model.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
      ),
    );
  }

  _buildItem(dynamic data) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).custom.w_b_b,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/icon.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['annoucement'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).custom.b_w_y,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data['target'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).custom.f70f70_w_fffd57,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['announceDate']
                                .toString()
                                .replaceAll('T00:00:00', ''),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'สนใจเข้าร่วม',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).custom.b325f8_w_fffd57,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _callRead() async {
    Dio dio = new Dio();
    var response = await dio
        .get('http://dcc-portal.webview.co/dcc-api/api/InvestorAnnoucement/');

    setState(() {
      _model = response.data;
    });

    // print(_model.toString());
  }
}
