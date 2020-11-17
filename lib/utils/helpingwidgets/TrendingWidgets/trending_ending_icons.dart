import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndingIcons extends StatelessWidget {
  final List<TPost> trendingPosts;
  final int index;
  final BoxConstraints constraints;

  EndingIcons(this.trendingPosts, this.index, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: constraints.maxWidth * 0.6,
        margin: EdgeInsets.only(top: constraints.maxHeight * 0.02),
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildIconText(context, "${trendingPosts[index].views}",
                Icons.remove_red_eye, 3.0, Colors.black54),
            SizedBox(width: constraints.maxWidth * 0.02),
            buildIconText(
                context,
                "${DateFormat.yMMMd().format(DateTime.parse(trendingPosts[index].date))}",
                Icons.watch_later,
                3.0,
                Colors.black54)
          ],
        ),
      ),
    );
  }
}
