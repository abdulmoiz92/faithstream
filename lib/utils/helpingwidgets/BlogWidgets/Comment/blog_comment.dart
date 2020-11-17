import 'dart:convert';

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/pendingcomment.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../../modal_sheet.dart';
import '../../../shared_pref_helper.dart';

class CommentModal extends StatefulWidget {
  final List<Blog> allBlogs;
  final int index;
  final String userToken;
  final String memberId;

  CommentModal(this.allBlogs, this.index, this.userToken, this.memberId);

  @override
  _CommentModalState createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  final List<Comment> commentsList = [];
  TextEditingController commentController = TextEditingController();
  String profileImage;
  String fullName;
  String commentText = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getData();
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if (mounted)
      setState(() {
        profileImage = prefs.getString(sph.profile_image);
        fullName =
            "${prefs.getString(sph.first_name)} ${prefs.getString(sph.last_name)}";
      });
    Provider.of<BlogProvider>(context).resetComments();
  }

  void getComments() async {
    var commentData = await http.get(
        "$baseAddress/api/Post/GetPostComments/${widget.allBlogs[widget.index].postId}",
        headers: {"Authorization": "Bearer ${widget.userToken}"});
    if (commentData.body.isNotEmpty) {
      var commentDataJson = json.decode(commentData.body);
      if (commentDataJson['data'] != null) {
        if (mounted)
          for (var c in commentDataJson['data']) {
            /*var userData = await http.get(
                "$baseAddress/api/Member/GetMemberProfile/${c['memberID']}",
                headers: {"Authorization": "Bearer ${widget.userToken}"});*/
            /* json.decode(userData.body)['data'] == null
                      ? null
                      : json.decode(userData.body)['data']
                  ['profileImage'] */
            if (commentDataJson['data'] == []) continue;
            if (mounted) {
              Comment newComment = Comment.fromJson(c);
              if (Provider.of<BlogProvider>(globalContext)
                          .doesCommentExist(c['id']) ==
                      false &&
                  Provider.of<BlogProvider>(globalContext)
                          .doesCommentExistInDeleteProcess(c['id']) ==
                      false)
                Provider.of<BlogProvider>(globalContext).addComment(newComment);
            }
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.95,
      child: LayoutBuilder(
        builder: (cntx, constraints) {
          return Container(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
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
                      StreamBuilder(
                          stream: Stream.periodic(Duration(seconds: 2))
                              .asyncMap((event) => getComments()),
                          builder: (context, snapshot) {
                            return Container(
                                key: Key("modallist"),
                                width: double.infinity,
                                height: constraints.maxHeight * 0.82,
                                child: ModalBottom(
                                  scrollingList:
                                      Provider.of<BlogProvider>(context)
                                          .getCommentsList(),
                                  postId: widget.allBlogs[widget.index].postId,
                                  userToken: widget.userToken,
                                  memberId: widget.memberId,
                                ));
                          }),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Card(
                        elevation: 5,
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10.0),
                              width: constraints.maxWidth * 0.85,
                              child: TextField(
                                maxLines: null,
                                style: TextStyle(color: Colors.black),
                                controller: commentController,
                                onChanged: (value) {
                                  setState(() {
                                    commentText = value;
                                  });
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
                              child: StatefulBuilder(
                                builder: (cntx, _setState) {
                                  return GestureDetector(
                                    onTap: () async {
                                      bool internet =
                                          Provider.of<PendingRequestProvider>(
                                                  context)
                                              .internet;
                                      if (commentText.isNotEmpty) {
                                        print(widget.memberId);
                                        Comment newComment = new Comment(
                                            commentMemberId:
                                                int.parse(widget.memberId),
                                            temopraryId:
                                                "temporary${widget.allBlogs[widget.index].postId}",
                                            authorImage: profileImage,
                                            commentText:
                                                commentController.value.text,
                                            authorName: fullName,
                                            time: compareDate(DateTime.now()
                                                .toIso8601String()));
                                        Provider.of<BlogProvider>(context)
                                            .addComment(newComment,
                                                postId: widget
                                                    .allBlogs[widget.index]
                                                    .postId);
                                        Provider.of<BlogProvider>(context)
                                            .setAddingCommentInProcess = true;
                                        /*Provider.of<BlogProvider>(context)
                                            .setPostComment(
                                            widget.allBlogs[widget.index]
                                                .postId, newComment);*/

                                        if (internet == false) {
                                          SharedPrefHelper sph =
                                              SharedPrefHelper();
                                          Provider.of<PendingRequestProvider>(
                                                      context)
                                                  .addPendingComments =
                                              new PendingComment(
                                                  userToken: widget.userToken,
                                                  memberId: widget.memberId,
                                                  createdOn: DateTime.now(),
                                                  updatedOn: DateTime.now(),
                                                  postId: widget
                                                      .allBlogs[widget.index]
                                                      .postId,
                                                  tempId:
                                                      "temporary${widget.allBlogs[widget.index].postId}",
                                                  commentText:
                                                      commentController.text,
                                                  commentedBy: fullName);
                                          sph.savePosts(
                                              sph.pendingcomment_requests,
                                              Provider.of<PendingRequestProvider>(
                                                      context)
                                                  .pendingComments);
                                          Provider.of<BlogProvider>(context)
                                                  .setAddingCommentInProcess =
                                              false;
                                        }

                                        if (internet == true)
                                          commentOnPost(
                                              context,
                                              widget.userToken,
                                              "${widget.memberId}",
                                              postId: widget
                                                  .allBlogs[widget.index]
                                                  .postId,
                                              commentText:
                                                  commentController.value.text,
                                              createdOn: DateTime.now(),
                                              updatedOn: DateTime.now(),
                                              tempId: newComment.temopraryId);
                                        commentController.clear();
                                        setState(() {
                                          commentText = "";
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: commentText.isEmpty
                                          ? Colors.black87.withOpacity(0.4)
                                          : Colors.black87,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
