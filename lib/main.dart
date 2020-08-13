import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/app/signin/SignInPage.dart';

void main() {
  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: SignInPage(),
    );
  }
}
