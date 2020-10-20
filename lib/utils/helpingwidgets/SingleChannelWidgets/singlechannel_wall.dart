import 'package:faithstream/helpers/singlechannel_helper.dart';
import 'package:faithstream/homescreen/components/your_blogs.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleChannelWall extends StatefulWidget {
  final int channelId;

  SingleChannelWall(this.channelId);

  @override
  _SingleChannelWallState createState() => _SingleChannelWallState();
}

class _SingleChannelWallState extends State<SingleChannelWall>
    with AutomaticKeepAliveClientMixin {
  String userToken;
  String memberId;
  String profileImage;

  @override
  Widget build(BuildContext context) {
    return YourBlogs(
      Provider.of<BlogProvider>(context).singleChannelBlogs,
      memberId,
      userToken,
      isSingleChannel: true,
      profileImage: profileImage,
    );
  }

  @override
  void initState() {
    super.initState();
    SingleChannelHelper().getData(
        mounted: mounted,
        userToken: userToken,
        memberId: memberId,
        channelId: widget.channelId,
        profileImage: profileImage,
        setState: setState);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void updateKeepAlive() => true;
}

