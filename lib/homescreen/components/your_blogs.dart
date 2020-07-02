import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/modal_sheet.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:faithstream/utils/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class YourBlogs extends StatelessWidget {
  final List<Blog> allBlogs;

  YourBlogs(@required this.allBlogs);

 int postIndex;

    @override
    Widget build(BuildContext context) {
      return LayoutBuilder(builder: (cntx, constraints) {
        return allBlogs == null
            ? Text("No Blogs To Show")
            : ListView.custom(
            childrenDelegate: SliverChildBuilderDelegate((BuildContext context,int index) {
              //Variables
               Widget authorInfo = Padding(
                padding: EdgeInsets.only(
                    left: constraints.maxWidth * 0.02,
                    top: constraints.maxHeight * 0.015),
                child: buildAvatarText(
                    context,
                    allBlogs[index].authorImage,
                    allBlogs[index].author,
                    2,
                    Text(
                      allBlogs[index].time,
                      style: kLabelText.copyWith(fontSize: 14),
                    ),
                    null,
                    Colors.black),
              );

              Widget likeShareComment = Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: constraints.maxWidth * 0.65,
                  padding: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.02,
                      horizontal: constraints.maxWidth * 0.03),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      buildIconText(context, "Like", Icons.thumb_up, 3.0,
                          Colors.black87),
                      Spacer(),
                      buildIconText(
                          context, "Share", Icons.share, 3.0, Colors.black87),
                      Spacer(),
                      buildIconText(
                          context, "comment", Icons.sms, 3.0, Colors.black87,
                          onTap: () {
                            commentModal(context, index);
                          }),
                    ],
                  ),
                ),
              );

              Widget imagePostWidget = allBlogs[index].postType == "Image"
                  ? Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        top: constraints.maxHeight * 0.02,
                        bottom: constraints.maxHeight * 0.01),
                    padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.04),
                    child: Text(allBlogs[index].title,
                        style: TextStyle(
                            color: Colors.black54, fontSize: 15)),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  if (allBlogs[index].image != null)
                    Center(
                        child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              width: constraints.maxWidth * 0.9,
                              height: allBlogs[index].imageHeight == null ? constraints.maxHeight * 0.4 : (allBlogs[index].imageHeight).ceilToDouble(),
                              child: Image.asset(
                                "assets/images/loading.gif",fit: BoxFit.fitHeight,),
                            ),
                            imageUrl: allBlogs[index].image,
                            fit: BoxFit.fitHeight,
                            width: constraints.maxWidth * 0.9)),
                ],
              )
                  : Container();

              Widget videoPostWidget = allBlogs[index].postType == "Video"
                  ? Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: constraints.maxHeight * 0.02,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.04),
                    child: Text(allBlogs[index].title,
                        style: TextStyle(
                            color: Colors.black54, fontSize: 15)),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Center(
                    child: allBlogs[index].image != null
                        ? CachedNetworkImage(
                      placeholder: (context, url) => Hero(
                        tag: "VideoImage",
                        child: Container(
                          width: constraints.maxWidth * 0.9,
                          height: constraints.maxHeight * 0.4,
                          child: Image.asset(
                              "assets/images/loading.gif"),
                        ),
                      ),
                      imageUrl: allBlogs[index].image,
                      imageBuilder: (context, imageProvider) =>
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(
                                builder: (cntx) => SingleBlogPost(
                                  singleBlog: allBlogs[index],
                                ))),
                            child: Container(
                              width: constraints.maxWidth * 0.9,
                              height: allBlogs[index].imageHeight == null ? constraints.maxHeight * 0.4 : (allBlogs[index].imageHeight).ceilToDouble(),
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
                                child: Column(
                                  children: <Widget>[
                                    Spacer(),
                                    Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                            BorderRadius.circular(
                                                50)),
                                        child: Center(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                8.0),
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
                                      alignment:
                                      Alignment.bottomRight,
                                      child: Container(
                                        margin: EdgeInsets.all(8.0),
                                        height: 20,
                                        child: Text("0:38",
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    )
                        : Center(
                      child: Container(
                        width: constraints.maxWidth * 0.9,
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
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                BorderRadius.circular(50)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Container();

              Widget EventImageWidget = allBlogs[index].postType == "Event" &&
                  allBlogs[index].videoUrl == null
                  ? Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        top: constraints.maxHeight * 0.02,
                        bottom: constraints.maxHeight * 0.01),
                    padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(allBlogs[index].title,
                            style: TextStyle(
                                color: Colors.red, fontSize: 15)),
                        SizedBox(
                          height: constraints.maxHeight * 0.01,
                        ),
                        if (allBlogs[index].eventLocation != null)
                          buildIconText(
                              context,
                              allBlogs[index].eventLocation,
                              Icons.location_on,
                              3.0,
                              Colors.black54),
                        SizedBox(
                          height: constraints.maxHeight * 0.01,
                        ),
                        if (allBlogs[index].eventTime != null)
                          buildIconText(
                              context,
                              allBlogs[index].eventTime,
                              Icons.watch_later,
                              3.0,
                              Colors.black54),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  if (allBlogs[index].image != null)
                    Center(
                        child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              width: constraints.maxWidth * 0.9,
                              height: allBlogs[index].imageHeight == null ? constraints.maxHeight * 0.4 : (allBlogs[index].imageHeight).ceilToDouble(),
                              child: Image.asset(
                                "assets/images/loading.gif",fit: BoxFit.fitHeight,),
                            ),
                            imageUrl: allBlogs[index].image,
                            fit: BoxFit.fill,
                            width: constraints.maxWidth * 0.9)),
                ],
              )
                  : Container();

              Widget EventVideoWidget = allBlogs[index].postType == "Event" &&
                  allBlogs[index].videoUrl != null
                  ? GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (cntx) => SingleBlogPost(
                            singleBlog: allBlogs[index],
                          )));
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          top: constraints.maxHeight * 0.02,
                          bottom: constraints.maxHeight * 0.02),
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(allBlogs[index].title,
                              style: TextStyle(
                                  color: Colors.red, fontSize: 15)),
                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),
                          if (allBlogs[index].eventLocation != null)
                            buildIconText(
                                context,
                                allBlogs[index].eventLocation,
                                Icons.location_on,
                                3.0,
                                Colors.black54),
                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),
                          if (allBlogs[index].eventTime != null)
                            buildIconText(
                                context,
                                allBlogs[index].eventTime,
                                Icons.watch_later,
                                3.0,
                                Colors.black54),
                        ],
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Center(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: constraints.maxWidth * 0.9,
                          height: constraints.maxHeight * 0.4,
                          child:
                          Image.asset("assets/images/loading.gif"),
                        ),
                        imageUrl: allBlogs[index].image == null
                            ? ""
                            : allBlogs[index].image,
                        imageBuilder: (context, imageProvider) =>
                            Container(
                              width: constraints.maxWidth * 0.9,
                              height: constraints.maxHeight * 0.4,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: allBlogs[index].image == null
                                      ? AssetImage(
                                      "assets/images/laptop.png")
                                      : imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                      BorderRadius.circular(50)),
                                  child: Container(
                                    width: constraints.maxWidth * 0.16,
                                    height: constraints.maxHeight * 0.05,
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2.0, right: 2.0),
                                          child: Text("0:38"),
                                        ),
                                        Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              )
                  : Container();

              return Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.02,
                      vertical: constraints.maxHeight * 0.01),
                  width: constraints.maxWidth * 1,
                  child: Wrap(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 6,
                        child: Column(
                          children: <Widget>[
                            authorInfo,
                            if (allBlogs[index].postType == "Image")
                              imagePostWidget,
                            if (allBlogs[index].postType == "Video")
                              videoPostWidget,
                            allBlogs[index].postType == "Event"
                                ? allBlogs[index].videoUrl == null
                                ? EventImageWidget
                                : EventVideoWidget
                                : Container(),
                            likeShareComment,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
                childCount: allBlogs.length,addAutomaticKeepAlives: true,addRepaintBoundaries: true,addSemanticIndexes: true,semanticIndexOffset: allBlogs != null ? (allBlogs.length / 3).round() : 0),
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical );
      });
    }
    commentModal(BuildContext context, int index) {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          isScrollControlled: true,
          context: context,
          builder: (context) => Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.95,
            child: LayoutBuilder(
              builder: (cntx, constraints) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 15.0),
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.comment,
                              color: Colors.black87,
                              size: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6.0),
                              child: Text(
                                "Comments",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.85,
                          child: ModalBottom(
                            scrollingList: allBlogs[index].comments,
                          )),
                      Container(child: Text("Add Comment")),
                    ],
                  ),
                );
              },
            ),
          ));
    }
  }
/*index == 4
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(child: Column(
                                children: <Widget>[
                                  Icon(Icons.arrow_forward,color: Colors.white,),
                                  SizedBox(height: constraints.maxHeight * 0.01,),
                                ],
                              ),),
                            ),
                          ],
                        ),
                      )*/
