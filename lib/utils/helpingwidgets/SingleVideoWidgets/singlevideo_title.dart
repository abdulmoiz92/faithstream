import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/material.dart';

class TitleAndLikes extends StatelessWidget {
  final String title;
  final String postViews;
  final String postLikes;
  final BoxConstraints constraints;
  final Blog blog;
  final TPost trendingPost;

  TitleAndLikes(this.title, this.postViews, this.postLikes, this.constraints,
      {this.blog, this.trendingPost});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, maxLines: 2, style: kTitleText.copyWith(fontSize: 15)),
        SizedBox(height: constraints.maxHeight * 0.02),
        Text("$postViews Views | $postLikes Likes"),
        SizedBox(
          height: constraints.maxHeight * 0.04,
        ),
        if (blog != null
            ? blog.isPurchased == false && blog.isPaidVideo == true
            : trendingPost.isPaid == true && trendingPost.isPurchased == false)
          FlatButton(
            color: Colors.red,
            child: buildIconText(
                context, "Buy Video", Icons.attach_money, 2.0, Colors.white,
                onTap: () {
/*              showModalBottomSheet(
                  context: context,
                  builder: (cntx) => PaymentMehodModal(blog.videoPrice));*/
                }),
            onPressed: () {},
          ),
      ],
    );
  }
}
