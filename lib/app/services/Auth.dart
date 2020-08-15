import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';


class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> signOut();
  Future<User> signInAnonymously();
}

class Auth implements AuthBase{
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User _userFromFireBase(FirebaseUser user) {
    if (user == null) return null;
    return User(uid: user.uid);
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

  Future<User> signOut() async {
    await _firebaseAuth.signOut();
  }
}
