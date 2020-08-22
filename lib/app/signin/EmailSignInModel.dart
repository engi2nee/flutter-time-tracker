import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter/app/signin/Validators.dart';

enum EmailSignInFormType { SIGN_IN, REGISTER }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.SIGN_IN,
      this.isLoading = false,
      this.submitted = false});

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;
  String get primaryButtonText {
    return formType == EmailSignInFormType.SIGN_IN
        ? "Sign in"
        : "Create an account";
  }

  String get secondryButtonText {
    return formType == EmailSignInFormType.SIGN_IN
        ? "Need an account? Register"
        : "Have an account? Sign in";
  }

  bool get submitEnabled {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorTest : null;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorTest : null;
  }

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    return EmailSignInModel(
        email: email ?? this.email,
        password: password ?? this.password,
        formType: formType ?? this.formType,
        isLoading: isLoading ?? this.isLoading,
        submitted: submitted ?? this.submitted);
  }
}
