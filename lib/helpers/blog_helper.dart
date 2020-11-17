import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:faithstream/main.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/donation.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/ProviderUtils/blog_provider.dart';
import '../utils/ProviderUtils/pending_provider.dart';
import '../utils/helpingmethods/helping_methods.dart';

class BlogHelper {
  Future<void> addNetworkImage(
      String id, String url, bool isAuthorImage) async {
    if (await fileExistsInCache(id) == true) {
      print("skipped");
      return;
    }
    if (url == null) return;
    writeBlogImage(id, url);
  }

  Future<Uint8List> getNetworkImage(String id) async {
    Uint8List image = await readBlogImage(id);
    if (image == null) return null;
    return image;
  }

  void setFavouriteAndLikeData(
      {dynamic isFavouriteData,
      dynamic postData,
      bool internet,
      SharedPrefHelper sph,
      String memberId,
      Blog newBlog,}) {
    if(sph == null) {
      for (var fv in isFavouriteData) {
        if (fv['id'] == postData['id']) {
          newBlog.setIsFavourite = 1;
        }
      }
      return;
    }
    var isFavouritejsonData = jsonDecode(isFavouriteData.body);
    if (isFavouriteData.body.isNotEmpty) if (isFavouritejsonData['data'] !=
        null) {
      if (internet == true)
        sph.savePosts(sph.favourite_posts, isFavouritejsonData['data']);
      for (var fv in isFavouritejsonData['data']) {
        if (fv['id'] == postData['id']) {
          newBlog.setIsFavourite = 1;
        }
      }
    }

    if (postData['postLikes'] != [])
      for (var il in postData['postLikes']) {
        if (il['memberID'] == memberId) {
          newBlog.setIsLiked = 1;
        }
      }
  }

  Future<void> completePendingFavouriteRequestsOffline(
      BuildContext context, SharedPrefHelper sph) async {
    var pendingFavouriteJsonData =
        await sph.readPosts(sph.pendingfavourite_requests);
    if (pendingFavouriteJsonData != null) {
      for (var l in pendingFavouriteJsonData) {
        Provider.of<BlogProvider>(context).setIsPostFavourite = l['blogId'];
      }
    }
  }

  Future<void> completePendingRemoveFavouriteRequestsOffline(
      BuildContext context, SharedPrefHelper sph) async {
    var pendingRemoveFavouriteJsonData =
        await sph.readPosts(sph.pendingremovefavourite_requests);
    if (pendingRemoveFavouriteJsonData != null) {
      for (var l in pendingRemoveFavouriteJsonData) {
        Provider.of<BlogProvider>(context).setIsPostFavourite = l['blogId'];
      }
    }
  }

  Future<void> completePendingLikeRequestsOffline(
      BuildContext context, SharedPrefHelper sph) async {
    var pendingLikeJsonData = await sph.readPosts(sph.pendinglikes_requests);
    if (pendingLikeJsonData != null) {
      for (var l in pendingLikeJsonData) {
        Provider.of<BlogProvider>(context).setIsPostLiked = l['blogId'];
      }
    }
  }

  void setDonation(dynamic u, List<Donation> donation) {
    if (u['denom'] != null) {
      if (u['denom'] != [])
        for (var d in u['denom']) {
          Donation newDonation = new Donation.fromJson(d);
          donation.add(newDonation);
        }
    }
  }

  Future<void> addImagesToCache() async {
    for (var i = 0;
        i < Provider.of<BlogProvider>(globalContext).allBlogs.length;
        i++) {
      if (Provider.of<BlogProvider>(globalContext).allBlogs[i].authorImage !=
          null)
        await BlogHelper().addNetworkImage(
            Provider.of<BlogProvider>(globalContext)
                .allBlogs[i]
                .authorId
                .toString(),
            Provider.of<BlogProvider>(globalContext).allBlogs[i].authorImage,
            true);
      await BlogHelper().addNetworkImage(
          Provider.of<BlogProvider>(globalContext).allBlogs[i].postId,
          Provider.of<BlogProvider>(globalContext).allBlogs[i].image,
          false);
    }
  }

  Future<void> getVideos(
      {bool mounted,
      Function setState,
      Blog newBlog,
      String memberId,
      String userToken}) async {
    SharedPrefHelper sph = SharedPrefHelper();
    final bool internet =
        Provider.of<PendingRequestProvider>(globalContext).internet;
    var channelData = await http.get(
        "$baseAddress/api/Post/GetTimeLine2/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    var isFavouriteData = await http.get(
        "$baseAddress/api/Post/GetFavoriteTimeLine/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        if (internet == true)
          sph.savePosts(sph.blog_posts, channelDataJson['data']);
        for (var u in channelDataJson['data']) {
          if (channelDataJson['data'] == []) continue;

          var postData = u;

          if (mounted)
            setState(() {
              List<Donation> donnations = [];

              BlogHelper().setDonation(u, donnations);

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
                  postData: postData,
                  internet: internet,
                  memberId: memberId,
                  sph: sph,
                  newBlog: newBlog);
              donnations = [];
            });
          Provider.of<BlogProvider>(globalContext).addBlog = newBlog;
          setState(() {});
        }
        BlogHelper().addImagesToCache();
      }
    }
  }

  Future<void> getVideosFromPrefs(
      {bool mounted,
      String memberId,
      String userToken,
      bool internet,
      bool comingFromPref,
      Blog newBlog,
      Function setState}) async {
    SharedPrefHelper sph = SharedPrefHelper();

    print("$memberId");
    print("$userToken");

    var channelDataJson = await sph.readPosts(sph.blog_posts);
    var isFavouritejsonData = await sph.readPosts(sph.favourite_posts);
    if (channelDataJson != null)
      for (var u in channelDataJson) {
        Uint8List imageBytes;
        Uint8List authorImageBytes;
        authorImageBytes =
            await BlogHelper().getNetworkImage(u['authorID'].toString());
        imageBytes = await BlogHelper().getNetworkImage(u['id']);
        var postData = u;

        if (mounted)
          setState(() {
            List<Donation> donnations = [];

            BlogHelper().setDonation(u, donnations);

            if (u['postType'] == "Event")
              newBlog = new Blog.fromEventJson(
                  postData, donnations, authorImageBytes, imageBytes);
            if (u['postType'] == "Video")
              newBlog = new Blog.fromVideoJson(
                  postData, donnations, authorImageBytes, imageBytes);

            if (u['postType'] == "Image")
              newBlog = new Blog.fromImageJson(
                  postData, donnations, authorImageBytes, imageBytes);

            BlogHelper().setFavouriteAndLikeData(
                isFavouriteData: isFavouritejsonData,
                postData: postData,
                sph: null,
                internet: internet,
                newBlog: newBlog,
                memberId: memberId);
            donnations = [];
          });
        Provider.of<BlogProvider>(globalContext).addBlog = newBlog;
        setState(() {});
      }
    if (internet == false) {
      await BlogHelper()
          .completePendingFavouriteRequestsOffline(globalContext, sph);
      await BlogHelper()
          .completePendingRemoveFavouriteRequestsOffline(globalContext, sph);
      await BlogHelper().completePendingLikeRequestsOffline(globalContext, sph);
    }
  }
}
