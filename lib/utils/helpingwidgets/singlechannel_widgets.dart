import 'dart:convert';

import 'package:faithstream/homescreen/components/your_blogs.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/model/donation.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../shared_pref_helper.dart';

class SingleChannelHeader extends StatefulWidget {
  final BoxConstraints constraints;
  Channel channel;
  final String userToken;
  final String memberId;

  SingleChannelHeader(this.constraints,{this.channel,this.userToken,this.memberId});

  @override
  _SingleChannelHeaderState createState() => _SingleChannelHeaderState();
}

class _SingleChannelHeaderState extends State<SingleChannelHeader> {
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
                  Colors.black.withOpacity(0.8),
                  BlendMode.darken))),
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
                              ? Image.asset(
                              "assets/images/test.jpeg")
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
                        padding:
                        EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Videos: ${widget.channel.numOfVideos} | Subscribers: ${widget.channel.numOfSubscribers}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 12.0),
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
                              onTap: widget.channel.status == 0 ? () {
                                setState(() {
                                  widget.channel.approvalRequired == true ? widget.channel.setStatus = 1 : widget.channel.setStatus = 2;
                                });
                                subscribeChannel(context,widget.userToken,widget.memberId,widget.channel);
                              } : () {
                                setState(() {
                                  widget.channel.setStatus = 0;
                                });
                                unSubscribeChannel(context, widget.userToken, widget.memberId, widget.channel);
                              }
                          ),
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
}

class SingleChannelWall extends StatefulWidget {
  final int channelId;

  SingleChannelWall(this.channelId);

  @override
  _SingleChannelWallState createState() => _SingleChannelWallState();
}

class _SingleChannelWallState extends State<SingleChannelWall> with AutomaticKeepAliveClientMixin {
  String userToken;
  String memberId;
  List<Blog> wallBlogs = [];
  @override
  Widget build(BuildContext context) {
    return YourBlogs(wallBlogs, memberId, userToken,isSingleChannel: true,);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if(mounted) setState(() {
      userToken = prefs.getString(sph.user_token);
      memberId = prefs.getString(sph.member_id);
    });
    checkInternet(context,futureFunction: getVideos());
  }

  Future<void> getVideos() async {
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Post/GetPostsByChannelID/${widget.channelId}",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        for (var u in channelDataJson['data']) {
          if (channelDataJson['data'] == []) continue;

          var postData = u;

          Blog newBlog = new Blog(
              postId: null,
              postType: null,
              videoUrl: null,
              image: null,
              title: null,
              author: null,
              authorImage: null,
              date: null,
              time: null,
              likes: null,
              views: null,
              subscribers: null);

          if(mounted)
            setState(() {
              List<Donation> donnations = [];

              if(u['denom'] != null) {
                if(u['denom'] != [])
                  for(var d in u['denom']) {
                    Donation newDonation = new Donation(id: d['id'].toString(),channelId: d['channelID'].toString(),denomAmount: d['denomAmount'],denomDescription: d['denomDescription']);
                    donnations.add(newDonation);
                  }
              }

              if (u['postType'] == "Event")
                newBlog = new Blog(
                    postId: postData['id'],
                    postType: postData['postType'],
                    videoUrl: postData['event']['video'] != null
                        ? postData['event']['video']['url']
                        : postData['event']['video'],
                    image: postData['event']['image'],
                    title: postData['title'],
                    authorId: postData['authorID'],
                    author: postData['authorName'],
                    authorImage: postData['authorImage'],
                    date: postData['dateCreated'],
                    time: "${compareDate(postData['dateCreated'])} ago",
                    likes: "${postData['likesCount']}",
                    views: postData['event']['video'] != null
                        ? "${postData['event']['video']['numOfViews']}"
                        : null,
                    subscribers: "${postData['numOfSubscribers']}",
                    eventId: postData['event']['id'],
                    eventLocation: postData['event']['location'],
                    eventTime:
                    "${DateFormat.jm().format(DateTime.parse(
                        postData['event']['startTime']))} | ${DateFormat.jm()
                        .format(DateTime.parse(
                        postData['event']['endTime']))} , ${DateFormat.MMMd()
                        .format(
                        DateTime.parse(postData['event']['postSchedule']))}",
                    isDonationRequired: postData['isDonationRequire'],
                    donations: donnations,
                    isTicketAvailable: postData['event']['isTicketPurchaseRequired'],
                    isPast: postData['event']['isPast']
                );
              if (u['postType'] == "Video")
                newBlog = new Blog(
                    postId: postData['id'],
                    postType: postData['postType'],
                    videoUrl: postData['video']['url'],
                    image: postData['video']['thumbnail'],
                    title: postData['title'],
                    authorId: postData['authorID'],
                    author: postData['authorName'],
                    authorImage: postData['authorImage'],
                    date: postData['dateCreated'],
                    time: "${compareDate(postData['dateCreated'])} ago",
                    likes: "${postData['video']['numOfLikes']}",
                    views: "${postData['video']['numOfViews']}",
                    subscribers: "${postData['numOfSubscribers']}",
                    videoDuration: "",
                    donations: donnations,
                    isDonationRequired: postData['isDonationRequire'],
                    isPaidVideo: postData['video']['isPaidContent'],
                    isPurchased: postData['video']['isPurchased'],
                    videoPrice: postData['video']['price'] == null ? null : double.parse(postData['video']['price']),
                    freeVideoLength: postData['video']['freeVideoLength'] );

