import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/app/services/Auth.dart';
import 'package:time_tracker_flutter/app/signin/EmailSignInPage.dart';
import 'package:time_tracker_flutter/app/signin/SocialSignInButton.dart';
import 'package:time_tracker_flutter/app/signin/signInButton.dart';
import 'package:time_tracker_flutter/widgets/PlatformExceptionAlertDialog.dart';

import 'SignInManager.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({@required this.isLoading, @required this.signInManager});

  final SignInManager signInManager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (context) => SignInManager(isLoading: isLoading,auth: auth),
          child: Consumer<SignInManager>(
              builder: (context, signInManager, _) => SignInPage(
                    signInManager: signInManager,
                    isLoading: isLoading.value,
                  )),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(title: "Sign in failed", exception: exception)
        .show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await signInManager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    try {
      await signInManager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'Error_Aborted_By_User') {
        print(e.code);
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0, child: _buildHeader()),
          SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black87,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Text(
        'Sign In',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
      );
    }
  }
}
