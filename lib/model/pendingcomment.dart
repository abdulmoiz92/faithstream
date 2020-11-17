import 'package:flutter/material.dart';

class PendingComment {
  String userToken;
  String memberId;
  DateTime createdOn;
  DateTime updatedOn;
  String postId;
  String tempId;
  String commentText;
  String commentedBy;

  PendingComment(
      {@required this.userToken,
        @required this.memberId,
        @required this.createdOn,
        @required this.updatedOn,
        @required this.postId,
        @required this.tempId,this.commentText,this.commentedBy});

  Map toJson() {
    return { 'userToken': userToken,
      'memberId': memberId,
      'createdOn': createdOn.toIso8601String(),
      'updatedOn': updatedOn.toIso8601String(),
      'postId': postId,
      'tempId': tempId,'commentText': commentText,'commentedBy': commentedBy };
  }
}