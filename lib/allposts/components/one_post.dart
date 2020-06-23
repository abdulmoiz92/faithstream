import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnePost extends StatelessWidget {
  List<Blog> singleBlog;
  List<TPost> trendingPost;

  OnePost({this.singleBlog, this.trendingPost});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (cntx, constraints) {
        return ListView.builder(
            itemCount:
                singleBlog != null ? singleBlog.length : trendingPost.length,
            itemBuilder: (cntx, index) {
              return Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (cntx) => singleBlog != null
                                ? SingleBlogPost(singleBlog: singleBlog[index])
                                : SingleBlogPost(
                                    trendingPost: trendingPost[index])));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.02),
                    width: constraints.maxWidth * 0.9,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: constraints.maxHeight * 0.02),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: constraints.maxHeight * 0.4,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/astrounat.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: constraints.maxWidth * 0.02),
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.02,
                                  vertical: constraints.maxHeight * 0.02),
                              width: constraints.maxWidth * 0.9,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                      singleBlog != null
                                          ? singleBlog[index].title
                                          : trendingPost[index].title,
                                      style: kTitleText.copyWith(
                                          fontSize:
                                              (constraints.maxHeight * 0.1) /
                                                  3.5)),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.02),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      buildIconText(
                                          context,
                                          singleBlog != null
                                              ? singleBlog[index].time
                                              : trendingPost[index].time,
                                          Icons.watch_later,
                                          2.0,
                                          Colors.blueGrey),
                                      Spacer(),
                                      buildIconText(
                                          context,
                                          singleBlog != null
                                              ? "${singleBlog[index].views} Views"
                                              : "${trendingPost[index].views} Views",
                                          Icons.remove_red_eye,
                                          2.0,
                                          Colors.blueGrey),
                                      Spacer(),
                                      FittedBox(
                                          child: buildIconText(
                                              context,
                                              singleBlog != null
                                                  ? singleBlog[index].author
                                                  : trendingPost[index].author,
                                              Icons.camera,
                                              2.0,
                                              Colors.blueGrey)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
