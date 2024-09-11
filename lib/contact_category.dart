// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:des/contact.dart';
// import 'package:des/models/mock_data.dart';
// import 'package:flutter/material.dart';

// class ContactCategoryPage extends StatefulWidget {
//   const ContactCategoryPage({super.key});

//   @override
//   State<ContactCategoryPage> createState() => _ContactCategoryPageState();
// }

// class _ContactCategoryPageState extends State<ContactCategoryPage> {
//   late TextEditingController _searchController;
//   Future<dynamic>? _futureModel;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           automaticallyImplyLeading: false,
//           flexibleSpace: Container(
//             width: double.infinity,
//             color: Colors.white,
//             padding: EdgeInsets.only(
//               top: MediaQuery.of(context).padding.top + 20,
//               left: 15,
//               right: 15,
//             ),
//             child: Row(
//               children: [
//                 // _backButton(context),
//                 Expanded(
//                   child: Text(
//                     'เบอร์ติดต่อ',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(width: 40),
//               ],
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 35,
//                 child: TextFormField(
//                   controller: _searchController,
//                   keyboardType: TextInputType.text,
//                   onEditingComplete: () {
//                     FocusScope.of(context).unfocus();
//                     _callRead();
//                   },
//                   decoration: _decorationSearch(
//                     context,
//                     hintText: 'ค้นหาเบอร์ติดต่อ',
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'ประเภทเบอร์',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     'ดูทั้งหมด',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF7A4CB1),
//                       decoration: TextDecoration.underline,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: FutureBuilder<dynamic>(
//                   future: _futureModel,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return ListView.separated(
//                         padding: EdgeInsets.only(top: 15),
//                         itemBuilder: (_, index) =>
//                             _buildItem(snapshot.data[index]),
//                         separatorBuilder: (_, __) => const SizedBox(height: 10),
//                         itemCount: snapshot.data.length,
//                       );
//                     } else {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildItem(dynamic model) {
//     return GestureDetector(
//       // onTap: () => Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (_) => ContactPage(
//       //       category: model['code'],
//       //     ),
//       //   ),
//       // ),
//       child: SizedBox(
//         height: 80,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(40),
//               child: CachedNetworkImage(
//                 imageUrl: model['imageUrl'],
//                 height: double.infinity,
//                 width: 80,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     model['title'],
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF7A4CB1),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     model['description'],
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF707070),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               model['total'],
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w400,
//                 color: Color(0xFF707070),
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//             ),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               color: Color(0xFF707070),
//               size: 16,
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _backButton(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child: Image.asset(
//         'assets/images/back.png',
//         height: 40,
//         width: 40,
//       ),
//     );
//   }

//   static InputDecoration _decorationSearch(context, {String hintText = ''}) =>
//       InputDecoration(
//         label: Text(hintText),
//         labelStyle: const TextStyle(
//           color: Color(0xFF707070),
//           fontSize: 12,
//         ),
//         // hintText: hintText,
//         filled: true,
//         fillColor: Colors.transparent,
//         prefixIcon: Container(
//           padding: EdgeInsets.all(9),
//           child: Image.asset(
//             'assets/images/search.png',
//             color: Color(0xFF707070),
//           ),
//         ),
//         contentPadding: const EdgeInsets.fromLTRB(15.0, 2.0, 2.0, 2.0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20.0),
//           borderSide: BorderSide(color: Theme.of(context).primaryColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20.0),
//           borderSide: BorderSide(color: Theme.of(context).primaryColor),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20.0),
//           borderSide: BorderSide(
//             color: Colors.black.withOpacity(0.2),
//           ),
//         ),
//         errorStyle: const TextStyle(
//           fontWeight: FontWeight.normal,
//           fontSize: 10.0,
//         ),
//       );

//   @override
//   void initState() {
//     _searchController = TextEditingController(text: '');
//     _callRead();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _callRead() async {
//     List<dynamic> data = await MockContact.mockContactCategoryList();
//     var result = data;
//     setState(() {
//       _futureModel = Future.value(result);
//     });
//   }
// }
