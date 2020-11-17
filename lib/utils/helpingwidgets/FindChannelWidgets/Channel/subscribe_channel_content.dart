import 'package:faithstream/model/channel.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/material.dart';

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
