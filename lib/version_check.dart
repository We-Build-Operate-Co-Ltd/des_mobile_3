// //Prompt users to update app if there is a new version available
// //Uses url_launcher package

// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:package_info/package_info.dart';
// import 'dart:io' show Platform;

// // ignore: constant_identifier_names
// const APP_STORE_URL = 'https://apps.apple.com/us/app/สช-on-mobile/id1540552791';
// // ignore: constant_identifier_names
// const PLAY_STORE_URL =
//     'https://play.google.com/store/apps/details?id=td.webuild.opec';

// versionCheck(BuildContext context) async {
//   String platform = '';
//   double newVersion = 0.0;

//   //Get Current installed version of app
//   final PackageInfo info = await PackageInfo.fromPlatform();
//   double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));

//   if (Platform.isAndroid) {
//     platform = 'android';
//   } else if (Platform.isIOS) {
//     platform = 'ios';
//   }

//   try {
//     Dio dio = Dio();
//     var data = await postDio(
//       "${server}configulation/read",
//       {
//         "title": "version_app_update",
//         "username": platform,
//       },
//     );

//     if (data != null) {
//       newVersion = double.parse(data['password']);

//       if (newVersion > currentVersion) {
//         _showVersionDialog(context);
//       }
//     }
//   } catch (ex) {
//     return null;
//   }
// }

// //Show Dialog to force user to update
// _showVersionDialog(context) async {
//   await showDialog<String>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       String title = "New Update Available";
//       String message =
//           "There is a newer version of app available please update it now.";
//       String btnLabel = "Update Now";
//       String btnLabelCancel = "Later";
//       return Platform.isIOS
//           ? CupertinoAlertDialog(
//               title: Text(title),
//               content: Text(message),
//               actions: <Widget>[
//                 ElevatedButton(
//                   child: Text(btnLabel),
//                   onPressed: () => launchInWebViewWithJavaScript(APP_STORE_URL),
//                 ),
//                 ElevatedButton(
//                   child: Text(btnLabelCancel),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             )
//           : AlertDialog(
//               title: Text(title),
//               content: Text(message),
//               actions: <Widget>[
//                 ElevatedButton(
//                   child: Text(btnLabel),
//                   onPressed: () =>
//                       launchInWebViewWithJavaScript(PLAY_STORE_URL),
//                 ),
//                 ElevatedButton(
//                   child: Text(btnLabelCancel),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             );
//     },
//   );
// }
