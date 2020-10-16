import 'dart:async';
import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:async/async.dart';
import 'package:faithstream/main.dart';
import 'package:faithstream/model/donation.dart';
import 'package:faithstream/model/pendingcomment.dart';
import 'package:faithstream/model/pendingfavourite.dart';
import 'package:faithstream/model/pendinglike.dart';
import 'package:faithstream/profile/event_followed.dart';
import 'package:faithstream/singlepost/single_channel.dart';
import 'package:faithstream/singlepost/single_image.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/custom_modal.dart' as bs;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modal_sheet.dart';
import '../shared_pref_helper.dart';

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
        /*Spacer(),
        if (allBlogs[index].isTicketAvailable ==
            true */ /* && allBlogs[index].isPast != true */ /*)
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (cntx) =>
                        Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.7,
                            margin: EdgeInsets.only(top: 20),
                            child: BuyTicketsUI(
                                userToken,
                                allBlogs[index])));
              },
              child: Icon(
                Icons.loyalty,
                color: Colors.black87,
              ),
            ),
          ),
        if (allBlogs[index].isDonationRequired == true)
          GestureDetector(
            onTap: () {
              allBlogs[index].donations.length == 0
                  ? showModalBottomSheet(
                  context: context,
                  builder: (cntx) => DonationModalSingle())
                  : showModalBottomSheet(
                  context: context,
                  builder: (cntx) =>
                      DonationModal(
                          allBlogs[index].donations));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.monetization_on,
                color: Colors.black87,
              ),
            ),
          ),*/
        Spacer(),
        Container(
          margin:
          EdgeInsets.only(right: widget.constraints.maxWidth * 0.02),
          child: GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
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

class _LikeShareCommentState extends State<LikeShareComment> with ChangeNotifier {
  StreamController likesController;
  StreamController commentController;

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
          StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 2)).asyncMap((event) => getLikeCount()),
              builder: (context, snapshot) {
                return buildIconColumnText(context,
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
                      Provider.of<BlogProvider>(globalContext).setLikingPostInProcess = true;
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
                        Provider.of<BlogProvider>(context).setLikingPostInProcess = false;
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
                    });
              }
          ),
          Spacer(),
          StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 2)).asyncMap((event) => getCommentCount()),
              builder: (context, snapshot) {
                return buildIconColumnText(
                    context,
                    "${Provider.of<BlogProvider>(globalContext).getPostCommentCounts(widget.allBlogs[widget.index].postId)} Comments",
                    Icons.mode_comment, 3.0, Colors.black87,
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (cntx) =>
                              CommentModal(widget.allBlogs, widget.index,
                                  widget.userToken, widget.memberId));
                    });
              }
          ),
          Spacer(),
          buildIconColumnText(
              context, "Share", Icons.share, 3.0, Colors.black87),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    likesController = new StreamController();
    commentController = new StreamController();
  }

  dynamic getCommentCount() async {
    final data = await http.get(
        "$baseAddress/api/Post/GetPostCommentsCount/${widget.allBlogs[widget
            .index].postId}",
        headers: {"Authorization": "Bearer ${widget.userToken}"});
    var dataJson = json.decode(data.body);
    if(dataJson['data'] != Provider.of<BlogProvider>(context).getPostCommentCounts(widget.allBlogs[widget.index].postId)) {
      Provider.of<BlogProvider>(globalContext).setCommentCount(
          dataJson['data'], widget.allBlogs[widget.index].postId);
      commentController.add(
          Provider.of<BlogProvider>(globalContext).getPostCommentCounts(
              widget.allBlogs[widget.index].postId));
    }
  }

  dynamic getLikeCount() async {
    final data = await http.get(
        "$baseAddress/api/Post/GetPostByID/${widget.allBlogs[widget.index]
            .postId}",
        headers: {"Authorization": "Bearer ${widget.userToken}"});
    var dataJson = json.decode(data.body);
    if(dataJson['data']['likesCount'] != Provider.of<BlogProvider>(globalContext).getPostLikedCounts(widget.allBlogs[widget.index].postId)) {
      Provider.of<BlogProvider>(globalContext).setLikesCount(dataJson['data']['likesCount'],widget.allBlogs[widget.index].postId);
      likesController.add(Provider.of<BlogProvider>(globalContext).getPostLikedCounts(widget.allBlogs[widget.index].postId));
    }
  }
}

class PostBottomComment extends StatefulWidget {
  BoxConstraints constraints;

  PostBottomComment(this.constraints);

  @override
  _PostBottomCommentState createState() => _PostBottomCommentState();
}

