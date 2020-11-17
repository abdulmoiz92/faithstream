import 'package:faithstream/model/blog.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Helpers/blog_widgets_helper.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:faithstream/utils/custom_modal.dart' as bs;

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
              style: TextStyle(color: Colors.black87, fontSize: 15,fontWeight: FontWeight.w400)),
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
              width: widget.constraints.maxWidth * 0.92,
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


