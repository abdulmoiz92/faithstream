import 'package:faithstream/model/comment.dart';
import 'package:flutter/cupertino.dart';

class TPost {
  final String id;
  final String videoId;
  final String videoUrl;
  final String image;
  final String title;
  final String author;
  final String authorImage;
  final String date;
  final String time;
  final String likes;
  final String views;
  final String subscribers;
  final int channelId;
  List<Comment> videoComments;
  bool isPurchased = false;
  bool isPaid = false;

  TPost({
    @required this.id,
    @required this.videoId,
    @required this.videoUrl,
    @required this.image,
    @required this.title,
    @required this.author,
    @required this.channelId,
    @required this.authorImage,
    @required this.date,
    @required this.time,
    @required this.likes,
    @required this.views,
    @required this.subscribers,
    this.isPaid,
    this.isPurchased,
    this.videoComments});
}