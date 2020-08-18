import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/donation.dart';
import 'package:faithstream/model/image_memory.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/database/image_database.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'your_blogs.dart';

class BlogPostsScreen extends StatefulWidget {
  @override
  BlogPostsScreenState createState() => BlogPostsScreenState();
}

class BlogPostsScreenState extends State<BlogPostsScreen>
    with AutomaticKeepAliveClientMixin<BlogPostsScreen>, ChangeNotifier {
  var internet;

  SharedPrefHelper sph = SharedPrefHelper();

  List<Blog> allBlogs = [];
  final List<TPost> allTrendingPosts = [];
  List<Comment> commentsList = [];

  List<int> ChannelIds;
  String userId;
  String userToken;
  String memberId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cntx, constraints) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.27),
          width: double.infinity,
          height: MediaQuery
              .of(context)
              .size
              .height * 1,
          child: Provider
              .of<BlogProvider>(context)
              .blogsLength > 1
              ? YourBlogs(Provider
              .of<BlogProvider>(context)
              .getAllBlogs, memberId, userToken)
              : const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
          ),
        ),
      );
    });
  }

  Future<SharedPreferences> getData() async {
    internet = await hasInternet();
    setState(() {

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if (internet == true) {
      await completePendingLikeRequests();
      await completePendingFavouriteRequests();
      await completePendingRemoveFavouriteRequests();
      await completePendingCommentRequests();
    }
    if (mounted) setState(() {
      userId = prefs.getString(sph.user_id);
      userToken = prefs.getString(sph.user_token);
      memberId = prefs.getString(sph.member_id);
    });
    Provider
        .of<BlogProvider>(context)
        .resetBlog = [];
    internet == true ? getVideos() : getVideosFromPrefs();
  }

  Future<void> completePendingFavouriteRequests() async {
    var pendingFavouriteJsonData = await sph.readPosts(
        sph.pendingfavourite_requests);
    if (pendingFavouriteJsonData != null) {
      for (var l in pendingFavouriteJsonData) {
        addToFavourite(context, l['userToken'], l['memberId'], l['blogId']);
      }
      Provider.of<PendingRequestProvider>(context).resetPendingFavourites();
      sph.clearKeyFromPrefs(sph.pendingfavourite_requests);
    }
  }

  Future<void> completePendingRemoveFavouriteRequests() async {
    var pendingRemoveFavouriteJsonData = await sph.readPosts(
        sph.pendingremovefavourite_requests);
    if (pendingRemoveFavouriteJsonData != null) {
      for (var l in pendingRemoveFavouriteJsonData) {
        removeFromFavourite(
            context, l['userToken'], l['memberId'], l['blogId']);
      }
      Provider.of<PendingRequestProvider>(context)
          .resetPendingRemoveFavourites();
      sph.clearKeyFromPrefs(sph.pendingremovefavourite_requests);
    }
  }


  Future<void> completePendingLikeRequests() async {
    var pendingLikeJsonData = await sph.readPosts(sph.pendinglikes_requests);
    if (pendingLikeJsonData != null) {
      for (var l in pendingLikeJsonData) {
        likePost(
            context,
            l['userToken'],
            l['memberId'],
            DateTime.parse(l['createdOn']),
            DateTime.parse(l['updatedOn']), () {},
            l['blogId']);
      }
      Provider.of<PendingRequestProvider>(context).resetPendingLikes();
      sph.clearKeyFromPrefs(sph.pendinglikes_requests);
    }
  }

  Future<void> completePendingCommentRequests() async {
    var pendingCommentJsonData = await sph.readPosts(
        sph.pendingcomment_requests);
    if (pendingCommentJsonData != null) {
      for (var l in pendingCommentJsonData) {
        commentOnPost(
            context,
            l['userToken'],
            l['memberId'],
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


  Future<void> getVideosFromPrefs() async {
    SharedPrefHelper sph = SharedPrefHelper();

    print("$memberId");
    print("$userToken");

    var channelDataJson = await sph.readPosts(sph.blog_posts);
    var isFavouritejsonData = await sph.readPosts(sph.favourite_posts);
    if (channelDataJson != null)
      for (var u in channelDataJson) {
        Uint8List imageBytes;
        Uint8List authorImageBytes;
        authorImageBytes = await getNetworkImage(u['authorID'].toString());
        imageBytes = await getNetworkImage(u['id']);
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
            likes: null,
            views: null,
            subscribers: null);

        if (mounted)
          setState(() {
            List<Donation> donnations = [];

            if (u['denom'] != null) {
              if (u['denom'] != [])
                for (var d in u['denom']) {
                  Donation newDonation = new Donation(id: d['id'].toString(),
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
                  authorImageBytes: authorImageBytes,
                  date: postData['dateCreated'],
                  time: "${compareDate(postData['dateCreated'])} ago",
                  likes: "${postData['likesCount']}",
                  views: postData['event']['video'] != null
                      ? "${postData['event']['video']['numOfViews']}"
                      : null,
                  subscribers: "${postData['numOfSubscribers']}",
                  eventId: postData['event']['id'],
                  eventLocation: postData['event']['location'],
                  eventTime:
                  "${DateFormat.jm().format(DateTime.parse(
                      postData['event']['startTime']))} | ${DateFormat.jm()
                      .format(DateTime.parse(
                      postData['event']['endTime']))} , ${DateFormat.MMMd()
                      .format(
                      DateTime.parse(postData['event']['postSchedule']))}",
                  comments: commentsList,
                  isDonationRequired: postData['isDonationRequire'],
                  donations: donnations,
                  imageBytes: imageBytes,
                  isTicketAvailable: postData['event']['isTicketPurchaseRequired'],
                  isPast: postData['event']['isPast']
              );
            if (u['postType'] == "Video")
              newBlog = new Blog(
                  postId: postData['id'],
                  postType: postData['postType'],
                  videoUrl: postData['video']['url'],
                  image: postData['video']['thumbnail'],
                  title: postData['title'],
                  authorId: postData['authorID'],
                  author: postData['authorName'],
                  authorImageBytes: authorImageBytes,
                  authorImage: postData['authorImage'],
                  date: postData['dateCreated'],
                  time: "${compareDate(postData['dateCreated'])} ago",
                  likes: "${postData['video']['numOfLikes']}",
                  views: "${postData['video']['numOfViews']}",
                  subscribers: "${postData['numOfSubscribers']}",
                  videoDuration: "",
                  comments: commentsList,
                  imageBytes: imageBytes,
                  donations: donnations,
                  isDonationRequired: postData['isDonationRequire'],
                  isPaidVideo: postData['video']['isPaidContent'],
                  isPurchased: postData['video']['isPurchased'],
                  videoPrice: postData['video']['price'] == null ? null : double
                      .parse(postData['video']['price']),
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
                authorImageBytes: authorImageBytes,
                authorImage: postData['authorImage'],
                date: postData['dateCreated'],
                time: "${compareDate(postData['dateCreated'])} ago",
                likes: "${postData['likesCount']}",
                views: null,
                subscribers: "${postData['numOfSubscribers']}",
                isDonationRequired: postData['isDonationRequire'],
                donations: donnations,
                comments: commentsList,
                imageBytes: imageBytes,
              );

            for (var fv in isFavouritejsonData) {
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
            donnations = [];
          });
        Provider
            .of<BlogProvider>(context)
            .addBlog = newBlog;
        setState(() {});
      }
  }


  Future<void> getVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    final bool internet = await hasInternet();
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Post/GetTimeLine2/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    var isFavouriteData = await http.get(
        "http://api.faithstreams.net/api/Post/GetFavoriteTimeLine/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        if (internet == true)
          sph.savePosts(sph.blog_posts, channelDataJson['data']);
        for (var u in channelDataJson['data']) {
          if (mounted) setState(() {
            commentsList = [];
          });
          if (channelDataJson['data'] == []) continue;

          var postData = u;

          int imageWidth;
          int imageHeight;

          Image image;

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
              likes: null,
              views: null,
              subscribers: null);

          if (mounted)
            setState(() {
              List<Donation> donnations = [];

              if (u['denom'] != null) {
                if (u['denom'] != [])
                  for (var d in u['denom']) {
                    Donation newDonation = new Donation(id: d['id'].toString(),
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
                    likes: "${postData['likesCount']}",
                    views: postData['event']['video'] != null
                        ? "${postData['event']['video']['numOfViews']}"
                        : null,
                    subscribers: "${postData['numOfSubscribers']}",
                    eventId: postData['event']['id'],
                    eventLocation: postData['event']['location'],
                    eventTime:
                    "${DateFormat.jm().format(DateTime.parse(
                        postData['event']['startTime']))} | ${DateFormat.jm()
                        .format(DateTime.parse(
                        postData['event']['endTime']))} , ${DateFormat.MMMd()
                        .format(
                        DateTime.parse(postData['event']['postSchedule']))}",
                    comments: commentsList,
                    isDonationRequired: postData['isDonationRequire'],
                    donations: donnations,
                    isTicketAvailable: postData['event']['isTicketPurchaseRequired'],
                    isPast: postData['event']['isPast']
                );
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
                    likes: "${postData['video']['numOfLikes']}",
                    views: "${postData['video']['numOfViews']}",
                    subscribers: "${postData['numOfSubscribers']}",
                    imageWidth: postData['video']['thumbnail'] == null
                        ? null
                        : imageWidth,
                    imageHeight: postData['video']['thumbnail'] == null
                        ? null
                        : imageHeight != null && imageHeight > 700
                        ? null
                        : imageHeight,
                    videoDuration: "",
                    comments: commentsList,
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
                  likes: "${postData['likesCount']}",
                  views: null,
                  subscribers: "${postData['numOfSubscribers']}",
                  isDonationRequired: postData['isDonationRequire'],
                  imageWidth: imageWidth,
                  imageHeight: imageHeight,
                  donations: donnations,
                  comments: commentsList,
                );

              var isFavouritejsonData = jsonDecode(isFavouriteData.body);
              if (isFavouriteData.body.isNotEmpty)
                if (isFavouritejsonData['data'] != null) {
                  if (internet == true)
                    sph.savePosts(
                        sph.favourite_posts, isFavouritejsonData['data']);
                  for (var fv in isFavouritejsonData['data']) {
                    if (fv['id'] == postData['id']) {
                      newBlog.setIsFavourite = 1;
                    }
                  }
                }

              if (u['postLikes'] != [])
                for (var il in u['postLikes']) {
                  if (il['memberID'] == memberId) {
                    newBlog.setIsLiked = 1;
                  }
                }
              allBlogs.add(newBlog);
              donnations = [];
            });
          Provider
              .of<BlogProvider>(context)
              .addBlog = newBlog;
          setState(() {});
        }
        print(Provider
            .of<BlogProvider>(context)
            .allBlogs
            .length);
        for (var i = 0; i < Provider
            .of<BlogProvider>(context)
            .allBlogs
            .length; i++) {
          if (Provider
              .of<BlogProvider>(context)
              .allBlogs[i].authorImage != null)
            await addNetworkImage(Provider
                .of<BlogProvider>(context)
                .allBlogs[i].authorId.toString(), Provider
                .of<BlogProvider>(context)
                .allBlogs[i].authorImage, true);
          if (Provider
              .of<BlogProvider>(context)
              .allBlogs[i].postType == "Event")
            await addNetworkImage(Provider
                .of<BlogProvider>(context)
                .allBlogs[i].postId, Provider
                .of<BlogProvider>(context)
                .allBlogs[i].image, false);
          if (Provider
              .of<BlogProvider>(context)
              .allBlogs[i].postType == "Video")
            await addNetworkImage(Provider
                .of<BlogProvider>(context)
                .allBlogs[i].postId, Provider
                .of<BlogProvider>(context)
                .allBlogs[i].image, false);
          if (Provider
              .of<BlogProvider>(context)
              .allBlogs[i].postType == "Image")
            await addNetworkImage(Provider
                .of<BlogProvider>(context)
                .allBlogs[i].postId, Provider
                .of<BlogProvider>(context)
                .allBlogs[i].image, false);
          print("added");
        }
        print("done");
      }
    }
  }

  Future<void> addNetworkImage(String id, String url,
      bool isAuthorImage) async {
    if (await fileExistsInCache(id) == true) {
      print("skipped");
      return;
    }
    if (url == null)
      return;
    final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load(
        "");
    final Uint8List bytes = imageData.buffer.asUint8List();
    writeBlogImage(id, bytes);
  }

  Future<Uint8List> getNetworkImage(String id) async {
    String image = await readBlogImage(id);
    if (image == null)
      return null;
    final Uint8List bytes = Uint8List.fromList(image.codeUnits);
    return bytes;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    print("disposed");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}