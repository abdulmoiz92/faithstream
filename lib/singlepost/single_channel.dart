import 'dart:convert';

import 'package:faithstream/model/channel.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/helpingwidgets/singlechannel_widgets.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SingleChannel extends StatefulWidget {
  final int channelId;

  SingleChannel(this.channelId);

  @override
  _SingleChannelState createState() => _SingleChannelState();
}

class _SingleChannelState extends State<SingleChannel> {
  String userId;
  String userToken;
  String memberId;

  Channel channel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          "Channel",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 3,
        child: LayoutBuilder(
          builder: (cntx, constraints) {
            return channel == null
                ? Center(
                    child: Container(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  ))
                : Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SingleChannelHeader(
                            constraints,
                            channel: channel,
                            userToken: userToken,
                            memberId: memberId,
                          ),
                          TabBar(
                            indicatorColor: Colors.transparent,
                            unselectedLabelColor: Colors.black87,
                            labelColor: Colors.red,
                            tabs: <Widget>[
                              Tab(
                                icon: Icon(Icons.timeline),
                                text: "Wall",
                              ),
                              Tab(
                                icon: Icon(Icons.videocam),
                                text: "Videos",
                              ),
                              Tab(
                                icon: Icon(Icons.event),
                                text: "Events",
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: constraints.maxHeight * 0.8,
                            child: TabBarView(
                              children: <Widget>[
                                SingleChannelWall(widget.channelId),
                                SingleChannelVideos(widget.channelId),
                                SingleChannelEvents(widget.channelId),
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
          },
        ),
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
        userId = prefs.getString(sph.user_id);
        userToken = prefs.getString(sph.user_token);
        memberId = prefs.getString(sph.member_id);
      });
    checkInternet(context, futureFunction: getVideos());
  }

  Future<void> getVideos() async {
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Member/GetChannelByID/${widget.channelId}/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      print(channelDataJson['data']);
      if (channelDataJson['data'] != null) {
        var data = channelDataJson['data'];

        if (mounted)
          setState(() {
            channel = new Channel(
                id: widget.channelId,
                authorImage: data['logo'],
                channelBg: data['banner'],
                channelName: data['name'],
                prefrence: data['preference'],
                numOfVideos: data['numOfVideos'],
                numOfSubscribers: data['numOfSubscribers'],
                status: data['subscriptionStatusID'],
                approvalRequired: data['subscriptionApprovalRequired']);
          });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
