import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/app/services/Auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  final AuthBase auth;
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    this._isLoadingController.close();
  }

  void _setIsLoading(bool isLeading) => _isLoadingController.add(isLeading);

  Future<User> _signIn(Future<User> Function() singInMethod) async {
    try {
      _setIsLoading(true);
      return await singInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