class _PostBottomCommentState extends State<PostBottomComment> {
  String profileImage = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(width: widget.constraints.maxWidth * 0.85,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.constraints.maxWidth * 0.015,
              vertical: widget.constraints.maxHeight * 0.025),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: profileImage == null ? AssetImage(
                            "assets/images/test.jpeg") : NetworkImage(
                            profileImage), fit: BoxFit.fill)),),
              Padding(padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Write a Comment", style: TextStyle(color: Colors.black54),),)
            ],),),),);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = new SharedPrefHelper();
    if (mounted) setState(() {
      profileImage = prefs.getString(sph.profile_image);
    });
  }

}

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
        "$baseAddress/api/Post/GetPostComments/${widget
            .allBlogs[widget.index].postId}",
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
              Comment newComment = new Comment(
                  commentId: c['id'],
                  commentMemberId: c['memberID'],
                  authorImage: null,
                  commentText: c['commentText'],
                  authorName: c['commentedBy'],
                  time: "${compareDate(c['dateCreated'])}");
              if(Provider.of<BlogProvider>(globalContext).doesCommentExist(c['id']) == false && Provider.of<BlogProvider>(globalContext).doesCommentExistInDeleteProcess(c['id']) == false)
              Provider.of<BlogProvider>(globalContext).addComment(
                  newComment);
            }
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.95,
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
                        stream: Stream.periodic(Duration(seconds: 2)).asyncMap((event) => getComments()),
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
                        }
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery
                              .of(context)
                              .viewInsets
                              .bottom),
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
                                      bool internet = Provider
                                          .of<PendingRequestProvider>(context)
                                          .internet;
                                      if (commentText.isNotEmpty) {
                                        Comment newComment = new Comment(
                                            commentMemberId: int.parse(
                                                widget.memberId),
                                            temopraryId: "temporary${widget
                                                .allBlogs[widget.index]
                                                .postId}",
                                            authorImage: profileImage,
                                            commentText: commentController.value
                                                .text,
                                            authorName: fullName,
                                            time: compareDate(DateTime.now()
                                                .toIso8601String()));
                                        Provider.of<BlogProvider>(context)
                                            .addComment(newComment,postId: widget.allBlogs[widget.index].postId);
                                        Provider.of<BlogProvider>(context).setAddingCommentInProcess = true;
                                        /*Provider.of<BlogProvider>(context)
                                            .setPostComment(
                                            widget.allBlogs[widget.index]
                                                .postId, newComment);*/

                                        if (internet == false) {
                                          SharedPrefHelper sph = SharedPrefHelper();
                                          Provider
                                              .of<PendingRequestProvider>(
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
                                              tempId: "temporary${widget
                                                  .allBlogs[widget.index]
                                                  .postId}",
                                              commentText: commentController
                                                  .text,
                                              commentedBy: fullName);
                                          sph.savePosts(
                                              sph.pendingcomment_requests,
                                              Provider
                                                  .of<PendingRequestProvider>(
                                                  context)
                                                  .pendingComments);
                                          Provider.of<BlogProvider>(context).setAddingCommentInProcess = false;
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
                                              tempId: newComment.temopraryId
                                          );
                                        commentController.clear();
                                        setState(() {
                                          commentText = "";
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: commentText.isEmpty ? Colors
                                          .black87.withOpacity(0.4) : Colors
                                          .black87,
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

class ImagePostWidget extends StatefulWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;
  final String userToken;
  final String memberId;

  ImagePostWidget(this.allBlogs, this.index, this.constraints, this.userToken,
      this.memberId);

  @override
  _ImagePostWidgetState createState() => _ImagePostWidgetState();
}

class _ImagePostWidgetState extends State<ImagePostWidget>
    with AutomaticKeepAliveClientMixin {
  bool internet;

  Image memoryImage;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.allBlogs[widget.index].imageBytes != null)
      _memoizer.runOnce(() => preCacheTheImage(context));
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
              top: widget.constraints.maxHeight * 0.02),
          padding:
          EdgeInsets.symmetric(horizontal: widget.constraints.maxWidth * 0.04),
          child: Text(widget.allBlogs[widget.index].title,
              style: TextStyle(color: Colors.black54, fontSize: 15)),
        ),
        /*if (allBlogs[index].isDonationRequired == true)
          DonationWidget(constraints, allBlogs[index].donations),*/
        Padding(
          padding: EdgeInsets.only(
              left: widget.constraints.maxWidth * 0.035, right: 8.0),
          child: DonateRemindBuy(
            isEvent: false,
            allBlogs: widget.allBlogs,
            index: widget.index,
            userToken: widget.userToken,
            memberId: widget.memberId,
            constraints: widget.constraints,),
        ),
        SizedBox(height: widget.constraints.maxHeight * 0.02),
        Center(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(context: context,
                  builder: (cntx) =>
                      SingleImage(
                          widget.allBlogs[widget.index].image,
                          widget.allBlogs[widget.index].imageBytes),
                  backgroundColor: Colors.black,
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25)),
              width: widget.constraints.maxWidth * 0.85,
              child: widget.allBlogs[widget.index].image == null
                  ? Image.asset(
                "assets/images/laptop.png",
                fit: BoxFit.fitHeight,
              )
                  : widget.allBlogs[widget.index].imageBytes == null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/loading.gif",
                  image: widget.allBlogs[widget.index].image,
                  fit: BoxFit.fill,
                ),
              ) : ClipRRect(
                  borderRadius: BorderRadius.circular(15), child: memoryImage),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> preCacheTheImage(BuildContext context) async {
    memoryImage = Image.memory(
      widget.allBlogs[widget.index].imageBytes, fit: BoxFit.fill,);
    precacheImage(memoryImage.image, context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class VideoPostWidget extends StatefulWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;
  final String userToken;
  final String memberId;

  VideoPostWidget(this.allBlogs, this.index, this.constraints, this.userToken,
      this.memberId);

  @override
  _VideoPostWidgetState createState() => _VideoPostWidgetState();
}

class _VideoPostWidgetState extends State<VideoPostWidget>
    with AutomaticKeepAliveClientMixin {
  bool internet;

  MemoryImage memoryImage;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.allBlogs[widget.index].imageBytes != null)
      _memoizer.runOnce(() => preCacheTheImage(context));
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            top: widget.constraints.maxHeight * 0.02,
          ),
          padding:
          EdgeInsets.symmetric(horizontal: widget.constraints.maxWidth * 0.04),
          child: Text(widget.allBlogs[widget.index].title,
              style: TextStyle(color: Colors.black54, fontSize: 15)),
        ),
        /*if (allBlogs[index].isDonationRequired == true)
          DonationWidget(constraints, allBlogs[index].donations),*/
        Padding(
          padding: EdgeInsets.only(
              left: widget.constraints.maxWidth * 0.035, right: 8.0),
          child: DonateRemindBuy(
            isEvent: false,
            allBlogs: widget.allBlogs,
            index: widget.index,
            userToken: widget.userToken,
            memberId: widget.memberId,
            constraints: widget.constraints,),
        ),
        SizedBox(height: widget.constraints.maxHeight * 0.02),
        Center(
          child: widget.allBlogs[widget.index].image != null
              ? GestureDetector(
            onTap: () {
              bs.showModalBottomSheet(context: context,
                  builder: (cntx) =>
                      SingleBlogPost(
                        singleBlog: widget.allBlogs[widget.index],
                      ),
                  barrierColor: Colors.white.withOpacity(0),
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true);
            },
            child: Container(
              width: widget.constraints.maxWidth * 0.85,
              height: widget.constraints.maxHeight * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: widget.allBlogs[widget.index].imageBytes == null
                        ? NetworkImage(widget.allBlogs[widget.index].image)
                        : memoryImage,
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.darken)),
              ),
              child: Container(
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        height: 20,
                        child: Text("0:38",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              : VideoPostAsset(
              widget.constraints, widget.allBlogs[widget.index]),
        ),
      ],
    );
  }

  Future<void> preCacheTheImage(BuildContext context) async {
    memoryImage = MemoryImage(widget.allBlogs[widget.index].imageBytes);
    precacheImage(memoryImage, context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


class VideoPostAsset extends StatelessWidget {
  final BoxConstraints constraints;
  final Blog blog;

  VideoPostAsset(this.constraints, this.blog);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (cntx) =>
                      SingleBlogPost(
                        singleBlog: blog,
                      ))),
      child: Container(
        width: constraints.maxWidth * 0.9,
        height: constraints.maxHeight * 0.4,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/laptop.png"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken)),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EventImagePostWidget extends StatefulWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;
  final String memberId;
  final String userToken;
  bool showButton;
  bool isSingleChannel;

  EventImagePostWidget(this.allBlogs, this.index, this.constraints,
      this.memberId, this.userToken, {this.showButton, this.isSingleChannel});

  @override
  _EventImagePostWidgetState createState() => _EventImagePostWidgetState();
}

class _EventImagePostWidgetState extends State<EventImagePostWidget>
    with AutomaticKeepAliveClientMixin {
  bool internet;

  Image memoryImage;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.allBlogs[widget.index].imageBytes != null)
      _memoizer.runOnce(() => preCacheTheImage(context));
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
              top: widget.constraints.maxHeight * 0.02,
              bottom: widget.constraints.maxHeight * 0.01),
          padding:
          EdgeInsets.symmetric(horizontal: widget.constraints.maxWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.allBlogs[widget.index].title,
                  style: TextStyle(color: Colors.red, fontSize: 15)),
              SizedBox(
                height: widget.constraints.maxHeight * 0.01,
              ),
              if (widget.allBlogs[widget.index].eventLocation != null)
                buildIconText(
                    context, widget.allBlogs[widget.index].eventLocation,
                    Icons.location_on, 3.0, Colors.black54),
              SizedBox(
                height: widget.constraints.maxHeight * 0.005,
              ),
              if (widget.allBlogs[widget.index].eventTime != null)
                buildIconText(context, widget.allBlogs[widget.index].eventTime,
                    Icons.watch_later, 3.0, Colors.black54),
              DonateRemindBuy(
                isEvent: false,
                allBlogs: widget.allBlogs,
                index: widget.index,
                userToken: widget.userToken,
                memberId: widget.memberId,
                constraints: widget.constraints,),
            ],
          ),
        ),
        SizedBox(height: widget.constraints.maxHeight * 0.02),
        if (widget.allBlogs[widget.index].image != null)
          Center(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(context: context,
                    builder: (cntx) =>
                        SingleImage(
                            widget.allBlogs[widget.index].image,
                            widget.allBlogs[widget.index].imageBytes),
                    backgroundColor: Colors.black,
                    isScrollControlled: true,
                    isDismissible: false,
                    enableDrag: false);
              },
              child: Container(
                width: widget.constraints.maxWidth * 0.85,
                child: widget.allBlogs[widget.index].imageBytes == null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/loading.gif",
                    image: widget.allBlogs[widget.index].image,
                    fit: BoxFit.fill,
                  ),
                )
                    : ClipRRect(borderRadius: BorderRadius.circular(15),
                    child: memoryImage),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> preCacheTheImage(BuildContext context) async {
    memoryImage = Image.memory(
      widget.allBlogs[widget.index].imageBytes, fit: BoxFit.fill,);
    precacheImage(memoryImage.image, context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class EventFollowModal extends StatelessWidget {
  final BoxConstraints constraints;
  final int eventId;
  final int memberId;
  final String userToken;

  bool reminder1 = false;

  bool reminder2 = false;

  bool reminder3 = false;


  EventFollowModal(this.constraints, this.eventId, this.memberId,
      this.userToken);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: StatefulBuilder(builder: (context, _setState) {
        return Column(
          children: <Widget>[
            CheckboxListTile(value: reminder1,
                activeColor: Colors.red,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("15 Minutes Before Event"),
                onChanged: (bool newValue) {
                  _setState(() {
                    reminder1 = newValue;
                  });
                }),
            CheckboxListTile(value: reminder2,
                activeColor: Colors.red,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("1 Hour Before Event"),
                onChanged: (bool newValue) {
                  _setState(() {
                    reminder2 = newValue;
                  });
                }),
            CheckboxListTile(value: reminder3,
                activeColor: Colors.red,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("1 Day Before Event"),
                onChanged: (bool newValue) {
                  _setState(() {
                    reminder3 = newValue;
                  });
                }),
            Align(alignment: Alignment.bottomRight,
              child: Container(decoration: BoxDecoration(
                  color: reminder1 || reminder2 || reminder3
                      ? Colors.red
                      : Colors.red.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25)),
                margin: EdgeInsets.only(top: 16.0),
                width: constraints.maxWidth * 0.2,
                child: GestureDetector(
                  onTap: () {
                    if (reminder1 || reminder2 || reminder3) {
                      addEventFollow(context, eventId, memberId, userToken,
                          reminder1: reminder1,
                          reminder2: reminder2,
                          reminder3: reminder3).then((_) {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (cntx) => EventsFollowed()));
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 8.0),
                    child: Center(child: Text("Done", style: TextStyle(
                        color: Colors.white),)),
                  ),
                ),),),
          ],
        );
      },),
    );
  }


}

