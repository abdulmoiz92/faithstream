import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/trendingscreen/trending_posts.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'your_blogs.dart';

class BlogPostsScreen extends StatefulWidget {

  @override
  _BlogPostsScreenState createState() => _BlogPostsScreenState();
}

class _BlogPostsScreenState extends State<BlogPostsScreen> with AutomaticKeepAliveClientMixin<BlogPostsScreen> {

  SharedPrefHelper sph = SharedPrefHelper();

  final List<Blog> allBlogs = [];
  final List<TPost> allTrendingPosts = [];
  List<Comment> commentsList = [];

  List<int> ChannelIds;
  String userId;
  String userToken;
  String memberId;
  @override
  Widget build(BuildContext context) {
   return LayoutBuilder(builder: (cntx, constraints) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.27),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          child: allBlogs.length > 5
              ? YourBlogs(allBlogs)
              : const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
          ),
        ),
      );
    });
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
   if(mounted) setState(() {
      userId = prefs.getString(sph.user_id);
      userToken = prefs.getString(sph.user_token);
      memberId = prefs.getString(sph.member_id);
    });
    checkInternet(context,futureFunction: getVideos());
  }

  Future<void> getVideos() async {
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Post/GetTimeLine2/$memberId",
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

          var commentData = await http.get(
              "http://api.faithstreams.net/api/Post/GetPostComments/${postData['id']}",
              headers: {"Authorization": "Bearer $userToken"});
          if (commentData.body.isNotEmpty) {
            var commentDataJson = json.decode(commentData.body);
            if (commentDataJson['data'] != null) {
              for (var c in commentDataJson['data']) {
                if (commentDataJson['data'] == []) continue;
               if(mounted) setState(() {
                  Comment newComment = new Comment(
                      commentText: c['commentText'],
                      authorName: c['commentedBy'],
                      time: "${_compareDate(c['dateCreated'])} ago");
                  commentsList.add(newComment);
                });
              }
            }
          }

          int imageWidth;
          int imageHeight;

          Image image;

          if(mounted)
          setState(() {
            if(u['postType'] == "Event") image = new Image.network(postData['event']['image'] == null ? "" : postData['event']['image']);
            if (u['postType'] == "Video") image = new Image.network(postData['video']['thumbnail'] == null ? "" : postData['video']['thumbnail']);
            if (u['postType'] == "Image") image = new Image.network(postData['image']['url'] == null ? "" : postData['image']['url']);
            Completer<ui.Image> completer = new Completer<ui.Image>();
            image.image
                .resolve(new ImageConfiguration())
                .addListener(ImageStreamListener((ImageInfo info,bool _) {
               if(mounted)
              completer.complete(info.image);
             if(mounted) setState(() {
                imageWidth = info.image.width;
                imageHeight = info.image.height;
              });
            }));
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

            if (u['postType'] == "Event")
              newBlog = new Blog(
                  postId: postData['id'],
                  postType: postData['postType'],
                  videoUrl: postData['event']['video'] != null
                      ? postData['event']['video']['url']
                      : postData['event']['video'],
                  image: postData['event']['image'],
                  title: postData['title'],
                  author: postData['authorName'],
                  authorImage: postData['authorImage'],
                  date: postData['dateCreated'],
                  time: "${_compareDate(postData['dateCreated'])} ago",
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
                  imageWidth: postData['event']['image'] == null ?  null : imageWidth,
                  imageHeight: postData['event']['image'] == null ? null : imageHeight
              );
            if (u['postType'] == "Video")
              newBlog = new Blog(
                  postId: postData['id'],
                  postType: postData['postType'],
                  videoUrl: postData['video']['url'],
                  image: postData['video']['thumbnail'],
                  title: postData['title'],
                  author: postData['authorName'],
                  authorImage: postData['authorImage'],
                  date: postData['dateCreated'],
                  time: "${_compareDate(postData['dateCreated'])} ago",
                  likes: "${postData['video']['numOfLikes']}",
                  views: "${postData['video']['numOfViews']}",
                  subscribers: "${postData['numOfSubscribers']}",
                  imageWidth: postData['video']['thumbnail'] == null ? null : imageWidth,
                  imageHeight: postData['video']['thumbnail'] == null ? null : imageHeight!= null && imageHeight > 700 ? null : imageHeight,
                  videoDuration: "",
                  comments: commentsList);

            if (u['postType'] == "Image")
              newBlog = new Blog(
                postId: postData['id'],
                postType: postData['postType'],
                videoUrl: null,
                image: postData['image']['url'],
                title: postData['title'],
                author: postData['authorName'],
                authorImage: postData['authorImage'],
                date: postData['dateCreated'],
                time: "${_compareDate(postData['dateCreated'])} ago",
                likes: "${postData['likesCount']}",
                views: null,
                subscribers: "${postData['numOfSubscribers']}",
                imageWidth: imageWidth,
                imageHeight: imageHeight,
                comments: commentsList,
              );

            allBlogs.add(newBlog);
          });
        }
      }
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
  void initState() {
    getData();
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}