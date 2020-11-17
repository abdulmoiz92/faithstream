import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:faithstream/main.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/donation.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared_pref_helper.dart';

String compareDate(String dateToCompare) {
  var dateExpression = DateTime.now().difference(DateTime.parse(dateToCompare));
  if (dateExpression.inDays == 0) {
    return dateExpression.inHours < 1
        ? "${dateExpression.inSeconds.round() < 60 ? "Just Now" : "${(dateExpression.inSeconds / 60).round()} ${(dateExpression.inSeconds / 60).round() == 1 ? "minute" : "minutes"}"}"
        : "${dateExpression.inHours} ${dateExpression.inHours == 1 ? "hour" : "hours"}";
  } else if (dateExpression.inDays >= 1) {
    if (dateExpression.inDays > 6 && dateExpression.inDays <= 29) {
      return "${(dateExpression.inDays / 7).round()} ${(dateExpression.inDays / 7).round() == 1 ? "week" : "weeks"}";
    } else if (dateExpression.inDays > 29) {
      return "${(dateExpression.inDays / 30).round()} ${(dateExpression.inDays / 30).round() == 1 ? "month" : "months"}";
    } else {
      return "${(dateExpression.inDays)} ${(dateExpression.inDays) == 1 ? "day" : "days"}";
    }
  }
}

Future<void> likePost(
    BuildContext context,
    String userToken,
    String memberId,
    DateTime createdOn,
    DateTime updatedOn,
    Function onSuccess,
    String postId) async {
  final response = await http.post(
    "$baseAddress/api/Post/LikePost",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, String>{
      'postID': postId,
      'createdOn': createdOn.toIso8601String(),
      'memberID': memberId,
      'updateOn': updatedOn.toIso8601String()
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['data'] != null) {
      Provider.of<BlogProvider>(context).setLikingPostInProcess = false;
      await updateBlogPrefs();
      print("successful");
    } else {
      print("unsuccessful");
      buildSnackBar(context, "Server is Busy,try again later");
    }
    return true;
  } else {}
}