class EventVideoPostWidget extends StatefulWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;
  final String userToken;
  final String memberId;

  EventVideoPostWidget(this.allBlogs, this.index, this.constraints,
      this.userToken, this.memberId);

  @override
  _EventVideoPostWidgetState createState() => _EventVideoPostWidgetState();
}

class _EventVideoPostWidgetState extends State<EventVideoPostWidget>
    with AutomaticKeepAliveClientMixin {
  bool internet;

  MemoryImage memoryImage;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.allBlogs[widget.index].imageBytes != null)
      _memoizer.runOnce(() => preCacheTheImage(context));
    return GestureDetector(
      onTap: () {
        bs.showModalBottomSheet(context: context,
            builder: (cntx) =>
                SingleBlogPost(
                  singleBlog: widget.allBlogs[widget.index],
                ),
            isScrollControlled: true,
            enableDrag: false,
            isDismissible: false,
            barrierColor: Colors.white.withOpacity(0));
      },
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: widget.constraints.maxHeight * 0.02,
                bottom: widget.constraints.maxHeight * 0.02),
            padding:
            EdgeInsets.symmetric(
                horizontal: widget.constraints.maxWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.allBlogs[widget.index].title,
                    style: TextStyle(color: Colors.red, fontSize: 15)),
                if (widget.allBlogs[widget.index].eventLocation != null)
                  SizedBox(
                    height: widget.constraints.maxHeight * 0.01,
                  ),
                buildIconText(
                    context, widget.allBlogs[widget.index].eventLocation,
                    Icons.location_on, 3.0, Colors.black54),
                SizedBox(
                  height: widget.constraints.maxHeight * 0.01,
                ),
                if (widget.allBlogs[widget.index].eventTime != null)
                  buildIconText(
                      context, widget.allBlogs[widget.index].eventTime,
                      Icons.watch_later, 3.0, Colors.black54),
                DonateRemindBuy(
                  isEvent: true,
                  allBlogs: widget.allBlogs,
                  index: widget.index,
                  userToken: widget.userToken,
                  memberId: widget.memberId,
                  constraints: widget.constraints,),
              ],
            ),
          ),
          SizedBox(height: widget.constraints.maxHeight * 0.01),
          Center(
            child: Container(
              width: widget.constraints.maxWidth * 0.85,
              height: widget.constraints.maxHeight * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: widget.allBlogs[widget.index].image == null
                      ? AssetImage("assets/images/laptop.png")
                      : widget.allBlogs[widget.index].imageBytes == null
                      ? NetworkImage(widget.allBlogs[widget.index].image)
                      : memoryImage,
                  fit: BoxFit.fill,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50)),
                  child: Container(
                    width: widget.constraints.maxWidth * 0.16,
                    height: widget.constraints.maxHeight * 0.05,
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: Text("0:38"),
                        ),
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> preCacheTheImage(BuildContext context) async {
    memoryImage = MemoryImage(widget.allBlogs[widget.index].imageBytes);
    precacheImage(memoryImage, context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class DonateRemindBuy extends StatelessWidget {
  final List<Blog> allBlogs;
  final int index;
  BoxConstraints constraints;
  String userToken;
  String memberId;
  bool isEvent;

  DonateRemindBuy(
      {this.isEvent, this.allBlogs, this.index, this.constraints, this.userToken, this.memberId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if(allBlogs[index].isPast != true && isEvent == true)
          Container(
            margin: EdgeInsets.only(
                top: constraints.maxHeight * 0.03,
                left: constraints.maxWidth * 0.007),
            padding: EdgeInsets.all(4.0),
            color: Colors.red,
            width: constraints.maxWidth * 0.27,
            child: buildIconText(
                context, "Remind Me", Icons.notifications, 3.0,
                Colors.white, onTap: () {
              showModalBottomSheet(context: context,
                  builder: (cntx) =>
                      EventFollowModal(constraints,
                          allBlogs[index].eventId, int.parse(memberId),
                          userToken));
            }),
          ),
        if(allBlogs[index].isPast != true && isEvent == true)
          Spacer(),
        if (allBlogs[index].isDonationRequired == true)
          Container(
            margin: EdgeInsets.only(
                top: constraints.maxHeight * 0.03,
                left: constraints.maxWidth * 0.007),
            padding: EdgeInsets.all(4.0),
            color: Colors.red,
            width: constraints.maxWidth * 0.22,
            child: buildIconText(
                context, "Donate", Icons.monetization_on, 3.0,
                Colors.white, onTap: () {
              allBlogs[index].donations.length == 0
                  ? showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  builder: (cntx) =>
                      DonationModalSingle(
                        channelName: allBlogs[index].author,
                        postTitle: allBlogs[index].title,
                        postType: allBlogs[index].postType,
                        channelId: allBlogs[index].authorId,
                        contentId: allBlogs[index].postId,))
                  : showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: false,
                  builder: (cntx) =>
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.6,
                        child: DonationModal(
                          allBlogs[index].donations,
                          contentId: allBlogs[index].postId,
                          postType: allBlogs[index].postType,
                          channelId: allBlogs[index].authorId,
                          postTitle: allBlogs[index].title,
                          channelName: allBlogs[index].author,),
                      ));
            }),
          ),
        if(allBlogs[index].isPast != true && isEvent == true ||
            allBlogs[index].isDonationRequired == true &&
                allBlogs[index].isTicketAvailable ==
                    true)
          Spacer(),
        if (allBlogs[index].isTicketAvailable ==
            true /* && widget.allBlogs[widget.index].isPast != true */)
          Container(
            margin: EdgeInsets.only(
                top: constraints.maxHeight * 0.03,
                left: constraints.maxWidth * 0.007),
            padding: EdgeInsets.all(4.0),
            color: Colors.red,
            width: constraints.maxWidth * 0.27,
            child: buildIconText(
                context, "Buy Tickets", Icons.loyalty, 3.0,
                Colors.white, onTap: () {
              showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  isScrollControlled: true,
                  builder: (cntx) =>
                      Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.7,
                          margin: EdgeInsets.only(top: 20),
                          child: BuyTicketsUI(
                              userToken,
                              allBlogs[index])));
            }),
          ),
      ],
    );
  }
}

