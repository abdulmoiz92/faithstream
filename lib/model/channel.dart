import 'package:flutter/cupertino.dart';

class Channel {
  String channelBg;
  String authorImage;
  String channelName;
  int numOfSubscribers;
  int numOfVideos;
  String prefrence;
  bool isSubscribed;

  Channel({@required this.channelBg,@required this.authorImage, @required this.channelName, @required this.numOfSubscribers,@required this.numOfVideos,@required this.prefrence,this.isSubscribed});

}