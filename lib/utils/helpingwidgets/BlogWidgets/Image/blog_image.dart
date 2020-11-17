import 'package:faithstream/model/blog.dart';
import 'package:faithstream/singlepost/single_image.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Helpers/blog_widgets_helper.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

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
          margin: EdgeInsets.only(top: widget.constraints.maxHeight * 0.02),
          padding: EdgeInsets.symmetric(
              horizontal: widget.constraints.maxWidth * 0.04),
          child: Text(widget.allBlogs[widget.index].title,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w400)),
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
            constraints: widget.constraints,
          ),
        ),
        SizedBox(height: widget.constraints.maxHeight * 0.02),
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
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              width: widget.constraints.maxWidth * 0.92,
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
