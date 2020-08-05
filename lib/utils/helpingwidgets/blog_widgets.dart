import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:faithstream/model/donation.dart';
import 'package:faithstream/profile/event_followed.dart';
import 'package:faithstream/singlepost/single_channel.dart';
import 'package:faithstream/singlepost/single_image.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
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
      this.userToken, this.blog,{this.isSingleChannel});

  @override
  _AuthorInfoState createState() => _AuthorInfoState();
}

class _AuthorInfoState extends State<AuthorInfo> {
  StreamController controller = new StreamController.broadcast();

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
              Colors.black,onTap: () => Navigator.push(context, MaterialPageRoute(builder: (cntx) => SingleChannel(widget.allBlogs[widget.index].authorId)))),
        ),
        Spacer(),
        if (widget.allBlogs[widget.index].isTicketAvailable == true /* && widget.allBlogs[widget.index].isPast != true */)
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
                                widget.userToken,
                                widget.allBlogs[widget.index])));
              },
              child: Icon(
                Icons.loyalty,
                color: Colors.black87,
              ),
            ),
          ),
        if (widget.allBlogs[widget.index].isDonationRequired == true)
          GestureDetector(
            onTap: () {
              widget.allBlogs[widget.index].donations.length == 0
                  ? showModalBottomSheet(
                  context: context,
                  builder: (cntx) => DonationModalSingle())
                  : showModalBottomSheet(
                  context: context,
                  builder: (cntx) =>
                      DonationModal(
                          widget.allBlogs[widget.index].donations));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.monetization_on,
                color: Colors.black87,
              ),
            ),
          ),
        if(widget.isSingleChannel != true)
        Container(
          margin:
          EdgeInsets.only(right: widget.constraints.maxWidth * 0.02),
          child: GestureDetector(
              onTap: () {
                final BlogProvider provider = Provider.of<BlogProvider>(
                    context);
                provider.setIsPostFavourite =
                    widget.allBlogs[widget.index].postId;
                provider.getIsPostFavourtite(
                    widget.allBlogs[widget.index].postId) == 0
                    ? removeFromFavourite(context, widget.userToken,
                    widget.memberId, widget.blog)
                    : addToFavourite(context, widget.userToken,
                    widget.memberId, widget.blog);
              },
              child: Icon(
                Icons.star,
                color: Provider.of<BlogProvider>(context).getIsPostFavourtite(
                    widget.allBlogs[widget.index].postId) == 1
                    ? Colors.red
                    : Colors.black87,
              )),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class LikeShareComment extends StatefulWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;
  final String memberId;
  final String userToken;
  final bool isSingleChannel;

  LikeShareComment(this.allBlogs, this.index, this.constraints, this.memberId,
      this.userToken,{this.isSingleChannel});

  @override
  _LikeShareCommentState createState() => _LikeShareCommentState();
}

