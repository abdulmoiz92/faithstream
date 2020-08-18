import 'dart:convert';
import 'dart:ui';

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/helpingwidgets/blog_widgets.dart';
import 'package:faithstream/utils/modal_sheet.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:faithstream/utils/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  ScrollController _sc = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cntx, constraints) {
      if(Provider.of<BlogProvider>(context).lazyBlog.length == 0)
      Provider.of<BlogProvider>(context).increaseItems(0,widget.allBlogs);
      _sc..addListener(() {
        if(_sc.position.pixels == _sc.position.maxScrollExtent)
          Provider.of<BlogProvider>(context).increaseItems(Provider.of<BlogProvider>(context).lazyBlog.length,widget.allBlogs);
      });
      return widget.allBlogs == null
          ? Center(child: Text("Nothing To Show"))
          : ListView.builder(
              controller: _sc,
              addAutomaticKeepAlives: true,
              cacheExtent: widget.allBlogs.length.toDouble(),
              itemCount: Provider.of<BlogProvider>(context).lazyBlog.length,
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
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AuthorInfo(widget.allBlogs, index,constraints,widget.memberId,widget.userToken,widget.allBlogs[index],isSingleChannel: widget.isSingleChannel,),
                          if (widget.allBlogs[index].postType == "Image")
                            ImagePostWidget(widget.allBlogs,index,constraints,widget.userToken,widget.memberId),
                          if (widget.allBlogs[index].postType == "Video")
                            VideoPostWidget(widget.allBlogs,index,constraints,widget.userToken,widget.memberId),
                          if(widget.allBlogs[index].postType == "Event")
                              widget.allBlogs[index].videoUrl == null
                                  ? EventImagePostWidget(widget.allBlogs,index,constraints,widget.memberId,widget.userToken,isSingleChannel: widget.isSingleChannel,)
                                  : EventVideoPostWidget(widget.allBlogs,index,constraints,widget.userToken,widget.memberId),
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
