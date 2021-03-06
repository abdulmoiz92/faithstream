import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/utils/helpingwidgets/TrendingWidgets/main/trendingvideo_main_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrendingPosts extends StatelessWidget {
  final List<TPost> trendingPosts;

  TrendingPosts({@required this.trendingPosts});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cntx, constraints) {
      return trendingPosts == null
          ? Text("No Trending Posts")
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: trendingPosts.length,
              itemBuilder: (cntx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (cntx) => SingleBlogPost(
                                  trendingPost: trendingPosts[index],
                                )));
                  },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: constraints.maxHeight * 0.03),
                      width: constraints.maxWidth * 0.95,
                      child: Column(
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(),
                            elevation: 6,
                            child: Column(
                              children: <Widget>[
                                TrendingVideoPostWidget(trendingPosts,index,constraints),
                                SizedBox(height: constraints.maxHeight * 0.03)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
    });
  }
}