              if (u['postType'] == "Image")
                newBlog = new Blog(
                  postId: postData['id'],
                  postType: postData['postType'],
                  videoUrl: null,
                  image: postData['image']['url'],
                  title: postData['title'],
                  authorId: postData['authorID'],
                  author: postData['authorName'],
                  authorImage: postData['authorImage'],
                  date: postData['dateCreated'],
                  time: "${compareDate(postData['dateCreated'])} ago",
                  likes: "${postData['likesCount']}",
                  views: null,
                  subscribers: "${postData['numOfSubscribers']}",
                  isDonationRequired: postData['isDonationRequire'],
                  donations: donnations,
                );

              wallBlogs.add(newBlog);

            });
        }
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void updateKeepAlive() => true;
}

class SingleChannelVideos extends StatefulWidget {
  final int channelId;

  SingleChannelVideos(this.channelId);

  @override
  _SingleChannelVideosState createState() => _SingleChannelVideosState();
}

class _SingleChannelVideosState extends State<SingleChannelVideos> with AutomaticKeepAliveClientMixin {
  String userToken;
  String memberId;
  List<Blog> videosBlogs = [];
  @override
  Widget build(BuildContext context) {
    return YourBlogs(videosBlogs, memberId, userToken,isSingleChannel: true,);
  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if(mounted) setState(() {
      userToken = prefs.getString(sph.user_token);
      memberId = prefs.getString(sph.member_id);
    });
    checkInternet(context,futureFunction: getVideos());
  }

  Future<void> getVideos() async {
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Post/GetAllPostedVideos/${widget.channelId}",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        for (var u in channelDataJson['data']) {
          if (channelDataJson['data'] == []) continue;

          var postData = u;

          Blog newBlog = new Blog(
              postId: null,
              postType: null,
              videoUrl: null,
              image: null,
              title: null,
              author: null,
              authorImage: null,
              date: null,
              time: null,
              likes: null,
              views: null,
              subscribers: null);

          if(mounted)
            setState(() {
              List<Donation> donnations = [];

              if(u['denom'] != null) {
                if(u['denom'] != [])
                  for(var d in u['denom']) {
                    Donation newDonation = new Donation(id: d['id'].toString(),channelId: d['channelID'].toString(),denomAmount: d['denomAmount'],denomDescription: d['denomDescription']);
                    donnations.add(newDonation);
                  }
              }
                newBlog = new Blog(
                    postId: postData['id'],
                    postType: postData['postType'],
                    videoUrl: postData['video']['url'],
                    image: postData['video']['thumbnail'],
                    title: postData['title'],
                    authorId: postData['authorID'],
                    author: postData['authorName'],
                    authorImage: postData['authorImage'],
                    date: postData['dateCreated'],
                    time: "${compareDate(postData['dateCreated'])} ago",
                    likes: "${postData['video']['numOfLikes']}",
                    views: "${postData['video']['numOfViews']}",
                    subscribers: "${postData['numOfSubscribers']}",
                    videoDuration: "",
                    donations: donnations,
                    isDonationRequired: postData['isDonationRequire'],
                    isPaidVideo: postData['video']['isPaidContent'],
                    isPurchased: postData['video']['isPurchased'],
                    videoPrice: postData['video']['price'] == null ? null : double.parse(postData['video']['price']),
                    freeVideoLength: postData['video']['freeVideoLength'] );

              videosBlogs.add(newBlog);
            });
        }
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void updateKeepAlive() => true;
}