class _LikeShareCommentState extends State<LikeShareComment> {
  StreamController controller = new StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.constraints.maxWidth * 0.6,
      padding: EdgeInsets.symmetric(
          horizontal: widget.constraints.maxWidth * 0.03,
          vertical: widget.constraints.maxHeight * 0.02),
      child: widget.isSingleChannel == true ? Container() : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          StreamBuilder(
            stream: controller.stream.asBroadcastStream(),
            builder: (context, snapshot) {
              return buildIconText(context, "Like", Icons.thumb_up, 3.0,
                  Provider.of<BlogProvider>(context).getIsPostLiked(
                      widget.allBlogs[widget.index].postId) == 1
                      ? Colors.red
                      : Colors.black87, onTap: () {
                    BlogProvider provider = Provider.of<BlogProvider>(context);
                    provider.setIsPostLiked =
                        widget.allBlogs[widget.index].postId;
                    likePost(
                        context,
                        widget.userToken,
                        "${widget.memberId}",
                        DateTime.now(),
                        DateTime.now(),
                            () {},
                        widget.allBlogs[widget.index]);
                  });
            },
          ),
          Spacer(),
          buildIconText(context, "Share", Icons.share, 3.0, Colors.black87),
          Spacer(),
          buildIconText(context, "comment", Icons.sms, 3.0, Colors.black87,
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (cntx) =>
                        CommentModal(widget.allBlogs, widget.index,
                            widget.userToken, widget.memberId));
              }),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
    getComments();
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
    Provider.of<BlogProvider>(context).resetComments(
        widget.allBlogs[widget.index].postId);
  }

  Future getComments() async {
    var commentData = await http.get(
        "http://api.faithstreams.net/api/Post/GetPostComments/${widget
            .allBlogs[widget.index].postId}",
        headers: {"Authorization": "Bearer ${widget.userToken}"});
    if (commentData.body.isNotEmpty) {
      var commentDataJson = json.decode(commentData.body);
      if (commentDataJson['data'] != null) {
        if (mounted)
          for (var c in commentDataJson['data']) {
            var userData = await http.get(
                "http://api.faithstreams.net/api/Member/GetMemberProfile/${c['memberID']}",
                headers: {"Authorization": "Bearer ${widget.userToken}"});
            if (commentDataJson['data'] == []) continue;
            if (mounted) {
              Comment newComment = new Comment(
                  commentId: c['id'],
                  commentMemberId: c['memberID'],
                  authorImage: json.decode(userData.body)['data']
                  ['profileImage'],
                  commentText: c['commentText'],
                  authorName: c['commentedBy'],
                  time: "${compareDate(c['dateCreated'])}");
              Provider.of<BlogProvider>(context).addComment(
                  newComment, widget.allBlogs[widget.index].postId);
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
                      Container(
                          key: Key("modallist"),
                          width: double.infinity,
                          height: constraints.maxHeight * 0.82,
                          child: ModalBottom(
                            scrollingList:
                            Provider.of<BlogProvider>(context).getCommentsList(
                                widget.allBlogs[widget.index].postId),
                            postId: widget.allBlogs[widget.index].postId,
                            userToken: widget.userToken,
                            memberId: widget.memberId,
                          )),
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
                                    onTap: () {
                                      if(commentText.isNotEmpty) {
                                        commentOnPost(
                                          context,
                                          widget.userToken,
                                          "${widget.memberId}",
                                          postId: widget
                                              .allBlogs[widget.index].postId,
                                          commentText:
                                          commentController.value.text,
                                          createdOn: DateTime.now(),
                                          updatedOn: DateTime.now(),
                                        );
                                        commentController.clear();
                                        setState(() {
                                          commentText = "";
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: commentText.isEmpty ? Colors.black87.withOpacity(0.4) : Colors.black87,
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

class ImagePostWidget extends StatelessWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;

  ImagePostWidget(this.allBlogs, this.index, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
              top: constraints.maxHeight * 0.02,
              bottom: constraints.maxHeight * 0.01),
          padding:
          EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.04),
          child: Text(allBlogs[index].title,
              style: TextStyle(color: Colors.black54, fontSize: 15)),
        ),
        /*if (allBlogs[index].isDonationRequired == true)
          DonationWidget(constraints, allBlogs[index].donations),*/
        SizedBox(height: constraints.maxHeight * 0.02),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (cntx) => SingleImage(allBlogs[index].image)));
            },
            child: Container(
              width: constraints.maxWidth * 0.9,
              child: allBlogs[index].image == null
                  ? Image.asset(
                "assets/images/laptop.png",
                fit: BoxFit.fitHeight,
              )
                  : FadeInImage.assetNetwork(
                placeholder: "assets/images/loading.gif",
                image: allBlogs[index].image,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TicketBuyWidget extends StatelessWidget {
  final BoxConstraints constraints;

  TicketBuyWidget(this.constraints);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: constraints.maxHeight * 0.02),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin:
              EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.04),
              width: constraints.maxWidth * 0.3,
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.loyalty,
                    color: Colors.white,
                    size: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Buy Tickets",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DonationWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final List<Donation> donations;
  final int isEventVideo;

  DonationWidget(this.constraints, this.donations, {this.isEventVideo});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: constraints.maxHeight * 0.02),
          GestureDetector(
            onTap: () {
              donations.length == 0
                  ? showModalBottomSheet(
                  context: context,
                  builder: (cntx) => DonationModalSingle())
                  : showModalBottomSheet(
                  context: context,
                  builder: (cntx) => DonationModal(donations));
            },
            child: Container(
              margin: isEventVideo == 1
                  ? EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.01)
                  : EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.04),
              width: constraints.maxWidth * 0.25,
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                    size: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Donate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VideoPostWidget extends StatelessWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;

  VideoPostWidget(this.allBlogs, this.index, this.constraints);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            top: constraints.maxHeight * 0.02,
          ),
          padding:
          EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.04),
          child: Text(allBlogs[index].title,
              style: TextStyle(color: Colors.black54, fontSize: 15)),
        ),
        /*if (allBlogs[index].isDonationRequired == true)
          DonationWidget(constraints, allBlogs[index].donations),*/
        SizedBox(height: constraints.maxHeight * 0.02),
        Center(
          child: allBlogs[index].image != null
              ? GestureDetector(
            onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (cntx) =>
                            SingleBlogPost(
                              singleBlog: allBlogs[index],
                            ))),
            child: Container(
              width: constraints.maxWidth * 0.9,
              height: constraints.maxHeight * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(allBlogs[index].image),
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
              : VideoPostAsset(constraints, allBlogs[index]),
        ),
      ],
    );
  }
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

