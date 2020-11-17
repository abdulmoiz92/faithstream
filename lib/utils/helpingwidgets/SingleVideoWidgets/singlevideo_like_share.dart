import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/pendinglike.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared_pref_helper.dart';

class LikeAndShareVideo extends StatefulWidget {
  final Blog singleBlog;
  final String userToken;
  final String memberId;

  LikeAndShareVideo(this.singleBlog, this.userToken, this.memberId);

  @override
  _LikeAndShareVideoState createState() => _LikeAndShareVideoState();
}

class _LikeAndShareVideoState extends State<LikeAndShareVideo> {
  @override
  Widget build(BuildContext context) {
    print(widget.singleBlog.postId);
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () async {
              bool internet = await hasInternet();
              SharedPrefHelper sph = SharedPrefHelper();
              Provider.of<BlogProvider>(context).setIsPostLiked =
                  widget.singleBlog.postId;
              if (internet == true) {
                likePost(
                    context,
                    widget.userToken,
                    widget.memberId,
                    DateTime.now(),
                    DateTime.now(),
                    () {},
                    widget.singleBlog.postId);
              }
              if (internet == false) {
                Provider.of<PendingRequestProvider>(context).addPendingLike =
                    new PendingLike(
                        userToken: widget.userToken,
                        memberId: widget.memberId,
                        createdOn: DateTime.now(),
                        updatedOn: DateTime.now(),
                        blogId: widget.singleBlog.postId);
                sph.savePosts(sph.pendinglikes_requests,
                    Provider.of<PendingRequestProvider>(context).pendingLikes);
              }
            },
            child: Icon(
              Icons.thumb_up,
              color: Provider.of<BlogProvider>(context)
                          .getIsPostLiked(widget.singleBlog.postId) ==
                      1
                  ? Colors.red
                  : Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(Icons.share),
        )
      ],
    );
  }
}