class DonationModalSingle extends StatefulWidget {
  String channelName;
  String postType;
  String postTitle;
  int channelId;
  String contentId;

  DonationModalSingle(
      {this.channelName, this.postType, this.postTitle, this.channelId, this.contentId});

  @override
  _DonationModalSingleState createState() => _DonationModalSingleState();
}

class _DonationModalSingleState extends State<DonationModalSingle> {
  TextEditingController amountController = new TextEditingController();

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
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      width: constraints.maxWidth * 0.85,
                      child: TextField(
                        maxLines: null,
                        style: TextStyle(color: Colors.black),
                        controller: amountController,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Add Your Amount",
                            hintStyle: TextStyle(fontSize: 14.0)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          if (amountController.text != "") {
                            Navigator.pop(context);
                            showModalBottomSheet(
                                context: context,
                                isDismissible: false,
                                builder: (cntx) =>
                                    PaymentMehodModal(
                                      amount: double.parse(
                                          amountController.text),
                                      notes: "You Donated to a ${widget
                                          .postType} by ${widget
                                          .channelName} with Title ${widget
                                          .postTitle}",
                                      channelId: widget.channelId,
                                      postType: widget.postType,
                                      contentId: widget.contentId,));
                          }
                        },
                        child: Icon(
                          Icons.monetization_on,
                          color: amountController.text.isEmpty
                              ? Colors.red.withOpacity(0.3)
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                )),
          );
          ;
        },
      ),
    );
  }
}

