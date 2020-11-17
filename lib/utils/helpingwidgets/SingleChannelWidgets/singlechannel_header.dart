import 'package:faithstream/model/channel.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class SingleChannelHeader extends StatefulWidget {
  final BoxConstraints constraints;
  Channel channel;
  final String userToken;
  final String memberId;

  SingleChannelHeader(this.constraints,
      {this.channel, this.userToken, this.memberId});

  @override
  _SingleChannelHeaderState createState() => _SingleChannelHeaderState();
}

class _SingleChannelHeaderState extends State<SingleChannelHeader> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  bool waiting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: widget.channel.channelBg == null
                  ? AssetImage("assets/images/astrounat.png")
                  : NetworkImage(widget.channel.channelBg),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.darken))),
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.constraints.maxHeight * 0.05,
            bottom: widget.constraints.maxHeight * 0.05,
            left: widget.constraints.maxWidth * 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                          image: widget.channel.authorImage == null
                              ? AssetImage("assets/images/test.jpeg")
                              : NetworkImage(widget.channel.authorImage),
                          fit: BoxFit.fill)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.channel.channelName == null
                            ? ""
                            : widget.channel.channelName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Videos: ${widget.channel.numOfVideos} | Subscribers: ${widget.channel.numOfSubscribers}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      waiting == true
                          ? Container(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Container(
                                width: widget.constraints.maxWidth * 0.3,
                                color: Colors.red,
                                padding: EdgeInsets.all(8.0),
                                child: buildIconText(
                                    context,
                                    widget.channel.status == 0
                                        ? "Subscribe"
                                        : "Unsubscribe",
                                    widget.channel.status == 0
                                        ? Icons.notifications
                                        : Icons.notifications_active,
                                    4.0,
                                    Colors.white,
                                    onTap: widget.channel.status == 0
                                        ? () {
                                            setState(() {
                                              widget.channel.approvalRequired ==
                                                      true
                                                  ? widget.channel.setStatus = 1
                                                  : widget.channel.setStatus =
                                                      2;
                                              FutureBuilder(
                                                future: subscribeChannel(
                                                    context,
                                                    widget.userToken,
                                                    widget.memberId,
                                                    widget.channel),
                                                builder: (cntx, snapshot) {
                                                  setState(() {
                                                    snapshot.connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? waiting = true
                                                        : waiting = false;
                                                  });
                                                },
                                              );
                                            });
                                          }
                                        : () {
                                            setState(() {
                                              widget.channel.setStatus = 0;
                                              FutureBuilder(
                                                future: unSubscribeChannel(
                                                    context,
                                                    widget.userToken,
                                                    widget.memberId,
                                                    widget.channel),
                                                builder: (cntx, snapshot) {
                                                  setState(() {
                                                    snapshot.connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? waiting = true
                                                        : waiting = false;
                                                  });
                                                },
                                              );
                                            });
                                          }),
                              ),
                            ),
                      if (widget.channel.status == 1)
                        Text(
                          "Pending",
                          style: TextStyle(color: Colors.yellow),
                        ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
