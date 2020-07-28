import 'package:flutter/cupertino.dart';

class Comment {
  String commentId;
  String commentText;
  int commentMemberId;
  String authorImage;
  String authorName;
  String time;

  Comment({@required this.commentId,@required this.commentMemberId,@required this.commentText,@required this.authorImage,@required this.authorName,@required this.time});
}