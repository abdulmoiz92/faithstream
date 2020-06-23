import 'package:faithstream/allposts/components/one_post.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllPosts extends StatelessWidget {
  List<Blog> allBlogs;
  List<TPost> allTrendingPosts;

  AllPosts({this.allBlogs,this.allTrendingPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1,
            child: allBlogs != null ? OnePost(singleBlog: allBlogs,) : OnePost(trendingPost: allTrendingPosts,),
          ),
    );
  }

}