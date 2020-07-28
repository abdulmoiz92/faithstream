import 'package:flutter/cupertino.dart';

class DBPost {
  String postId;
  int isLiked = 0;
  int isFavourited = 0;

  set setIsLiked(int value) {
    isLiked = value;
  }

  set setIsFavourited(int value) {
    isFavourited = value;
  }

  set setDBPostId(String id) {
    postId = id;
  }

  DBPost({@required this.postId,this.isLiked,this.isFavourited});

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'isLiked': isLiked,
      'isFavourite': isFavourited,
    };
  }
}