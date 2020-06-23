import 'package:faithstream/homescreen/components/your_blogs.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrendingPosts extends StatelessWidget {
  final List<TPost> trendingPosts;

  TrendingPosts(@required this.trendingPosts);

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
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: constraints.maxHeight * 0.10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: constraints.maxWidth * 0.4,
                          height: constraints.maxHeight * 0.6,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: trendingPosts[index].image == null
                                    ? AssetImage("assets/images/laptop.png")
                                    : NetworkImage(trendingPosts[index].image),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 8.0, top: 8.0),
                                height: constraints.maxHeight * 0.35,
                                child: Text(trendingPosts[index].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: kTitleText.copyWith(
                                        fontSize:
                                            (constraints.maxWidth * 0.2) / 4.5,
                                        fontWeight: FontWeight.w700,
                                        height: 1.3)),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8.0),
                                height: constraints.maxHeight * 0.25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FittedBox(
                                      child: Text(trendingPosts[index].author,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  (constraints.maxWidth * 0.2) /
                                                      5,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    SizedBox(
                                        height: constraints.maxHeight * 0.02),
                                    Row(
                                      children: <Widget>[
                                        buildIconText(
                                            context,
                                            trendingPosts[index].time,
                                            Icons.watch_later,
                                            2.0,
                                            Colors.black54),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: buildIconText(
                                              context,
                                              trendingPosts[index].views,
                                              Icons.remove_red_eye,
                                              2.0,
                                              Colors.black54),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
    });
  }
}
