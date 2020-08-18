import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/helpingwidgets/singlevideo_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final bool isTrending;
  final TPost trendingPost;
  final int channelId;

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
        @required this.channelId,
        @required this.comments, this.isTrending, this.trendingPost});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Comment>> commentsValue = isTrending == true ? ValueNotifier(Provider.of<BlogProvider>(context).getTPostCommentsList()) : ValueNotifier(
        Provider.of<BlogProvider>(context).getCommentsList());

    return LayoutBuilder(builder: (cnt, constraints) {
      if(isTrending != true)
      print(blog.postId);
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * 0.05,
                  horizontal: constraints.maxWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child:
                      TitleAndLikes(title, postViews, "1k", constraints,
                        blog: isTrending != true ? blog : null,
                        trendingPost: isTrending == true ? trendingPost : null,)),
                  Spacer(),
                  if(isTrending != true)
                    LikeAndShareVideo(blog,userToken,memberId),
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
              ChannelInfoWidget(authorImage, authorName, "1k", constraints,channelId: channelId,),
            ),
            Divider(thickness: 0.5, color: Colors.black26),
            SizedBox(height: constraints.maxHeight * 0.05),
            ShareOnSocailWidget(constraints),
            SizedBox(height: constraints.maxHeight * 0.08),
            CommentHeadingAndAdd(
              constraints: constraints,
              postId: postId,
              comments: comments,
              isTrending: isTrending,
            ),
            SizedBox(height: constraints.maxHeight * 0.04),
            Container(
              key: Key("SinglePostComments"),
              width: double.infinity,
              color: Colors.white,
              height: constraints.maxHeight * 0.5,
              child: ListView.builder(
                  itemCount: commentsValue.value.length,
                  itemBuilder: (cntx, index) {
                    return ValueListenableBuilder(
                      valueListenable: commentsValue,
                      builder: (context, comments, _) {
                        return SingleComment(
                            userToken, memberId, postId, comments,
                            index, constraints,isTrending);
                      },);
                  }),
            ),
          ],
        ),
      );
    });
  }
}