class DonationModal extends StatefulWidget {
  List<Donation> donationsList;
  String channelName;
  String postType;
  String postTitle;
  int channelId;
  String contentId;

  DonationModal(this.donationsList,
      {this.channelName, this.postType, this.postTitle, this.channelId, this.contentId});

  @override
  _DonationModalState createState() => _DonationModalState();
}

class _DonationModalState extends State<DonationModal> {
  double amount = 0.0;
  TextEditingController amountController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: MediaQuery
          .of(context)
          .viewInsets
          .bottom),
      child: LayoutBuilder(
        builder: (cntx, constraints) {
          return Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Align(alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.clear, size: 15), onPressed: () {
                      Navigator.pop(context);
                    },),),
                  Container(
                    width: double.infinity,
                    height: constraints.maxHeight * 0.9,
                    child: ListView.builder(
                        itemCount: widget.donationsList.length + 2,
                        itemBuilder: (cntx, index) {
                          return StatefulBuilder(
                            builder: (cntx, _setState) {
                              return Container(
                                margin: EdgeInsets.only(
                                    top: index == 0 ? 0 : 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    if(index < widget.donationsList.length)
                                      RadioListTile(
                                        activeColor: Colors.red,
                                        groupValue: amount,
                                        value: double.parse(
                                          widget.donationsList[index]
                                              .denomAmount,
                                        ),
                                        title: Container(
                                          width: constraints.maxWidth * 0.75,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 16),
                                          color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Text("Suggested",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight
                                                            .bold),),
                                                  Container(
                                                    width: constraints
                                                        .maxWidth * 0.62,
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Text(
                                                      "${widget
                                                          .donationsList[index]
                                                          .denomDescription ==
                                                          null || widget
                                                          .donationsList[index]
                                                          .denomDescription
                                                          .isEmpty ? "" : widget
                                                          .donationsList[index]
                                                          .denomDescription}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),),),
                                                ],),
                                              Spacer(),
                                              Text(
                                                  "\$${widget
                                                      .donationsList[index]
                                                      .denomAmount}",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                            ],),),
                                        onChanged: handleRadioChange,
                                      ),
                                    if(index == widget.donationsList.length)
                                      Container(
                                        margin: EdgeInsets.only(top: 16),
                                        child: RadioListTile(
                                          activeColor: Colors.red,
                                          groupValue: amount,
                                          value: amountController.text == ""
                                              ? 0.0
                                              : double.parse(
                                              amountController.text),
                                          title: TextField(
                                            controller: amountController,
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: false, signed: false),
                                            decoration: InputDecoration(
                                              contentPadding:
                                              EdgeInsets.only(
                                                  left: 10, right: 10),
                                              labelText: "Enter Amount Here",
                                              labelStyle:
                                              TextStyle(
                                                  color: Color(0xFAC9CAD1)),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFEBEAEF)),
                                              ),
                                            ),
                                          ),
                                          onChanged: handleRadioChange,
                                        ),
                                      ),
                                    if(index == widget.donationsList.length + 1)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (amount != 0.0) {
                                              Navigator.pop(context);
                                              showModalBottomSheet(
                                                  context: context,
                                                  isDismissible: false,
                                                  builder: (cntx) =>
                                                      PaymentMehodModal(
                                                        amount: amount,
                                                        notes: "You Donated to a ${widget
                                                            .postType} by ${widget
                                                            .channelName} with Title ${widget
                                                            .postTitle}",
                                                        channelId: widget
                                                            .channelId,
                                                        postType: widget
                                                            .postType,
                                                        contentId: widget
                                                            .contentId,));
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: constraints.maxWidth *
                                                    0.04,
                                                bottom: constraints.maxHeight *
                                                    0.05),
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 6.0),
                                            decoration: BoxDecoration(
                                                color: amount == 0.0
                                                    ? Colors.red.withOpacity(
                                                    0.3)
                                                    : Colors.red,
                                                borderRadius: BorderRadius
                                                    .circular(25)),
                                            child: Text(
                                              "Donate",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void handleRadioChange(double value) {
    setState(() {
      amount = value;
    });
  }
}

class PaymentMehodModal extends StatefulWidget {
  double amount;
  int channelId;
  String notes;
  String contentId;
  String postType;

  PaymentMehodModal(
      {this.amount, this.notes, this.channelId, this.contentId, this.postType});

  @override
  _PaymentMehodModalState createState() => _PaymentMehodModalState();
}

