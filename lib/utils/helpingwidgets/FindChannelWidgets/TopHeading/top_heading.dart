import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/material.dart';

class TopHeading extends StatelessWidget {
  final BoxConstraints constraints;
  final String groupName;

  TopHeading(this.constraints, this.groupName);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(
            left: constraints.maxWidth * 0.02,
            top: constraints.maxHeight * 0.025,
            bottom: constraints.maxHeight * 0.025),
        color: Colors.lightBlue.withOpacity(0.3),
        width: constraints.maxWidth * 0.9,
        height: constraints.maxHeight * 0.08,
        child: RichText(
          text: TextSpan(text: "", children: <TextSpan>[
            TextSpan(
                text: "Step 2: ", style: kTitleText.copyWith(fontSize: 13)),
            TextSpan(
                text: "Select $groupName",
                style: TextStyle(fontSize: 13, color: Colors.black87))
          ]),
        ),
      ),
    );
  }
}
