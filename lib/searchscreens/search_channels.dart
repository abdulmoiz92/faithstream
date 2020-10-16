import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:faithstream/homescreen/components/your_blogs.dart';
import 'package:faithstream/main.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/donation.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/searchscreens/components/search_suggestions.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  String memberId;
  String userToken;
  String profileImage;
  bool seearchMode = false;
  bool showChannels = false;
  bool isPostSelected = true;
  bool isTrendingSelected = false;
  bool isChannelsSelected = false;
  FocusNode searchFocus = new FocusNode();
  TextEditingController searchController = new TextEditingController();
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  StreamController stream = new StreamController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: seearchMode == false
            ? Text("Search",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black87, fontSize: 18))
            : Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      autofocus: false,
                      focusNode: searchFocus,
                      controller: searchController,
                      onChanged: (_) {
                        if (seearchMode == true &&
                            searchController.text.isNotEmpty) {
                          Debouncer(milliseconds: 1000).run(() {getPostSearchResults(searchController.text);});
                          Debouncer(milliseconds: 1000).run(() {getTrendingSearchResults(searchController.text);});
                          Debouncer(milliseconds: 1000).run(() {getChannelSearchResults(searchController.text);});
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Type To Search",
                          labelStyle: TextStyle(color: Color(0xFAC9CAD1)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                ],
              ),
        actions: <Widget>[
          if (seearchMode == true)
            IconButton(
              icon: Icon(Icons.clear),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  searchFocus.unfocus();
                  searchController.clear();
                  seearchMode = false;
                });
              },
            ),
          if(seearchMode == false)
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.red,
            onPressed:() {
                    setState(() {
                      searchFocus.requestFocus();
                      seearchMode = true;

                    });
                  }
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (cntx, constraints) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChannelsSelected = false;
                            isPostSelected = true;
                            isTrendingSelected = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: isPostSelected == true ? Colors.red : null,
                              border: Border.all(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text(
                              "Posts",
                              style: TextStyle(
                                  color: isPostSelected == true
                                      ? Colors.white
                                      : Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChannelsSelected = false;
                            isPostSelected = false;
                            isTrendingSelected = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: isTrendingSelected == true
                                  ? Colors.red
                                  : null,
                              border: Border.all(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text(
                              "Trending",
                              style: TextStyle(
                                  color: isTrendingSelected == true
                                      ? Colors.white
                                      : Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChannelsSelected = true;
                            isPostSelected = false;
                            isTrendingSelected = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: isChannelsSelected == true
                                  ? Colors.red
                                  : null,
                              border: Border.all(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text(
                              "Channels",
                              style: TextStyle(
                                  color: isChannelsSelected == true
                                      ? Colors.white
                                      : Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: constraints.maxHeight * 0.85,
                    margin: EdgeInsets.only(top: 8.0),
                    child: SearchSuggestions(
                      searchResults: isPostSelected == true
                          ? Provider.of<BlogProvider>(context).searchBlogs
                          : null,
                      channelSearchResults: isChannelsSelected == true
                          ? Provider.of<BlogProvider>(context).searchChannels
                          : null,
                      trendingSearchResults: isTrendingSelected == true
                          ? Provider.of<BlogProvider>(context).searchTrending
                          : null,
                      searchFocusNode: searchFocus,
                      userToken: userToken,
                      memberId: memberId,
                      profileImage: profileImage,
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  void dispose() {
    searchFocus.dispose();
    super.dispose();
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if (mounted)
      setState(() {
        userToken = prefs.getString(sph.user_token);
        memberId = prefs.getString(sph.member_id);
        profileImage = prefs.getString(sph.profile_image);
      });
    Provider.of<BlogProvider>(context).resetSearchBlog();
    Provider.of<BlogProvider>(context).resetTrendingSearch();
    Provider.of<BlogProvider>(context).resetChannelSearch();
  }

  Future<void> getChannelSearchResults(String query) async {
    Provider.of<BlogProvider>(context).resetChannelSearch();
    var channelData = await http.get(
        "$baseAddress/api/Member/GetChannelsByKeyword/$query/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        Provider.of<BlogProvider>(context).resetChannelSearch();
        for (var u in channelDataJson['data']) {
          if (channelDataJson['data'] == []) continue;
          Channel newChannel = new Channel(id: u['id'], channelName: u['name']);
          Provider.of<BlogProvider>(context).addChannelSearch = newChannel;
          setState(() {});
        }
      }
    }
  }

  Future<void> getTrendingSearchResults(String query) async {
    Provider.of<BlogProvider>(context).resetTrendingSearch();
    var channelData = await http.get(
        "$baseAddress/api/Member/GetVideosByKeyword/$query/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        Provider.of<BlogProvider>(context).resetSearchBlog();
        for (var t in channelDataJson['data']) {
          var channelInfo = await http.get(
              "$baseAddress/api/Channel/GetChannelByID/${t['channelID']}",
              headers: {"Authorization": "Bearer $userToken"});
          var channelInfoJson = json.decode(channelInfo.body);
          if (channelDataJson['data'] == []) continue;
          TPost newTPost = new TPost(
              id: t['id'],
              channelId: t['channelID'],
              videoId: t['videoID'],
              videoUrl: t['url'],
              image: t['thumbnail'],
              title: t['title'],
              author: channelInfoJson['data']['name'],
              date: t['dateUpdated'],
              authorImage: channelInfoJson['data']['logo'],
              likes: "${t['numOfLikes']}",
              subscribers: "${channelInfoJson['data']['numOfSubscribers']}",
              time: compareDate(t['dateUpdated']),
              isPaid: t['isPaidContent'],
              isPurchased: t['isPurchased'],
              views: "${t['numOfViews']}");
          Provider.of<BlogProvider>(context).addTrendingSearch = newTPost;
          setState(() {});
        }
      }
    }
  }

  Future<void> getPostSearchResults(String query) async {
    Provider.of<BlogProvider>(context).resetSearchBlog();
    var channelData = await http.get(
        "$baseAddress/api/Member/SearchContents/$query",
        headers: {"Authorization": "Bearer $userToken"});

    var isFavouriteData = await http.get(
        "$baseAddress/api/Post/GetFavoriteTimeLine/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        for (var u in channelDataJson['data']) {
          if (channelDataJson['data'] == []) continue;

          var eventData;

          if (u['postType'] == "Event")
            eventData = await http.get(
                "$baseAddress/api/Member/GetEventByID/${u['event']['id']}",
                headers: {"Authorization": "Bearer $userToken"});

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

          if (mounted)
            setState(() {
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
                    authorImageBytes: null,
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
                    isTicketAvailable: postData['event']
                        ['isTicketPurchaseRequired'],
                    isPast: json.decode(eventData.body)['data'] == null
                        ? true
                        : json.decode(eventData.body)['data']['isPast']);
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
                    authorImageBytes: null,
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
                  authorImageBytes: null,
                  date: postData['dateCreated'],
                  time: "${compareDate(postData['dateCreated'])} ago",
                  likesCount: postData['likesCount'],
                  views: null,
                  subscribers: "${postData['numOfSubscribers']}",
                  isDonationRequired: postData['isDonationRequire'],
                  donations: donnations,
                );

              var isFavouritejsonData = jsonDecode(isFavouriteData.body);
              if (isFavouriteData
                  .body.isNotEmpty) if (isFavouritejsonData['data'] != null)
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
              donnations = [];
            });
          Provider.of<BlogProvider>(context).addSearchBlog = newBlog;
          setState(() {});
        }
      }
    }
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}