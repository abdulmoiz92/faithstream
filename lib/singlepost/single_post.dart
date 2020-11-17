import 'dart:convert';
import 'dart:math';

import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/singlepost/components/single_post_content.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleBlogPost extends StatefulWidget {
  Blog singleBlog;
  TPost trendingPost;

  SingleBlogPost({@required this.singleBlog, @required this.trendingPost});

  @override
  SingleBlogPostState createState() => SingleBlogPostState();
}

class SingleBlogPostState extends State<SingleBlogPost> with AutomaticKeepAliveClientMixin {
  String userToken;
  String memberId;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var orientation = MediaQuery
        .of(context)
        .orientation;
    orientation == Orientation.landscape ? SystemChrome.setEnabledSystemUIOverlays([]) : SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    void _onBackPress(BuildContext context) {
      orientation == Orientation.landscape ? SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) : Navigator.of(context).pop();
      SystemChrome.setPreferredOrientations([]);
    }
    return WillPopScope(
      onWillPop: () {_onBackPress(context);},
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: orientation == Orientation.portrait ? AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          title: Text(
            "Playing Video",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black87, fontSize: 18),
          ),
          backgroundColor: Colors.white,
        ) : null,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: LayoutBuilder(
            builder: (cntx, constraints) {
              return Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    width: double.infinity,
                    height: orientation == Orientation.landscape ? constraints
                        .maxHeight * 1 : constraints.maxHeight * 0.39,
                    child: widget.singleBlog != null
                        ? Hero(
                      tag: "VideoImage",
                      child: VideoPlayerScreen(
                        url: widget.singleBlog.videoUrl,
                        blog: widget.singleBlog,
                      ),
                    )
                        : VideoPlayerScreen(url: widget.trendingPost.videoUrl),
                  ),
                  if(orientation == Orientation.portrait)
                    Container(
                        width: double.infinity,
                        height: constraints.maxHeight * 0.61,
                        child: widget.trendingPost == null
                            ? SinglePostContent(
                          userToken,
                          memberId,
                          blog: widget.singleBlog,
                          channelId: widget.singleBlog.authorId,
                          postId: widget.singleBlog.postId,
                          authorImage: widget.singleBlog.authorImage,
                          authorName: widget.singleBlog.author,
                          authorSubscribers: widget.singleBlog.subscribers,
                          title: widget.singleBlog.title,
                          postViews: widget.singleBlog.views,
                          postedDate: new DateFormat.yMMMd()
                              .format(DateTime.parse(widget.singleBlog.date)),
                          postDescription: "Something",
                        )
                            : SinglePostContent(
                          userToken,
                          memberId,
                          postId: widget.trendingPost.videoId,
                          channelId: widget.trendingPost.channelId,
                          authorImage: widget.trendingPost.authorImage,
                          authorName: widget.trendingPost.author,
                          authorSubscribers: widget.trendingPost.subscribers,
                          title: widget.trendingPost.title,
                          postViews: widget.trendingPost.views,
                          postedDate: new DateFormat.yMMMd()
                              .format(DateTime.parse(widget.trendingPost.date)),
                          postDescription: "Something",
                          comments: widget.trendingPost.videoComments,
                          isTrending: true,
                          trendingPost: widget.trendingPost,
                        )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
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
    widget.trendingPost != null ? Provider.of<BlogProvider>(context).resetTPostComments() : Provider.of<BlogProvider>(context).resetComments();
    widget.trendingPost != null ? getVideoComments() : getComments();
  }

  Future<void> getComments() async {
    var commentData = await http.get(
        "$baseAddress/api/Post/GetPostComments/${widget.singleBlog.postId}",
        headers: {"Authorization": "Bearer $userToken"});
    if (commentData.body.isNotEmpty) {
      var commentDataJson = json.decode(commentData.body);
      if (commentDataJson['data'] != null) {
        if(mounted)
          for (var c in commentDataJson['data']) {
            var userData = await http.get(
                "$baseAddress/api/Member/GetMemberProfile/${c['memberID']}",
                headers: {"Authorization": "Bearer $userToken"});
            if (commentDataJson['data'] == []) continue;
            if(mounted) {
              Comment newComment = new Comment(
                  commentId: c['id'],
                  commentMemberId: c['memberID'],
                  authorImage: json.decode(
                      userData.body)['data']['profileImage'],
                  commentText: c['commentText'],
                  authorName: c['commentedBy'],
                  time: "${compareDate(c['dateCreated'])}");
              Provider.of<BlogProvider>(context).addComment(newComment);
            }
          }
      }
    }
  }

  Future<void> getVideoComments() async {
    var commentData = await http.get(
        "$baseAddress/api/Channel/GetVideoComments/${widget.trendingPost.videoId}",
        headers: {"Authorization": "Bearer $userToken"});
    if (commentData.body.isNotEmpty) {
      var commentDataJson = json.decode(commentData.body);
      if (commentDataJson['data'] != null) {
        if(mounted)
          for (var c in commentDataJson['data']) {
            var userData = await http.get(
                "$baseAddress/api/Member/GetMemberProfile/${c['authorID']}",
                headers: {"Authorization": "Bearer $userToken"});
            if (commentDataJson['data'] == []) continue;
            if(mounted) {
              Comment newComment = new Comment(
                  commentId: c['id'],
                  commentMemberId: c['authorID'],
                  authorImage: json.decode(
                      userData.body)['data']['profileImage'],
                  commentText: c['commentText'],
                  authorName: c['commentedBy'],
                  time: "${compareDate(c['dateCreated'])}");
              Provider.of<BlogProvider>(context).addTPostComment(newComment);
            }
          }
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
