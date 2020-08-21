import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> signOut();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Stream<User> get onAuthStateChanged;
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<User> signInWithEmailAndPassword(String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSingIn = GoogleSignIn();

  User _userFromFireBase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFireBase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFireBase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFireBase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFireBase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFireBase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleAccount = await _googleSingIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return _userFromFireBase(authResult.user);
      } else {
        throw PlatformException(
            code: 'Error_Missing_Google_Auth',
            message: "Missing google auth token");
      }
    } else {
      throw PlatformException(
          code: 'Error_Aborted_By_User', message: "Sign in aborted by user");
    }
  }

  @override
  Future<User> signOut() async {
    await _googleSingIn.signOut();
    await _firebaseAuth.signOut();
  }
}
