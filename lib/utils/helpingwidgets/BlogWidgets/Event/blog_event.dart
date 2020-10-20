import 'package:faithstream/model/blog.dart';
import 'package:faithstream/singlepost/single_image.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Helpers/blog_widgets_helper.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:faithstream/utils/custom_modal.dart' as bs;

class EventImagePostWidget extends StatefulWidget {
  final List<Blog> allBlogs;
  final int index;
  final BoxConstraints constraints;
  final String memberId;
  final String userToken;
  bool showButton;
  bool isSingleChannel;

  EventImagePostWidget(this.allBlogs, this.index, this.constraints,
      this.memberId, this.userToken,
      {this.showButton, this.isSingleChannel});

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
          padding: EdgeInsets.symmetric(
              horizontal: widget.constraints.maxWidth * 0.04),
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
                    context,
                    widget.allBlogs[widget.index].eventLocation,
                    Icons.location_on,
                    3.0,
                    Colors.black54),
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
                constraints: widget.constraints,
              ),
            ],
          ),
        ),
        SizedBox(height: widget.constraints.maxHeight * 0.02),
        if (widget.allBlogs[widget.index].image != null)
          Center(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (cntx) => SingleImage(
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
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: memoryImage),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> preCacheTheImage(BuildContext context) async {
    memoryImage = Image.memory(
      widget.allBlogs[widget.index].imageBytes,
      fit: BoxFit.fill,
    );
    precacheImage(memoryImage.image, context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
        bs.showModalBottomSheet(
            context: context,
            builder: (cntx) => SingleBlogPost(
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
            padding: EdgeInsets.symmetric(
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
                    context,
                    widget.allBlogs[widget.index].eventLocation,
                    Icons.location_on,
                    3.0,
                    Colors.black54),
                SizedBox(
                  height: widget.constraints.maxHeight * 0.01,
                ),
                if (widget.allBlogs[widget.index].eventTime != null)
                  buildIconText(
                      context,
                      widget.allBlogs[widget.index].eventTime,
                      Icons.watch_later,
                      3.0,
                      Colors.black54),
                DonateRemindBuy(
                  isEvent: true,
                  allBlogs: widget.allBlogs,
                  index: widget.index,
                  userToken: widget.userToken,
                  memberId: widget.memberId,
                  constraints: widget.constraints,
                ),
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
