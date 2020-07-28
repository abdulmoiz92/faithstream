import 'dart:convert';

import 'package:faithstream/homescreen/home_screen.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingwidgets/findchannel_widgets.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChannelScreen extends StatefulWidget {
  int subCategoryId;
  int subCategoryPrefixesId;

  ChannelScreen({this.subCategoryId, this.subCategoryPrefixesId});

  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  List<Channel> allChannels = [];
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
          "Channels List",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (cntx, constraints) {
          return Container(
            margin: EdgeInsets.only(top: constraints.maxHeight * 0.03),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              children: <Widget>[
                SubscribeChannelTop(constraints),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: constraints.maxHeight * 0.015),
                    width: constraints.maxWidth * 0.9,
                    height: constraints.maxHeight * 0.860,
                    child: ListView.builder(
                        itemCount: allChannels.length,
                        itemBuilder: (cntx, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                bottom: constraints.maxHeight * 0.04),
                            width: constraints.maxWidth * 1,
                            height: constraints.maxHeight * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                    image: allChannels[index].channelBg == null
                                        ? AssetImage("assets/images/model.png")
                                        : NetworkImage(
                                            "${allChannels[index].channelBg}"),
                                    fit: BoxFit.fill,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.76),
                                        BlendMode.darken))),
                            child: SubscribeChannelContent(constraints,allChannels,index,userToken,memberId),
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
    if(mounted)
    checkInternet(context,futureFunction: getChannels());
  }

  Future<void> getChannels() async {
    var ChannelData = await http.get(
        "http://api.faithstreams.net/api/Channel/GetChannelsBySubCategory/${widget.subCategoryId}",
        headers: {"Authorization": "Bearer $userToken"});

    var ChannelDataPrefexies = await http.get(
        "http://api.faithstreams.net/api/Channel/GetChannelsBySubCategoryPrefix/${widget.subCategoryPrefixesId}",
        headers: {"Authorization": "Bearer $userToken"});

    var CategoryDataJson = json.decode(widget.subCategoryId != null
        ? ChannelData.body
        : ChannelDataPrefexies.body);

    for (var ch in CategoryDataJson['data']) {
      var ChannelMemberData = await http.get(
          "http://api.faithstreams.net/api/Member/GetChannelByID/${ch['id']}/$memberId",
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
              prefrence: ch['preference'],);
          if(ChannelMemberDataJson['data']['isSubscribed'] == true) {
            newChannel.isSubscribedSet = true;
          }
          allChannels.add(newChannel);
        });
    }
  }
}
