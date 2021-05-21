import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners();
  }

  Future login() async{
    isSigningIn = true;

    final user = await googleSignIn.signIn();
    if(user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      isSigningIn = false;
    }
  }

  void logout() async {
    isSigningIn = true;
    await googleSignIn.disconnect();
    isSigningIn = false;
    FirebaseAuth.instance.signOut();
  }
}