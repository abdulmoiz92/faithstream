import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String image;
  final String name;
  final String email;

  ProfileHeader({@required this.image,@required this.name, @required this.email});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cntx,constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: image == null ? AssetImage(
                    "assets/images/test.jpeg") : NetworkImage("$image"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.05),
            child: Text("$name", style: kTitleText.copyWith(fontSize: 20)),
          ),
          Container(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.02),
            child: Text("$email", style: kLabelText.copyWith(fontSize: 13,color: Colors.black54)),
          ),
        ],
      );
    });
  }

}