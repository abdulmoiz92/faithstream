import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/pendingfavourite.dart';
import 'package:faithstream/model/pendinglike.dart';
import 'package:faithstream/singlepost/single_channel.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:faithstream/utils/custom_modal.dart' as bs;
import '../../../../main.dart';
import '../../../shared_pref_helper.dart';

class AuthorInfo extends StatefulWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;
  final String memberId;
  final String userToken;
  final Blog blog;
  final bool isSingleChannel;

  AuthorInfo(this.allBlogs, this.index, this.constraints, this.memberId,
      this.userToken, this.blog, {this.isSingleChannel});

  @override
  _AuthorInfoState createState() => _AuthorInfoState();
}

class _AuthorInfoState extends State<AuthorInfo>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: widget.constraints.maxWidth * 0.65,
          padding: EdgeInsets.symmetric(
              vertical: widget.constraints.maxHeight * 0.01,
              horizontal: widget.constraints.maxWidth * 0.03),
          child: buildAvatarText(
              context,
              widget.allBlogs[widget.index].authorImage,
              widget.allBlogs[widget.index].author,
              2,
              Text(
                widget.allBlogs[widget.index].time,
                maxLines: null,
                style: kLabelText.copyWith(fontSize: 14),
              ),
              null,
              Colors.black,
              id: widget.allBlogs[widget.index].authorId.toString(),
              authorImageBytes: widget.allBlogs[widget.index].authorImageBytes,
              onTap: () {
                bs.showModalBottomSheet(context: context,
                    builder: (cntx) =>
                        SingleChannel(
                            widget.allBlogs[widget.index].authorId),
                    isScrollControlled: true,
                    isDismissible: false,
                    enableDrag: false,
                    barrierColor: Colors.white.withOpacity(0));
              },
              internet: Provider
                  .of<PendingRequestProvider>(context)
                  .internet),
        ),
        Spacer(),
        Container(
          margin:
          EdgeInsets.only(right: widget.constraints.maxWidth * 0.02),
          child: buildIconColumnText(context,
              null, Provider.of<
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
        ),
        Container(
          margin:
          EdgeInsets.only(right: widget.constraints.maxWidth * 0.02),
          child: GestureDetector(
            onTap: () async {
              SharedPrefHelper sph = SharedPrefHelper();
              Provider
                  .of<BlogProvider>(context)
                  .setIsPostFavourite = widget.allBlogs[widget.index].postId;
              bool internet = Provider
                  .of<PendingRequestProvider>(context)
                  .internet;
              if (internet == false)
                Provider.of<BlogProvider>(context).getIsPostFavourtite(
                    widget.allBlogs[widget.index].postId) == 0
                    ? Provider
                    .of<PendingRequestProvider>(context)
                    .addPendingRemoveFavourite = new PendingFavourite(
                    userToken: widget.userToken,
                    memberId: widget.memberId,
                    createdOn: DateTime.now(),
                    updatedOn: DateTime.now(),
                    blogId: widget.allBlogs[widget.index].postId) :
                Provider
                    .of<PendingRequestProvider>(context)
                    .addPendingFavourite = new PendingFavourite(
                    userToken: widget.userToken,
                    memberId: widget.memberId,
                    createdOn: DateTime.now(),
                    updatedOn: DateTime.now(),
                    blogId: widget.allBlogs[widget.index].postId);
              if (internet == false)
                Provider.of<BlogProvider>(context).getIsPostFavourtite(
                    widget.allBlogs[widget.index].postId) == 0
                    ? sph.savePosts(
                    sph.pendingremovefavourite_requests, Provider
                    .of<PendingRequestProvider>(context)
                    .pendingRemoveFavourites)
                    : sph.savePosts(sph.pendingfavourite_requests, Provider
                    .of<PendingRequestProvider>(context)
                    .pendingFavourites);
              if (internet == true)
                Provider.of<BlogProvider>(context).getIsPostFavourtite(
                    widget.allBlogs[widget.index].postId) == 0
                    ? removeFromFavourite(context, widget.userToken,
                    widget.memberId, widget.blog.postId)
                    : addToFavourite(context, widget.userToken,
                    widget.memberId, widget.blog.postId);
            },
            child:
            Icon(Provider.of<BlogProvider>(context).getIsPostFavourtite(
                widget.allBlogs[widget.index].postId) == 1
                ? Icons.turned_in
                : Icons.turned_in_not,
              color: Provider.of<BlogProvider>(context).getIsPostFavourtite(
                  widget.allBlogs[widget.index].postId) == 1
                  ? Colors.red
                  : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

