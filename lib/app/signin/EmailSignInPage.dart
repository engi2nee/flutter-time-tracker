import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/app/services/Auth.dart';
import 'package:time_tracker_flutter/app/signin/EmailSignInFormBlocBased.dart';

import 'EmailSignInFormStateful.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(child: EmailSignInFormBlocBased.create(context)),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
