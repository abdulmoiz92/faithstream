import 'package:faithstream/singlepost/single_channel.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/material.dart';

class ChannelInfoWidget extends StatelessWidget {
  final String authorName;
  final String authorImage;
  final String numOfSubscribers;
  final BoxConstraints constraints;
  final int channelId;

  ChannelInfoWidget(this.authorImage, this.authorName, this.numOfSubscribers,
      this.constraints,
      {this.channelId});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (cntx) => SingleChannel(channelId)));
          },
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  image: authorImage == null
                      ? AssetImage("assets/images/test.jpeg")
                      : NetworkImage(authorImage),
                  fit: BoxFit.fill),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: constraints.maxWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (cntx) => SingleChannel(channelId)));
                  },
                  child: Text(authorName,
                      style: kTitleText.copyWith(fontSize: 15))),
              SizedBox(
                height: constraints.maxHeight * 0.01,
              ),
              Text("$numOfSubscribers Subscribers",
                  textAlign: TextAlign.left,
                  style: kLabelText.copyWith(fontSize: 13)),
            ],
          ),
        )
      ],
    );
  }
}
