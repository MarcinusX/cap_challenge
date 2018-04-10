import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static AuthService instance = new AuthService._();

  AuthService._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FacebookLogin _facebookLogin = new FacebookLogin();

  FirebaseUser currentUser;

  Future<FirebaseUser> loadCurrentUser() async {
    currentUser = await _firebaseAuth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> loginWithGoogle() async {
    GoogleSignInAccount googleUser = _googleSignIn.currentUser;
    if (googleUser == null) {
      googleUser = await _googleSignIn.signInSilently();
    }
    if (googleUser == null) {
      googleUser = await _googleSignIn.signIn();
    }
    if (await loadCurrentUser() == null) {
      GoogleSignInAuthentication credentials = await googleUser.authentication;
      await _firebaseAuth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
      await _firebaseAuth.updateProfile(new UserUpdateInfo()
        ..photoUrl = googleUser.photoUrl
        ..displayName = googleUser.displayName);
    }
    return await loadCurrentUser();
  }

  Future<FirebaseUser> logInWithFacebook() async {
    final FacebookLoginResult result =
    await _facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        await _firebaseAuth.signInWithFacebook(accessToken: accessToken.token);
        return loadCurrentUser();
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        return null;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        return null;
      default:
        return null;
    }
  }

  Future logout() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _facebookLogin.logOut(),
      _firebaseAuth.signOut(),
    ]);
    new Future.delayed(
        const Duration(milliseconds: 200), () => loadCurrentUser());
  }
}
