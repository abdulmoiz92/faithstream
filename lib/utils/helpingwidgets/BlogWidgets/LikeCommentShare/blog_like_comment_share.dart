import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/pendinglike.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Comment/blog_comment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../shared_pref_helper.dart';

class LikeShareComment extends StatefulWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;
  final String memberId;
  final String userToken;
  final bool isSingleChannel;

  LikeShareComment(this.allBlogs, this.index, this.constraints, this.memberId,
      this.userToken, {this.isSingleChannel});

  @override
  _LikeShareCommentState createState() => _LikeShareCommentState();
}

class _LikeShareCommentState extends State<LikeShareComment> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.constraints.maxWidth * 1,
      padding: EdgeInsets.symmetric(
          horizontal: widget.constraints.maxWidth * 0.07,
          vertical: widget.constraints.maxHeight * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buildIconColumnText(context,
              "${Provider.of<BlogProvider>(globalContext).getPostLikedCounts(
                  widget.allBlogs[widget.index].postId)} ${Provider.of<
                  BlogProvider>(globalContext).getPostLikedCounts(
                  widget.allBlogs[widget.index].postId) == 1
                  ? "Like"
                  : "Likes"}", Provider.of<
                  BlogProvider>(globalContext).getIsPostLiked(
                  widget.allBlogs[widget.index].postId) == 1 ?
              Icons.favorite : Icons.favorite_border, 3.0,
              Colors.black87,
              iconColor: Provider.of<
                  BlogProvider>(globalContext).getIsPostLiked(
                  widget.allBlogs[widget.index].postId) == 1
                  ? Colors.red
                  : Colors.black87,
              onTap: () {
                SharedPrefHelper sph = SharedPrefHelper();
                BlogProvider provider = Provider.of<BlogProvider>(
                    context);
                provider.setIsPostLiked =
                    widget.allBlogs[widget.index].postId;
                Provider
                    .of<BlogProvider>(globalContext)
                    .setLikingPostInProcess = true;
                Provider.of<
                    BlogProvider>(context).getIsPostLiked(
                    widget.allBlogs[widget.index].postId) == 1 ? provider
                    .increaseLikesCount(
                    widget.allBlogs[widget.index].postId) : provider
                    .decreaseLikesCount(
                    widget.allBlogs[widget.index].postId);
                AssetsAudioPlayer.playAndForget(
                  Audio("assets/audio/likesound.mp3"),
                );
                bool internet = Provider
                    .of<PendingRequestProvider>(context)
                    .internet;
                if (internet == false) {
                  Provider
                      .of<PendingRequestProvider>(context)
                      .addPendingLike = new PendingLike(
                      userToken: widget.userToken,
                      memberId: widget.memberId,
                      createdOn: DateTime.now(),
                      updatedOn: DateTime.now(),
                      blogId: widget.allBlogs[widget.index].postId);
                  sph.savePosts(sph.pendinglikes_requests, Provider
                      .of<PendingRequestProvider>(context)
                      .pendingLikes);
                  Provider
                      .of<BlogProvider>(context)
                      .setLikingPostInProcess = false;
                }
                if (internet == true) {
                  likePost(
                      context,
                      widget.userToken,
                      "${widget.memberId}",
                      DateTime.now(),
                      DateTime.now(),
                          () {},
                      widget.allBlogs[widget.index].postId);
                  setState(() {});
                }
              }),
          Spacer(),
          buildIconColumnText(
              context,
              "${Provider.of<BlogProvider>(globalContext).getPostCommentCounts(
                  widget.allBlogs[widget.index].postId)} Comments",
              Icons.mode_comment, 3.0, Colors.black87,
              onTap: () {
                print(widget.memberId);
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (cntx) =>
                        CommentModal(widget.allBlogs, widget.index,
                            widget.userToken, widget.memberId));
              }),
          Spacer(),
          buildIconColumnText(
              context, "Share", Icons.share, 3.0, Colors.black87),
        ],
      )
      ,
    );
  }
}

