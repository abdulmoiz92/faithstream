import 'dart:convert';

import 'package:faithstream/main.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/donation.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'blog_helper.dart';

class SingleChannelHelper {
  Future<SharedPreferences> getData(
      {bool mounted,
      Function setState,
      String userToken,
      String memberId,
      String profileImage,
      int channelId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if (mounted)
      setState(() {
        userToken = prefs.getString(sph.user_token);
        memberId = prefs.getString(sph.member_id);
        profileImage = prefs.getString(sph.profile_image);
      });
    checkInternet(globalContext,
        futureFunction: SingleChannelHelper()
            .getVideos(
                mounted: mounted,
                memberId: memberId,
                userToken: userToken,
                channelId: channelId,
                setState: setState)
            .then((value) => SingleChannelHelper().getComment(
                mounted: mounted, memberId: memberId, userToken: userToken)));
  }

  Future<void> getVideos(
      {String userToken,
      String memberId,
      int channelId,
      bool mounted,
      Function setState}) async {
    var channelData = await http.get(
        "$baseAddress/api/Post/GetPostsByChannelID/$channelId",
        headers: {"Authorization": "Bearer $userToken"});

    var isFavouriteData = await http.get(
        "$baseAddress/api/Post/GetFavoriteTimeLine/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    SharedPrefHelper sph = new SharedPrefHelper();

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        for (var u in channelDataJson['data']) {
          if (channelDataJson['data'] == []) continue;

          var postData = u;

          Blog newBlog = new Blog();

          if (mounted)
            setState(() {
              List<Donation> donnations = [];

              if (u['denom'] != null) {
                if (u['denom'] != [])
                  for (var d in u['denom']) {
                    Donation newDonation = new Donation.fromJson(d);
                    donnations.add(newDonation);
                  }
              }

              if (u['postType'] == "Event")
                newBlog =
                    new Blog.fromEventJson(postData, donnations, null, null);
              if (u['postType'] == "Video")
                newBlog =
                    new Blog.fromVideoJson(postData, donnations, null, null);

              if (u['postType'] == "Image")
                newBlog =
                    new Blog.fromImageJson(postData, donnations, null, null);

              BlogHelper().setFavouriteAndLikeData(
                  isFavouriteData: isFavouriteData,
                  newBlog: newBlog,
                  memberId: memberId,
                  internet: Provider.of<PendingRequestProvider>(globalContext)
                      .internet,
                  postData: postData,
                  sph: sph);
            });
          Provider.of<BlogProvider>(globalContext).addSingleChannelBlogs =
              newBlog;
          setState(() {});
        }
      }
    }
  }

  Future<void> getComment(
      {String userToken, bool mounted, String memberId}) async {
    for (var b in Provider.of<BlogProvider>(globalContext).singleChannelBlogs) {
      var commentData = await http.get(
          "$baseAddress/api/Post/GetPostComments/${b.postId}",
          headers: {"Authorization": "Bearer ${userToken}"});
      if (commentData.body.isNotEmpty) {
        var commentDataJson = json.decode(commentData.body);
        if (commentDataJson['data'] != null) {
          if (mounted)
            for (var c in commentDataJson['data']) {
              if (c['memberID'] == int.parse(memberId)) {
                Comment newComment = new Comment.fromJson(c);
                Provider.of<BlogProvider>(globalContext)
                    .setPostComment(b.postId, newComment);
              }
            }
        }
      }
    }
  }
}
