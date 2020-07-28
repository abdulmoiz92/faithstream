import 'package:cached_network_image/cached_network_image.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class VideoNetworkWidget extends StatelessWidget {
  final List<TPost> trendingPosts;
  final int index;
  final BoxConstraints constraints;

  VideoNetworkWidget(this.trendingPosts,this.index,this.constraints);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Container(
        width: constraints.maxWidth * 0.9,
        height: constraints.maxHeight * 0.4,
        child: Image.asset("assets/images/loading.gif"),
      ),
      imageUrl: trendingPosts[index].image,
      imageBuilder: (context, imageProvider) =>
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (cntx) => SingleBlogPost(
                      trendingPost:
                      trendingPosts[index],
                    ))),
            child: Container(
              width: constraints.maxWidth * 0.95,
              height: constraints.maxHeight * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.darken)),
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
            image: AssetImage(
                "assets/images/laptop.png"),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken)),
      ),
      child: Center(
        child: ButtonAndDuration(),
      ),
    );
  }

}

class ButtonAndDuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Column(
      children: <Widget>[
        Spacer(),
        Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius:
                BorderRadius.circular(50)),
            child: Center(
              child: Padding(
                padding:
                const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.all(8.0),
            height: 20,
            child: Text("0:38",
                style: TextStyle(
                    color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class EndingIcons extends StatelessWidget {
  final List<TPost> trendingPosts;
  final int index;
  final BoxConstraints constraints;

  EndingIcons(this.trendingPosts,this.index,this.constraints);

  @override
  Widget build(BuildContext context) {
    return         Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: constraints.maxWidth * 0.6,
        margin:
        EdgeInsets.only(top: constraints.maxHeight * 0.02),
        padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildIconText(context, "${trendingPosts[index].views}", Icons.remove_red_eye, 3.0, Colors.black54),
            SizedBox(width: constraints.maxWidth * 0.02),
            buildIconText(context, "${DateFormat.yMMMd().format(DateTime.parse(trendingPosts[index].date))}", Icons.watch_later, 3.0, Colors.black54)
          ],
        ),
      ),
    );
  }

}