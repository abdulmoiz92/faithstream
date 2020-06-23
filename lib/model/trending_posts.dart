import 'package:flutter/cupertino.dart';

class TPost {
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

  TPost({@required this.videoUrl,
    @required this.image,
    @required this.title,
    @required this.author,
    @required this.authorImage,
    @required this.date,
    @required this.time,
    @required this.likes,
    @required this.views,
    @required this.subscribers,});
}