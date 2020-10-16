import 'dart:convert';

import 'package:faithstream/main.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/helpingwidgets/blog_widgets.dart';
import 'package:faithstream/utils/helpingwidgets/singlevideo_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SingleSearchPost extends StatefulWidget {
  Blog blog;
  String userToken;
  String memberId;
  String profileImage;

  SingleSearchPost(this.blog,this.userToken,this.memberId,this.profileImage);

  @override
  _SingleSearchPostState createState() => _SingleSearchPostState();
}

class _SingleSearchPostState extends State<SingleSearchPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: Text(widget.blog.title,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black87, fontSize: 18)),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(builder: (cntx, constraints) {
        return SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              Container(
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
                      AuthorInfo(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == widget.blog.postId),constraints,widget.memberId,widget.userToken,Provider
                          .of<BlogProvider>(context)
                          .searchBlogs[Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == widget.blog.postId)]),
                      widget.blog.postType == "Image" ? ImagePostWidget(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == widget.blog.postId),
                          constraints, widget.userToken, widget.memberId) : widget.blog.postType == "Video"
                          ? VideoPostWidget(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == widget.blog.postId),
                          constraints, widget.userToken, widget.memberId)
                          : Provider
                          .of<BlogProvider>(context)
                          .searchBlogs[Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == widget.blog.postId)]
                          .videoUrl == null ? EventImagePostWidget(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == widget.blog.postId),
                          constraints, widget.memberId, widget.userToken) : EventVideoPostWidget(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs, Provider
                          .of<BlogProvider>(context)
                          .searchBlogs
                          .indexWhere((element) => element.postId == widget.blog.postId),
                          constraints, widget.memberId, widget.userToken),
                      /* ------------------- Like Share Comment -------------------------- */
                      Align(
                        alignment: Alignment.centerLeft,
                        child: LikeShareComment(Provider
                            .of<BlogProvider>(context)
                            .searchBlogs,Provider
                            .of<BlogProvider>(context)
                            .searchBlogs
                            .indexWhere((element) => element.postId == widget.blog.postId),constraints,widget.memberId,widget.userToken,),
                      ),
                      if(Provider
                          .of<BlogProvider>(context)
                          .searchBlogs.firstWhere((element) => element.postId == widget.blog.postId).postComment != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(width: constraints.maxWidth * 0.8,child: SingleCommentDesign(memberId: widget.memberId,userToken: widget.userToken,constraints: constraints,postId: widget.blog.postId,comment: widget.blog.postComment,isFrontComment: true,)),
                          ),
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
                                postId: widget.blog.postId,
                                comments: null,
                                isTrending: false,
                              ));
                        },child: PostBottomComment(constraints)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
          ,
        );
      },),
    );
  }

  @override
  void initState() {
    super.initState();
    if(Provider.of<PendingRequestProvider>(globalContext).internet == true)
    getComment();
  }

  Future<void> getComment() async {
      var commentData = await http.get(
          "$baseAddress/api/Post/GetPostComments/${widget.blog.postId}",
          headers: {"Authorization": "Bearer ${widget.userToken}"});
      if (commentData.body.isNotEmpty) {
        var commentDataJson = json.decode(commentData.body);
        if (commentDataJson['data'] != null) {
          if (mounted)
            for (var c in commentDataJson['data']) {
              if(c['memberID'] == int.parse(widget.memberId)) {
                Comment newComment = new Comment(
                    commentId: c['id'],
                    commentMemberId: c['memberID'],
                    authorImage: widget.profileImage,
                    commentText: c['commentText'],
                    authorName: c['commentedBy'],
                    time: "${compareDate(c['dateCreated'])}");
                Provider.of<BlogProvider>(globalContext).setPostComment(widget.blog.postId, newComment);
              }
            }
        }
      }
    }

  }