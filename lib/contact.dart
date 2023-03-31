import 'package:cached_network_image/cached_network_image.dart';
import 'package:des/models/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, required this.category});

  final String category;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late TextEditingController _searchController;
  Future<dynamic>? _futureModel;
  Future<dynamic>? _futureCategoryModel;
  String _categoryCode = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                _backButton(context),
                Expanded(
                  child: Text(
                    'เบอร์ติดต่อ',
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 35,
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    _callRead();
                  },
                  decoration: _decorationSearch(
                    context,
                    hintText: 'ค้นหาเบอร์ติดต่อ',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 25,
                width: double.infinity,
                child: FutureBuilder(
                  future: _futureCategoryModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (_, index) =>
                            _builditemCategory(snapshot.data[index]),
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemCount: snapshot.data.length,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: _futureModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        padding: EdgeInsets.only(top: 15),
                        itemBuilder: (_, index) =>
                            _buildItem(snapshot.data[index]),
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemCount: snapshot.data.length,
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _builditemCategory(dynamic model) {
    bool thisItem = model['code'] == _categoryCode;
    return GestureDetector(
      onTap: () => setState(() {
        _categoryCode = model['code'];
        _callRead();
      }),
      child: Container(
        height: 25,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: thisItem ? Color(0xFFB325F8) : Color(0x1AB325F8),
          borderRadius: BorderRadius.circular(12.5),
        ),
        child: Text(
          model['title'],
          style: TextStyle(
            color: thisItem ? Colors.white : Color(0x80B325F8),
            fontSize: 13,
            fontWeight: thisItem ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(dynamic model) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse('tel:${model['phone']}'),
          mode: LaunchMode.externalApplication),
      child: SizedBox(
        height: 45,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: CachedNetworkImage(
                imageUrl: model['imageUrl'],
                height: double.infinity,
                width: 45,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    model['phone'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7A4CB1),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0xFFEEEEEE),
                      offset: Offset(0, 3),
                    ),
                  ]),
              child: Image.asset(
                'assets/images/phone_purple.png',
                height: 22.7,
                width: 22.7,
              ),
            )
          ],
        ),
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

  static InputDecoration _decorationSearch(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: Container(
          padding: EdgeInsets.all(9),
          child: Image.asset(
            'assets/images/search.png',
            color: Color(0xFF707070),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(15.0, 2.0, 2.0, 2.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  @override
  void initState() {
    _searchController = TextEditingController(text: '');
    _categoryCode = widget.category;
    _callReadCategory();
    _callRead();
    super.initState();
  }

  void _callReadCategory() async {
    dynamic data = await MockContact.mockContactCategoryList();
    setState(() {
      _futureCategoryModel = Future.value(data);
    });
  }

  void _callRead() async {
    List<dynamic> data = await MockContact.mockContactList();
    var result = data;
    if (_categoryCode.isNotEmpty)
      result = await data
          .where((dynamic e) => e['category'] == _categoryCode)
          .toList();
    // if (_searchController.text.isNotEmpty) {
    //   result = await result
    //       .where((dynamic e) => e['title'] == _searchController.text)
    //       .toList();
    // }

    setState(() {
      _futureModel = Future.value(result);
    });
  }
}
