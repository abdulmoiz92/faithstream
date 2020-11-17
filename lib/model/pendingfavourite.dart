import 'package:flutter/material.dart';

class PendingFavourite {
  String userToken;
  String memberId;
  DateTime createdOn;
  DateTime updatedOn;
  String blogId;

  PendingFavourite(
      {@required this.userToken,
        @required this.memberId,
        @required this.createdOn,
        @required this.updatedOn,
        @required this.blogId});

  Map toJson() {
    return { 'userToken': userToken,
      'memberId': memberId,
      'createdOn': createdOn.toIso8601String(),
      'updatedOn': updatedOn.toIso8601String(),
      'blogId': blogId, };
  }
}