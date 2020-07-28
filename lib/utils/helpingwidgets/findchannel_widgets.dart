import 'package:faithstream/model/category.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/cupertino.dart';
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

class SubCategoryList extends StatelessWidget {
  final bool mounted;
  final List<Category> allSubCategories;
  final String groupName;
  final int index;
  final BoxConstraints constraints;

  SubCategoryList(this.mounted, this.allSubCategories, this.groupName,
      this.index, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Divider(),
          Container(
            width: constraints.maxWidth * 0.9,
            child: Padding(
              padding: groupName == "religion"
                  ? EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.03)
                  : EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (mounted)
                    Image.network(
                      "${allSubCategories[index].iconUrl}",
                      width: 50,
                      height: 30,
                    ),
                  Padding(
                    padding: groupName == "religion"
                        ? EdgeInsets.all(0)
                        : EdgeInsets.only(top: constraints.maxHeight * 0.03),
                    child: Text("${allSubCategories[index].categoryName}"),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubCategoryPrefixList extends StatelessWidget {
  final bool mounted;
  final List<Category> allSubCategories;
  final int index;
  final BoxConstraints constraints;

  SubCategoryPrefixList(
      this.mounted, this.allSubCategories, this.index, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (mounted)
              Image.network(
                "${allSubCategories[index].iconUrl}",
                width: 50,
                height: 30,
              ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Text("${allSubCategories[index].categoryName}"),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

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

class SubscribeChannelContent extends StatefulWidget {
  final BoxConstraints constraints;
  final List<Channel> allChannels;
  final int index;
  final String userToken;
  final String memberId;

  SubscribeChannelContent(this.constraints, this.allChannels, this.index,
      this.userToken, this.memberId);

  @override
  _SubscribeChannelContentState createState() =>
      _SubscribeChannelContentState();
}

class _SubscribeChannelContentState extends State<SubscribeChannelContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: widget.constraints.maxHeight * 0.04,
                horizontal: widget.constraints.maxWidth * 0.05),
            child: buildChannelContent(
                context,
                widget.allChannels[widget.index].authorImage,
                widget.allChannels[widget.index].channelName,
                widget.index,
                widget.allChannels),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                if (widget.allChannels[widget.index].getIsSubscribed == true) {
                  setState(() {
                    widget.allChannels[widget.index].setIsSubscribe(false);
                  });
                  unSubscribeChannel(context, widget.userToken, widget.memberId,
                      widget.allChannels[widget.index]);
                } else {
                  setState(() {
                    widget.allChannels[widget.index].setIsSubscribe(true);
                  });
                  subscribeChannel(context, widget.userToken, widget.memberId,
                      widget.allChannels[widget.index]);
                }
              },
              child: Container(
                margin:
                    EdgeInsets.only(right: widget.constraints.maxWidth * 0.03),
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(right: 3.0),
                            child: Icon(
                              widget.allChannels[widget.index]
                                          .getIsSubscribed ==
                                      false
                                  ? Icons.notifications
                                  : Icons.done,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextSpan(
                            text: widget.allChannels[widget.index]
                                        .getIsSubscribed ==
                                    false
                                ? "Subscribe"
                                : "Unsubscribe",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
