import 'package:flutter_line_sdk/flutter_line_sdk.dart';

Future<LoginResult?> loginLine() async {
  try {
    final loginOption = LoginOption(false, 'normal', requestCode: 8192);

    return await LineSDK.instance.login(
      scopes: ["profile", "openid", "email"],
      option: loginOption,
    );
  } catch (e) {
    return null;
  }
}

void logoutLine() {
  LineSDK.instance.logout();
}