Future<void> subscribeChannel(BuildContext context, String userToken,
    String memberId, Channel channel) async {
  final response = await http.post(
    "$baseAddress/api/Member/SubscribeChannel",
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
      if (channel.status == 2)
        getSubscribedChannelVideos(context, userToken, memberId, channel);
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

Future<void> getSubscribedChannelVideos(BuildContext context, String userToken,
    String memberId, Channel channel) async {
  var channelData = await http.get(
      "$baseAddress/api/Post/GetPostsByChannelID/${channel.id}",
      headers: {"Authorization": "Bearer $userToken"});

  var isFavouriteData = await http.get(
      "$baseAddress/api/Post/GetFavoriteTimeLine/$memberId",
      headers: {"Authorization": "Bearer $userToken"});

  if (channelData.body.isNotEmpty) {
    var channelDataJson = json.decode(channelData.body);
    if (channelDataJson['data'] != null) {
      for (var u in channelDataJson['data']) {
        if (channelDataJson['data'] == []) continue;

        var postData = u;

        Blog newBlog = new Blog(
            postId: null,
            postType: null,
            videoUrl: null,
            image: null,
            title: null,
            author: null,
            authorImage: null,
            date: null,
            time: null,
            likesCount: null,
            views: null,
            subscribers: null);

        List<Donation> donnations = [];

        if (u['denom'] != null) {
          if (u['denom'] != [])
            for (var d in u['denom']) {
              Donation newDonation = new Donation(
                  id: d['id'].toString(),
                  channelId: d['channelID'].toString(),
                  denomAmount: d['denomAmount'],
                  denomDescription: d['denomDescription']);
              donnations.add(newDonation);
            }
        }

        if (u['postType'] == "Event")
          newBlog = new Blog(
              postId: postData['id'],
              postType: postData['postType'],
              videoUrl: postData['event']['video'] != null
                  ? postData['event']['video']['url']
                  : postData['event']['video'],
              image: postData['event']['image'],
              title: postData['title'],
              authorId: postData['authorID'],
              author: postData['authorName'],
              authorImage: postData['authorImage'],
              date: postData['dateCreated'],
              time: "${compareDate(postData['dateCreated'])} ago",
              likesCount: postData['likesCount'],
              views: postData['event']['video'] != null
                  ? "${postData['event']['video']['numOfViews']}"
                  : null,
              subscribers: "${postData['numOfSubscribers']}",
              eventId: postData['event']['id'],
              eventLocation: postData['event']['location'],
              eventTime:
                  "${DateFormat.jm().format(DateTime.parse(postData['event']['startTime']))} | ${DateFormat.jm().format(DateTime.parse(postData['event']['endTime']))} , ${DateFormat.MMMd().format(DateTime.parse(postData['event']['postSchedule']))}",
              isDonationRequired: postData['isDonationRequire'],
              donations: donnations,
              isTicketAvailable: postData['event']['isTicketPurchaseRequired'],
              isPast: postData['event']['isPast']);
        if (u['postType'] == "Video")
          newBlog = new Blog(
              postId: postData['id'],
              postType: postData['postType'],
              videoUrl: postData['video']['url'],
              image: postData['video']['thumbnail'],
              title: postData['title'],
              authorId: postData['authorID'],
              author: postData['authorName'],
              authorImage: postData['authorImage'],
              date: postData['dateCreated'],
              time: "${compareDate(postData['dateCreated'])} ago",
              likesCount: postData['video']['numOfLikes'],
              views: "${postData['video']['numOfViews']}",
              subscribers: "${postData['numOfSubscribers']}",
              videoDuration: "",
              donations: donnations,
              isDonationRequired: postData['isDonationRequire'],
              isPaidVideo: postData['video']['isPaidContent'],
              isPurchased: postData['video']['isPurchased'],
              videoPrice: postData['video']['price'] == null
                  ? null
                  : double.parse(postData['video']['price']),
              freeVideoLength: postData['video']['freeVideoLength']);

        if (u['postType'] == "Image")
          newBlog = new Blog(
            postId: postData['id'],
            postType: postData['postType'],
            videoUrl: null,
            image: postData['image']['url'],
            title: postData['title'],
            authorId: postData['authorID'],
            author: postData['authorName'],
            authorImage: postData['authorImage'],
            date: postData['dateCreated'],
            time: "${compareDate(postData['dateCreated'])} ago",
            likesCount: postData['likesCount'],
            views: null,
            subscribers: "${postData['numOfSubscribers']}",
            isDonationRequired: postData['isDonationRequire'],
            donations: donnations,
          );

        var isFavouritejsonData = jsonDecode(isFavouriteData.body);
        if (isFavouriteData.body.isNotEmpty) if (isFavouritejsonData['data'] !=
            null)
          for (var fv in isFavouritejsonData['data']) {
            if (fv['id'] == postData['id']) {
              newBlog.setIsFavourite = 1;
            }
          }

        if (u['postLikes'] != [])
          for (var il in u['postLikes']) {
            if (il['memberID'] == memberId) {
              newBlog.setIsLiked = 1;
            }
          }
        Provider.of<BlogProvider>(globalContext).addBlog = newBlog;
      }
      Provider.of<BlogProvider>(globalContext).sortBlog();
    }
  }
}

Future<void> unSubscribeChannel(BuildContext context, String userToken,
    String memberId, Channel channel) async {
  final response = await http.post(
    "$baseAddress/api/Member/UnSubscribeChannel",
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
      Provider.of<BlogProvider>(globalContext)
          .removeUnscribedChannelPosts(channel.id);
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

Future<void> commentOnPost(
    BuildContext context, String userToken, String memberId,
    {String postId,
    String commentText,
    String commentBy,
    DateTime createdOn,
    DateTime updatedOn,
    String tempId}) async {
  var userData = await http.get(
      "$baseAddress/api/Member/GetMemberProfile/$memberId",
      headers: {"Authorization": "Bearer $userToken"});
  var authorName =
      "${json.decode(userData.body)['data']['firstName']} ${json.decode(userData.body)['data']['lastName'] != null ? json.decode(userData.body)['data']['lastName'] : ""}";
  final response = await http.post(
    "$baseAddress/api/Post/AddPostComment",
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
    var commentData = await http.get(
        "$baseAddress/api/Post/GetPostComments/${postId}",
        headers: {"Authorization": "Bearer ${userToken}"});
    if (json.decode(response.body)['data'] != null) {
      if (commentData.body.isNotEmpty) {
        var commentDataJson = jsonDecode(commentData.body);
        try {
          var singlecomment = commentDataJson['data'][
          Provider.of<BlogProvider>(globalContext).getPostCommentCounts(postId) - 1];
          Provider.of<BlogProvider>(globalContext)
              .setCommentId(tempId, singlecomment['id']);
//          Provider.of<BlogProvider>(globalContext).setPostCommentId(singlecomment['id'], postId);
          Provider.of<BlogProvider>(globalContext).resetTempId(tempId);
          Provider.of<BlogProvider>(globalContext).setAddingCommentInProcess = false;
        } on Exception catch (_) {
          print("error");
          return;
        }
      }
    } else {
      print("unsuccessful");
    }
    return true;
  } else {
    print(jsonDecode(response.body).toString());
    print("error");
  }
}

Future<void> deleteComment(BuildContext context, String postId,
    String commentId, String userToken) async {
  final response = await http.post(
    "$baseAddress/api/Post/DeletePostComment",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{'id': commentId, 'postID': postId,'isDeleted': true}),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['data'] != null) {
      Provider.of<BlogProvider>(globalContext).removeComment(commentId);
      Provider.of<BlogProvider>(context).deleteCommentInDeleteProcess = commentId;
      print("successful");
    } else {
      print(json.decode(response.body).toString());
    }
    return true;
  } else {
    print(jsonDecode(response.body).toString());
    print("error");
  }
}

Future<void> commentOnVideoPost(
    BuildContext context, String userToken, String memberId,
    {String videoId,
    String commentText,
    String commentBy,
    DateTime createdOn,
    DateTime updatedOn,
    String tempId}) async {
  var userData = await http.get(
      "$baseAddress/api/Member/GetMemberProfile/$memberId",
      headers: {"Authorization": "Bearer $userToken"});
  var authorName =
      "${json.decode(userData.body)['data']['firstName']} ${json.decode(userData.body)['data']['lastName'] != null ? json.decode(userData.body)['data']['lastName'] : ""}";
  final response = await http.post(
    "$baseAddress/api/Channel/AddVideoComments",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      'dateCreated': createdOn.toIso8601String(),
      'dateUpdated': updatedOn.toIso8601String(),
      'commentText': commentText,
      'commentedBy': authorName,
      'authorID': int.parse(memberId),
      'videoID': videoId
    }),
  );

  if (response.statusCode == 200) {
    var commentData = await http.get(
        "$baseAddress/api/Channel/GetVideoComments/${videoId}",
        headers: {"Authorization": "Bearer ${userToken}"});
    if (json.decode(response.body)['data'] != null) {
      if (commentData.body.isNotEmpty) {
        var commentDataJson = jsonDecode(commentData.body);
        var singlecomment = commentDataJson['data'][0];
        Provider.of<BlogProvider>(context)
            .setTrendingCommentId(tempId, singlecomment['id']);
        Provider.of<BlogProvider>(context).resetTrendingTempId(tempId);
      }
    } else {
      print("unsuccessful");
    }
    return true;
  } else {
    print(jsonDecode(response.body).toString());
    print("error");
  }
}

