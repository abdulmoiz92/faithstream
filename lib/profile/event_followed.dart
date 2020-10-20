import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:faithstream/homescreen/components/blog_posts.dart';
import 'package:faithstream/homescreen/components/your_blogs.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Event/blog_event.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsFollowed extends StatefulWidget {
  @override
  _EventsFollowedState createState() => _EventsFollowedState();
}

class _EventsFollowedState extends State<EventsFollowed> {
  String userId;
  String userToken;
  String memberId;
  List<Blog> eventsFollowed = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          "My Events",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(builder: (cntx, constraints) {
        return Container(
          padding: EdgeInsets.only(bottom: 0),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          child: LayoutBuilder(builder: (cntx, constraints) {
            return eventsFollowed == null
                ? Center(child: Text("No Events Followed Yet"))
                : ListView.builder(
                    addAutomaticKeepAlives: false,
                    itemCount: eventsFollowed.length,
                    itemBuilder: (cntx, index) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black87)),
                          padding: EdgeInsets.only(bottom: 16.0),
                          margin: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.02,
                              vertical: constraints.maxHeight * 0.01),
                          width: constraints.maxWidth * 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0,right: 8.0),
                                  child: Text(eventsFollowed[index].time,style: TextStyle(color: Colors.black54),),
                                ),
                              ),
                              EventImagePostWidget(
                                eventsFollowed,
                                index,
                                constraints,
                                memberId,
                                userToken,
                                showButton: false,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical);
          }),
        );
      }),
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
        "$baseAddress/api/Member/GetMemberFollowedEvents/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        for (var u in channelDataJson['data']) {
          if (channelDataJson['data'] == []) continue;

          var postData = u;

          Blog newBlog =
              new Blog(image: null, title: null, date: null, time: null);

          if (mounted)
            if(postData['isPast'] != true)
            setState(() {
              newBlog = new Blog(
                image: postData['image'],
                title: postData['title'],
                date: postData['dateCreated'],
                time: "${compareDate(postData['dateCreated'])} ago",
                eventLocation: postData['location'],
                isPast: postData['isPast'],
                eventTime:
                    "${DateFormat.jm().format(DateTime.parse(postData['startTime']))} | ${DateFormat.jm().format(DateTime.parse(postData['endTime']))} , ${DateFormat.MMMd().format(DateTime.parse(postData['postSchedule']))}",
              );
              eventsFollowed.add(newBlog);
            });
        }
      }
    }
  }
}
