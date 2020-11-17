import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/utils/helpingwidgets/TrendingWidgets/video/trending_video_widgets.dart';
import 'package:flutter/material.dart';

import '../trending_ending_icons.dart';

class TrendingVideoPostWidget extends StatelessWidget {
  final List<TPost> trendingPosts;
  final int index;
  final BoxConstraints constraints;

  TrendingVideoPostWidget(this.trendingPosts,this.index,this.constraints);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: trendingPosts[index].image != null
              ? VideoNetworkWidget(trendingPosts,index,constraints): Center(
            child: VideoAssetWidget(constraints),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            top: constraints.maxHeight * 0.02,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.03),
          child: Text(trendingPosts[index].title,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        EndingIcons(trendingPosts,index,constraints),
      ],
    );
  }
}
