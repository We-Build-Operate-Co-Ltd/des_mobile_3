import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  if (loginResult.status == LoginStatus.success) {
    final AccessToken accessToken = loginResult.accessToken!;
    final OAuthCredential credential =
        FacebookAuthProvider.credential(accessToken.tokenString);
    try {
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException {
      // manage Firebase authentication exceptions
      return null;
    } catch (e) {
      // manage other exceptions
      return null;
    }
  } else {
    // login was not successful, for example user cancelled the process
    return null;
  }
}

void logoutFacebook() async {
  await FacebookAuth.instance.logOut();
}
