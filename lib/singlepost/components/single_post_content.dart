import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingwidgets/singlevideo_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SinglePostContent extends StatelessWidget {
  final String postId;
  final Blog blog;
  final String authorImage;
  final String authorName;
  final String authorSubscribers;
  final String postViews;
  final String title;
  final String postedDate;
  final String postDescription;
  final List<Comment> comments;
  final String memberId;
  final String userToken;
  final bool isLiked;

  SinglePostContent(this.userToken, this.memberId,
      {@required this.postId,
      @required this.authorImage,
      @required this.blog,
      @required this.authorName,
      @required this.authorSubscribers,
      @required this.postViews,
      @required this.title,
      @required this.isLiked,
      @required this.postedDate,
      @required this.postDescription,
      @required this.comments});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Comment>> commentsValue = ValueNotifier(blog.comments);
    return LayoutBuilder(builder: (cnt, constraints) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * 0.05,
                  horizontal: constraints.maxWidth * 0.05),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child:
                          TitleAndLikes(title, postViews, "1k", constraints,blog)),
                  Spacer(),
                  LikeAndShareVideo(blog),
                ],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            Divider(thickness: 0.5, color: Colors.black26),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * 0.02,
                  horizontal: constraints.maxHeight * 0.04),
              child:
                  ChannelInfoWidget(authorImage, authorName, "1k", constraints),
            ),
            Divider(thickness: 0.5, color: Colors.black26),
            SizedBox(height: constraints.maxHeight * 0.05),
            ShareOnSocailWidget(constraints),
            SizedBox(height: constraints.maxHeight * 0.08),
            CommentHeadingAndAdd(
              constraints: constraints,
              postId: postId,
              comments: comments,
              blog: blog,
            ),
            SizedBox(height: constraints.maxHeight * 0.04),
            Container(
              key: Key("SinglePostComments"),
              width: double.infinity,
              color: Colors.white,
              height: constraints.maxHeight * 0.5,
              child: ListView.builder(
                  itemCount: blog.comments.length,
                  itemBuilder: (cntx, index) {
                    return ValueListenableBuilder(
                      valueListenable: commentsValue,
                      builder: (BuildContext context, List<Comment> commentsvalue, Widget child) {
                        return SingleComment(userToken, memberId, postId, commentsvalue,
                            index, constraints);
                      },
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }
}
