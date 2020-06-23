import 'dart:convert';
import 'dart:io';

import 'package:faithstream/allposts/all_posts.dart';
import 'package:faithstream/homescreen/components/trending_post.dart';
import 'package:faithstream/homescreen/components/your_blogs.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/profile/profile_main.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPrefHelper sph = SharedPrefHelper();
  String userId;
  String userToken;
  String memberId;

  final List<Blog> _allBlogs = [];

  List<int> ChannelIds;

  final List<TPost> _allTrendingPosts = [];

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: LayoutBuilder(builder: (cntx, constraints) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.03),
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).padding.top),
                Container(
                  margin: EdgeInsets.only(
                    left: constraints.maxWidth * 0.05,
                    right: constraints.maxWidth * 0.03,
                  ),
                  child: buildHeading(
                      context,
                      Text("Blog", style: kTitleText),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (cntx) => ProfileNavigation()));
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: AssetImage("assets/images/test.jpeg"),
                                fit: BoxFit.fill),
                          ),
                          child: null,
                        ),
                      )),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.05,
                ),
                Container(
                    width: double.infinity,
                    height: mediaQuery.size.height * 0.4,
                    child: YourBlogs(_allBlogs)),
                SizedBox(
                  height: mediaQuery.size.height * 0.05,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: constraints.maxWidth * 0.05,
                    right: constraints.maxWidth * 0.03,
                  ),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: buildHeading(
                    context,
                    Text("Trending", style: kTitleText.copyWith(fontSize: 25)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (cntx) => AllPosts(
                                      allTrendingPosts: _allTrendingPosts,
                                    )));
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: constraints.maxWidth * 0.05,
                    right: constraints.maxWidth * 0.03,
                  ),
                  width: double.infinity,
                  height: constraints.maxHeight * 0.3,
                  child: TrendingPosts(_allTrendingPosts),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    setState(() {
      userId = prefs.getString(sph.user_id);
      userToken = prefs.getString(sph.user_token);
      memberId = prefs.getString(sph.member_id);
    });
    getVideos();
    getTrendingVideos();
  }

  Future<void> getVideos() async {
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Member/GetMemberSubscribedChannels/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      for (var u in channelDataJson['data']) {
        int channelId = u['id'];
        var videoData = await http.get(
            "http://api.faithstreams.net/api/Post/GetPostsByChannelID/$channelId",
            headers: {"Authorization": "Bearer $userToken"});

        var videoDataJson = json.decode(videoData.body);
        for (var v in videoDataJson['data']) {
          if (videoDataJson['data'] == []) continue;

          setState(() {
            Blog newBlog = new Blog(
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

            if (v['postType'] == "Event")
              newBlog = new Blog(
                  videoUrl: v['event']['video'] != null
                      ? v['event']['video']['url']
                      : v['event']['video'],
                  image: v['event']['image'],
                  title: v['title'],
                  author: u['name'],
                  authorImage: u['logo'],
                  date: v['dateCreated'],
                  time: _compareDate(v['dateCreated']),
                  likes: "${v['likesCount']}",
                  views: v['event']['video'] != null ? "${v['event']['video']['numOfViews']}" : null,
                  subscribers: "${u['numOfSubscribers']}");

            if (v['postType'] == "Video")
              newBlog = new Blog(
                  videoUrl: v['video']['url'],
                  image: v['video']['thumbnail'],
                  title: v['title'],
                  author: u['name'],
                  authorImage: u['logo'],
                  date: v['dateCreated'],
                  time: _compareDate(v['dateCreated']),
                  likes: "${v['video']['numOfLikes']}",
                  views: "${v['video']['numOfViews']}",
                  subscribers: "${u['numOfSubscribers']}");

            if (v['postType'] == "Image")
              newBlog = new Blog(
                  videoUrl: null,
                  image: v['image']['url'],
                  title: v['title'],
                  author: u['name'],
                  authorImage: u['logo'],
                  date: v['dateCreated'],
                  time: _compareDate(v['dateCreated']),
                  likes: "${v['likesCount']}",
                  views: null,
                  subscribers: "${u['numOfSubscribers']}");

            _allBlogs.add(newBlog);
          });
        }
      }
    }
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
        _allTrendingPosts.add(newTPost);
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
}
