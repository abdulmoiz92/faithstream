import 'dart:async';
import 'dart:typed_data';

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
  final int authorId;
  final String author;
  final String authorImage;
  final String date;
  final String time;
  int likesCount;
  int commentsCount;
  final String views;
  final String subscribers;
  final String videoDuration;
  final int imageWidth;
  final int imageHeight;
  final bool isTicketAvailable;
  final int eventId;
  int _isLiked = 0;
  int _isFavourite = 0;
  final bool isDonationRequired;
  final bool isPaidVideo;
  final bool isPurchased;
  final double videoPrice;
  final int freeVideoLength;
  Comment postComment;
  List<Donation> donations;
  final bool isPast;
  Uint8List imageBytes;
  Uint8List authorImageBytes;

  get getIsFavourite => _isFavourite;

  get getIsLiked => _isLiked;

  set setIsLiked(int value) {
    _isLiked = value;
  }

  set increaseLikeCount(_) {
    likesCount = likesCount + 1;
  }

  set decreseLikeCount(_) {
    likesCount = likesCount - 1;
  }

  set increaseCommentCount(_) {
    commentsCount = commentsCount + 1;
  }

  set decreseCommentCount(_) {
    commentsCount = commentsCount - 1;
  }

  set setIsFavourite(int value) {
    _isFavourite = value;
  }

  set setComment(Comment comment) {
    postComment = comment;
  }

  Blog({
    this.isPast,
    @required this.postId,
    @required this.postType,
    @required this.videoUrl,
    @required this.image,
    @required this.title,
    @required this.author,
    @required this.authorId,
    @required this.authorImage,
    @required this.date,
    @required this.time,
    @required this.likesCount,
    @required this.commentsCount,
    @required this.views,
    @required this.subscribers,
    this.imageWidth,
    this.imageHeight,
    this.postComment,
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
    this.freeVideoLength,
    this.imageBytes,
    this.authorImageBytes
  });

  Map toJson() => {
    'postId': postId,
  };
}
