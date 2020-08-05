import 'package:flutter/cupertino.dart';

class Channel {
  int id;
  String channelBg;
  String authorImage;
  String channelName;
  int numOfSubscribers;
  int numOfVideos;
  String prefrence;
  int status;
  final bool approvalRequired;
  bool isSubscribed = false;

  set isSubscribedSet(bool value) {
    isSubscribed = value;
  }

  set setStatus(int value) {
    status = value;
  }

  get getIsSubscribed => isSubscribed;

  Channel({@required this.id,@required this.channelBg,@required this.authorImage, @required this.channelName, @required this.numOfSubscribers,@required this.numOfVideos,@required this.prefrence,@required this.status,this.approvalRequired});

  setIsSubscribe(bool value) {
    isSubscribed = value;
  }
}