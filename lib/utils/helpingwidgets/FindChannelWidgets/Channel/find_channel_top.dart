import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/material.dart';

class FindChannelTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Find & Subscribe Channel",
          style: kTitleText.copyWith(fontSize: 14),
        ),
        Spacer(),
        RichText(
          text: TextSpan(text: "", children: <TextSpan>[
            TextSpan(
                text: "Step 1: ", style: kTitleText.copyWith(fontSize: 13)),
            TextSpan(
                text: "Select area of intrest",
                style: TextStyle(fontSize: 13, color: Colors.black87))
          ]),
        )
      ],
    );
  }
}