class SingleChannelEvents extends StatefulWidget {
  final int channelId;

  SingleChannelEvents(this.channelId);

  @override
  _SingleChannelEventsState createState() => _SingleChannelEventsState();
}

class _SingleChannelEventsState extends State<SingleChannelEvents> with AutomaticKeepAliveClientMixin {
  String userToken;
  String memberId;
  List<Blog> eventBlogs = [];
  @override
  Widget build(BuildContext context) {
    return YourBlogs(eventBlogs, memberId, userToken,isSingleChannel: true);
  }


  @override
  void initState() {
    print(widget.channelId);
    getData();
    super.initState();
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if(mounted) setState(() {
      userToken = prefs.getString(sph.user_token);
      memberId = prefs.getString(sph.member_id);
    });
    checkInternet(context,futureFunction: getVideos());
  }

  Future<void> getVideos() async {
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Post/GetAllPostedEvents/${widget.channelId}",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        for (var u in channelDataJson['data']) {
          if (channelDataJson['data'] == []) continue;

          var postData = u;

          Blog newBlog = new Blog(
              postId: null,
              postType: null,
              videoUrl: null,
              image: null,
              title: null,
              author: null,
              authorImage: null,
              date: null,
              time: null,
              likes: null,
              views: null,
              subscribers: null);

          if(mounted)
            setState(() {
              List<Donation> donnations = [];

              if(u['denom'] != null) {
                if(u['denom'] != [])
                  for(var d in u['denom']) {
                    Donation newDonation = new Donation(id: d['id'].toString(),channelId: d['channelID'].toString(),denomAmount: d['denomAmount'],denomDescription: d['denomDescription']);
                    donnations.add(newDonation);
                  }
              }
              newBlog = new Blog(
                  postId: postData['id'],
                  postType: postData['postType'],
                  videoUrl: postData['event']['video'] != null
                      ? postData['event']['video']['url']
                      : postData['event']['video'],
                  image: postData['event']['image'],
                  title: postData['title'],
                  authorId: postData['authorID'],
                  author: postData['authorName'],
                  authorImage: postData['authorImage'],
                  date: postData['dateCreated'],
                  time: "${compareDate(postData['dateCreated'])} ago",
                  likes: "${postData['likesCount']}",
                  views: postData['event']['video'] != null
                      ? "${postData['event']['video']['numOfViews']}"
                      : null,
                  subscribers: "${postData['numOfSubscribers']}",
                  eventId: postData['event']['id'],
                  eventLocation: postData['event']['location'],
                  eventTime:
                  "${DateFormat.jm().format(DateTime.parse(
                      postData['event']['startTime']))} | ${DateFormat.jm()
                      .format(DateTime.parse(
                      postData['event']['endTime']))} , ${DateFormat.MMMd()
                      .format(
                      DateTime.parse(postData['event']['postSchedule']))}",
                  isDonationRequired: postData['isDonationRequire'],
                  donations: donnations,
                  isTicketAvailable: postData['event']['isTicketPurchaseRequired'],
                  isPast: postData['event']['isPast']
              );
              print(postData);
              eventBlogs.add(newBlog);
            });
        }
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}