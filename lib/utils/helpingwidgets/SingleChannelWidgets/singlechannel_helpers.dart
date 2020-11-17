import 'package:faithstream/homescreen/components/your_blogs.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleChannelVideos extends StatefulWidget {
  final int channelId;

  SingleChannelVideos(this.channelId);

  @override
  _SingleChannelVideosState createState() => _SingleChannelVideosState();
}

class _SingleChannelVideosState extends State<SingleChannelVideos>
    with AutomaticKeepAliveClientMixin {
  String userToken;
  String memberId;
  List<Blog> videosBlogs = [];

  @override
  Widget build(BuildContext context) {
    return YourBlogs(
      Provider.of<BlogProvider>(context).getSingleChannelVideos(),
      memberId,
      userToken,
      isSingleChannel: true,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void updateKeepAlive() => true;
}

class SingleChannelEvents extends StatefulWidget {
  final int channelId;

  SingleChannelEvents(this.channelId);

  @override
  _SingleChannelEventsState createState() => _SingleChannelEventsState();
}

class _SingleChannelEventsState extends State<SingleChannelEvents>
    with AutomaticKeepAliveClientMixin {
  String userToken;
  String memberId;
  List<Blog> eventBlogs = [];

  @override
  Widget build(BuildContext context) {
    return YourBlogs(
        Provider.of<BlogProvider>(context).getSingleChannelEvents(),
        memberId,
        userToken,
        isSingleChannel: true);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
}
