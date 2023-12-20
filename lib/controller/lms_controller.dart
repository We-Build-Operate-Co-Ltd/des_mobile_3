import 'package:dio/dio.dart';
import 'package:get/get.dart' as getLib;

import '../shared/config.dart';
import '../shared/extension.dart';

class LMSController extends getLib.GetxController {
  var count = 0.obs;
  void increment() {
    count++;
  }

  List<dynamic> recomendModel = [].obs;

  @override
  void onInit() {
    callRecomendRead();
    super.onInit();
  }

  Future<void> callRecomendRead() async {
    // final dio = Dio();
    // final response =
    //     await dio.get('$serverEndpoint$serverSubFirstEndpoint/opec/rotation/');
    // // print(response);
    // rotations.addAll(response.data['data'][0]);

    // print('-------------------------------------------');

    final dio = Dio();
    FormData formData = new FormData.fromMap({"apikey": apiKeyLMS});
    // map['apikey'] = _api_key;
    try {
      //https://lms.dcc.onde.go.th/api/api/recomend/003138ecf4ad3c45f1b903d72a860181
      //response = await dio.post('${service}api/popular_course', data: formData);
      final response = await dio.post(
        '$serverLMS/recomend/$apiKeyLMS',
        data: formData,
      );
      // logWTF(response.data);
      if (response.data['status']) {
        logWTF('_get_course' + response.data['data']);
        recomendModel.addAll(response.data['data']);
      }
    } catch (e) {}
  }
}
