import 'dart:convert';

import 'package:faithstream/homescreen/components/trending_post.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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
          child: Provider.of<BlogProvider>(context).trendingPosts.length > 1
              ? TrendingPosts(
                  trendingPosts: Provider.of<BlogProvider>(context).getAllTPosts,
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
    Provider.of<BlogProvider>(context).resetTrendingVideos();
    if(mounted)
    checkInternet(context,futureFunction: getTrendingVideos());
  }

  Future<void> getTrendingVideos() async {
    var trendingVideosData = await http.get(
        "$baseAddress/api/Channel/GetTrendingVideos",
        headers: {"Authorization": "Bearer $userToken"});

    var trendingVideosDataJson = json.decode(trendingVideosData.body);

    for (var t in trendingVideosDataJson['data']) {
      int channelId = t['channelID'];
      var channelInfo = await http.get(
          "$baseAddress/api/Channel/GetChannelByID/$channelId",
          headers: {"Authorization": "Bearer $userToken"});
      var channelInfoJson = json.decode(channelInfo.body);
      if (mounted) {
        TPost newTPost = new TPost(
            id: t['id'],
            channelId: t['channelID'],
            videoId: t['videoID'],
            videoUrl: t['url'],
            image: t['thumbnail'],
            title: t['title'],
            author: channelInfoJson['data']['name'],
            date: t['dateUpdated'],
            authorImage: channelInfoJson['data']['logo'],
            likes: "${t['numOfLikes']}",
            subscribers: "${channelInfoJson['data']['numOfSubscribers']}",
            time: compareDate(t['dateUpdated']),
            isPaid: t['isPaidContent'],
            isPurchased: t['isPurchased'],
            views: "${t['numOfViews']}");
        Provider
            .of<BlogProvider>(context)
            .addTrendingPost = newTPost;
        setState(() {});
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
