import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter/widgets/CustomRaisedButton.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton(
      {@required String text,
      Color color,
      Color textColor,
      VoidCallback onPressed})
      : super(
            child:
                Text(text, style: TextStyle(color: textColor, fontSize: 15.0)),
            color: color,
            onPressed: onPressed);
}
