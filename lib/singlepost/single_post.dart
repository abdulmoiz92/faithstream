import 'dart:math';

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/singlepost/components/single_post_content.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleBlogPost extends StatelessWidget {
  Blog singleBlog;
  TPost trendingPost;

  SingleBlogPost({@required this.singleBlog, @required this.trendingPost});

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text("FaithStream"),
    );

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: LayoutBuilder(
          builder: (cntx, constraints) {
            var imageContainer =  Container(
              width: double.infinity,
              height: constraints.maxHeight * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                image: DecorationImage(
                    image: singleBlog != null ? singleBlog.image == null
                        ? AssetImage("assets/images/astrounat.png")
                        : NetworkImage(singleBlog.image) : trendingPost.image == null
                        ? AssetImage("assets/images/astrounat.png")
                        : NetworkImage(trendingPost.image) ,
                    fit: BoxFit.fill),
              ),
            );
            return Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: constraints.maxHeight * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: singleBlog != null ? singleBlog.videoUrl == null ? imageContainer :VideoPlayerScreen(url: singleBlog.videoUrl,) : VideoPlayerScreen(url: trendingPost.videoUrl),
                ),
                Container(
                    width: double.infinity,
                    height: constraints.maxHeight * 0.65,
                    child: trendingPost == null ? SinglePostContent(
                      authorImage: singleBlog.authorImage,
                      authorName: singleBlog.author,
                      authorSubscribers: singleBlog.subscribers,
                      title: singleBlog.title,
                      postViews: singleBlog.views,
                      postedDate: new DateFormat.yMMMd().format(DateTime.parse(singleBlog.date)),
                      postDescription: "Something",
                    ) : SinglePostContent(
                      authorImage: trendingPost.authorImage,
                      authorName: trendingPost.author,
                      authorSubscribers: trendingPost.subscribers,
                      title: trendingPost.title,
                      postViews: trendingPost.views,
                      postedDate: new DateFormat.yMMMd().format(DateTime.parse(trendingPost.date)),
                      postDescription: "Something",
                    )
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


/**/
