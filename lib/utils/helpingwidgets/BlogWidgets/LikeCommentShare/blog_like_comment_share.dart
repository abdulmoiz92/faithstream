import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/pendinglike.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/helpingwidgets/BlogWidgets/Comment/blog_comment.dart';
import 'package:faithstream/utils/helpingwidgets/SingleVideoWidgets/comment/singlevideo_addcomment_single.dart';
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
  String profileImage;

  LikeShareComment(this.allBlogs, this.index, this.constraints, this.memberId,
      this.userToken,
      {this.isSingleChannel, this.profileImage});

  @override
  _LikeShareCommentState createState() => _LikeShareCommentState();
}

class _LikeShareCommentState extends State<LikeShareComment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.constraints.maxWidth * 1,
      padding: EdgeInsets.symmetric(
          horizontal: widget.constraints.maxWidth * 0.04,
          vertical: widget.constraints.maxHeight * 0.04),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (cntx) => CommentModal(widget.allBlogs, widget.index,
                      widget.userToken, widget.memberId));
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: NetworkImage(widget.profileImage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (cntx) => CommentModal(widget.allBlogs, widget.index,
                      widget.userToken, widget.memberId));
            },
            child: Container(
              width: widget.constraints.maxWidth * 0.65,
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(left: widget.constraints.maxWidth * 0.02),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      width: 1, color: Colors.black87.withAlpha(20))),
              child: Text(
                "Say something",
                style: TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ),
          ),
          Spacer(),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                color: Color(0xFFefefef),
                borderRadius: BorderRadius.circular(50)),
            padding: EdgeInsets.all(4.0),
            child: Center(
              child: buildIconColumnText(
                  context, null, Icons.share, 3.0, Colors.black87,size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
