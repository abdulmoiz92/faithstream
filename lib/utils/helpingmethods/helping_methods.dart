import 'dart:convert';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String compareDate(String dateToCompare) {
  var dateExpression =
  DateTime.now().difference(DateTime.parse(dateToCompare));
  if (dateExpression.inDays == 0) {
    return dateExpression.inHours < 1
        ? "${dateExpression.inSeconds.round() < 60
        ? "Just Now"
        : "${(dateExpression.inSeconds / 60).round()} ${(dateExpression
        .inSeconds / 60).round() == 1 ? "minute" : "minutes"}"}"
        : "${dateExpression.inHours} ${dateExpression.inHours == 1
        ? "hour"
        : "hours"}";
  } else if (dateExpression.inDays >= 1) {
    if (dateExpression.inDays > 6 && dateExpression.inDays <= 29) {
      return "${(dateExpression.inDays / 7).round()} ${(dateExpression.inDays /
          7).round() == 1 ? "week" : "weeks"}";
    } else if (dateExpression.inDays > 29) {
      return "${(dateExpression.inDays / 30).round()} ${(dateExpression.inDays /
          30).round() == 1 ? "month" : "months"}";
    } else {
      return "${(dateExpression.inDays)} ${(dateExpression.inDays) == 1
          ? "day"
          : "days"}";
    }
  }
}

Future<void> likePost(BuildContext context, String userToken, String memberId,
    DateTime createdOn, DateTime updatedOn, Function onSuccess,
    Blog blog) async {
  final response = await http.post(
    "http://api.faithstreams.net/api/Post/LikePost",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, String>{
      'postID': blog.postId,
      'createdOn': createdOn.toIso8601String(),
      'memberID': memberId,
      'updateOn': updatedOn.toIso8601String()
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['data'] != null) {
      print("successful");
    } else {
      print("unsuccessful");
      buildSnackBar(context, "Server is Busy,try again later");
    }
    return true;
  } else {
    buildSnackBar(context, "Server is Busy,try again later");
    print("error");
  }
}

Future<void> subscribeChannel(BuildContext context, String userToken, String memberId, Channel channel) async {
  final response = await http.post(
    "http://api.faithstreams.net/api/Member/SubscribeChannel",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      'memberID': int.parse(memberId),
      'channelID': int.parse("${channel.id}")
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['status'] == "success") {
      print("successful");
    } else {
      print("unsuccessful");
      buildSnackBar(context, "Server is Busy,try again later");
    }
    return true;
  } else {
    buildSnackBar(context, "Server is Busy,try again later");
    print("error");
  }
}

Future<void> unSubscribeChannel(BuildContext context, String userToken, String memberId, Channel channel) async {
  final response = await http.post(
    "http://api.faithstreams.net/api/Member/UnSubscribeChannel",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      'memberID': int.parse(memberId),
      'channelID': int.parse("${channel.id}")
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['status'] == "success") {
      print("successful");
    } else {
      print("unsuccessful");
      buildSnackBar(context, response.body.toString());
    }
    return true;
  } else {
    buildSnackBar(context, response.body.toString());
    print("error");
  }
}

Future<void> commentOnPost(BuildContext context, String userToken,
    String memberId,
    {String postId, String commentText, String commentBy, DateTime createdOn, DateTime updatedOn}) async {
  var userData = await http.get(
      "http://api.faithstreams.net/api/Member/GetMemberProfile/$memberId",
      headers: {"Authorization": "Bearer $userToken"});
  var authorName = "${json.decode(userData.body)['data']['firstName']} ${json
      .decode(userData.body)['data']['lastName'] != null ? json.decode(
      userData.body)['data']['lastName'] : ""}";
  var authorImage = json.decode(userData.body)['data']['profileImage'];
  final response = await http.post(
    "http://api.faithstreams.net/api/Post/AddPostComment",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      'dateCreated': createdOn.toIso8601String(),
      'dateUpdated': updatedOn.toIso8601String(),
      'commentText': commentText,
      'commentedBy': authorName,
      'memberID': int.parse(memberId),
      'postID': postId
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['data'] != null) {
      print("successful");
    } else {
      print("unsuccessful");
    }
    return true;
  } else {
    print(jsonDecode(response.body).toString());
    print("error");
  }
}

Future<void> deleteComment(BuildContext context, String postId, String commentId,String userToken, {Function deleteFromList}) async {
  final response = await http.post(
    "http://api.faithstreams.net/api/Post/DeletePostComment",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      'id': commentId,
      'postID': postId
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['data'] != null) {
      print("successful");
      deleteFromList;
    } else {
      print(json.decode(response.body).toString());
    }
    return true;
  } else {
    print(jsonDecode(response.body).toString());
    print("error");
  }
}

Future<void> updateUserInfo(BuildContext context, String userToken,String userId, String memberId,String firstName,String lastName,String emailAddress,String phoneNumber) async {
  final response = await http.post(
    "http://api.faithstreams.net/api/Member/UpdateMemberProfile",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      "id": int.parse(memberId),
      "firstName": firstName,
      "lastName": lastName,
      "userID": int.parse(userId),
      "emailAddress": emailAddress,
      "phone": phoneNumber
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['message'] == "Profile updated successfully") {
      print("successful");
      buildSnackBar(context, "Information Updated");
      Navigator.pop(context,true);
    } else {
      print("unsuccessful");
      buildSnackBar(context, response.body.toString());
    }
    return true;
  } else {
    buildSnackBar(context, response.body.toString());
    print("error");
  }
}

Future<void> addToFavourite(BuildContext context, String userToken, String memberId, Blog blog) async {
  final response = await http.post(
    "http://api.faithstreams.net/api/Member/SaveFavoriteContent",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      'memberID': int.parse(memberId),
      'contentID': blog.postId,
      'contentType': blog.postType
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['status'] == "success") {
      print("successful");
    } else {
      print("unsuccessful");
      buildSnackBar(context, "Server is Busy,try again later");
    }
    return true;
  } else {
    buildSnackBar(context, "Server is Busy,try again later");
    print("error");
  }
}

Future<void> removeFromFavourite(BuildContext context, String userToken, String memberId, Blog blog) async {
  final response = await http.post(
    "http://api.faithstreams.net/api/Member/RemoveFavoriteContent",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      'memberID': int.parse(memberId),
      'contentID': blog.postId,
      'contentType': blog.postType
    }),
  );
  if (response.statusCode == 200) {
    if (json.decode(response.body)['status'] == "success") {
      print("successful");
    } else {
      print("unsuccessful");
      buildSnackBar(context, "Server is Busy,try again later");
    }
    return true;
  } else {
    buildSnackBar(context, "Server is Busy,try again later");
    print("error");
  }
}