class _PaymentMehodModalState extends State<PaymentMehodModal> {
  int method = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: MediaQuery
          .of(context)
          .viewInsets
          .bottom),
      child: LayoutBuilder(
        builder: (cntx, constraints) {
          return Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Align(alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.clear, size: 15,), onPressed: () {
                      Navigator.pop(context);
                    },),),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: RadioListTile(
                      activeColor: Colors.red,
                      onChanged: handleRadioChange,
                      groupValue: method,
                      value: 1,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.credit_card,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              "Pay With Paypal",
                              style: TextStyle(color: Colors.black87),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    if (method != 0) {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          isScrollControlled: true,
                          isDismissible: false,
                          context: context,
                          builder: (cntxs) =>
                              Container(height: MediaQuery
                                  .of(cntxs)
                                  .size
                                  .height * 0.7,
                                  child: PaypalDetails(
                                    amount: widget.amount.toString(),
                                    channelId: widget.channelId,
                                    notes: widget.notes,
                                    contentId: widget.contentId,
                                    postType: widget.postType,)));
                    }
                  },
                  child: Container(
                    width: constraints.maxWidth * 0.2,
                    margin: EdgeInsets.only(
                        right: constraints.maxWidth * 0.04,
                        bottom: constraints.maxHeight * 0.05),
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    decoration: BoxDecoration(
                        color: method == 0
                            ? Colors.red.withOpacity(0.3)
                            : Colors.red,
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "Next",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void handleRadioChange(int value) {
    setState(() {
      method = value;
    });
  }
}

class PaypalDetails extends StatefulWidget {
  String amount;
  int channelId;
  String notes;
  String contentId;
  String postType;

  PaypalDetails(
      {this.amount, this.notes, this.contentId, this.channelId, this.postType});

  @override
  _PaypalDetailsState createState() => _PaypalDetailsState();
}

class _PaypalDetailsState extends State<PaypalDetails> {
  TextEditingController cardNumberController = new TextEditingController();
  TextEditingController expirationDayController = new TextEditingController();
  TextEditingController expirationMonthController = new TextEditingController();
  TextEditingController cvvController = new TextEditingController();


  String cardNumberText = "";
  String expirationDayText = "";
  String expirationMonthText = "";
  String cvvText = "";


  @override
  Widget build(BuildContext context) {
    /* ------------------- Validations -------------------- */
    bool validation = cardNumberText.isNotEmpty &&
        expirationDayText.isNotEmpty &&
        expirationMonthText.isNotEmpty &&
        cvvText.isNotEmpty;
    bool lengthValidation = cardNumberController.text.length == 16 &&
        expirationDayText.length == 2 &&
        expirationMonthText.length == 4 &&
        cvvText.length == 3;
    String cardType = getCardType(cardNumberText);
    bool expirationValidation = false;
    if (validation == true)
      expirationValidation = (int.parse(expirationMonthController.text) ==
          DateTime
              .now()
              .year &&
          int.parse(expirationDayController.text) > DateTime
              .now()
              .month &&
          int.parse(expirationDayController.text) != 0 &&
          int.parse(expirationDayController.text) <= 12) ||
          (int.parse(expirationMonthController.text) > DateTime
              .now()
              .year &&
              int.parse(expirationMonthController.text) <=
                  (DateTime
                      .now()
                      .year + 3) &&
              int.parse(expirationDayController.text) != 0 &&
              int.parse(expirationDayController.text) <= 12);
    print(
        "validation: $validation  Expiration $expirationValidation  Length: $lengthValidation");
    /* ------------------- End Validations -------------------- */
    return LayoutBuilder(
      builder: (cntx, constraints) {
        return Container(
          margin:
          EdgeInsets.only(bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom),
          child: Stack(
            children: <Widget>[
              Align(alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.clear, size: 15), onPressed: () {
                  Navigator.pop(context);
                },),),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.085, horizontal: 8.0),
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Card Number",
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        Spacer(),
                        if (cardType != null)
                          Container(
                              width: 24,
                              height: 24,
                              child: Image.asset(
                                cardType == "visa"
                                    ? "assets/images/visa.png"
                                    : "assets/images/mastercard.png",
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.high,
                              )),
                        if (cardType == null)
                          Text(
                              cardNumberController.text.isNotEmpty
                                  ? "Not Supported"
                                  : "",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    DetailsTextField(
                      labelText: "xxxx xxxx xxxx xxxx",
                      controller: cardNumberController,
                      inputList: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16)
                      ],
                      onChange: (value) {
                        setState(() {
                          cardNumberText = value;
                        });
                      },
                      icon: Icons.credit_card,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.06),
                    Text(
                      "Expiration Date",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: constraints.maxWidth * 0.4,
                            child: DetailsTextField(
                              labelText: "MM",
                              controller: expirationDayController,
                              inputList: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2)
                              ],
                              onChange: (value) {
                                setState(() {
                                  expirationDayText = value;
                                });
                              },
                            )),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Container(
                            width: constraints.maxWidth * 0.4,
                            child: DetailsTextField(
                              labelText: "YYYY",
                              controller: expirationMonthController,
                              inputList: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4)
                              ],
                              onChange: (value) {
                                setState(() {
                                  expirationMonthText = value;
                                });
                              },
                            )),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.06),
                    Text(
                      "CVV",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    DetailsTextField(
                      labelText: "xxx",
                      controller: cvvController,
                      inputList: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3)
                      ],
                      onChange: (value) {
                        setState(() {
                          cvvText = value;
                        });
                      },
                    ),
                    SizedBox(height: constraints.maxHeight * 0.06),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          if (validation && lengthValidation) {
                            if (expirationValidation && cardType != null) {
                              Navigator.pop(context);
                              showModalBottomSheet(context: context,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  builder: (cntxs) =>
                                      Container(height: MediaQuery
                                          .of(cntxs)
                                          .size
                                          .height * 0.7,
                                          child: SendDonationPaymentRequest(
                                            amount: widget.amount,
                                            channelId: widget.channelId,
                                            notes: widget.notes,
                                            cardNumber: cardNumberText,
                                            cardType: cardType,
                                            cvc: cvvText,
                                            expiryMonth: expirationDayText,
                                            expiryYear: expirationMonthText,
                                            contentId: widget.contentId,
                                            postType: widget.postType,)));
                            }
                          }
                        },
                        child: Container(
                          width: constraints.maxWidth * 0.2,
                          margin: EdgeInsets.only(
                              right: constraints.maxWidth * 0.04,
                              bottom: constraints.maxHeight * 0.05),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 6.0),
                          decoration: BoxDecoration(
                              color: validation == false ||
                                  expirationValidation == false ||
                                  lengthValidation == false ||
                                  cardType == null
                                  ? Colors.red.withOpacity(0.3)
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            "Done",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getCardType(String number) {
    if (number.startsWith(new RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      return "master";
    } else if (number.startsWith(new RegExp(r'[4]'))) {
      return "visa";
    } else {
      return null;
    }
  }
}


class SendDonationPaymentRequest extends StatefulWidget {
  String amount;
  String cardType;
  String cardNumber;
  int channelId;
  String cvc;
  String expiryMonth;
  String expiryYear;
  String notes;
  String postType;
  String contentId;

  SendDonationPaymentRequest(
      {this.amount, this.cardType, this.cardNumber, this.cvc, this.expiryMonth, this.expiryYear, this.notes, this.channelId, this.postType, this.contentId});

  @override
  _SendDonationPaymentRequestState createState() =>
      _SendDonationPaymentRequestState();
}

class _SendDonationPaymentRequestState
    extends State<SendDonationPaymentRequest> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  String userToken;
  String memberId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _memoizer.runOnce(() =>
        makePaymentOfDonation(
            context: context,
            contentId: widget.contentId,
            notes: widget.notes,
            postType: widget.postType,
            channelId: widget.channelId,
            amount: widget.amount,
            cardType: widget.cardType,
            cardNumber: widget.cardNumber,
            cvc: widget.cvc,
            expiryMonth: widget.expiryMonth,
            expiryYear: widget.expiryYear
        )), builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting :
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(width: 50, height: 50,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,),),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text("Please Wait..."),)
            ],),);
          break;
        case ConnectionState.done :
          return snapshot.data == true ? Stack(
            children: <Widget>[
              Align(alignment: Alignment.topRight, child: Padding(
                padding: EdgeInsets.only(right: 8.0, top: 4.0),
                child: IconButton(
                  icon: Icon(Icons.clear, size: 15), onPressed: () {
                  Navigator.pop(context);
                },),),),
              Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.done, color: Colors.red, size: 50,),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0), child: Text("Done"),),
                ],),),
            ],
          ) : Stack(
            children: <Widget>[
              Align(alignment: Alignment.topRight, child: Padding(
                padding: EdgeInsets.only(right: 8.0, top: 4.0),
                child: IconButton(
                  icon: Icon(Icons.clear, size: 15), onPressed: () {
                  Navigator.pop(context);
                },),),),
              Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.clear, color: Colors.red, size: 50,),
                  Padding(padding: EdgeInsets.only(top: 16.0),
                    child: Text("Something Went Wrong :("),),
                ],),),
            ],
          );
      }
    },);;

    /**/
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    setState(() {
      userToken = prefs.getString(sph.user_token);
      memberId = prefs.getString(sph.member_id);
    });
  }

}

