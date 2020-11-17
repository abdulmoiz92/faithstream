import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/material.dart';

class SubscribeChannelTop extends StatelessWidget {
  final BoxConstraints constraints;

  SubscribeChannelTop(this.constraints);

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
        height: constraints.maxHeight * 0.085,
        child: RichText(
          text: TextSpan(text: "", children: [
            WidgetSpan(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Subscribe and tap when done",
                        style: kTitleText.copyWith(fontSize: 13)),
                    Spacer(),
                    Container(
                      color: Colors.red,
                      margin: EdgeInsets.only(right: constraints.maxWidth * 0.02),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Home",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
