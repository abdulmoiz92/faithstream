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
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritePosts extends StatefulWidget {
  @override
  _FavouritePostsState createState() => _FavouritePostsState();
}

class _FavouritePostsState extends State<FavouritePosts> {
  String userId;
  String userToken;
  String memberId;
  List<Blog> favouriteBlogs = [];
  List<Comment> commentsList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          "Favourite Posts",
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
          child: YourBlogs(Provider.of<BlogProvider>(context).getFavouriteTimeLine,memberId,userToken),
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
    if(mounted) setState(() {
      userId = prefs.getString(sph.user_id);
      userToken = prefs.getString(sph.user_token);
      memberId = prefs.getString(sph.member_id);
    });
    Provider.of<BlogProvider>(context).resetFavourite = [];
    checkInternet(context,futureFunction: getVideos());
  }

  Future<void> getVideos() async {
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Post/GetFavoriteTimeLine/$memberId",
        headers: {"Authorization": "Bearer $userToken"});
    var isFavouriteData = await http.get(
        "http://api.faithstreams.net/api/Post/GetFavoriteTimeLine/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        for (var u in channelDataJson['data']) {
          if(mounted) setState(() {
            commentsList = [];
          });
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
                    eventLocation: postData['event']['location'],
                    eventTime:
                    "${DateFormat.jm().format(DateTime.parse(
                        postData['event']['startTime']))} | ${DateFormat.jm()
                        .format(DateTime.parse(
                        postData['event']['endTime']))} , ${DateFormat.MMMd()
                        .format(
                        DateTime.parse(postData['event']['postSchedule']))}",
                    comments: commentsList,
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
                    comments: commentsList);

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
                  comments: commentsList,
                );

              var isFavouritejsonData = jsonDecode(isFavouriteData.body);
              if(isFavouriteData.body.isNotEmpty)
                if(isFavouritejsonData['data'] != null)
                  for(var fv in isFavouritejsonData['data'] ) {
                    if(fv['id'] == newBlog.postId)
                      newBlog.setIsFavourite = 1;
                  }

              if(u['postLikes'] != [])
                for(var il in u['postLikes']) {
                  if(il['memberID'] == memberId)
                    newBlog.setIsLiked = 1;
                }
            });
            Provider.of<BlogProvider>(context).addFavouriteTimeLine = newBlog;
            setState(() {});
        }
      }
    }
  }
}