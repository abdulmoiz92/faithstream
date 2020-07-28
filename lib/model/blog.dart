import 'dart:async';

import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/donation.dart';
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
  final bool isTicketAvailable;
  final int eventId;
  bool _isLiked = false;
  bool _isFavourite = false;
  final bool isDonationRequired;
  final bool isPaidVideo;
  final bool isPurchased;
  final double videoPrice;
  final int freeVideoLength;
  List<Comment> comments;
  List<Donation> donations;

  set setIsLiked(bool value) {
    _isLiked = value;
  }

  get getIsLiked => _isLiked;

  set setIsFavourite(bool value) {
    _isFavourite = value;
  }

  set addCommentSet(Comment comment) {
    comments.add(comment);
  }

  get getIsFavourite => _isFavourite;

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
    this.eventId,
    this.eventLocation,
    this.eventTime,
    this.videoDuration,
    this.donations,
    @required this.isTicketAvailable,
    @required this.isDonationRequired,
    this.isPaidVideo,
    this.isPurchased,
    this.videoPrice,
    this.freeVideoLength
  });

  isLikedSet(bool value) {
    _isLiked = value;
  }

  isFavouriteSet(bool value) {
    _isFavourite = value;
  }

  StreamController<Comment> streamcomments;

  void addStreamComment(Comment comment) {
    streamcomments.sink.add(comment);
  }

  Stream<Comment> getStreamComments() {
    return streamcomments.stream;
  }

  addComment(Comment comment) {
    comments.add(comment);
  }

  resetComments() {
    comments = [];
  }
}
