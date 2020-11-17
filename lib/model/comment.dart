import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/cupertino.dart';

class Comment {
  String commentId;
  String commentText;
  int commentMemberId;
  String authorImage;
  String authorName;
  String time;
  String temopraryId;

  Comment(
      {@required this.commentId, @required this.commentMemberId, @required this.commentText, @required this.authorImage, @required this.authorName, @required this.time, this.temopraryId});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(commentId: json['id'],
        commentMemberId: json['memberID'],
        authorImage: null,
        commentText: json['commentText'],
        authorName: json['commentedBy'],
        time: "${compareDate(json['dateCreated'])}"
    );
  }
}