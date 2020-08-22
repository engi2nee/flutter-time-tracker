import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/app/services/Auth.dart';
import 'package:time_tracker_flutter/app/signin/EmailSignInModel.dart';

class EmailSignInBloc {
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();
  final AuthBase auth;

  EmailSignInBloc({@required this.auth});
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.SIGN_IN) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.SIGN_IN
        ? EmailSignInFormType.REGISTER
        : EmailSignInFormType.SIGN_IN;
    updateWith(
      email: '',
      password: '',
      submitted: false,
      isLoading: false,
      formType: formType,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);
    _modelController.add(_model);
  }
}
