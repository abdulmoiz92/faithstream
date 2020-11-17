import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/pendingcomment.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../shared_pref_helper.dart';

class AddCommentSingle extends StatefulWidget {
  final BoxConstraints constraints;
  final List<Comment> comments;
  final String postId;
  final bool isTrending;

  AddCommentSingle(
      {@required this.constraints,
      @required this.postId,
      @required this.comments,
      @required this.isTrending});

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
                        autofocus: true,
                        focusNode: commentFocus,
                        maxLines: null,
                        style: TextStyle(color: Colors.black),
                        controller: commentController,
                        onChanged: (value) {
                          setState(() {});
                        },
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
                      child: GestureDetector(
                        onTap: () async {
                          if (commentController.text.isNotEmpty) {
                            widget.isTrending != true
                                ? await commentOnSinglePost(context)
                                : commentOnVideoSinglePost(context);
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: commentController.text.isEmpty
                              ? Colors.black87.withOpacity(0.4)
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Future<Builder> commentOnSinglePost(BuildContext context) async {
    bool internet = Provider.of<PendingRequestProvider>(context).internet;
    Comment newComment = new Comment(
        commentMemberId: int.parse(memberId),
        temopraryId: "temporary${widget.postId}",
        authorImage: profileImage,
        commentText: commentController.value.text,
        authorName: fullName,
        time: compareDate(DateTime.now().toIso8601String()));
    Provider.of<BlogProvider>(context).addComment(newComment);
//    Provider.of<BlogProvider>(context).setPostComment(widget.postId, newComment);
    commentController.clear();
    FocusScope.of(context).unfocus();
    if (internet == false) {
      SharedPrefHelper sph = SharedPrefHelper();
      Provider.of<PendingRequestProvider>(context).addPendingComments =
          new PendingComment(
              userToken: userToken,
              memberId: memberId,
              createdOn: DateTime.now(),
              updatedOn: DateTime.now(),
              postId: widget.postId,
              tempId: "temporary${widget.postId}",
              commentText: newComment.commentText,
              commentedBy: fullName);
      sph.savePosts(sph.pendingcomment_requests,
          Provider.of<PendingRequestProvider>(context).pendingComments);
      Navigator.pop(context);
    }
    if (internet == true) Navigator.pop(context);
    commentOnPost(globalContext, userToken, "${memberId}",
        postId: widget.postId,
        commentText: newComment.commentText,
        createdOn: DateTime.now(),
        updatedOn: DateTime.now(),
        tempId: newComment.temopraryId);
  }

  Builder commentOnVideoSinglePost(BuildContext context) {
    Comment newComment = new Comment(
        commentMemberId: int.parse(memberId),
        temopraryId:
            "temporary${Provider.of<BlogProvider>(context).getCommentsList().length + 1}",
        authorImage: profileImage,
        commentText: commentController.value.text,
        authorName: fullName,
        time: compareDate(DateTime.now().toIso8601String()));
    Provider.of<BlogProvider>(context).addTPostComment(newComment);
    commentController.clear();
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
    commentOnVideoPost(
      globalContext,
      userToken,
      "${memberId}",
      videoId: widget.postId,
      commentText: commentController.value.text,
      tempId: newComment.temopraryId,
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );
  }
}
