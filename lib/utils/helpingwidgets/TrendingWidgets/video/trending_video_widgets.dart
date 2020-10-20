import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:flutter/material.dart';

import '../trending_button_duration.dart';

class VideoNetworkWidget extends StatelessWidget {
  final List<TPost> trendingPosts;
  final int index;
  final BoxConstraints constraints;

  VideoNetworkWidget(this.trendingPosts, this.index, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth * 0.9,
      height: constraints.maxHeight * 0.4,
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (cntx) => SingleBlogPost(
                      trendingPost: trendingPosts[index],
                    ))),
        child: Container(
          width: constraints.maxWidth * 0.95,
          height: constraints.maxHeight * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: trendingPosts[index].image == null
                    ? AssetImage("assets/images/laptop.png")
                    : NetworkImage(trendingPosts[index].image),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.darken)),
          ),
          child: Container(
            height: double.infinity,
            child: ButtonAndDuration(),
          ),
        ),
      ),
    );
  }
}

class VideoAssetWidget extends StatelessWidget {
  final BoxConstraints constraints;

  VideoAssetWidget(this.constraints);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth * 0.95,
      height: constraints.maxHeight * 0.4,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/laptop.png"),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.darken)),
      ),
      child: Center(
        child: ButtonAndDuration(),
      ),
    );
  }
}
