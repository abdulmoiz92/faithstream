import 'package:faithstream/model/comment.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/material.dart';

class SingleComment extends StatefulWidget {
  final List<Comment> comments;
  final int index;
  final BoxConstraints constraints;
  final String memberId;
  final String userToken;
  final String postId;
  final bool isTrending;

  SingleComment(this.userToken, this.memberId, this.postId, this.comments,
      this.index, this.constraints, this.isTrending);

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
                            widget.memberId &&
                        widget.comments[widget.index].temopraryId == null
                    ? Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            var commentFormat = widget.comments[widget.index];
                            widget.isTrending != true
                                ? deleteComment(context, widget.postId,
                                    commentFormat.commentId, widget.userToken)
                                //                              .then((_) => Provider.of<BlogProvider>(context).commentExistsInPostComment(commentFormat, widget.postId))
                                : deleteVideoComment(context, widget.postId,
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