class EventImagePostWidget extends StatelessWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;
  final String memberId;
  final String userToken;
  bool showButton;
  bool isSingleChannel;

  EventImagePostWidget(this.allBlogs, this.index, this.constraints,
      this.memberId, this.userToken,{this.showButton,this.isSingleChannel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
              top: constraints.maxHeight * 0.02,
              bottom: constraints.maxHeight * 0.01),
          padding:
          EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(allBlogs[index].title,
                  style: TextStyle(color: Colors.red, fontSize: 15)),
              SizedBox(
                height: constraints.maxHeight * 0.01,
              ),
              if (allBlogs[index].eventLocation != null)
                buildIconText(context, allBlogs[index].eventLocation,
                    Icons.location_on, 3.0, Colors.black54),
              SizedBox(
                height: constraints.maxHeight * 0.01,
              ),
              if (allBlogs[index].eventTime != null)
                buildIconText(context, allBlogs[index].eventTime,
                    Icons.watch_later, 3.0, Colors.black54),
              if(showButton != false && allBlogs[index].isPast != true && isSingleChannel != true)
              Container(
                margin: EdgeInsets.only(
                    top: constraints.maxHeight * 0.03,left: constraints.maxWidth * 0.007),
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
            ],
          ),
        ),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (allBlogs[index].isDonationRequired == true)
              DonationWidget(constraints, allBlogs[index].donations),
            Spacer(),
            if (allBlogs[index].isTicketAvailable == true)
              Padding(
                padding: EdgeInsets.only(
                    left: 0.0),
                child: TicketBuyWidget(constraints),
              ),
          ],
        ),*/
        SizedBox(height: constraints.maxHeight * 0.02),
        if (allBlogs[index].image != null)
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (cntx) => SingleImage(allBlogs[index].image)));
              },
              child: Container(
                width: constraints.maxWidth * 0.9,
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/loading.gif",
                  image: allBlogs[index].image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class EventFollowModal extends StatelessWidget {
  final BoxConstraints constraints;
  final int eventId;
  final int memberId;
  final String userToken;

  bool reminder1 = false;

  bool reminder2 = false;

  bool reminder3 = false;


  EventFollowModal(this.constraints,this.eventId, this.memberId, this.userToken);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: StatefulBuilder(builder: (context,_setState){
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
              child: Container(decoration: BoxDecoration(color: reminder1 || reminder2 || reminder3 ? Colors.red : Colors.red.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25)),
                margin: EdgeInsets.only(top: 16.0),
                width: constraints.maxWidth * 0.2,
                child: GestureDetector(
                  onTap: () {
                    if(reminder1 || reminder2 || reminder3) {
                      addEventFollow(context,eventId,memberId,userToken,reminder1: reminder1,reminder2: reminder2,reminder3: reminder3).then((_) {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (cntx) => EventsFollowed()));
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 8.0),
                    child: Center(child: Text("Done", style: TextStyle(color: Colors.white),)),
                  ),
                ),),),
          ],
        );
      },),
    );
  }


}

