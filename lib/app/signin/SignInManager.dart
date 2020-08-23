import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/app/services/Auth.dart';

class SignInManager {
  SignInManager({@required this.isLoading, @required this.auth});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() singInMethod) async {
    try {
      isLoading.value = true;
      return await singInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
