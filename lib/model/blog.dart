import 'package:faithstream/model/comment.dart';
import 'package:flutter/cupertino.dart';

class Blog {
  final String postId;
  final String eventLocation;
  final String eventTime;
  final String postType;
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
  final String videoDuration;
  final int imageWidth;
  final int imageHeight;
  final List<Comment> comments;

  Blog({
    @required this.postId,
    @required this.postType,
    @required this.videoUrl,
    @required this.image,
    @required this.title,
    @required this.author,
    @required this.authorImage,
    @required this.date,
    @required this.time,
    @required this.likes,
    @required this.views,
    @required this.subscribers,
    this.imageWidth,
    this.imageHeight,
    this.comments,
    this.eventLocation,
    this.eventTime,
    this.videoDuration
  });
}