class EventVideoPostWidget extends StatelessWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;

  EventVideoPostWidget(this.allBlogs, this.index, this.constraints);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (cntx) =>
                    SingleBlogPost(
                      singleBlog: allBlogs[index],
                    )));
      },
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                top: constraints.maxHeight * 0.02,
                bottom: constraints.maxHeight * 0.02),
            padding:
            EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(allBlogs[index].title,
                    style: TextStyle(color: Colors.red, fontSize: 15)),
                if (allBlogs[index].eventLocation != null)
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                buildIconText(context, allBlogs[index].eventLocation,
                    Icons.location_on, 3.0, Colors.black54),
                SizedBox(
                  height: constraints.maxHeight * 0.01,
                ),
                if (allBlogs[index].eventTime != null)
                  buildIconText(context, allBlogs[index].eventTime,
                      Icons.watch_later, 3.0, Colors.black54),
                /*Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      if (allBlogs[index].isDonationRequired == true)
                      DonationWidget(
                        constraints,
                        allBlogs[index].donations,
                        isEventVideo: 1,
                      ),
                      Spacer(),
                      if (allBlogs[index].isTicketAvailable == true)
                        Padding(
                          padding: EdgeInsets.only(
                              left: 0),
                          child: TicketBuyWidget(constraints),
                        ),
                    ],
                  ),*/
              ],
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.01),
          Center(
            child: Container(
              width: constraints.maxWidth * 0.9,
              height: constraints.maxHeight * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: allBlogs[index].image == null
                      ? AssetImage("assets/images/laptop.png")
                      : NetworkImage(allBlogs[index].image),
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
                    width: constraints.maxWidth * 0.16,
                    height: constraints.maxHeight * 0.05,
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
}

class DonationModalSingle extends StatefulWidget {
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
                                builder: (cntx) =>
                                    PaymentMehodModal(
                                        double.parse(amountController.text)));
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

  DonationModal(this.donationsList);

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
              Container(
                width: double.infinity,
                height: constraints.maxHeight * 0.8,
                child: ListView.builder(
                    itemCount: widget.donationsList.length + 1,
                    itemBuilder: (cntx, index) {
                      return StatefulBuilder(
                        builder: (cntx, _setState) {
                          return index != widget.donationsList.length
                              ? RadioListTile(
                            activeColor: Colors.red,
                            groupValue: amount,
                            value: double.parse(
                              widget.donationsList[index].denomAmount,
                            ),
                            title: Text(
                                "\$${widget.donationsList[index].denomAmount}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                "${widget.donationsList[index]
                                    .denomDescription}"),
                            onChanged: handleRadioChange,
                          )
                              : RadioListTile(
                            activeColor: Colors.red,
                            groupValue: amount,
                            value: amountController.text == ""
                                ? 0.0
                                : double.parse(amountController.text),
                            title: TextField(
                              controller: amountController,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              keyboardType:
                              TextInputType.numberWithOptions(
                                  decimal: false, signed: false),
                              decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                                labelText: "Enter Amount Here",
                                labelStyle:
                                TextStyle(color: Color(0xFAC9CAD1)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFEBEAEF)),
                                ),
                              ),
                            ),
                            onChanged: handleRadioChange,
                          );
                        },
                      );
                    }),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    if (amount != 0.0) {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          context: context,
                          builder: (cntx) => PaymentMehodModal(amount));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        right: constraints.maxWidth * 0.04,
                        bottom: constraints.maxHeight * 0.05),
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    decoration: BoxDecoration(
                        color: amount == 0.0
                            ? Colors.red.withOpacity(0.3)
                            : Colors.red,
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "Donate",
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

  void handleRadioChange(double value) {
    setState(() {
      amount = value;
    });
  }
}

class PaymentMehodModal extends StatefulWidget {
  double amount;

  PaymentMehodModal(this.amount);

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
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
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
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    if (method != 0) {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (cntxs) =>
                              Container(height: MediaQuery
                                  .of(cntxs)
                                  .size
                                  .height * 0.7, child: PaypalDetails()));
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
    bool lengthValidation = cardNumberController.text.length == 12 &&
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
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.07, horizontal: 8.0),
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
                      labelText: "xxxx xxxx xxxx",
                      controller: cardNumberController,
                      inputList: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12)
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
                          print("cvv changed");
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

class DetailsTextField extends StatelessWidget {
  String labelText;
  IconData icon;
  TextEditingController controller;
  List<TextInputFormatter> inputList;
  Function onChange;

  DetailsTextField(
      {this.labelText, this.icon, this.controller, this.inputList,this.onChange});

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
                            child: buildTextWithIcon(
                                context,
                                Icons.shopping_cart,
                                "Buy Tickets",
                                6.0,
                                Colors.black87)),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.06,
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
                                    4 || snapshots.data['data']['remainingTickets'] <= 4
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
                                  data: Theme
                                      .of(context)
                                      .sliderTheme,
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
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (cntx) =>
                                                PaymentMehodModal(double.parse(
                                                    payable.toString())));
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
        "http://api.faithstreams.net/api/Member/GetEventByID/${widget.blog
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
