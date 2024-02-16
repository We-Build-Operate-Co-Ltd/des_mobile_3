import 'package:des/shared/secure_storage.dart';
import 'package:dio/dio.dart';

import 'config.dart';
import 'extension.dart';

class DCCProvider {
  static getImageProfile() async {
    try {
      var profileMe = await ManageStorage.readDynamic('profileMe') ?? '';
      var response = await Dio()
          .get('$ondeURL/api/user/GetImageProfile/${profileMe['userid']}');

      return response.data ?? '';
      // setState(() {
      //   _imageProfile = responseCenter.data;
      // });
    } catch (e) {
      logE('_getImageProfile');
    }
  }
}
