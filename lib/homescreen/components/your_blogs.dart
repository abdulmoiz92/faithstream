import 'dart:convert';
import 'dart:ui';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:faithstream/main.dart';
import 'package:faithstream/model/blog.dart';
import 'package:async/async.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/helpingwidgets/blog_widgets.dart';
import 'package:faithstream/utils/helpingwidgets/singlevideo_widgets.dart';
import 'package:faithstream/utils/modal_sheet.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:faithstream/utils/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class YourBlogs extends StatelessWidget {
  final List<Blog> allBlogs;
  final String memberId;
  final String userToken;
  final bool isSingleChannel;
  String profileImage;

  YourBlogs(@required this.allBlogs, @required this.memberId,
      @required this.userToken, {this.isSingleChannel,this.profileImage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cntx, constraints) {
      return allBlogs == null
          ? Center(child: Text("Nothing To Show"))
          : ListView.builder(itemCount: allBlogs.length,itemBuilder: (cntx,index) {
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
                  AuthorInfo(allBlogs, index,constraints,memberId,userToken,allBlogs[index],isSingleChannel: isSingleChannel,),
                  if (allBlogs[index].postType == "Image")
                    ImagePostWidget(allBlogs,index,constraints,userToken,memberId),
                  if (allBlogs[index].postType == "Video")
                    VideoPostWidget(allBlogs,index,constraints,userToken,memberId),
                  if(allBlogs[index].postType == "Event")
                    allBlogs[index].videoUrl == null
                        ? EventImagePostWidget(allBlogs,index,constraints,memberId,userToken,isSingleChannel: isSingleChannel,)
                        : EventVideoPostWidget(allBlogs,index,constraints,userToken,memberId),
                  /* ------------------- Like Share Comment -------------------------- */
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LikeShareComment(allBlogs,index,constraints,memberId,userToken,isSingleChannel: isSingleChannel,),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          builder: (cntx) => AddCommentSingle(
                            constraints: constraints,
                            postId: allBlogs[index].postId,
                            comments: null,
                            isTrending: false,
                          ));
                    },child: PostBottomComment(constraints)),
                  ),
                ],
              ),
            ),
          ),
        );
      },);
    });

  }

  
}