class DetailsTextField extends StatelessWidget {
  String labelText;
  IconData icon;
  TextEditingController controller;
  List<TextInputFormatter> inputList;
  Function onChange;

  DetailsTextField(
      {this.labelText, this.icon, this.controller, this.inputList, this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: inputList,
      onChanged: onChange,
      keyboardType:
      TextInputType.numberWithOptions(decimal: false, signed: false),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10, right: 10),
        labelText: labelText,
        suffixIcon: icon == null
            ? null
            : Icon(
          icon,
          color: Colors.red,
        ),
        labelStyle: TextStyle(color: Color(0xFAC9CAD1)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEBEAEF)),
        ),
      ),
    );
  }
}

class BuyTicketsUI extends StatefulWidget {
  String userToken;
  Blog blog;

  BuyTicketsUI(this.userToken, this.blog);

  @override
  _BuyTicketsUIState createState() => _BuyTicketsUIState();
}

class _BuyTicketsUIState extends State<BuyTicketsUI> {
  int Quantity = 1;
  double price;
  double discountPrice;
  int total;
  int discount = 0;
  int payable;
  int remainingTickets;
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (cntx, constraints) {
        return FutureBuilder(
          future: _memoizer.runOnce(() => this.getData()),
          builder: (cntex, snapshots) {
            if (snapshots.connectionState == ConnectionState.done) {
              if (snapshots.data['status'] != "error") {
                price = double.parse(
                    snapshots.data['data']['ticketPrice'].toString());
                discountPrice = double.parse(
                    snapshots.data['data']['ticketDiscount'].toString());
                remainingTickets =
                    snapshots.data['data']['remainingTickets'] - Quantity;
                total = (price * Quantity).toInt();
                payable = total - discount;
              }
            }
            if (snapshots.connectionState == ConnectionState.done)
              if (snapshots.data['status'] == "error")
                return Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.cloud_off, size: 50, color: Colors.red,),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Text("Tickets Are Unavailable",
                      style: TextStyle(color: Colors.black87, fontSize: 15),),
                    SizedBox(height: constraints.maxHeight * 0.01),
                    Text("Please Check Later",
                      style: TextStyle(color: Colors.black45, fontSize: 15),)
                  ],);
            if (snapshots.connectionState == ConnectionState.waiting ||
                snapshots.connectionState == ConnectionState.done)
              switch (snapshots.connectionState) {
                case ConnectionState.done :
                  return snapshots.data['data']['remainingTickets'] == 0
                      ? Center(child: Image.asset("assets/images/soldout.jpg"),)
                      : Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: <Widget>[
                              buildTextWithIcon(
                                  context,
                                  Icons.shopping_cart,
                                  "Buy Tickets",
                                  6.0,
                                  Colors.black87),
                              Spacer(),
                              IconButton(icon: Icon(Icons.clear, size: 15),
                                onPressed: () {
                                  Navigator.pop(context);
                                },)
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.03,
                              left: constraints.maxWidth * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Price: Rs $price",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              Text(
                                "Buy ${snapshots
                                    .data['data']['ticketDiscountOnQty']} tickets & get discount of Rs ${snapshots
                                    .data['data']['ticketDiscount']} on each !",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.06),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Available Tickets: $remainingTickets",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.05,
                              ),
                              Container(
                                width: constraints.maxWidth * 0.8,
                                child: double.parse(snapshots.data['data']
                                ['ticketsLimitPerPerson']
                                    .toString()) <=
                                    4 || snapshots
                                    .data['data']['remainingTickets'] <= 4
                                    ? Container(
                                  width: constraints.maxWidth * 0.7,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      buildNumber("1", snapshots.data['data']
                                      ['ticketDiscountOnQty'], discountPrice),
                                      Spacer(),
                                      if(double.parse(snapshots.data['data']
                                      ['ticketsLimitPerPerson']
                                          .toString()) > 1)
                                        buildNumber("2", snapshots.data['data']
                                        ['ticketDiscountOnQty'], discountPrice),
                                      Spacer(),
                                      if(double.parse(snapshots.data['data']
                                      ['ticketsLimitPerPerson']
                                          .toString()) > 2)
                                        buildNumber("3", snapshots.data['data']
                                        ['ticketDiscountOnQty'], discountPrice),
                                      Spacer(),
                                      if(double.parse(snapshots.data['data']
                                      ['ticketsLimitPerPerson']
                                          .toString()) > 3)
                                        buildNumber("4", snapshots.data['data']
                                        ['ticketDiscountOnQty'], discountPrice),
                                    ],
                                  ),
                                )
                                    : SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    inactiveTrackColor: Colors.grey,
                                    thumbColor: Colors.white,
                                    activeTrackColor: Colors.white,
                                    overlayColor: Colors.white,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 7.0),
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 15.0),
                                  ),
                                  child: Slider(
                                    activeColor: Colors.red,
                                    inactiveColor: Colors.grey,
                                    value: Quantity.toDouble(),
                                    min: 1.0,
                                    // snapshots.data['data']['event']['ticketsLimitPerPerson'] > snapshots.data['data']['event']['remainingTickets'] ? double.parse(snapshots.data['data']['event']['remainingTickets'].toString()) :
                                    max: double.parse(snapshots
                                        .data['data']['ticketsLimitPerPerson']
                                        .toString()) > double.parse(snapshots
                                        .data['data']['remainingTickets']
                                        .toString()) ? double.parse(snapshots
                                        .data['data']['remainingTickets']
                                        .toString()) : double.parse(snapshots
                                        .data['data']['ticketsLimitPerPerson']
                                        .toString()),
                                    onChanged: (double newValue) {
                                      setState(() {
                                        Quantity = newValue.toInt();
                                        total =
                                            (Quantity * price).toInt();
                                        Quantity >=
                                            snapshots.data['data']
                                            ['ticketDiscountOnQty']
                                            ? discount =
                                            (discountPrice * Quantity)
                                                .toInt()
                                            : discount = 0;
                                        payable = total - discount;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.05),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: constraints.maxWidth * 0.4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      buildInfoSingle("Quantity:", "$Quantity"),
                                      SizedBox(
                                          height: constraints.maxHeight * 0.04),
                                      buildInfoSingle("Sub Total:", "$total"),
                                      SizedBox(
                                          height: constraints.maxHeight * 0.04),
                                      buildInfoSingle("Discount:", "$discount"),
                                      SizedBox(
                                          height: constraints.maxHeight * 0.04),
                                      buildInfoSingle("Payable:", "$payable"),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.1),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      if (payable != 0) {
                                        Navigator.pop(context);
/*                                        showModalBottomSheet(
                                            context: context,
                                            isDismissible: false,
                                            builder: (cntx) =>
                                                PaymentMehodModal(double.parse(
                                                    payable.toString())));*/
                                      }
                                    },
                                    child: Container(
                                      width: constraints.maxWidth * 0.2,
                                      margin: EdgeInsets.only(
                                        left: constraints.maxWidth * 0.025,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 6.0),
                                      decoration: BoxDecoration(
                                          color: payable == 0 ? Colors.red
                                              .withOpacity(0.4) : Colors.red,
                                          borderRadius:
                                          BorderRadius.circular(25)),
                                      child: Text(
                                        "Next",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  break;
                case ConnectionState.waiting :
                  return Container(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  );
                  break;
              }
          },
        );
      },
    );
  }

  Widget buildNumber(String text, maxDiscountQuantity, double discountPrice) {
    return GestureDetector(
      onTap: () {
        print(maxDiscountQuantity);
        setState(() {
          Quantity = int.parse(text);
          if (Quantity >= maxDiscountQuantity)
            discount = (discountPrice * Quantity).toInt();
          if (Quantity < maxDiscountQuantity)
            discount = 0;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Quantity == int.parse(text) ? Colors.red : Colors
                .transparent,
            border: Border.all(width: 1,
                color: Quantity == int.parse(text) ? Colors.transparent : Colors
                    .red),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Center(child: Text(text, style: TextStyle(
            color: Quantity == int.parse(text) ? Colors.white : Colors
                .black),)),
      ),
    );
  }

  void getData() async {
    var postData = await http.get(
        "$baseAddress/api/Member/GetEventByID/${widget.blog
            .eventId}",
        headers: {"Authorization": "Bearer ${widget.userToken}"});

    return json.decode(postData.body);
  }

  Widget buildInfoSingle(String heading, String amount) {
    return Row(
      children: <Widget>[
        Text(heading, style: TextStyle(fontWeight: FontWeight.bold)),
        Spacer(),
        Text(amount),
      ],
    );
  }
}
