import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInExtension {
  late GoogleSignIn _googleSignIn;
  GoogleSignInExtension() {
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }
  Future<GoogleSignInAccount?> login() async {
    final checkGoogleValue = await _googleSignIn.signIn();
    return checkGoogleValue;
  }
  Future<void> logout() async {
    await _googleSignIn.signOut();
  }
}
