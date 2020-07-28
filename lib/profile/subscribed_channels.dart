import 'dart:convert';

import 'package:faithstream/model/channel.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscribedChannels extends StatefulWidget {
  @override
  _SubscribedChannelsState createState() => _SubscribedChannelsState();
}

class _SubscribedChannelsState extends State<SubscribedChannels> {
  List<Channel> allSubscribedChannels = [];
  String userToken;
  String memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          "Subscribed Channels",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (cntx, constraints) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    width: constraints.maxWidth * 0.9,
                    height: constraints.maxHeight * (1),
                    child: ListView.builder(
                        itemCount: allSubscribedChannels.length,
                        itemBuilder: (cntx, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                top: index == 0
                                    ? constraints.maxHeight * (0.015 + 0.03)
                                    : 0,
                                bottom: constraints.maxHeight * 0.04),
                            width: constraints.maxWidth * 1,
                            height: constraints.maxHeight * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                    image: allSubscribedChannels[index]
                                                .channelBg ==
                                            null
                                        ? AssetImage("assets/images/model.png")
                                        : NetworkImage(
                                            "${allSubscribedChannels[index].channelBg}"),
                                    fit: BoxFit.fill,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.76),
                                        BlendMode.darken))),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: constraints.maxHeight * 0.04,
                                        horizontal:
                                            constraints.maxWidth * 0.05),
                                    child: buildChannelContent(
                                        context,
                                        allSubscribedChannels[index]
                                            .authorImage,
                                        allSubscribedChannels[index]
                                            .channelName,
                                        index,
                                        allSubscribedChannels),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (allSubscribedChannels[index]
                                                .getIsSubscribed ==
                                            true) {
                                          setState(() {
                                            allSubscribedChannels[index]
                                                .setIsSubscribe(false);
                                          });
                                          unSubscribeChannel(
                                              context,
                                              userToken,
                                              memberId,
                                              allSubscribedChannels[index]);
                                        } else {
                                          setState(() {
                                            allSubscribedChannels[index]
                                                .setIsSubscribe(true);
                                          });
                                          subscribeChannel(
                                              context,
                                              userToken,
                                              memberId,
                                              allSubscribedChannels[index]);
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: constraints.maxWidth * 0.03),
                                        color: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 3.0),
                                                    child: Icon(
                                                      allSubscribedChannels[
                                                                      index]
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
                                                    text: allSubscribedChannels[
                                                                    index]
                                                                .getIsSubscribed ==
                                                            false
                                                        ? "Subscribe"
                                                        : "Unsubscribe",
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if (mounted)
      setState(() {
        userToken = prefs.getString(sph.user_token);
        memberId = prefs.getString(sph.member_id);
      });
    checkInternet(context, futureFunction: getChannels());
  }

  Future<void> getChannels() async {
    var ChannelData = await http.get(
        "http://api.faithstreams.net/api/Member/GetMemberSubscribedChannels/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    var CategoryDataJson = json.decode(ChannelData.body);

    for (var ch in CategoryDataJson['data']) {
      var ChannelMemberData = await http.get(
          "http://api.faithstreams.net/api/Member/GetMemberSubscribedChannels/$memberId",
          headers: {"Authorization": "Bearer $userToken"});

      var ChannelMemberDataJson = json.decode(ChannelMemberData.body);

      if (mounted)
        setState(() {
          Channel newChannel = new Channel(
            id: ch['id'],
            channelBg: ch['banner'],
            authorImage: ch['logo'],
            channelName: ch['name'],
            numOfVideos: ch['numOfVideos'],
            numOfSubscribers: ch['numOfSubscribers'],
            prefrence: ch['preference'],
          );
          newChannel.isSubscribedSet = true;
          allSubscribedChannels.add(newChannel);
        });
    }
  }
}
