import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cntx,constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/test.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.02),
            child: Text("Owais Khan", style: kTitleText.copyWith(fontSize: 25,color: Colors.white)),
          ),
          Container(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
            child: Text("imranmoiz936@gmail.com", style: kLabelText.copyWith(fontSize: 14,color: Colors.white54)),
          ),
        ],
      );
    });
  }

}