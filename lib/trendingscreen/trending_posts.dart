import 'dart:convert';

import 'package:faithstream/homescreen/components/trending_post.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TrendingPostsScreen extends StatefulWidget {
  @override
  _TrendingPostsScreenState createState() => _TrendingPostsScreenState();
}

class _TrendingPostsScreenState extends State<TrendingPostsScreen>
    with AutomaticKeepAliveClientMixin<TrendingPostsScreen> {
  final List<TPost> allTrendingPosts = [];
  String userId;
  String userToken;
  String memberId;

  @override
  Widget build(BuildContext context) {
   if(mounted) return LayoutBuilder(builder: (cntx, constraints) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.27),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          child: allTrendingPosts.length > 5
              ? TrendingPosts(
                  trendingPosts: allTrendingPosts,
                )
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
        ),
      );
    });
  }

  @override
  void initState() {
    if(mounted)
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
    if(mounted)
    checkInternet(context,futureFunction: getTrendingVideos());
  }

  Future<void> getTrendingVideos() async {
    var trendingVideosData = await http.get(
        "http://api.faithstreams.net/api/Channel/GetTrendingVideos",
        headers: {"Authorization": "Bearer $userToken"});

    var trendingVideosDataJson = json.decode(trendingVideosData.body);

    for (var t in trendingVideosDataJson['data']) {
      int channelId = t['channelID'];
      var channelInfo = await http.get(
          "http://api.faithstreams.net/api/Channel/GetChannelByID/$channelId",
          headers: {"Authorization": "Bearer $userToken"});
      var channelInfoJson = json.decode(channelInfo.body);
      if (mounted)
        setState(() {
          TPost newTPost = new TPost(
              videoUrl: t['url'],
              image: t['thumbnail'],
              title: t['title'],
              author: channelInfoJson['data']['name'],
              date: t['dateUpdated'],
              authorImage: channelInfoJson['data']['logo'],
              likes: "${t['numOfLikes']}",
              subscribers: "${channelInfoJson['data']['numOfSubscribers']}",
              time: _compareDate(t['dateUpdated']),
              views: "${t['numOfViews']}");
          allTrendingPosts.add(newTPost);
        });
    }
  }

  String _compareDate(String dateToCompare) {
    var dateExpression =
        DateTime.now().difference(DateTime.parse(dateToCompare));
    if (dateExpression.inDays == 0) {
      return dateExpression.inHours < 1
          ? "${dateExpression.inSeconds} sec"
          : "${dateExpression.inHours} hrs";
    } else if (dateExpression.inDays >= 1) {
      if (dateExpression.inDays > 6 && dateExpression.inDays <= 29) {
        return "${(dateExpression.inDays / 7).round()} weeks";
      } else if (dateExpression.inDays > 29) {
        return "${(dateExpression.inDays / 30).round()} months";
      } else {
        return "${(dateExpression.inDays)} days";
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
