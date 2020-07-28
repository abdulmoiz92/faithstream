import 'dart:convert';

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/databasemethods/database_methods.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/helpingwidgets/blog_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_pref_helper.dart';

class TitleAndLikes extends StatelessWidget {
  final String title;
  final String postViews;
  final String postLikes;
  final BoxConstraints constraints;
  final Blog blog;

  TitleAndLikes(this.title, this.postViews, this.postLikes, this.constraints,this.blog);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, maxLines: 2, style: kTitleText.copyWith(fontSize: 15)),
        SizedBox(height: constraints.maxHeight * 0.02),
        Text("$postViews Views | $postLikes Likes"),
        SizedBox(height: constraints.maxHeight * 0.04,),
        if(blog.isPurchased == false && blog.isPaidVideo == true)
          FlatButton(color: Colors.red,child: buildIconText(context, "Buy Video", Icons.attach_money, 2.0, Colors.white,onTap: () {showModalBottomSheet(context: context,builder: (cntx) => PaymentMehodModal(blog.videoPrice));}),onPressed: () {},),
      ],
    );
  }
}

class LikeAndShareVideo extends StatefulWidget {
  final Blog singleBlog;

  LikeAndShareVideo(this.singleBlog);

  @override
  _LikeAndShareVideoState createState() => _LikeAndShareVideoState();
}

class _LikeAndShareVideoState extends State<LikeAndShareVideo> {
  Stream get strem => Stream.fromFuture(findIsLiked(widget.singleBlog.postId));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: StreamBuilder(
            stream: strem,
            builder: (context, snapshot) {
              return Icon(
                Icons.thumb_up,
                color: snapshot.data == 1 ? Colors.red : Colors.black87,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(Icons.share),
        )
      ],
    );
  }
}

class ChannelInfoWidget extends StatelessWidget {
  final String authorName;
  final String authorImage;
  final String numOfSubscribers;
  final BoxConstraints constraints;

  ChannelInfoWidget(this.authorImage, this.authorName, this.numOfSubscribers,
      this.constraints);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(
                image: authorImage == null
                    ? AssetImage("assets/images/test.jpeg")
                    : NetworkImage(authorImage),
                fit: BoxFit.fill),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: constraints.maxWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(authorName, style: kTitleText.copyWith(fontSize: 15)),
              SizedBox(
                height: constraints.maxHeight * 0.01,
              ),
              Text("$numOfSubscribers Subscribers",
                  textAlign: TextAlign.left,
                  style: kLabelText.copyWith(fontSize: 13)),
            ],
          ),
        )
      ],
    );
  }
}

class ShareOnSocailWidget extends StatelessWidget {
  final BoxConstraints constraints;

  ShareOnSocailWidget(this.constraints);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: constraints.maxWidth * 0.6,
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              "assets/images/facebook.png",
              width: 32,
              height: 32,
            ),
            Spacer(),
            Image.asset(
              "assets/images/twitter.png",
              width: 32,
              height: 32,
            ),
            Spacer(),
            Image.asset(
              "assets/images/google-plus.png",
              width: 32,
              height: 32,
            ),
            Spacer(),
            Image.asset(
              "assets/images/linkedin.png",
              width: 32,
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class CommentHeadingAndAdd extends StatelessWidget {
  final BoxConstraints constraints;
  final String postId;
  final List<Comment> comments;
  Blog blog;

  CommentHeadingAndAdd(
      {@required this.constraints,
      @required this.postId,
      @required this.comments,this.blog});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: constraints.maxWidth * 0.04),
            child: Text(
              "Comments",
              textAlign: TextAlign.left,
              style: kTitleText.copyWith(fontSize: 20),
            )),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    builder: (cntx) => AddCommentSingle(
                          constraints: constraints,
                          postId: postId,
                          comments: comments,
                          blog: blog,
                        ));
              },
              child: Text(
                "Add Comment",
                style: TextStyle(color: Colors.red, fontSize: 13),
              )),
        ),
      ],
    );
  }
}

class AddCommentSingle extends StatefulWidget {
  final BoxConstraints constraints;
  final List<Comment> comments;
  final String postId;
  Blog blog;

  AddCommentSingle(
      {@required this.constraints,
      @required this.postId,
      @required this.comments,this.blog});

  @override
  _AddCommentSingleState createState() => _AddCommentSingleState();
}

class _AddCommentSingleState extends State<AddCommentSingle> {
  final TextEditingController commentController = TextEditingController();
  var profileImage;
  var fullName;
  var userToken;
  var memberId;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if (mounted)
      setState(() {
        userToken = prefs.getString(sph.user_token);
        memberId = prefs.getString(sph.member_id);
        fullName =
            "${prefs.getString(sph.first_name)} ${prefs.getString(sph.last_name)}";
        profileImage = prefs.getString(sph.profile_image);
      });
  }

  FocusNode commentFocus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (cntx, constraints) {
          return Align(
            alignment: Alignment.bottomLeft,
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      width: widget.constraints.maxWidth * 0.85,
                      child: TextField(
                        focusNode: commentFocus,
                        maxLines: null,
                        style: TextStyle(color: Colors.black),
                        controller: commentController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Add a comment",
                            hintStyle: TextStyle(fontSize: 14.0)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Consumer<SingleBlogPostState>(
                        builder: (context,_singleBlog,_) {
                          return GestureDetector(
                            onTap: () {
                              Comment newComment = new Comment(
                                  commentText: commentController.value.text,
                                  authorName: fullName,
                                  authorImage: profileImage,
                                  time: DateTime.now().toIso8601String());
                              widget.blog.addCommentSet = newComment;
                              _singleBlog.reassemble();
                              commentOnPost(
                                context,
                                userToken,
                                "${memberId}",
                                postId: widget.postId,
                                commentText: commentController.value.text,
                                createdOn: DateTime.now(),
                                updatedOn: DateTime.now(),
                              );
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}

class SingleComment extends StatefulWidget {
  final List<Comment> comments;
  final int index;
  final BoxConstraints constraints;
  final String memberId;
  final String userToken;
  final String postId;

  SingleComment(this.userToken, this.memberId, this.postId, this.comments,
      this.index, this.constraints);

  @override
  _SingleCommentState createState() => _SingleCommentState();
}

class _SingleCommentState extends State<SingleComment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10),
        width: widget.constraints.maxWidth * 0.9,
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                    image: widget.comments[widget.index].authorImage == null
                        ? AssetImage("assets/images/test.jpeg")
                        : NetworkImage(
                            widget.comments[widget.index].authorImage),
                    fit: BoxFit.fill),
              ),
            ),
            Container(
              width: widget.constraints.maxWidth * 0.7,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("${widget.comments[widget.index].authorName}",
                      style: kTitleText.copyWith(fontSize: 13)),
                  SizedBox(
                    height: widget.constraints.maxHeight * 0.01,
                  ),
                  Text("${widget.comments[widget.index].commentText}",
                      style: kLabelText.copyWith(
                          fontSize: 11, height: 1.4, color: Colors.black87)),
                ],
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: Colors.grey,
                ),
                widget.comments[widget.index].commentMemberId.toString() ==
                        widget.memberId
                    ? Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            var commentFormat = widget.comments[widget.index];
                            setState(() {
                              widget.comments.removeAt(widget.index);
                            });
                            deleteComment(context, widget.postId,
                                commentFormat.commentId, widget.userToken);
                          },
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
