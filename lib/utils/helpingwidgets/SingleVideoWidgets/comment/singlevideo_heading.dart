import 'package:faithstream/model/comment.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingwidgets/SingleVideoWidgets/comment/singlevideo_addcomment_single.dart';
import 'package:flutter/material.dart';

class CommentHeadingAndAdd extends StatelessWidget {
  final BoxConstraints constraints;
  final String postId;
  final List<Comment> comments;
  final bool isTrending;

  CommentHeadingAndAdd(
      {@required this.constraints,
        @required this.postId,
        @required this.comments,
        @required this.isTrending});

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
                      isTrending: isTrending,
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
