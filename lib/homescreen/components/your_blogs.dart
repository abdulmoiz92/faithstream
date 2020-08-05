import 'dart:convert';
import 'dart:ui';

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingwidgets/blog_widgets.dart';
import 'package:faithstream/utils/modal_sheet.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:faithstream/utils/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class YourBlogs extends StatefulWidget {
  final List<Blog> allBlogs;
  final String memberId;
  final String userToken;
  final bool isSingleChannel;

  YourBlogs(@required this.allBlogs,@required this.memberId,@required this.userToken,{this.isSingleChannel});

  @override
  _YourBlogsState createState() => _YourBlogsState();
}

class _YourBlogsState extends State<YourBlogs> {
  int postIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cntx, constraints) {
      return widget.allBlogs == null
          ? Center(child: Text("Nothing To Show"))
          : ListView.builder(
              addAutomaticKeepAlives: false,
              itemCount: widget.allBlogs.length,
              itemBuilder: (cntx, index) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.02,
                        vertical: constraints.maxHeight * 0.01),
                    width: constraints.maxWidth * 1,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AuthorInfo(widget.allBlogs, index,constraints,widget.memberId,widget.userToken,widget.allBlogs[index],isSingleChannel: widget.isSingleChannel,),
                          if (widget.allBlogs[index].postType == "Image")
                            ImagePostWidget(widget.allBlogs,index,constraints),
                          if (widget.allBlogs[index].postType == "Video")
                            VideoPostWidget(widget.allBlogs,index,constraints),
                          if(widget.allBlogs[index].postType == "Event")
                              widget.allBlogs[index].videoUrl == null
                                  ? EventImagePostWidget(widget.allBlogs,index,constraints,widget.memberId,widget.userToken,isSingleChannel: widget.isSingleChannel,)
                                  : EventVideoPostWidget(widget.allBlogs,index,constraints),
                          /* ------------------- Like Share Comment -------------------------- */
                          Align(
                            alignment: Alignment.centerLeft,
                            child: LikeShareComment(widget.allBlogs,index,constraints,widget.memberId,widget.userToken,isSingleChannel: widget.isSingleChannel,),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical);
    });
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
