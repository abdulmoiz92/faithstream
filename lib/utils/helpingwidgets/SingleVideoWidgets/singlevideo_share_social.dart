import 'package:flutter/material.dart';

class ShareOnSocailWidget extends StatelessWidget {
  final BoxConstraints constraints;

  ShareOnSocailWidget(this.constraints);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: constraints.maxWidth * 0.6,
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              "assets/images/facebook.png",
              width: 32,
              height: 32,
            ),
            Spacer(),
            Image.asset(
              "assets/images/twitter.png",
              width: 32,
              height: 32,
            ),
            Spacer(),
            Image.asset(
              "assets/images/google-plus.png",
              width: 32,
              height: 32,
            ),
            Spacer(),
            Image.asset(
              "assets/images/linkedin.png",
              width: 32,
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