Future<void> deleteVideoComment(BuildContext context, String videoId,
    String commentId, String userToken) async {
  final response = await http.post(
    "$baseAddress/api/Channel/DeleteVideoComments",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{'id': commentId, 'videoID': videoId}),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['data'] != null) {
      print("successful");
      Provider.of<BlogProvider>(context).removeTPostComment(commentId);
    } else {
      print(json.decode(response.body).toString());
    }
    return true;
  } else {
    print(jsonDecode(response.body).toString());
    print("error");
  }
}

Future<void> updateUserInfo(
    BuildContext context,
    String userToken,
    String userId,
    String memberId,
    String firstName,
    String lastName,
    String emailAddress,
    String phoneNumber) async {
  final response = await http.post(
    "$baseAddress/api/Member/UpdateMemberProfile",
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
    if (json.decode(response.body)['message'] ==
        "Profile updated successfully") {
      print("successful");
      buildSnackBar(context, "Information Updated");
      Navigator.pop(context, true);
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

Future<void> addToFavourite(BuildContext context, String userToken,
    String memberId, String postId) async {
  final response = await http.post(
    "$baseAddress/api/Member/SaveFavoriteContent",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      'memberID': int.parse(memberId),
      'contentID': postId
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['status'] == "success") {
      await updateBlogPrefs();
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

Future<void> removeFromFavourite(BuildContext context, String userToken,
    String memberId, String postId) async {
  final response = await http.post(
    "$baseAddress/api/Member/RemoveFavoriteContent",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      'memberID': int.parse(memberId),
      'contentID': postId
    }),
  );
  if (response.statusCode == 200) {
    if (json.decode(response.body)['status'] == "success") {
      await updateBlogPrefs();
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

Future<void> addEventFollow(
    BuildContext context, int eventId, int memberId, String userToken,
    {bool reminder1, bool reminder2, bool reminder3}) async {
  final response = await http.post(
    "$baseAddress/api/Member/AddEventFollowUp",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $userToken"
    },
    body: jsonEncode(<String, dynamic>{
      "eventID": eventId,
      "memberID": memberId,
      "reminder1": reminder1,
      "reminder2": reminder2,
      "reminder3": reminder3
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['data'] != null) {
      print("successful");
    } else {
      print(json.decode(response.body).toString());
    }
  } else {
    print(jsonDecode(response.body).toString());
    print("error");
  }
}

Future<String> get _localTempPath async {
  var status = await Permission.storage.status;
  if (status.isUndetermined) {
    // We didn't ask for permission yet.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();
    print(statuses[Permission.storage]);
  }
  if (status.isGranted) {
    final directory = await getTemporaryDirectory();

    return directory.path;
  } else {
    return null;
  }
}

Future<void> deleteCacheDir() async {
  final dir = await _localTempPath;

  Directory(dir.toString()).deleteSync(recursive: true);
}

Future<File> localFile(String id) async {
  final path = await _localTempPath;

  return new File('$path/$id.txt');
}

Future<File> localProfileFile() async {
  final path = await _localTempPath;

  return new File('$path/profile.txt');
}

Future<bool> fileExistsInCache(String id) async {
  final file = await localFile(id);

  return file.exists();
}

Future<void> writeBlogImage(String id, String image) async {
  var response = await http.get(image);
  final file = await localFile(id);

  if (file.existsSync() == true) return null;

  return file.writeAsBytesSync(response.bodyBytes);
}

Future<void> writeProfileImage(String image) async {
  var response = await http.get(image);
  print(image);
  final file = await localProfileFile();

  return file.writeAsBytesSync(response.bodyBytes);
}

Future<Uint8List> readBlogImage(String id) async {
  try {
    final file = await localFile(id);

    return await file.readAsBytesSync();
  } catch (e) {
    return null;
  }
}

Future<Uint8List> readProfileImage() async {
  try {
    final file = await localProfileFile();

    return await file.readAsBytesSync();
  } catch (e) {
    return null;
  }
}

Future<void> updateBlogPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPrefHelper sph = SharedPrefHelper();
  final bool internet = await hasInternet();
  var channelData = await http.get(
      "$baseAddress/api/Post/GetTimeLine2/${prefs.getString(sph.member_id)}",
      headers: {"Authorization": "Bearer ${prefs.getString(sph.user_token)}"});

  var isFavouriteData = await http.get(
      "$baseAddress/api/Post/GetFavoriteTimeLine/${prefs.getString(sph.member_id)}",
      headers: {"Authorization": "Bearer ${prefs.getString(sph.user_token)}"});

  if (channelData.body.isNotEmpty) {
    var channelDataJson = json.decode(channelData.body);
    if (channelDataJson['data'] != null) {
      if (internet == true)
        sph.savePosts(sph.blog_posts, channelDataJson['data']);
      print("updated");
    }
  }
  var isFavouritejsonData = jsonDecode(isFavouriteData.body);
  if (isFavouriteData.body.isNotEmpty) if (isFavouritejsonData['data'] !=
      null) {
    if (internet == true)
      sph.savePosts(sph.favourite_posts, isFavouritejsonData['data']);
  }
}

Future<void> completePendingFavouriteRequests(
    BuildContext context, SharedPrefHelper sph) async {
  var pendingFavouriteJsonData =
      await sph.readPosts(sph.pendingfavourite_requests);
  if (pendingFavouriteJsonData != null) {
    for (var l in pendingFavouriteJsonData) {
      addToFavourite(context, l['userToken'], l['memberId'], l['blogId']);
    }
    Provider.of<PendingRequestProvider>(context).resetPendingFavourites();
    sph.clearKeyFromPrefs(sph.pendingfavourite_requests);
  }
}

Future<void> completePendingRemoveFavouriteRequests(
    BuildContext context, SharedPrefHelper sph) async {
  var pendingRemoveFavouriteJsonData =
      await sph.readPosts(sph.pendingremovefavourite_requests);
  if (pendingRemoveFavouriteJsonData != null) {
    for (var l in pendingRemoveFavouriteJsonData) {
      removeFromFavourite(context, l['userToken'], l['memberId'], l['blogId']);
    }
    Provider.of<PendingRequestProvider>(context).resetPendingRemoveFavourites();
    sph.clearKeyFromPrefs(sph.pendingremovefavourite_requests);
  }
}

Future<void> completePendingLikeRequests(
    BuildContext context, SharedPrefHelper sph) async {
  var pendingLikeJsonData = await sph.readPosts(sph.pendinglikes_requests);
  if (pendingLikeJsonData != null) {
    for (var l in pendingLikeJsonData) {
      likePost(
          context,
          l['userToken'],
          l['memberId'],
          DateTime.parse(l['createdOn']),
          DateTime.parse(l['updatedOn']),
          () {},
          l['blogId']);
    }
    Provider.of<PendingRequestProvider>(context).resetPendingLikes();
    sph.clearKeyFromPrefs(sph.pendinglikes_requests);
  }
}

Future<void> completePendingCommentRequests(
    BuildContext context, SharedPrefHelper sph) async {
  var pendingCommentJsonData = await sph.readPosts(sph.pendingcomment_requests);
  if (pendingCommentJsonData != null) {
    for (var l in pendingCommentJsonData) {
      commentOnPost(context, l['userToken'], l['memberId'],
          createdOn: DateTime.parse(l['createdOn']),
          updatedOn: DateTime.parse(l['updatedOn']),
          postId: l['postId'],
          tempId: l['tempId'],
          commentText: l['commentText'],
          commentBy: l['commentedBy']);
    }
    Provider.of<PendingRequestProvider>(context).resetPendingComments();
    sph.clearKeyFromPrefs(sph.pendingcomment_requests);
  }
}

Future<bool> makePaymentOfDonation(
    {BuildContext context,
    String amount,
    String notes,
    String postType,
    String contentId,
    int channelId,
    String cardType,
    String cardNumber,
    String cvc,
    String expiryMonth,
    String expiryYear,
    }) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPrefHelper sph = new SharedPrefHelper();
  final response = await http.post(
    "$baseAddress/api/Member/MakePayment",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer ${prefs.getString(sph.user_token)}"
    },
    body: jsonEncode(<String, dynamic>{
      "dateCreated": DateTime.now().toIso8601String(),
      "amount": amount,
      "memberID": int.parse(prefs.getString(sph.member_id)),
      "channelID": channelId,
      "paypalInvoiceNumber": "string",
      "contentID": contentId,
      "contentType": postType,
      "paypalTransactionID": "",
      "creditCardID": 0,
      "creditCard": {
        "ownerID": 0,
        "ownerType": "",
        "cardType": cardType,
        "number": cardNumber,
        "cvc": cvc,
        "expiryMonth": expiryMonth,
        "expiryYear": expiryYear,
        "isDefault": true,
        "isActive": true
      },
      "statusID": 0,
      "venmoTransationNumber": "",
      "zelleTransationNumber": "",
      "donorName": "${prefs.getString(sph.first_name)} ${prefs.getString(sph.last_name)}",
      "donationType": "string",
      "paymentType": "Donation",
      "status": "",
      "organizationID": 0,
      "ticketQty": 0,
      "paymentServiceID": 0,
      "serviceTransactionNumber": ""
    }),
  );

  if (response.statusCode == 200) {
    if (json.decode(response.body)['data'] != null) {
      print("successful");
      return true;
    } else {
      return false;
    }
  } else {
    print("error");
    return false;
  }
}


class SingleCommentDesign extends StatelessWidget {
  Comment comment;
  BoxConstraints constraints;
  String memberId;
  String userToken;
  String postId;
  bool isFrontComment;

  SingleCommentDesign({this.constraints,this.comment,this.memberId,this.userToken,this.postId,this.isFrontComment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0, top: 8.0),
        padding: EdgeInsets.all(8.0),
        width: constraints.maxWidth * 0.95,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                      image: comment.authorImage ==
                          null
                          ? AssetImage("assets/images/test.jpeg")
                          : NetworkImage(
                          comment.authorImage),
                      fit: BoxFit.fill)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6.0, vertical: 6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(comment.authorName,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.only(top: 4.0),
                    width: constraints.maxWidth * 0.55,
                    child: Text(
                      comment.commentText,
                      style: TextStyle(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  buildIconText(
                      context,
                      comment.time,
                      Icons.calendar_today,
                      3.0,
                      Colors.black),
                  if (memberId ==
                      comment.commentMemberId
                          .toString() && comment.temopraryId == null)
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: GestureDetector(
                          onTap: () {
                            Provider.of<BlogProvider>(context).addcommentInDeleteProcess = comment;
                            deleteComment(
                                globalContext,
                                postId,
                                comment.commentId,
                                userToken);
//                                .then((_) => Provider.of<BlogProvider>(context).commentExistsInPostComment(comment, postId));
                          },
                          child: Text(
                            "Delete",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black87, fontSize: 10),
                          )),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

